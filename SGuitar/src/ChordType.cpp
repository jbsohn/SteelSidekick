//
//  ChordType.cpp
//  SGuitar
//
//  Created by John Sohn on 2/24/16.
//  Copyright © 2016 John Sohn. All rights reserved.
//

#include <vector>
#include "SG/ChordType.h"
#include "JsonBox.h"

namespace SG {
    struct ChordType::ChordTypeImpl {
        std::string name;
        std::vector<int> intervals;
        bool isValid;
        
        void init(const ChordType& chordType) {
            name = chordType.impl->name;
            intervals = chordType.impl->intervals;
        }
    };
    
    ChordType::ChordType() : impl(new ChordTypeImpl) {
        impl->name = "";
        impl->intervals = {};
        impl->isValid = false;
    }
    
    ChordType::ChordType(std::string name, std::vector<int> intervals) : impl(new ChordTypeImpl) {
        impl->name = name;
        impl->intervals = intervals;
        impl->isValid = true;
    }

    ChordType::ChordType(const ChordType& chordType) : impl(new ChordTypeImpl) {
        impl->init(chordType);
    }

    ChordType::~ChordType() {
        
    }
    
    ChordType& ChordType::operator=(const ChordType& ChordType) {
        impl->init(ChordType);
        return *this;
    }
    
    ChordType::ChordType(ChordType&& chordType) {
        impl = std::move(chordType.impl);
        chordType.impl = nullptr;
    }
    
    ChordType& ChordType::operator=(ChordType&& chordType) {
        if (this != &chordType) {
            impl = std::move(chordType.impl);
            chordType.impl = nullptr;
        }
        return *this;
    }
    
    bool ChordType::isValid() const {
        return impl->isValid;
    }
    
    std::string ChordType::getName() {
        return impl->name;
    }
    
    std::vector<int> ChordType::getintervals() {
        return impl->intervals;
    }
    
    

}