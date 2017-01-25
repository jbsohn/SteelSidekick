//
//  Chord.h
//  SGuitar
//
//  Created by John Sohn on 12/9/14.
//  Copyright (c) 2014 John Sohn. All rights reserved.
//

#ifndef __Chord_h__
#define __Chord_h__

#include "Note.h"

#ifdef __cplusplus
#include <memory>
#include <vector>

namespace SG {
    class Chord {
    public:
        Chord();
        Chord(int rootNoteValue, std::vector<int> intervals);
        Chord(const Chord& chord);
        Chord& operator=(const Chord& chord);
        Chord(Chord&& chord);
        Chord& operator=(Chord&& chord);
        ~Chord();
        
        bool isValid() const;

        std::vector<int> getNoteValues() const;
        int getNumberOfScaleNotes() const;
        int getScaleNote(int index) const;
    
        bool isNoteValueInChord(int noteValue) const;

        std::string unitTestDescription();
    private:
        struct ChordImpl;
        std::unique_ptr<ChordImpl> impl;
    };
}
#endif

#ifdef __OBJC__

@interface Chord : NSObject

- (NSArray*)getNoteValues;
- (int)getNumberOfScaleNotes;
- (int)getScaleNote:(int)index;
- (BOOL)isNoteValueInChord:(int)noteValue;
- (NSString *)unitTestDescription;

@end

#endif

#endif
