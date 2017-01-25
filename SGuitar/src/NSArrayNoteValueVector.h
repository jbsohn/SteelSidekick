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
#import "SG/SGuitar.h"

@interface NSArrayNoteValueVector : NSObject

+ (NSArray *)arrayFromNoteValueVector:(std::vector<int>)vector;

@end
#endif
