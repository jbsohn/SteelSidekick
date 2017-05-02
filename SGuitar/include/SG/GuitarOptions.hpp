//
//  GuitarOptions.h
//  SGuitar
//
//  Created by John on 7/30/13.
//  Copyright (c) 2013 John. All rights reserved.
//

#ifndef __GuitarOptions_h__
#define __GuitarOptions_h__

#include "Note.hpp"
#include "OptionTypes.hpp"

#ifdef __cplusplus

namespace SG {
    //
    // storage container for the global guitar settings
    //
    class GuitarOptions {
    protected:
        std::string guitarType;
        std::string guitarName;
        bool showAllNotes;
        ACCIDENTAL_DISPLAY_TYPE showNotesAs;
        
    public:
        GuitarOptions();
        ~GuitarOptions();

        void setGuitarType(std::string guitarType) {
            this->guitarType = guitarType;
        }
        
        std::string getGuitarType() const {
            return this->guitarType;
        }
        
        void setGuitarName(std::string guitarName) {
            this->guitarName = guitarName;
        }
        
        std::string getGuitarName() const {
            return this->guitarName;
        }
        
        void setShowAllNotes(bool showAllNotes) {
            this->showAllNotes = showAllNotes;
        }
        
        bool getShowAllNotes() const {
            return this->showAllNotes;
        }
        
        void setShowNotesAs(ACCIDENTAL_DISPLAY_TYPE type) {
            this->showNotesAs = type;
        }
        
        ACCIDENTAL_DISPLAY_TYPE getShowNotesAs() const {
            return this->showNotesAs;
        }
    };
}
#endif

#endif
