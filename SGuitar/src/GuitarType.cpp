//
//  GuitarType.cpp
//  SGuitar
//
//  Created by John Sohn on 2/29/16.
//  Copyright © 2016 John Sohn. All rights reserved.
//

#include <vector>
#include "SG/GuitarType.h"
#include "JsonBox.h"

namespace SG {
    struct GuitarType::GuitarTypeImpl {
        std::string name;
        std::string description;
        bool isCustomType;
        bool isValid;
        
        void init(const GuitarType& guitarType) {
            name = guitarType.impl->name;
            description = guitarType.impl->description;
            isCustomType = guitarType.impl->isCustomType;
        }
    };
    
    GuitarType::GuitarType() : impl(new GuitarTypeImpl) {
        impl->name = "";
        impl->description = "";
        impl->isCustomType = false;
        impl->isValid = false;
    }
    
    GuitarType::GuitarType(std::string name, std::string description, bool isCustomType) : impl(new GuitarTypeImpl) {
        impl->name = name;
        impl->description = description;
        impl->isCustomType = isCustomType;
    }
    
    GuitarType::GuitarType(const GuitarType& guitarType) : impl(new GuitarTypeImpl) {
        impl->init(guitarType);
    }
    
    GuitarType::~GuitarType() {
        
    }

    GuitarType& GuitarType::operator=(const GuitarType& guitarType) {
        impl->init(guitarType);
        return *this;
    }

    GuitarType::GuitarType(GuitarType&& guitarType) {
        impl = std::move(guitarType.impl);
        guitarType.impl = nullptr;
    }
    
    GuitarType& GuitarType::operator=(GuitarType&& guitarType) {
        if (this != &guitarType) {
            impl = std::move(guitarType.impl);
            guitarType.impl = nullptr;
        }
        return *this;
    }
    
    bool GuitarType::isValid() const {
        return impl->isValid;
    }

    std::string GuitarType::getName() {
        return impl->name;
    }
    
    std::string GuitarType::getDescription() {
        return impl->description;
    }
    
    bool GuitarType::isCustomType() {
        return impl->isCustomType;
    }

}