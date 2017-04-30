//
//  NSArrayNoteValueVector.h
//  SteelSidekick
//
//  Created by John Sohn on 5/2/16.
//
//

#import <Foundation/Foundation.h>

#ifdef __cplusplus
#import <vector>
#import "SG/SGuitar.hpp"

@interface NSArrayIntVector : NSObject

+ (NSArray *)arrayFromIntVector:(std::vector<int>)vector;

@end

#endif
