//
//  GuitarPlayer.mm
//  SoundTestSTK
//
//  Created by John on 2/16/15.
//
//

#import <math.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVAudioSession.h>
#import <Guitar.h>
#import "GuitarPlayer.h"

using namespace stk;

#define SAMPLE_RATE             22000
#define MAX_PLUCKED_STRINGS     12

OSStatus RenderTone(void *inRefCon,
                    AudioUnitRenderActionFlags 	*ioActionFlags,
                    const AudioTimeStamp 		*inTimeStamp,
                    UInt32 						inBusNumber,
                    UInt32 						inNumberFrames,
                    AudioBufferList 			*ioData)

{
    GuitarPlayer *guitarPlayer = (__bridge GuitarPlayer *)inRefCon;
    const int channel = 0;
    Float32 *buffer = (Float32 *)ioData->mBuffers[channel].mData;
    
    // Generate the samples
    for (UInt32 frame = 0; frame < inNumberFrames; frame++)
    {
        float tick = [guitarPlayer guitarTick];
        buffer[frame] = tick;
        
    }
    return noErr;
}

void ToneInterruptionListener(void *inClientData, UInt32 inInterruptionState)
{
    //        ToneGeneratorViewController *viewController =
    //        (ToneGeneratorViewController *)inClientData;
    //
    //        [viewController stop];
}

@interface GuitarPlayer() <AVAudioSessionDelegate>

@end

@implementation GuitarPlayer {
    AudioComponentInstance audioUnit;
    int selectedMidiNotes[MAX_PLUCKED_STRINGS + 1];
    Guitar *guitar;
}

+ (GuitarPlayer *)sharedInstance
{
    static GuitarPlayer *guitarPlayer = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        guitarPlayer = [[self alloc] init];
    });
    return guitarPlayer;
}

- (id)init
{
    self = [super init];
    if (self) {
        for (int i = 0; i < MAX_PLUCKED_STRINGS; i++) {
            selectedMidiNotes[i] = -1;
        }

    }
    return self;
}

- (void)playInit {
    [self setupGuitar];
    
    if ([self startAudioSession]) {
        [self startAudioUnit];
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Audio
//
- (BOOL)startAudioSession
{
    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSError *error = nil;

    if (![session setCategory:AVAudioSessionCategoryPlayback error:&error]) {
        NSLog(@"Error setting category, error: %@", error);
        return NO;
    }
    
    if (![session setActive:YES error:&error]) {
        NSLog(@"Error setting active session, error: %@", error);
        return NO;
    }

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(audioSessionInterrupted:)
                                                 name:AVAudioSessionInterruptionNotification
                                               object:nil];
    return YES;
}

- (void)audioSessionInterrupted:(NSNotification*)notification {
    NSDictionary *interruptionDictionary = [notification userInfo];
    NSNumber *interruptionType = (NSNumber *)[interruptionDictionary valueForKey:AVAudioSessionInterruptionTypeKey];
    if ([interruptionType intValue] == AVAudioSessionInterruptionTypeBegan) {
        NSLog(@"Interruption started");
    } else if ([interruptionType intValue] == AVAudioSessionInterruptionTypeEnded){
        NSLog(@"Interruption ended");
    } else {
        NSLog(@"Something else happened");
    }
}

- (BOOL)startAudioUnit
{
    audioUnit = nil;

    if (![self setupAudioUnit]) {
        return NO;
    }

    // Stop changing parameters on the unit
    OSErr err = AudioUnitInitialize(audioUnit);
    if (err != noErr) {
        NSLog(@"Error calling AudioUnitInitialize, error: %ld", (long) err);
        return NO;
    }
    
    // Start playback
    err = AudioOutputUnitStart(audioUnit);
    if (err != noErr) {
        NSLog(@"Error calling AudioOutputUnitStart, error: %ld", (long) err);
        return NO;
    }
    
    return YES;
}

- (BOOL)setupAudioUnit
{
    // Configure the search parameters to find the default playback output unit
    // (called the kAudioUnitSubType_RemoteIO on iOS but
    // kAudioUnitSubType_DefaultOutput on Mac OS X)
    AudioComponentDescription defaultOutputDescription;
    defaultOutputDescription.componentType = kAudioUnitType_Output;
    defaultOutputDescription.componentSubType = kAudioUnitSubType_RemoteIO;
    defaultOutputDescription.componentManufacturer = kAudioUnitManufacturer_Apple;
    defaultOutputDescription.componentFlags = 0;
    defaultOutputDescription.componentFlagsMask = 0;
    
    // Get the default playback output unit
    AudioComponent defaultOutput = AudioComponentFindNext(NULL, &defaultOutputDescription);
    if (!defaultOutput) {
        NSLog(@"Error calling AudioComponentFindNext");
        return NO;
    }
    
    // Create a new unit based on this that we'll use for output
    OSErr err = AudioComponentInstanceNew(defaultOutput, &audioUnit);
    if (err != noErr) {
        NSLog(@"Error calling AudioComponentInstanceNew, error: %ld", (long)err);
        return NO;
    }
    
    // Set our tone rendering function on the unit
    AURenderCallbackStruct input;
    input.inputProc = RenderTone;
    input.inputProcRefCon = (__bridge void *) self;
    
    err = AudioUnitSetProperty(audioUnit,
                               kAudioUnitProperty_SetRenderCallback,
                               kAudioUnitScope_Input,
                               0,
                               &input,
                               sizeof(input));
    if (err != noErr) {
        NSLog(@"Error calling AudioUnitSetProperty, error: %ld", (long) err);
        return NO;
    }
    
    // Set the format to 32 bit, single channel, floating point, linear PCM
    const int four_bytes_per_float = 4;
    const int eight_bits_per_byte = 8;
    AudioStreamBasicDescription streamFormat;
    streamFormat.mSampleRate = SAMPLE_RATE;
    streamFormat.mFormatID = kAudioFormatLinearPCM;
    streamFormat.mFormatFlags =
    kAudioFormatFlagsNativeFloatPacked | kAudioFormatFlagIsNonInterleaved;
    streamFormat.mBytesPerPacket = four_bytes_per_float;
    streamFormat.mFramesPerPacket = 1;
    streamFormat.mBytesPerFrame = four_bytes_per_float;
    streamFormat.mChannelsPerFrame = 1;
    streamFormat.mBitsPerChannel = four_bytes_per_float * eight_bits_per_byte;

    err = AudioUnitSetProperty (audioUnit,
                                kAudioUnitProperty_StreamFormat,
                                kAudioUnitScope_Input,
                                0,
                                &streamFormat,
                                sizeof(AudioStreamBasicDescription));
    if (err != noErr) {
        NSLog(@"Error calling AudioUnitSetProperty, error: %ld", (long)err);
    }
    
    return YES;
}

- (void)shutdownAudioComponent
{
    AudioOutputUnitStop(audioUnit);
    AudioUnitUninitialize(audioUnit);
    AudioComponentInstanceDispose(audioUnit);
    audioUnit = nil;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Guitar
//
- (void)setupGuitar
{
    if (!guitar) {
        Stk::setSampleRate(SAMPLE_RATE);
        guitar = new Guitar(MAX_PLUCKED_STRINGS + 1);
    }
}

- (void)playMidiNoteOnString:(int)onString adjustedBy:(int)adjustment
{
    NSLog(@"playMidiNoteOnString onString: %d, adjustedBy: %d", onString, adjustment);
    int selectedMidiNote = selectedMidiNotes[onString];
    if (selectedMidiNote >= 0) {
         selectedMidiNote += adjustment;
        
        NSLog(@"selectedMidiNote: %d", selectedMidiNote);
        [self playMidiNote:selectedMidiNote onString:onString isPlucked:NO];
    }
}

- (void)playMidiNote:(int)midiNote onString:(int)onString
{
    [self playMidiNote:midiNote onString:onString isPlucked:YES];
}

- (void)playMidiNote:(int)midiNote onString:(int)onString isPlucked:(BOOL)plucked;
{
    selectedMidiNotes[onString] = midiNote;
    
    double amplitude = 0.0;
    
    if (plucked) {
        amplitude = 6.0;
    }

    double frequency = [self midiNoteToFrequency:midiNote];
    guitar->noteOn(frequency, amplitude, onString);
}

- (float)guitarTick
{
    return guitar->tick();
}

- (double)midiNoteToFrequency:(int)note
{
    double result = -1.0;
    
    if (note >=0 && note <=119) {
        result = 440 * pow(2.0,(note-69.0)/12.0);
    }
    
    NSLog(@"note: %d, frequency: %f", note, result);
    return result;
}

@end
