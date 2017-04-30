//
//  GuitarAdjustmentSetting.h
//  SGuitar
//
//  Created by John Sohn on 12/9/14.
//  Copyright (c) 2014 John Sohn. All rights reserved.
//

#ifndef __GuitarAdjustment_h__
#define __GuitarAdjustment_h__

#include "StringAdjustment.hpp"

#ifdef __cplusplus
#include <string>
#include <vector>

namespace SG {
    class GuitarAdjustment {
    protected:
        std::string adjustmentID;
        std::vector<StringAdjustment> adjustments;
        bool valid;
        
    public:
        GuitarAdjustment();
        GuitarAdjustment(std::string adjustmentID);
        ~GuitarAdjustment();

        bool isValid() const {
            return valid;
        }
        
        void setAdjustmentID(std::string adjustmentID) {
            this->adjustmentID = adjustmentID;
        }
        
        std::string getAdjustmentID() const {
            return adjustmentID;
        }
        
        void clearAdjustments() {
            adjustments.clear();
        }
        
        void addStringAdjustment(StringAdjustment adjustment) {
            adjustments.push_back(adjustment);
        }
        
        std::vector<StringAdjustment> getStringAdjustments() const {
            return adjustments;
        }
        
        int getNumberOfStringAdjustments() const {
            return (int) adjustments.size();
        }
        
        StringAdjustment getStringAdjustment(int index) const {
            return adjustments[index];
        }
        
        SG::StringAdjustment stringAdjustmentForStringNumber(int stringNumber) const;
        std::string getDescription() const;
    };
}
#endif

#endif
