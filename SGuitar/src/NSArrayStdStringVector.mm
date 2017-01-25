//
//  NSArrayVector.m
//  SteelSidekick
//
//  Created by John Sohn on 9/11/15.
//
//

#import "NSArrayStdStringVector.h"
#import <vector>
#import <string>

@implementation NSArrayStdStringVector

+ (NSArray *)arrayFromStdStringVector:(std::vector<std::string>)vector {
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:vector.size()];
    
    for (std::string cur : vector) {
        [array addObject:@(cur.c_str())];
    }
    return array;
}

+ (std::vector<std::string>)vectorFromStdStringArray:(NSArray *)array {
    std::vector<std::string> vector([array count]);

    vector.clear();

    for (NSString *cur in array) {
        vector.push_back([cur UTF8String]);
    }
    return vector;
}

@end
