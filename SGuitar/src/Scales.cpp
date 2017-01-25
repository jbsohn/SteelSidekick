//
//  Scales.cpp
//  SGuitar
//
//  Created by John Sohn on 2/22/16.
//  Copyright © 2016 John Sohn. All rights reserved.
//

#include <vector>
#include "SG/Scales.h"
#include "SG/Scale.h"
#include "SG/FileUtils.h"
#include "JsonBox.h"

namespace SG {
    struct Scales::ScalesImpl {
        std::vector<ScaleType> scales;
        bool isValid;
    };

    Scales::Scales() : impl(new ScalesImpl) {

    }

    Scales::~Scales() {
        
    }
    
    bool Scales::isValid() const {
        return impl->isValid;
    }

    void Scales::readFile(std::string filename) {
        std::string json = FileUtils::readFile(filename);
        readString(json);
    }
    
    bool Scales::readString(std::string json) {
        try {
            impl->scales.clear();
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
                std::vector<int> semitones;
                
                JsonBox::Value semitonesValue = object["Semitones"];
                JsonBox::Array semitonesArray = semitonesValue.getArray();

                for (JsonBox::Value cur : semitonesArray) {
                    if (cur.isInteger()) {
                        semitones.push_back(cur.getInteger());
                    }
                }
                
                ScaleType curScaleType(name, semitones);
                impl->scales.push_back(curScaleType);
            }
        } catch (...) {
            impl->isValid = false;
            return false;
        }
        
        impl->isValid = true;
        return true;
    }
    
    std::vector<SG::ScaleType> Scales::getScales() const {
        return impl->scales;
    }
    
    SG::ScaleType Scales::getScaleType(std::string scaleName) {
        ScaleType scale;

        for (ScaleType curScale : impl->scales) {
            if (curScale.getName() == scaleName) {
                scale = curScale;
                break;
            }
        }
        return scale;
    }
}
