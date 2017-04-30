//
//  ScaleOptions.h
//  SGuitar
//
//  Created by John Sohn on 2/25/16.
//  Copyright © 2016 John Sohn. All rights reserved.
//

#ifndef _ScaleOptions_h_
#define _ScaleOptions_h_

#include "OptionTypes.hpp"
#include "Note.hpp"
#include "Scale.hpp"

#ifdef __cplusplus

namespace SG {
    class ScaleOptions {
    protected:
        bool showScale;
        std::string scaleName;
        int scaleRootNoteValue;
        DISPLAY_ITEM_AS_TYPE displayItemsAs;
        
    public:
        ScaleOptions();
        ~ScaleOptions();
        
        void setShowScale(bool showScale) {
            this->showScale = showScale;
        }
        
        bool getShowScale() const {
            return showScale;
        }
        
        void setScaleName(std::string scaleName) {
            this->scaleName = scaleName;
        }
        
        std::string getScaleName() const {
            return scaleName;
        }
        
        void setScaleRootNoteValue(int rootNoteValue) {
            this->scaleRootNoteValue = rootNoteValue;
        }
        
        int getScaleRootNoteValue() const {
            return scaleRootNoteValue;
        }
        
        void setDisplayItemsAs(DISPLAY_ITEM_AS_TYPE type) {
            this->displayItemsAs = type;
        }
        
        DISPLAY_ITEM_AS_TYPE getDisplayItemsAs() const {
            return displayItemsAs;
        }
    };
}
#endif

#endif
