//
//  GuitarAdjustmentSetting.h
//  SGuitar
//
//  Created by John Sohn on 12/9/14.
//  Copyright (c) 2014 John Sohn. All rights reserved.
//

#ifndef __GuitarAdjustment_h__
#define __GuitarAdjustment_h__

#include "StringAdjustment.h"

#ifdef __cplusplus
#include <memory>
#include <string>
#include <vector>

namespace SG {
    class GuitarAdjustment {
    public:
        GuitarAdjustment();
        GuitarAdjustment(std::string adjustmentID);
        GuitarAdjustment(const GuitarAdjustment& adjustment);
        GuitarAdjustment& operator=(const GuitarAdjustment& adjustment);
        GuitarAdjustment(GuitarAdjustment&& adjustment);
        GuitarAdjustment& operator=(GuitarAdjustment&& adjustment);
        ~GuitarAdjustment();
        
        bool isValid() const;

        void setAdjustmentID(std::string adjustmentID);
        std::string getAdjustmentID() const;

        // string adjustments
        void clearAdjustments();
        void addStringAdjustment(SG::StringAdjustment adjustment);
        std::vector<SG::StringAdjustment> getStringAdjustments() const;
        SG::StringAdjustment getStringAdjustment(int index) const;
        SG::StringAdjustment stringAdjustmentForStringNumber(int stringNumber) const;
        int getNumberOfStringAdjustments() const;

        std::string getDescription() const;
    private:
        struct GuitarAdjustmentImpl;
        std::unique_ptr<GuitarAdjustmentImpl> impl;
    };
}
#endif

#endif
