//
//  GuitarTypes.cpp
//  SGuitar
//
//  Created by John Sohn on 5/13/16.
//  Copyright © 2016 John Sohn. All rights reserved.
//

#include <JsonBox.h>
#include "SG/GuitarTypes.hpp"
#include "SG/FileUtils.hpp"

namespace SG {
    GuitarTypes::GuitarTypes() {
        valid = false;
    }

    GuitarTypes::~GuitarTypes() {
        
    }

    bool GuitarTypes::isValid() const {
        return valid;
    }
    
    bool GuitarTypes::readFile(std::string filename) {
        std::string json = FileUtils::readFile(filename);
        readGuitarTypes(json);
        return false;
    }
    
    std::vector<GuitarType> GuitarTypes::getGuitarTypes() {
        return types;
    }
    
    GuitarType GuitarTypes::getGuitarType(std::string type) {
        GuitarType guitarType;
    
        for (GuitarType curGuitarType : types) {
            if (curGuitarType.getName() == type) {
                guitarType = curGuitarType;
                break;
            }
        }
        return guitarType;
    }
    
    std::vector<GuitarType> GuitarTypes::readGuitarTypes(std::string json) {
        JsonBox::Value root;
        root.loadFromString(json);
        
        if (!root.isNull()) {
            JsonBox::Array rootTypes = root.getArray();
            
            if (!rootTypes.empty()) {
                for (JsonBox::Value curType : rootTypes) {
                    JsonBox::Value typeRoot = curType["type"];
                    std::string type = "";
                    if (typeRoot.isString()) {
                        type = typeRoot.getString();
                    }
                    
                    JsonBox::Value descriptionRoot = curType["type"];
                    std::string description = "";
                    if (descriptionRoot.isString()) {
                        description = typeRoot.getString();
                    }
                    
                    JsonBox::Value isCustomTypeRoot = curType["isCustomType"];
                    bool isCustomType = false;
                    if (isCustomTypeRoot.isBoolean()) {
                        isCustomType = isCustomTypeRoot.getBoolean();
                    }
                    
                    GuitarType newType(type, description, isCustomType);
                    types.push_back(newType);
                }
            }
        }
        
        return types;
    }
}
