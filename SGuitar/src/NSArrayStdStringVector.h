//
//  NSArrayVector.h
//  SteelSidekick
//
//  Created by John Sohn on 9/11/15.
//
//

#import <Foundation/Foundation.h>
#import <vector>

@interface NSArrayStdStringVector : NSObject

+ (NSArray *)arrayFromStdStringVector:(std::vector<std::string>)vector;
+ (std::vector<std::string>)vectorFromStdStringArray:(NSArray *)array;

@end
