//
//  Chords.cpp
//  SGuitar
//
//  Created by John Sohn on 2/22/16.
//  Copyright © 2016 John Sohn. All rights reserved.
//

#include <vector>
#include "SG/Chords.h"
#include "SG/FileUtils.h"
#include "JsonBox.h"

namespace SG {
    struct Chords::ChordsImpl {
        std::vector<ChordType> chords;
        bool isValid;
    };

    Chords::Chords() : impl(new ChordsImpl) {

    }

    Chords::~Chords() {
        
    }
    
    bool Chords::isValid() const {
        return impl->isValid;
    }

    void Chords::readFile(std::string filename) {
        std::string json = FileUtils::readFile(filename);
        readString(json);
    }
    
    bool Chords::readString(std::string json) {
        try {
            impl->chords.clear();
            impl->isValid = false;
            
            JsonBox::Value root;
            root.loadFromString(json);
            
            if (root.isNull()) {
                return false;
            }
            
            JsonBox::Array rootArray = root.getArray();
            
            if (rootArray.empty()) {
                impl->isValid = false;
                return false;
            }
            
            for (JsonBox::Value cur: rootArray) {
                JsonBox::Object object = cur.getObject();
                
                JsonBox::Value nameValue = object["Name"];
                std::string name = nameValue.getString();
                std::vector<int> intervals;
                
                JsonBox::Value intervalsValue = object["Intervals"];
                JsonBox::Array intervalsArray = intervalsValue.getArray();

                for (JsonBox::Value cur : intervalsArray) {
                    if (cur.isInteger()) {
                        intervals.push_back(cur.getInteger());
                    }
                }
                
                ChordType curChordType(name, intervals);
                impl->chords.push_back(curChordType);
            }
        } catch (...) {
            impl->isValid = false;
            return false;
        }
        
        impl->isValid = true;
        return true;
    }

    std::vector<ChordType> Chords::getChords() const {
        return impl->chords;
    }
    
    ChordType Chords::getChordType(std::string chordName) {
        ChordType chord;
        
        for (ChordType curChord : impl->chords) {
            if (curChord.getName() == chordName) {
                chord = curChord;
                break;
            }
        }
        return chord;
    }
}
