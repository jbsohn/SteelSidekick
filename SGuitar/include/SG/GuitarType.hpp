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

namespace SG {
    struct GuitarTypeImpl;
    class GuitarType {
    protected:
        std::string name;
        std::string description;
        bool customType;
        bool valid;
        
    public:
        GuitarType();
        GuitarType(std::string name, std::string description, bool isCustomType);
//        GuitarType(const GuitarType& guitarType);
//        GuitarType& operator=(const GuitarType& guitarType);
//        GuitarType(GuitarType&& guitarType);
//        GuitarType& operator=(GuitarType&& guitarType);
        ~GuitarType();
        
        bool isValid() const {
            return valid;
        }
        
        std::string getName() {
            return name;
        }
        
        std::string getDescription() {
            return description;
        }
        
        bool isCustomType() {
            return customType;
        }
        
    protected:
        void init(const GuitarType& guitarType);
        
    };
}
#endif

#endif
