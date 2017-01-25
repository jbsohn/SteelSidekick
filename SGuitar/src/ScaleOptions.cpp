//
//  ScaleOptions.cpp
//  SGuitar
//
//  Created by John Sohn on 2/25/16.
//  Copyright © 2016 John Sohn. All rights reserved.
//

#include "SG/ScaleOptions.h"

namespace SG {
    struct ScaleOptions::ScaleOptionsImpl {
        bool showScale;
        std::string scaleName;
        int scaleRootNoteValue;
        DISPLAY_ITEM_AS_TYPE displayItemsAs;
        
        void init(const ScaleOptions& options) {
            showScale = options.impl->showScale;
            scaleName = options.impl->scaleName;
            scaleRootNoteValue = options.impl->scaleRootNoteValue;
            displayItemsAs = options.impl->displayItemsAs;
        }
    };

    ScaleOptions::ScaleOptions() : impl(new ScaleOptionsImpl) {
        impl->showScale = true;
        impl->scaleName = "";
        impl->scaleRootNoteValue = NOTE_VALUE_C;
        impl->displayItemsAs = DIA_NOTES;
    }

    ScaleOptions::~ScaleOptions() {
        
    }

    ScaleOptions::ScaleOptions(const ScaleOptions& options) : impl(new ScaleOptionsImpl) {
        impl->init(options);
    }

    ScaleOptions& ScaleOptions::operator=(const ScaleOptions& options) {
        impl->init(options);
        return *this;
    }

    ScaleOptions::ScaleOptions(ScaleOptions&& scaleOptions) {
        impl = std::move(scaleOptions.impl);
        scaleOptions.impl = nullptr;
    }
    
    ScaleOptions& ScaleOptions::operator=(ScaleOptions&& scaleOptions) {
        if (this != &scaleOptions) {
            impl = std::move(scaleOptions.impl);
            scaleOptions.impl = nullptr;
        }
        return *this;
    }

    void ScaleOptions::setShowScale(bool showScale) {
        impl->showScale = showScale;
    }
    
    bool ScaleOptions::getShowScale() const {
        return impl->showScale;
    }
    
    void ScaleOptions::setScaleName(std::string scaleName) {
        impl->scaleName = scaleName;
    }
    
    std::string ScaleOptions::getScaleName() const {
        return impl->scaleName;
    }

    void ScaleOptions::setScaleRootNoteValue(int rootNoteValue) {
        impl->scaleRootNoteValue = rootNoteValue;
    }
    
    int ScaleOptions::getScaleRootNoteValue() const {
        return impl->scaleRootNoteValue;
    }

    void ScaleOptions::setDisplayItemsAs(DISPLAY_ITEM_AS_TYPE type) {
        impl->displayItemsAs = type;
    }
    
    DISPLAY_ITEM_AS_TYPE ScaleOptions::getDisplayItemsAs() const {
        return impl->displayItemsAs;
    }
}
