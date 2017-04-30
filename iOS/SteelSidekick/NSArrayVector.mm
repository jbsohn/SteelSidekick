//
//  NSArrayVector.m
//  SteelSidekick
//
//  Created by John Sohn on 9/11/15.
//
//

#import "NSArrayVector.h"
#import <vector>

@implementation NSArrayVector

+ (NSArray *)arrayFromIntVector:(std::vector<int>)vector {
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:vector.size()];
    
    for (int cur : vector) {
        [array addObject:[NSNumber numberWithInt:cur]];
    }
    return array;
}

+ (std::vector<int>)vectorFromIntArray:(NSArray *)array {
    std::vector<int> vector([array count]);

    vector.clear();

    for (NSNumber *cur in array) {
        vector.push_back([cur intValue]);
    }
    return vector;
}

@end
