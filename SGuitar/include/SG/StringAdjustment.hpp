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
    //
    // container to store the adjustment for a string, the string number and step (adjustments) to make
    //
    class StringAdjustment {
    protected:
        int stringNumber;
        int step;
        bool valid;

    public:
        StringAdjustment();
        StringAdjustment(int stringNumber, int step);
        ~StringAdjustment();
        
        bool isValid() const {
            return valid;
        }
        
        int getStringNumber() const {
            return stringNumber;
        }
        
        void setStep(int step) {
            this->step = step;
        }
        
        int getStep() const {
            return step;
        }
    
        std::string getDescription() const;
    };
}
#endif

#endif
