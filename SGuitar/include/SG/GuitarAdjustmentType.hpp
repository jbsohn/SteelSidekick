//
//  GuitarAdjustmentType.h
//  SteelSidekick
//

#ifndef __GuitarAdjustmentType_h__
#define __GuitarAdjustmentType_h__

typedef enum {
    PT_P1,
    PT_P2,
    PT_P3,
    PT_P4,
    PT_P5,
    PT_P6,
    PT_P7,
    PT_P8,
    PT_P9,
    PT_P10
} PEDAL_TYPES;

typedef enum {
    LT_LKL,
    LT_LKLR,
    LT_LKV,
    LT_LKR,
    LT_LKRR,
    LT_RKL,
    LT_RKLR,
    LT_RKV,
    LT_RKR,
    LT_RKRR,
} LEVER_TYPES;


#ifdef __cplusplus
#include <string>

namespace SG {
    class GuitarAdjustmentType {
    public:
        static std::string getPedalTypeName(int index);
        static std::string getLeverTypeName(int index);
    protected:
        static std::string PEDAL_TYPE_NAMES[];
        static std::string LEVER_TYPE_NAMES[];
    };
}
#endif

//#ifdef __OBJC__
//
//@interface GuitarAdjustmentType : NSObject
//
//+ (NSString *)getPedalTypeName:(int)index;
//+ (NSString *)getLeverTypeName:(int)index;
//
//@end
//
//#endif

#endif
