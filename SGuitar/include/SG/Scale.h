//
//  Scale.h
//  SGuitar
//
//  Created by John Sohn on 12/9/14.
//  Copyright (c) 2014 John Sohn. All rights reserved.
//

#ifndef __Scale_h__
#define __Scale_h__

#include "Note.h"

#ifdef __cplusplus
#include <memory>
#include <array>
#include <vector>

namespace SG {
    class Scale {
    public:
        Scale();
        Scale(int rootNoteValue, std::vector<int> semitones);
        Scale(const Scale& scale);
        Scale& operator=(const Scale& Type);
        Scale(Scale&& scale);
        Scale& operator=(Scale&& scale);
        ~Scale();
        bool isValid() const;
        
        std::vector<int> getNoteValues() const;
        
		bool isNoteValueInScale(int noteValue) const;
        int intervalForNoteValue(int noteValue) const;
        
        std::string unitTestDescription();
    private:
        struct ScaleImpl;
        std::unique_ptr<ScaleImpl> impl;
    };
}
#endif

#ifdef __OBJC__

@interface Scale : NSObject

- (NSArray*)getNoteValues;
- (BOOL)isNoteValueInScale:(int)noteValue;
- (int)intervalForNoteValue:(int)noteValue;
- (NSString *)unitTestDescription;

@end

#endif

#endif
