//
//  ScaleOptions.h
//  SGuitar
//
//  Created by John Sohn on 2/25/16.
//  Copyright © 2016 John Sohn. All rights reserved.
//

#ifndef _ScaleOptions_h_
#define _ScaleOptions_h_

#include "OptionTypes.h"
#include "Note.h"

#ifdef __cplusplus
#include <memory>

namespace SG {
    class ScaleOptions {
    public:
        ScaleOptions();
        ScaleOptions(const ScaleOptions& options);
        ScaleOptions& operator=(const ScaleOptions& options);
        ScaleOptions(ScaleOptions&& options);
        ScaleOptions& operator=(ScaleOptions&& options);
        ~ScaleOptions();
        
        void setShowScale(bool showScale);
        bool getShowScale() const;

        void setScaleName(std::string scaleName);
        std::string getScaleName() const;

        void setScaleRootNoteValue(int rootNoteValue);
        int getScaleRootNoteValue() const;

        void setDisplayItemsAs(DISPLAY_ITEM_AS_TYPE type);
        DISPLAY_ITEM_AS_TYPE getDisplayItemsAs() const;
    private:
        struct ScaleOptionsImpl;
        std::unique_ptr<ScaleOptionsImpl> impl;
    };
}
#endif

#ifdef __OBJC__

#import <Foundation/Foundation.h>

@interface ScaleOptions : NSObject

@property BOOL showScale;
@property NSString *scaleName;
@property int scaleRoteNoteValue;
@property DISPLAY_ITEM_AS_TYPE displayItemAs;

@end

#endif

#endif
