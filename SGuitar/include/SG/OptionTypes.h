//
//  OptionTypes.h
//  SGuitar
//
//  Created by John Sohn on 2/25/16.
//  Copyright © 2016 John Sohn. All rights reserved.
//

#ifndef _OptionTypes_h
#define _OptionTypes_h

typedef enum {
    DIA_NOTES,
    DIA_INTERVAL
} DISPLAY_ITEM_AS_TYPE;

typedef enum {
    ADT_SHARP,
    ADT_FLAT
} ACCIDENTAL_DISPLAY_TYPE;

#ifdef __cplusplus
#include <string>

class OptionTypes {
    static std::string ACCIDENTAL_DISPLAY_TYPE_NAMES[];
    static std::string DISPLAY_ITEM_AS_TYPE_NAMES[];
};

#endif

#endif
