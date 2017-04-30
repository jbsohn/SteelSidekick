//
//  ChordType.cpp
//  SGuitar
//
//  Created by John Sohn on 2/24/16.
//  Copyright © 2016 John Sohn. All rights reserved.
//

#include <vector>
#include "SG/ChordType.hpp"
#include "JsonBox.h"

namespace SG {
    ChordType::ChordType() {
        name = "";
        intervals = {};
        valid = false;
    }
    
    ChordType::ChordType(std::string name, std::vector<int> intervals) {
        this->name = name;
        this->intervals = intervals;
        this->valid = true;
    }

    ChordType::~ChordType() {
        
    }
    
    void ChordType::init(const ChordType& chordType) {
        name = chordType.name;
        intervals = chordType.intervals;
    }
}
