//
//  ScaleType.cpp
//  SGuitar
//
//  Created by John Sohn on 2/24/16.
//  Copyright © 2016 John Sohn. All rights reserved.
//

#include <vector>
#include "SG/ScaleType.h"

namespace SG {
    struct ScaleType::ScaleTypeImpl {
        std::string name;
        std::vector<int> semitones;
        bool isValid;
        
        void init(const ScaleType& scaleType) {
            name = scaleType.impl->name;
            semitones = scaleType.impl->semitones;
        }
    };
    
    ScaleType::ScaleType() : impl(new ScaleTypeImpl) {
        impl->name = "";
        impl->semitones = {};
        impl->isValid = false;
    }
    
    ScaleType::ScaleType(std::string name, std::vector<int> semitones) : impl(new ScaleTypeImpl) {
        impl->name = name;
        impl->semitones = semitones;
        impl->isValid = true;
    }
    
    ScaleType::ScaleType(const ScaleType& scaleType) : impl(new ScaleTypeImpl) {
        impl->init(scaleType);
    }

    ScaleType::~ScaleType() {
        
    }

    ScaleType& ScaleType::operator=(const ScaleType& scaleType) {
        impl->init(scaleType);
        return *this;
    }

    ScaleType::ScaleType(ScaleType&& scaleType) {
        impl = std::move(scaleType.impl);
        scaleType.impl = nullptr;
    }
    
    ScaleType& ScaleType::operator=(ScaleType&& scaleType) {
        if (this != &scaleType) {
            impl = std::move(scaleType.impl);
            scaleType.impl = nullptr;
        }
        return *this;
    }

    bool ScaleType::isValid() const {
        return impl->isValid;
    }
    
    std::string ScaleType::getName() {
        return impl->name;
    }
    
    std::vector<int> ScaleType::getSemitones() {
        return impl->semitones;
    }
    
    
}
