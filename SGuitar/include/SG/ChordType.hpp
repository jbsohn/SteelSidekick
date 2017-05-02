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

namespace SG {
    //
    // storage container for the scale name and its intervals
    //
    class ChordType {
    protected:
        std::string name;
        std::vector<int> intervals;
        bool valid;
        
    public:
        ChordType();
        ChordType(std::string name, std::vector<int> intervals);
        ~ChordType();

        bool isValid() const {
            return valid;
        }
        
        std::string getName() {
            return name;
        }
        
        std::vector<int> getintervals() {
            return intervals;
        }
    protected:
        void init(const ChordType& chordType);
    };
}
#endif

#endif
