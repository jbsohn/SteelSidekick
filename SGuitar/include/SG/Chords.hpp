//
//  Chords.h
//  SGuitar
//
//  Created by John Sohn on 2/22/16.
//  Copyright © 2016 John Sohn. All rights reserved.
//

#ifndef __Chords_h__
#define __Chords_h__

#include "ChordType.hpp"

#ifdef __cplusplus
#include <vector>
#include <string>

namespace SG {
    class Chords {
    protected:
        std::vector<ChordType> chords;
        bool valid;
        
    public:
        Chords();
        ~Chords();

        bool isValid() const {
            return valid;
        }

        std::vector<ChordType> getChords() const {
            return chords;
        }
        
        void readFile(std::string filename);
        bool readString(std::string json);

        ChordType getChordType(std::string chordName);
    };
}
#endif

#endif

