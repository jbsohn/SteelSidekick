//
//  StringAdjustment.h
//  SGuitar
//
//  Created by John Sohn on 12/14/14.
//  Copyright (c) 2014 John Sohn. All rights reserved.
//

#ifndef __StringAdjustment_h__
#define __StringAdjustment_h__


#ifdef __cplusplus
#include <memory>

namespace SG {
    class StringAdjustment {
    public:
        StringAdjustment();
        StringAdjustment(int stringNumber, int step);
        StringAdjustment(const StringAdjustment& adjustment);
        StringAdjustment& operator=(const StringAdjustment& adjustment);
        StringAdjustment(StringAdjustment&& adjustment);
        StringAdjustment& operator=(StringAdjustment&& adjustment);
        ~StringAdjustment();
        
        bool isValid() const;
        
        int getStringNumber() const;
        
        void setStep(int step);
        int getStep() const;
        
        std::string getDescription() const;
    private:
        struct StringAdjustmentImpl;
        std::unique_ptr<StringAdjustmentImpl> impl;
    };
}
#endif

#endif
