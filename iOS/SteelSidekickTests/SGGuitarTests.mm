//
//  SGGuitarTests.m
//  Guitar
//
//  Created by John Sohn on 2/18/15.
//  Copyright (c) 2015 John Sohn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <fstream>
#import <sstream>
#import "SG/SGuitar.hpp"
#import "SG/GuitarString.hpp"
#import "SG/Guitar.hpp"
#import "SG/Chords.hpp"
#import "SG/Scales.hpp"
#import "SG/ChordType.hpp"
#import "SG/ScaleType.hpp"

@interface SGGuitarTests : XCTestCase

@end

@implementation SGGuitarTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testNote
{
    SG::Note note(48);
    XCTAssert(note.getMIDIValue() == 48);
    XCTAssert(note.getNoteValue() == NOTE_VALUE_C);
    XCTAssert(note.getPitchValue() == 4);
}

- (void)testGuitarString
{
    const int NUMBER_OF_FRETS = 24;
    SG::GuitarString string(48, NUMBER_OF_FRETS);

    std::vector<int> notes = string.getNoteValues();
    
    for (SG::Note note : notes) {
        SG::Note curNote(note);
        XCTAssert(curNote.getNoteValue() >= NOTE_VALUE_C && curNote.getNoteValue() <= NOTE_VALUE_B);
    }

    string.adjustStringBySteps(-2);
    notes = string.getNoteValues();
    SG::Note adjustedFirstNote(notes[0]);
    XCTAssert(adjustedFirstNote.getNoteValue() == NOTE_VALUE_A_SHARP);

    string.reset();
    notes = string.getNoteValues();
    SG::Note resetFirstNote(notes[0]);
    XCTAssert(resetFirstNote.getNoteValue() == NOTE_VALUE_C);
}

- (void)testGuitarInvalid
{
    SG::Guitar guitar;
    // TODO: guitar.readString("bad json");
    XCTAssert(!guitar.isValid());
}

static std::string readFile(const char* filename)
{
    std::ifstream t(filename);
    std::stringstream buffer;
    buffer << t.rdbuf();
    return buffer.str();
}


- (void)testGuitar
{
    SG::Guitar guitar;
    NSString *filename = [[NSBundle bundleForClass:[self class]] pathForResource:@"Guitar-Test" ofType:@"json"];
    XCTAssert(guitar.readFile([filename UTF8String]));
    
    XCTAssert(guitar.isValid());

    int numberOfFrets = guitar.getNumberOfFrets();
    XCTAssert(numberOfFrets == 6);
    
    size_t numberOfStrings = guitar.getStrings().size() -1;
    XCTAssert(numberOfStrings == 4);
    
    std::vector<SG::GuitarString> strings = guitar.getStrings();

    SG::GuitarString string1 = strings[1];
    XCTAssert(string1.isValid());

    SG::GuitarString string2 = strings[2];
    XCTAssert(string2.isValid());
    
    SG::GuitarString string3 = strings[3];
    XCTAssert(string3.isValid());
    
    SG::GuitarString string4 = strings[4];
    XCTAssert(string4.isValid());

    // ensure strings have correct values
    XCTAssert([self evaluateString:string1 numberOfFrets:numberOfFrets integerValue:NOTE_VALUE_E midiValue:40 pitchValue:3]);
    XCTAssert([self evaluateString:string2 numberOfFrets:numberOfFrets integerValue:NOTE_VALUE_A midiValue:45 pitchValue:3]);
    XCTAssert([self evaluateString:string3 numberOfFrets:numberOfFrets integerValue:NOTE_VALUE_D midiValue:50 pitchValue:4]);
    XCTAssert([self evaluateString:string4 numberOfFrets:numberOfFrets integerValue:NOTE_VALUE_G midiValue:55 pitchValue:4]);

    // activate pedal
    guitar.activateAdjustment("P1", true);
    strings = guitar.getStrings();
    SG::GuitarString adjustedString1 = strings[1];
    XCTAssert(adjustedString1.isValid());

    SG::GuitarString adjustedString2 = strings[2];
    XCTAssert(adjustedString2.isValid());

    SG::GuitarString adjustedString3 = strings[3];
    XCTAssert(adjustedString3.isValid());

    SG::GuitarString adjustedString4 = strings[4];
    XCTAssert(adjustedString4.isValid());
    
    // ensure strings have correct values after activating pedal
    NSLog(@"testing activated strings...");
    XCTAssert([self evaluateString:adjustedString1 numberOfFrets:numberOfFrets integerValue:NOTE_VALUE_D midiValue:38 pitchValue:3]);
    XCTAssert([self evaluateString:adjustedString2 numberOfFrets:numberOfFrets integerValue:NOTE_VALUE_G midiValue:43 pitchValue:3]);
    XCTAssert([self evaluateString:adjustedString3 numberOfFrets:numberOfFrets integerValue:NOTE_VALUE_D midiValue:50 pitchValue:4]);
    XCTAssert([self evaluateString:adjustedString4 numberOfFrets:numberOfFrets integerValue:NOTE_VALUE_G midiValue:55 pitchValue:4]);
    NSLog(@"complete");
    
    // reset
    guitar.resetStrings();
    strings = guitar.getStrings();
    SG::GuitarString resetString1 = strings[1];
    XCTAssert(resetString1.isValid());
    
    SG::GuitarString resetString2 = strings[2];
    XCTAssert(resetString2.isValid());
    
    SG::GuitarString resetString3 = strings[3];
    XCTAssert(resetString3.isValid());
    
    SG::GuitarString resetString4 = strings[4];
    XCTAssert(resetString4.isValid());
    
    // ensure strings have correct values after being reset
    XCTAssert([self evaluateString:resetString1 numberOfFrets:numberOfFrets integerValue:NOTE_VALUE_E midiValue:40 pitchValue:3]);
    XCTAssert([self evaluateString:resetString2 numberOfFrets:numberOfFrets integerValue:NOTE_VALUE_A midiValue:45 pitchValue:3]);
    XCTAssert([self evaluateString:resetString3 numberOfFrets:numberOfFrets integerValue:NOTE_VALUE_D midiValue:50 pitchValue:4]);
    XCTAssert([self evaluateString:resetString4 numberOfFrets:numberOfFrets integerValue:NOTE_VALUE_G midiValue:55 pitchValue:4]);
}

- (BOOL)evaluateString:(const SG::GuitarString &)string
         numberOfFrets:(int)numberOfFrets
          integerValue:(int)integerValue
             midiValue:(int)midiValue
            pitchValue:(int)pitchValue
{
    std::vector<int> notes = string.getNoteValues();
    XCTAssert(notes.size() == numberOfFrets + 1); // account for fret 0
    if (notes.size() != numberOfFrets + 1) { // account for fret 0
        return NO;
    }
    
    SG::Note note(notes[0]);
    XCTAssert(note.getNoteValue() == integerValue);
    if (note.getNoteValue() != integerValue) {
        return NO;
    }
    
    XCTAssert(note.getMIDIValue() == midiValue);
    if (note.getMIDIValue() != midiValue) {
        return NO;
    }
    
    XCTAssert(note.getPitchValue() == pitchValue);
    if (note.getPitchValue() != pitchValue) {
        return NO;
    }
    return YES;
}

- (void)testGuitarGFIE9
{
    return;
    NSString *filename = [[NSBundle bundleForClass:[self class] ] pathForResource:@"TestGuitar" ofType:@"json"];
    std::string json = readFile([filename UTF8String]);
    SG::Guitar guitar;
    // TODO: guitar.readString(json.c_str());
    XCTAssert(guitar.isValid());
    std::vector<SG::GuitarString> strings = guitar.getStrings();
    
    SG::GuitarString string2 = strings[2];
    XCTAssert(string2.isValid());
    std::vector<int> notes = string2.getNoteValues();
    SG::Note note2 = notes[0];
    XCTAssert(note2.getNoteValue() == NOTE_VALUE_D_SHARP);
              
    SG::GuitarString string4 = strings[4];
    XCTAssert(string4.isValid());
    notes = string4.getNoteValues();
    SG::Note note4 = notes[0];
    XCTAssert(note4.getNoteValue() == NOTE_VALUE_E);
    
    SG::GuitarString string6 = strings[6];
    XCTAssert(string6.isValid());
    notes = string6.getNoteValues();
    SG::Note note6 = notes[0];
    XCTAssert(note6.getNoteValue() == NOTE_VALUE_G_SHARP);
    
    SG::GuitarString string8 = strings[8];
    XCTAssert(string8.isValid());
    notes = string8.getNoteValues();
    SG::Note note8 = notes[0];
    XCTAssert(note8.getNoteValue() == NOTE_VALUE_E);

    {
        guitar.activateAdjustment("P1", true);
        std::vector<SG::GuitarString> strings = guitar.getStrings();
        
        SG::GuitarString string5 = strings[5];
        notes = string5.getNoteValues();
        SG::Note note5(notes[0]);
        XCTAssert(note5.getNoteValue() == NOTE_VALUE_C_SHARP);
        
        SG::GuitarString string10 = strings[10];
        notes = string10.getNoteValues();
        SG::Note note10 = notes[0];
        XCTAssert(note10.getNoteValue() == NOTE_VALUE_C_SHARP);
        
        guitar.resetStrings();
    }

    {
        guitar.activateAdjustment("P2", true);
        std::vector<SG::GuitarString> strings = guitar.getStrings();
    
        SG::GuitarString string3 = strings[3];
        notes = string3.getNoteValues();
        SG::Note note3 = notes[0];
        XCTAssert(note3.getNoteValue() == NOTE_VALUE_A);
        
        SG::GuitarString string6 = strings[6];
        notes = string3.getNoteValues();
        SG::Note note6 = notes[0];
        XCTAssert(note6.getNoteValue() == NOTE_VALUE_A);

        guitar.resetStrings();
    }
    
    {
        guitar.activateAdjustment("LKL", true);
        std::vector<SG::GuitarString> strings = guitar.getStrings();
        
        SG::GuitarString string8 = strings[8];
        std::vector<int> notes = string8.getNoteValues();
        SG::Note note3 = notes[3];
        XCTAssert(note3.getNoteValue() == NOTE_VALUE_G_SHARP);
        
        SG::GuitarString string4 = strings[4];
        notes = string4.getNoteValues();
        SG::Note note6 = notes[6];
        XCTAssert(note6.getNoteValue() == NOTE_VALUE_B);
        
        guitar.resetStrings();
    }

    guitar.activateAdjustment("RKL", true);
    guitar.resetStrings();
    guitar.activateAdjustment("RKR", true);
    guitar.resetStrings();
    
    {
        std::vector<SG::GuitarString> strings = guitar.getStrings();
        SG::GuitarString string2 = strings[2];
        XCTAssert(string2.isValid());
        notes = string2.getNoteValues();
        SG::Note note2 = notes[0];
        XCTAssert(note2.getNoteValue() == NOTE_VALUE_D_SHARP);
        
        SG::GuitarString string4 = strings[4];
        XCTAssert(string4.isValid());
        notes = string4.getNoteValues();
        SG::Note note4 = notes[0];
        XCTAssert(note4.getNoteValue() == NOTE_VALUE_E);
        
        SG::GuitarString string6 = strings[6];
        XCTAssert(string6.isValid());
        notes = string6.getNoteValues();
        SG::Note note6 = notes[0];
        XCTAssert(note6.getNoteValue() == NOTE_VALUE_G_SHARP);
        
        SG::GuitarString string8 = strings[8];
        XCTAssert(string8.isValid());
        notes = string8.getNoteValues();
        SG::Note note8 = notes[0];
        XCTAssert(note8.getNoteValue() == NOTE_VALUE_E);
    }
}

- (void)testNoteValueForName {
    int noteValue = NOTE_VALUE_NONE;

    noteValue = SG::NoteName::noteValueForName("C");
    XCTAssert(noteValue == NOTE_VALUE_C);

    noteValue = SG::NoteName::noteValueForName("G");
    XCTAssert(noteValue == NOTE_VALUE_G);

    noteValue = SG::NoteName::noteValueForName("A");
    XCTAssert(noteValue == NOTE_VALUE_A);
    
    noteValue = SG::NoteName::noteValueForName("B");
    XCTAssert(noteValue == NOTE_VALUE_B);
}

- (void)testBadNote
{
    {
        SG::Note note("C-X");
        XCTAssert(note.getPitchValue() == -1);
        XCTAssert(note.getNoteValue() == -1);
        XCTAssert(note.getMIDIValue() == -1);
    }
    
    {
        SG::Note note("C");
        XCTAssert(note.getPitchValue() == -1);
        XCTAssert(note.getNoteValue() == -1);
        XCTAssert(note.getMIDIValue() == -1);
    }
    
}

- (void)testNoteName
{
    {
        SG::Note note("C-4");
        XCTAssert(note.getPitchValue() == 4);
        XCTAssert(note.getNoteValue() == NOTE_VALUE_C);
        XCTAssert(note.getMIDIValue() == 48);
    }

    {
        SG::Note note("C#-4");
        XCTAssert(note.getPitchValue() == 4);
        XCTAssert(note.getNoteValue() == NOTE_VALUE_C_SHARP);
        XCTAssert(note.getMIDIValue() == 49);
    }

    {
        SG::Note note("C-0");
        XCTAssert(note.getPitchValue() == 0);
        XCTAssert(note.getNoteValue() == NOTE_VALUE_C);
        XCTAssert(note.getMIDIValue() == 0);
    }
}

- (void)testNoteMidiValue
{
    {
        SG::Note note(NOTE_VALUE_C, 0);
        XCTAssert(note.getPitchValue() == 0);
        XCTAssert(note.getNoteValue() == NOTE_VALUE_C);
        XCTAssert(note.getMIDIValue() == 0);
    }

    {
        SG::Note note(NOTE_VALUE_G_SHARP, 1);
        XCTAssert(note.getPitchValue() == 1);
        XCTAssert(note.getNoteValue() == NOTE_VALUE_G_SHARP);
        XCTAssert(note.getMIDIValue() == 20);
    }

    
    {
        SG::Note note(NOTE_VALUE_C_SHARP, 2);
        XCTAssert(note.getPitchValue() == 2);
        XCTAssert(note.getNoteValue() == NOTE_VALUE_C_SHARP);
        XCTAssert(note.getMIDIValue() == 25);
    }
    
    {
        SG::Note note(NOTE_VALUE_G_SHARP, 2);
        XCTAssert(note.getPitchValue() == 2);
        XCTAssert(note.getNoteValue() == NOTE_VALUE_G_SHARP);
        XCTAssert(note.getMIDIValue() == 32);
    }
    
    {
        SG::Note note(NOTE_VALUE_B, 2);
        XCTAssert(note.getPitchValue() == 2);
        XCTAssert(note.getNoteValue() == NOTE_VALUE_B);
        XCTAssert(note.getMIDIValue() == 35);
    }
    
    {
        SG::Note note(NOTE_VALUE_C, 3);
        XCTAssert(note.getPitchValue() == 3);
        XCTAssert(note.getNoteValue() == NOTE_VALUE_C);
        XCTAssert(note.getMIDIValue() == 36);
    }
    
    
    {
        SG::Note note(NOTE_VALUE_B, 4);
        XCTAssert(note.getPitchValue() == 4);
        XCTAssert(note.getNoteValue() == NOTE_VALUE_B);
        XCTAssert(note.getMIDIValue() == 59);
    }
    
    {
        SG::Note note(NOTE_VALUE_A, 5);
        XCTAssert(note.getPitchValue() == 5);
        XCTAssert(note.getNoteValue() == NOTE_VALUE_A);
        XCTAssert(note.getMIDIValue() == 69);
    }

    
    {
        SG::Note note(NOTE_VALUE_C, 8);
        XCTAssert(note.getPitchValue() == 8);
        XCTAssert(note.getNoteValue() == NOTE_VALUE_C);
        XCTAssert(note.getMIDIValue() == 96);
    }
    
    {
        SG::Note note(NOTE_VALUE_G, 8);
        XCTAssert(note.getPitchValue() == 8);
        XCTAssert(note.getNoteValue() == NOTE_VALUE_G);
        XCTAssert(note.getMIDIValue() == 103);
    }
}

- (void)testWriteGuitar {
    SG::Guitar guitar;
    NSString *root = [NSString stringWithUTF8String:SG::FileUtils::getRootPathForUserFiles().c_str()];
    guitar.setNumberOfFrets(24);
    guitar.setNumberOfStrings(6);

    guitar.setString(1, SG::GuitarString(SG::Note(NOTE_VALUE_C, 2), 24));
    guitar.setString(2, SG::GuitarString(SG::Note(NOTE_VALUE_D, 2), 24));
    guitar.setString(3, SG::GuitarString(SG::Note(NOTE_VALUE_E, 2), 24));
    guitar.setString(4, SG::GuitarString(SG::Note(NOTE_VALUE_F, 2), 24));
    guitar.setString(5, SG::GuitarString(SG::Note(NOTE_VALUE_G, 2), 24));
    guitar.setString(6, SG::GuitarString(SG::Note(NOTE_VALUE_A, 2), 24));
    
    NSString *file = [NSString stringWithFormat:@"%@/TEST", root];
    guitar.writeFile([file UTF8String]);
}

@end
