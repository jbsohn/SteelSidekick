//
//  GuitarOptions.cpp
//  SGuitar
//
//  Created by John on 7/30/13.
//  Copyright (c) 2013 John. All rights reserved.
//

#include <string>
#include "SG/Note.h"
#include "SG/OptionTypes.h"
#include "SG/GuitarOptions.h"

namespace SG  {
    struct GuitarOptions::GuitarOptionsImpl {
        std::string guitarType;
        std::string guitarName;
        bool showAllNotes;
        ACCIDENTAL_DISPLAY_TYPE showNotesAs;
        
        void init(const GuitarOptions& options) {
            guitarType = options.impl->guitarType;
            guitarName = options.impl->guitarName;
            showNotesAs = options.impl->showNotesAs;
            showAllNotes = options.impl->showAllNotes;
        }
    };

    GuitarOptions::GuitarOptions()
        : impl(new GuitarOptionsImpl) {
        impl->guitarType = "";
        impl->guitarName = "";
        impl->showAllNotes = false;
        impl->showNotesAs = ADT_SHARP;
    }

	GuitarOptions::~GuitarOptions() {

	}

    GuitarOptions::GuitarOptions(GuitarOptions& options)
        : impl(new GuitarOptionsImpl) {
        impl->init(options);
    }

    GuitarOptions& GuitarOptions::operator=(GuitarOptions& options) {
        impl->init(options);
        return *this;
    }

    GuitarOptions::GuitarOptions(GuitarOptions&& options) {
        impl = options.impl;
        options.impl = nullptr;
    }
    
    GuitarOptions& GuitarOptions::operator=(GuitarOptions&& options) {
        if (this != &options) {
            impl = options.impl;
            options.impl = nullptr;
        }
        return *this;
    }

    void GuitarOptions::setGuitarType(std::string guitarType) {
        impl->guitarType = guitarType;
    }

    std::string GuitarOptions::getGuitarType() const {
        return impl->guitarType;
    }

    void GuitarOptions::setGuitarName(std::string guitarName) {
        impl->guitarName = guitarName;
    }

    std::string GuitarOptions::getGuitarName() const {
        return impl->guitarName;
    }

    void GuitarOptions::setShowAllNotes(bool showAllNotes) {
        impl->showAllNotes = showAllNotes;
    }

    bool GuitarOptions::getShowAllNotes() const {
        return impl->showAllNotes;
    }

    void GuitarOptions::setShowNotesAs(ACCIDENTAL_DISPLAY_TYPE type) {
        impl->showNotesAs = type;
    }
    
    ACCIDENTAL_DISPLAY_TYPE GuitarOptions::getShowNotesAs() const {
        return impl->showNotesAs;
    }
}
