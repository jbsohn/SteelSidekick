//
//  Chords.h
//  SGuitar
//
//  Created by John Sohn on 2/22/16.
//  Copyright © 2016 John Sohn. All rights reserved.
//

#ifndef __Chords_h__
#define __Chords_h__

#include "ChordType.h"

#ifdef __cplusplus
#include <vector>
#include <string>
#include <memory>

namespace SG {
    class Chords {
    public:
        Chords();
        ~Chords();

        bool isValid() const;

        void readFile(std::string filename);
        bool readString(std::string json);
        
        std::vector<ChordType> getChords() const;
        ChordType getChordType(std::string chordName);
        
    private:
        struct ChordsImpl;
        std::unique_ptr<ChordsImpl> impl;
        
    };
}
#endif

#endif

