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

namespace SG {
    class StringAdjustment {
    protected:
        int stringNumber;
        int step;
        bool valid;

    public:
        StringAdjustment();
        StringAdjustment(int stringNumber, int step);
//        StringAdjustment(const StringAdjustment& adjustment);
//        StringAdjustment& operator=(const StringAdjustment& adjustment);
//        StringAdjustment(StringAdjustment&& adjustment);
//        StringAdjustment& operator=(StringAdjustment&& adjustment);
        ~StringAdjustment();
        
        bool isValid() const {
            return valid;
        }
        
        int getStringNumber() const {
            return stringNumber;
        }
        
        void setStep(int step) {
            step = step;
        }
        
        int getStep() const {
            return step;
        }
    
        std::string getDescription() const;
    };
}
#endif

#endif
