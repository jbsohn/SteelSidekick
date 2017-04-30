//
//  GuitarTypes.h
//  SGuitar
//
//  Created by John Sohn on 5/13/16.
//  Copyright © 2016 John Sohn. All rights reserved.
//

#ifndef __GuitarTypes_h__
#define __GuitarTypes_h__

#ifdef __cplusplus
#include <string>
#include "GuitarType.hpp"

namespace SG {
    class GuitarTypes {
    protected:
        std::vector<GuitarType> types;
        bool valid;

    public:
        GuitarTypes();
        ~GuitarTypes();
        bool isValid() const;
        
        bool readFile(std::string filename);

        GuitarType getGuitarType(std::string type);
        std::vector<GuitarType> getGuitarTypes();
    
    protected:
        std::vector<GuitarType> readGuitarTypes(std::string json);
    };
}
#endif

#endif
