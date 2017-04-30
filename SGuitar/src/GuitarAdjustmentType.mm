//
//  GuitarAdjustmentType.mm
//  SteelSidekick
//

#import <Foundation/Foundation.h>
#import "SG/GuitarAdjustmentType.hpp"

@implementation GuitarAdjustmentType

+ (NSString *)getPedalTypeName:(int)index {
    return @(SG::GuitarAdjustmentType::getPedalTypeName(index).c_str());
}

+ (NSString *)getLeverTypeName:(int)index {
    return @(SG::GuitarAdjustmentType::getLeverTypeName(index).c_str());
}

@end
