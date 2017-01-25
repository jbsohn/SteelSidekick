//
//  GuitarPlayer.h
//  SoundTestSTK
//
//  Created by John on 2/16/15.
//
//

#import <Foundation/Foundation.h>

@interface GuitarPlayer : NSObject

+ (GuitarPlayer *)sharedInstance;

- (instancetype)init NS_UNAVAILABLE;

- (void)playInit;
- (void)playMidiNoteOnString:(int)onString adjustedBy:(int)adjustment;
- (void)playMidiNote:(int)midiNote onString:(int)onString;
- (void)playMidiNote:(int)midiNote onString:(int)onString isPlucked:(BOOL)plucked;
- (float)guitarTick;

@end
