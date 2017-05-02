//
//  ChordOptions.h
//  SGuitar
//
//  Created by John Sohn on 2/25/16.
//  Copyright © 2016 John Sohn. All rights reserved.
//

#ifndef _ChordOptions_h_
#define _ChordOptions_h_

#include "OptionTypes.hpp"
#include "Note.hpp"
#include "Chord.hpp"

#ifdef __cplusplus
#include <string>

namespace SG {
    //
    // storage container for the chord settings
    //
    class ChordOptions {
    protected:
        bool showChord;
        std::string chordName;
        int chordRootNoteValue;
        DISPLAY_ITEM_AS_TYPE displayItemsAs;
        
    public:
        ChordOptions();
        ~ChordOptions();
        
        void setShowChord(bool showChord) {
            this->showChord = showChord;
        }
        
        bool getShowChord() const {
            return showChord;
        }
        
        void setChordName(std::string chordName) {
            this->chordName = chordName;
        }
        
        std::string getChordName() const {
            return chordName;
        }
        
        void setChordRootNoteValue(int rootNoteValue) {
            this->chordRootNoteValue = rootNoteValue;
        }
        
        int getChordRootNoteValue() const {
            return chordRootNoteValue;
        }
        
        
        void setDisplayItemsAs(DISPLAY_ITEM_AS_TYPE type) {
            this->displayItemsAs = type;
        }
        
        DISPLAY_ITEM_AS_TYPE getDisplayItemsAs() const {
            return displayItemsAs;
        }
    };
}
#endif

#endif
