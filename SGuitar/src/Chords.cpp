//
//  Chords.cpp
//  SGuitar
//
//  Created by John Sohn on 2/22/16.
//  Copyright © 2016 John Sohn. All rights reserved.
//

#include <vector>
#include "SG/Chords.hpp"
#include "SG/FileUtils.hpp"
#include "JsonBox.h"

namespace SG {
    Chords::Chords() {

    }

    Chords::~Chords() {
        
    }
    
    void Chords::readFile(std::string filename) {
        std::string json = FileUtils::readFile(filename);
        readString(json);
    }
    
    bool Chords::readString(std::string json) {
        try {
            chords.clear();
            valid = false;
            
            JsonBox::Value root;
            root.loadFromString(json);
            
            if (root.isNull()) {
                return false;
            }
            
            JsonBox::Array rootArray = root.getArray();
            
            if (rootArray.empty()) {
                valid = false;
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
                chords.push_back(curChordType);
            }
        } catch (...) {
            valid = false;
            return false;
        }
        
        valid = true;
        return true;
    }

    ChordType Chords::getChordType(std::string chordName) {
        ChordType chord;
        
        for (ChordType curChord : chords) {
            if (curChord.getName() == chordName) {
                chord = curChord;
                break;
            }
        }
        return chord;
    }
}
