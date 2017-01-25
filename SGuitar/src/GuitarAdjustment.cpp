//
//  GuitarAdjustment.cpp
//  SGuitar
//
//  Created by John Sohn on 12/14/14.
//  Copyright (c) 2014 John Sohn. All rights reserved.
//

#include <string>
#include <vector>
#include "SG/GuitarAdjustment.h"

namespace SG {
    struct GuitarAdjustment::GuitarAdjustmentImpl {
        std::string adjustmentID;
        std::vector<StringAdjustment> adjustments;
        bool isValid;
        
        void init(const GuitarAdjustment& adjustment) {
            adjustmentID = adjustment.impl->adjustmentID;
            adjustments = adjustment.impl->adjustments;
            isValid = adjustment.impl->isValid;
        }
    };

    GuitarAdjustment::GuitarAdjustment()
        :impl(new GuitarAdjustmentImpl) {
        impl->isValid = false;
    }

    GuitarAdjustment::GuitarAdjustment(std::string adjustmentID)
        :impl(new GuitarAdjustmentImpl) {
        impl->adjustmentID = adjustmentID;
        impl->isValid = true;
    }

    GuitarAdjustment::GuitarAdjustment(const GuitarAdjustment& adjustment)
        :impl(new GuitarAdjustmentImpl) {
        impl->init(adjustment);
    }

    GuitarAdjustment::~GuitarAdjustment() {

    }

    GuitarAdjustment& GuitarAdjustment::operator=(const GuitarAdjustment& adjustment) {
        impl->init(adjustment);
        return *this;
    }

    GuitarAdjustment::GuitarAdjustment(GuitarAdjustment&& adjustment) {
        impl = std::move(adjustment.impl);
        adjustment.impl = nullptr;
    }
    
    GuitarAdjustment& GuitarAdjustment::operator=(GuitarAdjustment&& adjustment) {
        if (this != &adjustment) {
            impl = std::move(adjustment.impl);
            adjustment.impl = nullptr;
        }
        return *this;
    }

    bool GuitarAdjustment::isValid() const {
        return impl->isValid;
    }

    void GuitarAdjustment::setAdjustmentID(std::string adjustmentID) {
        impl->adjustmentID = adjustmentID;
    }
    
    std::string GuitarAdjustment::getAdjustmentID() const {
        return impl->adjustmentID;
    }

    void GuitarAdjustment::clearAdjustments() {
        impl->adjustments.clear();
    }

    void GuitarAdjustment::addStringAdjustment(StringAdjustment adjustment) {
        impl->adjustments.push_back(adjustment);
    }
        
    std::vector<StringAdjustment> GuitarAdjustment::getStringAdjustments() const {
        return impl->adjustments;
    }

    int GuitarAdjustment::getNumberOfStringAdjustments() const {
        return (int) impl->adjustments.size();
    }

    StringAdjustment GuitarAdjustment::getStringAdjustment(int index) const {
        return impl->adjustments[index];
    }
    
    StringAdjustment GuitarAdjustment::stringAdjustmentForStringNumber(int stringNumber) const {
        for (StringAdjustment cur : impl->adjustments) {
            if (cur.getStringNumber() == stringNumber) {
                return cur;
            }
        }
        return StringAdjustment();
    }

    std::string GuitarAdjustment::getDescription() const {
        std::string description = "";
        if (impl->adjustmentID.size() > 0) {
            description += "adjustmentID: ";
            description += impl->adjustmentID;
            description += ", isValid: ";
            description += std::to_string(impl->isValid);
            description += "\r\n";

            description += "adjustments:\r\n";
            for (StringAdjustment cur : impl->adjustments) {
                description += cur.getDescription();
                description += "\r\n";
            }
        }
        return description;
    }
}
