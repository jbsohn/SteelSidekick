//
//  GuitarOptions.h
//  SGuitar
//
//  Created by John on 7/30/13.
//  Copyright (c) 2013 John. All rights reserved.
//

#ifndef __GuitarOptions_h__
#define __GuitarOptions_h__

#include "Note.h"
#include "OptionTypes.h"

#ifdef __cplusplus
#include <memory>

namespace SG {
    class GuitarOptions {
    public:
        GuitarOptions();
        GuitarOptions(GuitarOptions& options);
        GuitarOptions& operator=(GuitarOptions& options);
        GuitarOptions(GuitarOptions&& options);
        GuitarOptions& operator=(GuitarOptions&& options);
        ~GuitarOptions();

        void setGuitarType(std::string guitarType);
        std::string getGuitarType() const;

        void setGuitarName(std::string guitarName);
        std::string getGuitarName() const;

        void setShowAllNotes(bool showAllNotes);
        bool getShowAllNotes() const;

        void setShowNotesAs(ACCIDENTAL_DISPLAY_TYPE type);
        ACCIDENTAL_DISPLAY_TYPE getShowNotesAs() const;
    private:
        struct GuitarOptionsImpl;
        GuitarOptionsImpl* impl;
    };
}
#endif

#ifdef __OBJC__

@interface GuitarOptions : NSObject

@property NSString* guitarType;
@property NSString* guitarName;
@property BOOL showAllNotes;
@property ACCIDENTAL_DISPLAY_TYPE showNotesAs;

@end

#endif

#endif
