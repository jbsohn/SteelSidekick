//
//  ChordType.h
//  SGuitar
//
//  Created by John Sohn on 2/24/16.
//  Copyright © 2016 John Sohn. All rights reserved.
//

#ifndef _ChordType_h_
#define _ChordType_h_

#ifdef __cplusplus
#include <vector>
#include <string>
#include <memory>

namespace SG {
    class ChordType {
    public:
        ChordType();
        ChordType(std::string name, std::vector<int> intervals);
        ChordType(const ChordType& chordType);
        ChordType& operator=(const ChordType& chordType);
        ChordType(ChordType&& chordType);
        ChordType& operator=(ChordType&& chordType);
        ~ChordType();

        bool isValid() const;
        
        std::string getName();
        std::vector<int> getintervals();
    private:
        struct ChordTypeImpl;
        std::unique_ptr<ChordTypeImpl> impl;
    };
}
#endif

#endif