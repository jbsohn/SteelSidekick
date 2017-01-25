//
//  NSArrayVector.h
//  SteelSidekick
//
//  Created by John Sohn on 9/11/15.
//
//

#import <Foundation/Foundation.h>
#import <vector>

@interface NSArrayVector : NSObject

+ (NSArray *)arrayFromIntVector:(std::vector<int>)vector;
+ (std::vector<int>)vectorFromIntArray:(NSArray *)array;

@end
