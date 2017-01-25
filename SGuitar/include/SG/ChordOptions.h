//
//  ChordOptions.h
//  SGuitar
//
//  Created by John Sohn on 2/25/16.
//  Copyright © 2016 John Sohn. All rights reserved.
//

#ifndef _ChordOptions_h_
#define _ChordOptions_h_

#include "OptionTypes.h"
#include "Note.h"

#ifdef __cplusplus
#include <memory>
#include <string>

namespace SG {
    class ChordOptions {
    public:
        ChordOptions();
        ChordOptions(const ChordOptions& options);
        ChordOptions& operator=(const ChordOptions& options);
        ChordOptions(ChordOptions&& options);
        ChordOptions& operator=(ChordOptions&& options);
        ~ChordOptions();
        
        void setShowChord(bool showChord);
        bool getShowChord() const;

        void setChordName(std::string chordName);
        std::string getChordName() const;
        
        void setChordRootNoteValue(int rootNoteValue);
        int getChordRootNoteValue() const;
        
        void setDisplayItemsAs(DISPLAY_ITEM_AS_TYPE type);
        DISPLAY_ITEM_AS_TYPE getDisplayItemsAs() const;
    private:
        struct ChordOptionsImpl;
        std::unique_ptr<ChordOptionsImpl> impl;
    };
}
#endif

#ifdef __OBJC__

@interface ChordOptions : NSObject

@property BOOL showChord;
@property NSString* chordName;
@property int chordRoteNoteValue;
@property DISPLAY_ITEM_AS_TYPE displayItemAs;

@end

#endif

#endif
