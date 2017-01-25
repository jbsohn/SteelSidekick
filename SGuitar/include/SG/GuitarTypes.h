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
#include <memory>
#include <map>
#include <string>
#include "GuitarType.h"

namespace SG {
    class GuitarTypes {
    public:
        GuitarTypes();
        ~GuitarTypes();
        bool isValid() const;
        
        bool readFile(std::string filename);

        GuitarType getGuitarType(std::string type);
        std::vector<GuitarType> getGuitarTypes();
    private:
        struct GuitarTypesImpl;
        std::unique_ptr<GuitarTypesImpl> impl;
    };
}
#endif

#endif
