//
//  NSArrayNoteValueVector.m
//  SteelSidekick
//
//  Created by John Sohn on 5/2/16.
//
//

#import "NSArrayNoteValueVector.h"

@implementation NSArrayNoteValueVector

+ (NSArray *)arrayFromNoteValueVector:(std::vector<int>)vector {
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:vector.size()];

    for (int cur : vector) {
        [array addObject:[NSNumber numberWithInt:cur]];
    }
    return array;
}

@end
