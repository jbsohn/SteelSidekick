//
//  ChordOptions.cpp
//  SGuitar
//
//  Created by John Sohn on 2/25/16.
//  Copyright © 2016 John Sohn. All rights reserved.
//

#include "SG/ChordOptions.h"

namespace SG {
    struct ChordOptions::ChordOptionsImpl {
        bool showChord;
        std::string chordName;
        int chordRootNoteValue;
        DISPLAY_ITEM_AS_TYPE displayItemsAs;
        
        void init(const ChordOptions& options) {
            showChord = options.impl->showChord;
            chordName = options.impl->chordName;
            chordRootNoteValue = options.impl->chordRootNoteValue;
            displayItemsAs = options.impl->displayItemsAs;
        }
    };

    ChordOptions::ChordOptions() : impl(new ChordOptionsImpl) {
        impl->showChord = true;
        impl->chordName = "";
        impl->chordRootNoteValue = NOTE_VALUE_C;
        impl->displayItemsAs = DIA_NOTES;
    }

    ChordOptions::~ChordOptions() {
        
    }

    ChordOptions::ChordOptions(const ChordOptions& options) : impl(new ChordOptionsImpl) {
        impl->init(options);
    }

    ChordOptions& ChordOptions::operator=(const ChordOptions& options) {
        impl->init(options);
        return *this;
    }

    ChordOptions::ChordOptions(ChordOptions&& chordOptions) {
        impl = std::move(chordOptions.impl);
        chordOptions.impl = nullptr;
    }
    
    ChordOptions& ChordOptions::operator=(ChordOptions&& chordOptions) {
        if (this != &chordOptions) {
            impl = std::move(chordOptions.impl);
            chordOptions.impl = nullptr;
        }
        return *this;
    }

    void ChordOptions::setShowChord(bool showChord) {
        impl->showChord = showChord;
    }
    
    bool ChordOptions::getShowChord() const {
        return impl->showChord;
    }
    
    void ChordOptions::setChordName(std::string chordName) {
        impl->chordName = chordName;
    }
    
    std::string ChordOptions::getChordName() const {
        return impl->chordName;
    }
    
    void ChordOptions::setChordRootNoteValue(int rootNoteValue) {
        impl->chordRootNoteValue = rootNoteValue;
    }
    
    int ChordOptions::getChordRootNoteValue() const {
        return impl->chordRootNoteValue;
    }
    
    
    void ChordOptions::setDisplayItemsAs(DISPLAY_ITEM_AS_TYPE type) {
        impl->displayItemsAs = type;
    }
    
    DISPLAY_ITEM_AS_TYPE ChordOptions::getDisplayItemsAs() const {
        return impl->displayItemsAs;
    }
    
}
