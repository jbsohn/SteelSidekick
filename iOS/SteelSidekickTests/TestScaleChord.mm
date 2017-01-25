//
//  TestScaleChord.m
//  SGuitar
//
//  Created by John on 3/4/15.
//  Copyright (c) 2015 John Sohn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "Note.h"
#import "Scale.h"
#import "Chord.h"
#import "Note.h"
#import "Scales.h"
#import "Chords.h"
#import "FileUtils.h"

using namespace SG;

@interface TestScaleChord : XCTestCase

@end

@implementation TestScaleChord {
    Chords chords;
    Scales scales;
}

- (void)setUp {
    [super setUp];
    [self loadChords];
    [self loadScales];
}

- (void)tearDown {
    [super tearDown];
}

- (void)loadChords {
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *path = [bundle pathForResource:@"Chords" ofType:@"settings"];
    std::string json = SG::FileUtils::readFile([path UTF8String]);
    chords.readString(json);
}

- (void)loadScales {
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *path = [bundle pathForResource:@"Scales" ofType:@"settings"];
    std::string json = SG::FileUtils::readFile([path UTF8String]);
    scales.readString(json);
}

- (BOOL)evaluateChordType:(NSString *)name
             withRootNote:(int)rootNoteValue
          withDescription:(NSString *)description
{
    ChordType chordType = chords.getChordType([name UTF8String]);
    std::vector<int> intervals = chordType.getintervals();
    SG::Chord chord(rootNoteValue, intervals);
    std::string s = chord.unitTestDescription();
    std::string chordName = chordType.getName();
    std::string rootNoteName = SG::Note::nameForNoteValue(rootNoteValue, AT_SHARP);
    NSString *chordDescription = [NSString stringWithUTF8String:s.c_str()];
//    XCTAssertEqualObjects(chordDescription, description,
//                          @"chord: %s failed for root note: %s", chordName.c_str(), rootNoteName.c_str());
    return [chordDescription isEqualToString:description];
}

- (BOOL)evaluateScaleType:(NSString *)name
             withRootNote:(int)rootNoteValue
          withDescription:(NSString *)description
{
    ScaleType scaleType = scales.getScaleType([name UTF8String]);
    std::vector<int> semitones = scaleType.getSemitones();
    SG::Scale scale(rootNoteValue, semitones);
    std::string sd = scale.unitTestDescription();
    std::string scaleName = scaleType.getName();
    std::string rootNoteName = SG::Note::nameForNoteValue(rootNoteValue, AT_SHARP);
    NSLog(@"sd: %s", sd.c_str());
    NSString *scaleDescription = [NSString stringWithUTF8String:sd.c_str()];
    NSLog(@"scaleDescription: %@", scaleDescription);
//    XCTAssert([scaleDescription isEqualToString:description],
//              @"scale: %@ failed for root note: %s", name, rootNoteName.c_str());
    return [scaleDescription isEqualToString:description];
}

//--------------------------------------------------------------------------------
//    Major Scales
//    C: C, D, E, F, G, A, B, C
//    C#/Db: C#, D#, F, F#, G#, A#, C, C#
//    D: D, E, F#, G, A, B, C#, D
//    D#/Eb: D#, F, G, G#, A#, C, D, D#
//    E: E, F#, G#, A, B, C#, D#, E
//    F: F, G, A, Bb, C, D, E, F
//    F#/Gb: F#, G#, A#, B, C#, D#, F, F#
//    G: G, A, B, C, D, E, F#, G
//    G#/Ab: G#, A#, C, C#, D#, F, G, G#
//    A: A, B, C#, D, E, F#, G#, A
//    A#/Bb: A#, C, D, D#, F, G, A, A#
//    B: B, C#, D#, E, F#, G#, A#, B
//
- (void)testMajorScales
{
    NSString *c = @"C D E F G A B";
    NSString *cSharp = @"C# D# F F# G# A# C";
    NSString *d = @"D E F# G A B C#";
    NSString *dSharp = @"D# F G G# A# C D";
    NSString *e = @"E F# G# A B C# D#";
    NSString *f = @"F G A A# C D E";
    NSString *fSharp = @"F# G# A# B C# D# F";
    NSString *g = @"G A B C D E F#";
    NSString *gSharp = @"G# A# C C# D# F G";
    NSString *a = @"A B C# D E F# G#";
    NSString *aSharp = @"A# C D D# F G A";
    NSString *b = @"B C# D# E F# G# A#";

    XCTAssert([self evaluateScaleType:@"Major" withRootNote:NOTE_VALUE_C withDescription:c]);
    XCTAssert([self evaluateScaleType:@"Major" withRootNote:NOTE_VALUE_C_SHARP withDescription:cSharp]);
    XCTAssert([self evaluateScaleType:@"Major" withRootNote:NOTE_VALUE_D withDescription:d]);
    XCTAssert([self evaluateScaleType:@"Major" withRootNote:NOTE_VALUE_D_SHARP withDescription:dSharp]);
    XCTAssert([self evaluateScaleType:@"Major" withRootNote:NOTE_VALUE_E withDescription:e]);
    XCTAssert([self evaluateScaleType:@"Major" withRootNote:NOTE_VALUE_F withDescription:f]);
    XCTAssert([self evaluateScaleType:@"Major" withRootNote:NOTE_VALUE_F_SHARP withDescription:fSharp]);
    XCTAssert([self evaluateScaleType:@"Major" withRootNote:NOTE_VALUE_G withDescription:g]);
    XCTAssert([self evaluateScaleType:@"Major" withRootNote:NOTE_VALUE_G_SHARP withDescription:gSharp]);
    XCTAssert([self evaluateScaleType:@"Major" withRootNote:NOTE_VALUE_A withDescription:a]);
    XCTAssert([self evaluateScaleType:@"Major" withRootNote:NOTE_VALUE_A_SHARP withDescription:aSharp]);
    XCTAssert([self evaluateScaleType:@"Major" withRootNote:NOTE_VALUE_B withDescription:b]);
}

//--------------------------------------------------------------------------------
//    Minor Scales
//    A: A, B, C, D, E, F, G, A
//    A#/Bb: A#, C, C#, D#, F, F#, G#, A#
//    B: B, C#, D, E, F#, G, A, B
//    C: C, D, Eb, F, G, Ab, Bb, C
//    C#/Db: C#, D#, E, F#, G#, A, B, C#
//    D: D, E, F, G, A, Bb, C, D
//    D#/Eb: D#, F, F#, G#, A#, B, C#, D#
//    E: E, F#, G, A, B, C, D, E
//    F: F, G, Ab, Bb, C, Db, Eb, F
//    F#/Gb: F#, G#, A, B, C#, D, E, F#
//    G: G, A, Bb, C, D, Eb, F, G
//    G#/Ab: G#, A#, B, C#, D#, E, F#, G#
//
- (void)testNaturalMinorScales
{
    NSString *a = @"A B C D E F G";
    NSString *aSharp = @"A# C C# D# F F# G#";
    NSString *b = @"B C# D E F# G A";
    NSString *c = @"C D D# F G G# A#";
    NSString *cSharp = @"C# D# E F# G# A B";
    NSString *d = @"D E F G A A# C";
    NSString *dSharp = @"D# F F# G# A# B C#";
    NSString *e = @"E F# G A B C D";
    NSString *f = @"F G G# A# C C# D#";
    NSString *fSharp = @"F# G# A B C# D E";
    NSString *g = @"G A A# C D D# F";
    NSString *gSharp = @"G# A# B C# D# E F#";
    
    XCTAssert([self evaluateScaleType:@"Natural Minor" withRootNote:NOTE_VALUE_C withDescription:c]);
    XCTAssert([self evaluateScaleType:@"Natural Minor" withRootNote:NOTE_VALUE_C_SHARP withDescription:cSharp]);
    XCTAssert([self evaluateScaleType:@"Natural Minor" withRootNote:NOTE_VALUE_D withDescription:d]);
    XCTAssert([self evaluateScaleType:@"Natural Minor" withRootNote:NOTE_VALUE_D_SHARP withDescription:dSharp]);
    XCTAssert([self evaluateScaleType:@"Natural Minor" withRootNote:NOTE_VALUE_E withDescription:e]);
    XCTAssert([self evaluateScaleType:@"Natural Minor" withRootNote:NOTE_VALUE_F withDescription:f]);
    XCTAssert([self evaluateScaleType:@"Natural Minor" withRootNote:NOTE_VALUE_F_SHARP withDescription:fSharp]);
    XCTAssert([self evaluateScaleType:@"Natural Minor" withRootNote:NOTE_VALUE_G withDescription:g]);
    XCTAssert([self evaluateScaleType:@"Natural Minor" withRootNote:NOTE_VALUE_G_SHARP withDescription:gSharp]);
    XCTAssert([self evaluateScaleType:@"Natural Minor" withRootNote:NOTE_VALUE_A withDescription:a]);
    XCTAssert([self evaluateScaleType:@"Natural Minor" withRootNote:NOTE_VALUE_A_SHARP withDescription:aSharp]);
    XCTAssert([self evaluateScaleType:@"Natural Minor" withRootNote:NOTE_VALUE_B withDescription:b]);
}

//--------------------------------------------------------------------------------
//    Harmonic Minor Scales
//    A: A, B, C, D, E, F, G#, A
//    A#/Bb: A#, C, C#, Eb, F, F#, A, A#
//    B: B, C#, E, F#, G, A#, B
//    C: C, D, Eb, F, G, Ab, B, C
//    C#/Db: C#, Eb, E, F#, G#, A, C, C#
//    D: D, E, F, G, A, Bb, C#, D
//    D#/Eb: D#, F, F#, G#, A#, B, D, D#
//    E: E, F#, Gb, A, B, C, D#, E
//    F: F, G, Ab, Bb, C, Db, E, F
//    F#/Gb: F#, G#, A, B, C#, D, F, F#
//    G: G, A, Bb, C, D, Eb, F#, G
//    G#/Ab: G#, A#, B, C#, Eb, E, G, G#
//
- (void)testHarmonicMinorScales
{
    NSString *a = @"A B C D E F G#";
    NSString *aSharp = @"A# C C# D# F F# A";
    NSString *b = @"B C# D E F# G A#";
    NSString *c = @"C D D# F G G# B";
    NSString *cSharp = @"C# D# E F# G# A C";
    NSString *d = @"D E F G A A# C#";
    NSString *dSharp = @"D# F F# G# A# B D";
    NSString *e = @"E F# G A B C D#";
    NSString *f = @"F G G# A# C C# E";
    NSString *fSharp = @"F# G# A B C# D F";
    NSString *g = @"G A A# C D D# F#";
    NSString *gSharp = @"G# A# B C# D# E G";
    
    XCTAssert([self evaluateScaleType:@"Harmonic Minor" withRootNote:NOTE_VALUE_C withDescription:c]);
    XCTAssert([self evaluateScaleType:@"Harmonic Minor" withRootNote:NOTE_VALUE_C_SHARP withDescription:cSharp]);
    XCTAssert([self evaluateScaleType:@"Harmonic Minor" withRootNote:NOTE_VALUE_D withDescription:d]);
    XCTAssert([self evaluateScaleType:@"Harmonic Minor" withRootNote:NOTE_VALUE_D_SHARP withDescription:dSharp]);
    XCTAssert([self evaluateScaleType:@"Harmonic Minor" withRootNote:NOTE_VALUE_E withDescription:e]);
    XCTAssert([self evaluateScaleType:@"Harmonic Minor" withRootNote:NOTE_VALUE_F withDescription:f]);
    XCTAssert([self evaluateScaleType:@"Harmonic Minor" withRootNote:NOTE_VALUE_F_SHARP withDescription:fSharp]);
    XCTAssert([self evaluateScaleType:@"Harmonic Minor" withRootNote:NOTE_VALUE_G withDescription:g]);
    XCTAssert([self evaluateScaleType:@"Harmonic Minor" withRootNote:NOTE_VALUE_G_SHARP withDescription:gSharp]);
    XCTAssert([self evaluateScaleType:@"Harmonic Minor" withRootNote:NOTE_VALUE_A withDescription:a]);
    XCTAssert([self evaluateScaleType:@"Harmonic Minor" withRootNote:NOTE_VALUE_A_SHARP withDescription:aSharp]);
    XCTAssert([self evaluateScaleType:@"Harmonic Minor" withRootNote:NOTE_VALUE_B withDescription:b]);
}

//--------------------------------------------------------------------------------
//    Pentatonic Major Scales
//    C: C, D, E, G, A, C
//    C#/Db: C#, D#, F, G#, A#, C#
//    D: D, E, F#, A, B, D
//    D#/Eb: D#, F, G, A#, C, D#
//    E: E, F#, G#, B, C#, E
//    F: F, G, A, C, D, F
//    F#/Gb: F#, G#, B#, C#, D#, F#
//    G: G, A, B, D, E, G
//    G#/Ab: G#, A#, C, E#, F, G#
//    A: A, B, C#, E, F#, A
//    A#/Bb: A#, C, D, F, G, A#
//    B: B, C#, D#, F#, G#,B
//
- (void)testPentatonicMajorScales
{
    NSString *c = @"C D E G A";
    NSString *cSharp = @"C# D# F G# A#";
    NSString *d = @"D E F# A B";
    NSString *dSharp = @"D# F G A# C";
    NSString *e = @"E F# G# B C#";
    NSString *f = @"F G A C D";
    NSString *fSharp = @"F# G# A# C# D#";
    NSString *g = @"G A B D E";
    NSString *gSharp = @"G# A# C D# F";
    NSString *a = @"A B C# E F#";
    NSString *aSharp = @"A# C D F G";
    NSString *b = @"B C# D# F# G#";

    XCTAssert([self evaluateScaleType:@"Pentatonic Major" withRootNote:NOTE_VALUE_C withDescription:c]);
    XCTAssert([self evaluateScaleType:@"Pentatonic Major" withRootNote:NOTE_VALUE_C_SHARP withDescription:cSharp]);
    XCTAssert([self evaluateScaleType:@"Pentatonic Major" withRootNote:NOTE_VALUE_D withDescription:d]);
    XCTAssert([self evaluateScaleType:@"Pentatonic Major" withRootNote:NOTE_VALUE_D_SHARP withDescription:dSharp]);
    XCTAssert([self evaluateScaleType:@"Pentatonic Major" withRootNote:NOTE_VALUE_E withDescription:e]);
    XCTAssert([self evaluateScaleType:@"Pentatonic Major" withRootNote:NOTE_VALUE_F withDescription:f]);
    XCTAssert([self evaluateScaleType:@"Pentatonic Major" withRootNote:NOTE_VALUE_F_SHARP withDescription:fSharp]);
    XCTAssert([self evaluateScaleType:@"Pentatonic Major" withRootNote:NOTE_VALUE_G withDescription:g]);
    XCTAssert([self evaluateScaleType:@"Pentatonic Major" withRootNote:NOTE_VALUE_G_SHARP withDescription:gSharp]);
    XCTAssert([self evaluateScaleType:@"Pentatonic Major" withRootNote:NOTE_VALUE_A withDescription:a]);
    XCTAssert([self evaluateScaleType:@"Pentatonic Major" withRootNote:NOTE_VALUE_A_SHARP withDescription:aSharp]);
    XCTAssert([self evaluateScaleType:@"Pentatonic Major" withRootNote:NOTE_VALUE_B withDescription:b]);
}

//--------------------------------------------------------------------------------
//    Pentatonic Minor Scales
//    C: C, Eb, F, G, Bb, C
//    C#/Db: C#, E, F#, G#, B, C#
//    D: D, F, G, A, C, D
//    D#/Eb: D#, F#, G#, A#, C#, D#
//    E: E, G, A, B, D, E
//    F: F, Ab, Bb, C, Eb, F
//    F#/Gb: F#, A, B, C#, E, F#
//    G: G, Bb, C, D, F, G
//    G#/Ab: G#, B, C#, D#, F#, G#
//    A: A, C, D, E, G, A
//    A#/Bb: A#, C#, D#, E#, G#, A#
//    B: B, D, E, F#, A, B
//
- (void)testPentatonicMinorScales
{
    NSString *c = @"C D# F G A#";
    NSString *cSharp = @"C# E F# G# B";
    NSString *d = @"D F G A C";
    NSString *dSharp = @"D# F# G# A# C#";
    NSString *e = @"E G A B D";
    NSString *f = @"F G# A# C D#";
    NSString *fSharp = @"F# A B C# E";
    NSString *g = @"G A# C D F";
    NSString *gSharp = @"G# B C# D# F#";
    NSString *a = @"A C D E G";
    NSString *aSharp = @"A# C# D# F G#";
    NSString *b = @"B D E F# A";

    XCTAssert([self evaluateScaleType:@"Pentatonic Minor" withRootNote:NOTE_VALUE_C withDescription:c]);
    XCTAssert([self evaluateScaleType:@"Pentatonic Minor" withRootNote:NOTE_VALUE_C_SHARP withDescription:cSharp]);
    XCTAssert([self evaluateScaleType:@"Pentatonic Minor" withRootNote:NOTE_VALUE_D withDescription:d]);
    XCTAssert([self evaluateScaleType:@"Pentatonic Minor" withRootNote:NOTE_VALUE_D_SHARP withDescription:dSharp]);
    XCTAssert([self evaluateScaleType:@"Pentatonic Minor" withRootNote:NOTE_VALUE_E withDescription:e]);
    XCTAssert([self evaluateScaleType:@"Pentatonic Minor" withRootNote:NOTE_VALUE_F withDescription:f]);
    XCTAssert([self evaluateScaleType:@"Pentatonic Minor" withRootNote:NOTE_VALUE_F_SHARP withDescription:fSharp]);
    XCTAssert([self evaluateScaleType:@"Pentatonic Minor" withRootNote:NOTE_VALUE_G withDescription:g]);
    XCTAssert([self evaluateScaleType:@"Pentatonic Minor" withRootNote:NOTE_VALUE_G_SHARP withDescription:gSharp]);
    XCTAssert([self evaluateScaleType:@"Pentatonic Minor" withRootNote:NOTE_VALUE_A withDescription:a]);
    XCTAssert([self evaluateScaleType:@"Pentatonic Minor" withRootNote:NOTE_VALUE_A_SHARP withDescription:aSharp]);
    XCTAssert([self evaluateScaleType:@"Pentatonic Minor" withRootNote:NOTE_VALUE_B withDescription:b]);
}

//--------------------------------------------------------------------------------
//    Minor Blues Scales (Pentatonic)
//    C: C, Eb, F, F#, G, Bb, C
//    D: D, F, G, G#, A, C, D
//    E: E, G, A, A#, B, D, E
//    F: F, Ab, Bb, B, C, Eb, F
//    G: G, Bb, C, C#, D, F#, G
//    A: A, C, D, D#, E, G, A
//    B: B, D, E, F, F#, A, B
//
- (void)testMinorBluesScales
{
    NSString *c = @"C D# F F# G A#";
    NSString *cSharp = @"C# E F# G G# B";
    NSString *d = @"D F G G# A C";
    NSString *dSharp = @"D# F# G# A A# C#";
    NSString *e = @"E G A A# B D";
    NSString *f = @"F G# A# B C D#";
    NSString *fSharp = @"F# A B C C# E";
    NSString *g = @"G A# C C# D F";
    NSString *gSharp = @"G# B C# D D# F#";
    NSString *a = @"A C D D# E G";
    NSString *aSharp = @"A# C# D# E F G#";
    NSString *b = @"B D E F F# A";

    XCTAssert([self evaluateScaleType:@"Minor Blues" withRootNote:NOTE_VALUE_C withDescription:c]);
    XCTAssert([self evaluateScaleType:@"Minor Blues" withRootNote:NOTE_VALUE_C_SHARP withDescription:cSharp]);
    XCTAssert([self evaluateScaleType:@"Minor Blues" withRootNote:NOTE_VALUE_D withDescription:d]);
    XCTAssert([self evaluateScaleType:@"Minor Blues" withRootNote:NOTE_VALUE_D_SHARP withDescription:dSharp]);
    XCTAssert([self evaluateScaleType:@"Minor Blues" withRootNote:NOTE_VALUE_E withDescription:e]);
    XCTAssert([self evaluateScaleType:@"Minor Blues" withRootNote:NOTE_VALUE_F withDescription:f]);
    XCTAssert([self evaluateScaleType:@"Minor Blues" withRootNote:NOTE_VALUE_F_SHARP withDescription:fSharp]);
    XCTAssert([self evaluateScaleType:@"Minor Blues" withRootNote:NOTE_VALUE_G withDescription:g]);
    XCTAssert([self evaluateScaleType:@"Minor Blues" withRootNote:NOTE_VALUE_G_SHARP withDescription:gSharp]);
    XCTAssert([self evaluateScaleType:@"Minor Blues" withRootNote:NOTE_VALUE_A withDescription:a]);
    XCTAssert([self evaluateScaleType:@"Minor Blues" withRootNote:NOTE_VALUE_A_SHARP withDescription:aSharp]);
    XCTAssert([self evaluateScaleType:@"Minor Blues" withRootNote:NOTE_VALUE_B withDescription:b]);
}

//--------------------------------------------------------------------------------
//    Major Blues Scales (Pentatonic)
//    C: C, D, Eb, E, G, A, C
//    D: D, E, F, F#, A, B, D
//    E: E, F#, G, G#, B, C#, E
//    F: F, G, Ab, A, C, D, F
//    G: G, A, Bb, B, D, E, G
//    A: A, B, C, C#, E, F#, A
//    B: B, C#, D, D#, F#, G#, B
//
- (void)testMajorBluesScales
{
    NSString *c = @"C D D# E G A";
    NSString *cSharp = @"C# D# E F G# A#";
    NSString *d = @"D E F F# A B";
    NSString *dSharp = @"D# F F# G A# C";
    NSString *e = @"E F# G G# B C#";
    NSString *f = @"F G G# A C D";
    NSString *fSharp = @"F# G# A A# C# D#";
    NSString *g = @"G A A# B D E";
    NSString *gSharp = @"G# A# B C D# F";
    NSString *a = @"A B C C# E F#";
    NSString *aSharp = @"A# C C# D F G";
    NSString *b = @"B C# D D# F# G#";

    XCTAssert([self evaluateScaleType:@"Major Blues" withRootNote:NOTE_VALUE_C withDescription:c]);
    XCTAssert([self evaluateScaleType:@"Major Blues" withRootNote:NOTE_VALUE_C_SHARP withDescription:cSharp]);
    XCTAssert([self evaluateScaleType:@"Major Blues" withRootNote:NOTE_VALUE_D withDescription:d]);
    XCTAssert([self evaluateScaleType:@"Major Blues" withRootNote:NOTE_VALUE_D_SHARP withDescription:dSharp]);
    XCTAssert([self evaluateScaleType:@"Major Blues" withRootNote:NOTE_VALUE_E withDescription:e]);
    XCTAssert([self evaluateScaleType:@"Major Blues" withRootNote:NOTE_VALUE_F withDescription:f]);
    XCTAssert([self evaluateScaleType:@"Major Blues" withRootNote:NOTE_VALUE_F_SHARP withDescription:fSharp]);
    XCTAssert([self evaluateScaleType:@"Major Blues" withRootNote:NOTE_VALUE_G withDescription:g]);
    XCTAssert([self evaluateScaleType:@"Major Blues" withRootNote:NOTE_VALUE_G_SHARP withDescription:gSharp]);
    XCTAssert([self evaluateScaleType:@"Major Blues" withRootNote:NOTE_VALUE_A withDescription:a]);
    XCTAssert([self evaluateScaleType:@"Major Blues" withRootNote:NOTE_VALUE_A_SHARP withDescription:aSharp]);
    XCTAssert([self evaluateScaleType:@"Major Blues" withRootNote:NOTE_VALUE_B withDescription:b]);
}

//--------------------------------------------------------------------------------

- (void) testMajorChords
{
    NSString *c = @"C E G";
    NSString *cSharp = @"C# F G#";
    NSString *d = @"D F# A";
    NSString *dSharp = @"D# G A#";
    NSString *e = @"E G# B";
    NSString *f = @"F A C";
    NSString *fSharp = @"F# A# C#";
    NSString *g = @"G B D";
    NSString *gSharp = @"G# C D#";
    NSString *a = @"A C# E";
    NSString *aSharp = @"A# D F";
    NSString *b = @"B D# F#";
    
    XCTAssert([self evaluateChordType:@"Major" withRootNote:NOTE_VALUE_C withDescription:c]);
    XCTAssert([self evaluateChordType:@"Major" withRootNote:NOTE_VALUE_C_SHARP withDescription:cSharp]);
    XCTAssert([self evaluateChordType:@"Major" withRootNote:NOTE_VALUE_D withDescription:d]);
    XCTAssert([self evaluateChordType:@"Major" withRootNote:NOTE_VALUE_D_SHARP withDescription:dSharp]);
    XCTAssert([self evaluateChordType:@"Major" withRootNote:NOTE_VALUE_E withDescription:e]);
    XCTAssert([self evaluateChordType:@"Major" withRootNote:NOTE_VALUE_F withDescription:f]);
    XCTAssert([self evaluateChordType:@"Major" withRootNote:NOTE_VALUE_F_SHARP withDescription:fSharp]);
    XCTAssert([self evaluateChordType:@"Major" withRootNote:NOTE_VALUE_G withDescription:g]);
    XCTAssert([self evaluateChordType:@"Major" withRootNote:NOTE_VALUE_G_SHARP withDescription:gSharp]);
    XCTAssert([self evaluateChordType:@"Major" withRootNote:NOTE_VALUE_A withDescription:a]);
    XCTAssert([self evaluateChordType:@"Major" withRootNote:NOTE_VALUE_A_SHARP withDescription:aSharp]);
    XCTAssert([self evaluateChordType:@"Major" withRootNote:NOTE_VALUE_B withDescription:b]);
}

- (void) testMinorChords
{
    NSString *c = @"C D# G";
    NSString *cSharp = @"C# E G#";
    NSString *d = @"D F A";
    NSString *dSharp = @"D# F# A#";
    NSString *e = @"E G B";
    NSString *f = @"F G# C";
    NSString *fSharp = @"F# A C#";
    NSString *g = @"G A# D";
    NSString *gSharp = @"G# B D#";
    NSString *a = @"A C E";
    NSString *aSharp = @"A# C# F";
    NSString *b = @"B D F#";

    XCTAssert([self evaluateChordType:@"Minor" withRootNote:NOTE_VALUE_C withDescription:c]);
    XCTAssert([self evaluateChordType:@"Minor" withRootNote:NOTE_VALUE_C_SHARP withDescription:cSharp]);
    XCTAssert([self evaluateChordType:@"Minor" withRootNote:NOTE_VALUE_D withDescription:d]);
    XCTAssert([self evaluateChordType:@"Minor" withRootNote:NOTE_VALUE_D_SHARP withDescription:dSharp]);
    XCTAssert([self evaluateChordType:@"Minor" withRootNote:NOTE_VALUE_E withDescription:e]);
    XCTAssert([self evaluateChordType:@"Minor" withRootNote:NOTE_VALUE_F withDescription:f]);
    XCTAssert([self evaluateChordType:@"Minor" withRootNote:NOTE_VALUE_F_SHARP withDescription:fSharp]);
    XCTAssert([self evaluateChordType:@"Minor" withRootNote:NOTE_VALUE_G withDescription:g]);
    XCTAssert([self evaluateChordType:@"Minor" withRootNote:NOTE_VALUE_G_SHARP withDescription:gSharp]);
    XCTAssert([self evaluateChordType:@"Minor" withRootNote:NOTE_VALUE_A withDescription:a]);
    XCTAssert([self evaluateChordType:@"Minor" withRootNote:NOTE_VALUE_A_SHARP withDescription:aSharp]);
    XCTAssert([self evaluateChordType:@"Minor" withRootNote:NOTE_VALUE_B withDescription:b]);
}

- (void) testAugmentedChords
{
    NSString *c = @"C E G#";
    NSString *cSharp = @"C# F A";
    NSString *d = @"D F# A#";
    NSString *dSharp = @"D# G B";
    NSString *e = @"E G# C";
    NSString *f = @"F A C#";
    NSString *fSharp = @"F# A# D";
    NSString *g = @"G B D#";
    NSString *gSharp = @"G# C E";
    NSString *a = @"A C# F";
    NSString *aSharp = @"A# D F#";
    NSString *b = @"B D# G";
    
    XCTAssert([self evaluateChordType:@"Augmented" withRootNote:NOTE_VALUE_C withDescription:c]);
    XCTAssert([self evaluateChordType:@"Augmented" withRootNote:NOTE_VALUE_C_SHARP withDescription:cSharp]);
    XCTAssert([self evaluateChordType:@"Augmented" withRootNote:NOTE_VALUE_D withDescription:d]);
    XCTAssert([self evaluateChordType:@"Augmented" withRootNote:NOTE_VALUE_D_SHARP withDescription:dSharp]);
    XCTAssert([self evaluateChordType:@"Augmented" withRootNote:NOTE_VALUE_E withDescription:e]);
    XCTAssert([self evaluateChordType:@"Augmented" withRootNote:NOTE_VALUE_F withDescription:f]);
    XCTAssert([self evaluateChordType:@"Augmented" withRootNote:NOTE_VALUE_F_SHARP withDescription:fSharp]);
    XCTAssert([self evaluateChordType:@"Augmented" withRootNote:NOTE_VALUE_G withDescription:g]);
    XCTAssert([self evaluateChordType:@"Augmented" withRootNote:NOTE_VALUE_G_SHARP withDescription:gSharp]);
    XCTAssert([self evaluateChordType:@"Augmented" withRootNote:NOTE_VALUE_A withDescription:a]);
    XCTAssert([self evaluateChordType:@"Augmented" withRootNote:NOTE_VALUE_A_SHARP withDescription:aSharp]);
    XCTAssert([self evaluateChordType:@"Augmented" withRootNote:NOTE_VALUE_B withDescription:b]);
}

- (void) testDiminishedChords
{
    NSString *c = @"C D# F#";
    NSString *cSharp = @"C# E G";
    NSString *d = @"D F G#";
    NSString *dSharp = @"D# F# A";
    NSString *e = @"E G A#";
    NSString *f = @"F G# B";
    NSString *fSharp = @"F# A C";
    NSString *g = @"G A# C#";
    NSString *gSharp = @"G# B D";
    NSString *a = @"A C D#";
    NSString *aSharp = @"A# C# E";
    NSString *b = @"B D F";

    XCTAssert([self evaluateChordType:@"Diminished" withRootNote:NOTE_VALUE_C withDescription:c]);
    XCTAssert([self evaluateChordType:@"Diminished" withRootNote:NOTE_VALUE_C_SHARP withDescription:cSharp]);
    XCTAssert([self evaluateChordType:@"Diminished" withRootNote:NOTE_VALUE_D withDescription:d]);
    XCTAssert([self evaluateChordType:@"Diminished" withRootNote:NOTE_VALUE_D_SHARP withDescription:dSharp]);
    XCTAssert([self evaluateChordType:@"Diminished" withRootNote:NOTE_VALUE_E withDescription:e]);
    XCTAssert([self evaluateChordType:@"Diminished" withRootNote:NOTE_VALUE_F withDescription:f]);
    XCTAssert([self evaluateChordType:@"Diminished" withRootNote:NOTE_VALUE_F_SHARP withDescription:fSharp]);
    XCTAssert([self evaluateChordType:@"Diminished" withRootNote:NOTE_VALUE_G withDescription:g]);
    XCTAssert([self evaluateChordType:@"Diminished" withRootNote:NOTE_VALUE_G_SHARP withDescription:gSharp]);
    XCTAssert([self evaluateChordType:@"Diminished" withRootNote:NOTE_VALUE_A withDescription:a]);
    XCTAssert([self evaluateChordType:@"Diminished" withRootNote:NOTE_VALUE_A_SHARP withDescription:aSharp]);
    XCTAssert([self evaluateChordType:@"Diminished" withRootNote:NOTE_VALUE_B withDescription:b]);
}

- (void) testSuspendedFourthChords
{
    NSString *c = @"C F G";
    NSString *cSharp = @"C# F# G#";
    NSString *d = @"D G A";
    NSString *dSharp = @"D# G# A#";
    NSString *e = @"E A B";
    NSString *f = @"F A# C";
    NSString *fSharp = @"F# B C#";
    NSString *g = @"G C D";
    NSString *gSharp = @"G# C# D#";
    NSString *a = @"A D E";
    NSString *aSharp = @"A# D# F";
    NSString *b = @"B E F#";
    
    XCTAssert([self evaluateChordType:@"Suspended Fourth" withRootNote:NOTE_VALUE_C withDescription:c]);
    XCTAssert([self evaluateChordType:@"Suspended Fourth" withRootNote:NOTE_VALUE_C_SHARP withDescription:cSharp]);
    XCTAssert([self evaluateChordType:@"Suspended Fourth" withRootNote:NOTE_VALUE_D withDescription:d]);
    XCTAssert([self evaluateChordType:@"Suspended Fourth" withRootNote:NOTE_VALUE_D_SHARP withDescription:dSharp]);
    XCTAssert([self evaluateChordType:@"Suspended Fourth" withRootNote:NOTE_VALUE_E withDescription:e]);
    XCTAssert([self evaluateChordType:@"Suspended Fourth" withRootNote:NOTE_VALUE_F withDescription:f]);
    XCTAssert([self evaluateChordType:@"Suspended Fourth" withRootNote:NOTE_VALUE_F_SHARP withDescription:fSharp]);
    XCTAssert([self evaluateChordType:@"Suspended Fourth" withRootNote:NOTE_VALUE_G withDescription:g]);
    XCTAssert([self evaluateChordType:@"Suspended Fourth" withRootNote:NOTE_VALUE_G_SHARP withDescription:gSharp]);
    XCTAssert([self evaluateChordType:@"Suspended Fourth" withRootNote:NOTE_VALUE_A withDescription:a]);
    XCTAssert([self evaluateChordType:@"Suspended Fourth" withRootNote:NOTE_VALUE_A_SHARP withDescription:aSharp]);
    XCTAssert([self evaluateChordType:@"Suspended Fourth" withRootNote:NOTE_VALUE_B withDescription:b]);
}

- (void) testSuspendedSecondChords
{
    NSString *c = @"C D G";
    NSString *cSharp = @"C# D# G#";
    NSString *d = @"D E A";
    NSString *dSharp = @"D# F A#";
    NSString *e = @"E F# B";
    NSString *f = @"F G C";
    NSString *fSharp = @"F# G# C#";
    NSString *g = @"G A D";
    NSString *gSharp = @"G# A# D#";
    NSString *a = @"A B E";
    NSString *aSharp = @"A# C F";
    NSString *b = @"B C# F#";

    XCTAssert([self evaluateChordType:@"Suspended Second" withRootNote:NOTE_VALUE_C withDescription:c]);
    XCTAssert([self evaluateChordType:@"Suspended Second" withRootNote:NOTE_VALUE_C_SHARP withDescription:cSharp]);
    XCTAssert([self evaluateChordType:@"Suspended Second" withRootNote:NOTE_VALUE_D withDescription:d]);
    XCTAssert([self evaluateChordType:@"Suspended Second" withRootNote:NOTE_VALUE_D_SHARP withDescription:dSharp]);
    XCTAssert([self evaluateChordType:@"Suspended Second" withRootNote:NOTE_VALUE_E withDescription:e]);
    XCTAssert([self evaluateChordType:@"Suspended Second" withRootNote:NOTE_VALUE_F withDescription:f]);
    XCTAssert([self evaluateChordType:@"Suspended Second" withRootNote:NOTE_VALUE_F_SHARP withDescription:fSharp]);
    XCTAssert([self evaluateChordType:@"Suspended Second" withRootNote:NOTE_VALUE_G withDescription:g]);
    XCTAssert([self evaluateChordType:@"Suspended Second" withRootNote:NOTE_VALUE_G_SHARP withDescription:gSharp]);
    XCTAssert([self evaluateChordType:@"Suspended Second" withRootNote:NOTE_VALUE_A withDescription:a]);
    XCTAssert([self evaluateChordType:@"Suspended Second" withRootNote:NOTE_VALUE_A_SHARP withDescription:aSharp]);
    XCTAssert([self evaluateChordType:@"Suspended Second" withRootNote:NOTE_VALUE_B withDescription:b]);
}

@end
