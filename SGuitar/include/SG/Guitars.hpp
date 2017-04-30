//
//  Guitars.h
//  SGuitar
//
//  Created by John Sohn on 2/29/16.
//  Copyright © 2016 John Sohn. All rights reserved.
//

#ifndef _Guitars_h_
#define _Guitars_h_

#ifdef __cplusplus
#include <vector>
#include <string>
#include "GuitarType.hpp"

namespace SG {
    class Guitars {
    protected:
        std::string guitarsPath;
        bool valid;

    public:
        Guitars();
        ~Guitars();
        bool isValid() const;
        
        void setGuitarsPath(std::string guitarsPath);
        std::vector<std::string> getGuitarNames(std::string type) const;
        SG::GuitarType getGuitarType(std::string guitarName, std::vector<SG::GuitarType> types) const;
        std::string guitarFileNameForGuitar(std::string name, std::string type) const;

        std::vector<std::string> getCustomGuitarNames() const;
        std::string guitarFileNameForCustomGuitar(std::string name) const;
        bool removeCustomGuitar(std::string name);

    protected:
        std::vector<GuitarType> readGuitarTypes(std::string json);        
    };
}
#endif

#endif
