//
//  Scales.cpp
//  SGuitar
//
//  Created by John Sohn on 2/22/16.
//  Copyright © 2016 John Sohn. All rights reserved.
//

#include <vector>
#include "SG/Scales.hpp"
#include "SG/Scale.hpp"
#include "SG/FileUtils.hpp"
#include "JsonBox.h"

namespace SG {
    Scales::Scales() {

    }

    Scales::~Scales() {
        
    }
    
    void Scales::readFile(std::string filename) {
        std::string json = FileUtils::readFile(filename);
        readString(json);
    }
    
    bool Scales::readString(std::string json) {
        try {
            scales.clear();
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
                std::vector<int> semitones;
                
                JsonBox::Value semitonesValue = object["Semitones"];
                JsonBox::Array semitonesArray = semitonesValue.getArray();

                for (JsonBox::Value cur : semitonesArray) {
                    if (cur.isInteger()) {
                        semitones.push_back(cur.getInteger());
                    }
                }
                
                ScaleType curScaleType(name, semitones);
                scales.push_back(curScaleType);
            }
        } catch (...) {
            valid = false;
            return false;
        }
        
        valid = true;
        return true;
    }
    
    SG::ScaleType Scales::getScaleType(std::string scaleName) {
        ScaleType scale;

        for (ScaleType curScale : scales) {
            if (curScale.getName() == scaleName) {
                scale = curScale;
                break;
            }
        }
        return scale;
    }
}
