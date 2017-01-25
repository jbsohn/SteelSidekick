//
//  GuitarType.h
//  SGuitar
//
//  Created by John Sohn on 2/29/16.
//  Copyright © 2016 John Sohn. All rights reserved.
//

#ifndef _GuitarType_h_
#define _GuitarType_h_

#ifdef __cplusplus
#include <vector>
#include <string>
#include <memory>

namespace SG {
    struct GuitarTypeImpl;
    class GuitarType {
    public:
        GuitarType();
        GuitarType(std::string name, std::string description, bool isCustomType);
        GuitarType(const GuitarType& guitarType);
        GuitarType& operator=(const GuitarType& guitarType);
        GuitarType(GuitarType&& guitarType);
        GuitarType& operator=(GuitarType&& guitarType);
        ~GuitarType();
        
        bool isValid() const;
        
        std::string getName();
        std::string getDescription();
        bool isCustomType();
    private:
        struct GuitarTypeImpl;
        std::unique_ptr<GuitarTypeImpl> impl;
    };
}
#endif

#endif
