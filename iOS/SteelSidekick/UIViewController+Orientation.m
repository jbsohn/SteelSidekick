//
//  UIViewController+Orientation.m
//  SteelSidekick
//
//  Created by John Sohn on 12/12/16.
//
//

#import "UIViewController+Orientation.h"

@implementation UIViewController (Orientation)

- (ORIENTATION)getOrientationForSize:(CGSize)size {
    if (size.width > size.height) {
        return O_LANDSCAPE;
    }
    return O_PORTRAIT;
}

- (ORIENTATION)getOrientationForView:(UIView *)view {
    return [self getOrientationForSize:view.frame.size];
}

- (ORIENTATION)getOrientation {
    return [self getOrientationForSize:self.view.frame.size];
}

- (ORIENTATION)orientationForUIInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    if (UIInterfaceOrientationIsPortrait(interfaceOrientation)) {
        return O_PORTRAIT;
    }
    return O_LANDSCAPE;
}

- (BOOL)isLandscape:(CGSize)size {
    if (size.width > size.height) {
        return YES;
    }
    return NO;
}

- (CGSize)sizeForLandscape:(CGSize)size {
    CGSize newSize;
    if (size.height > size.width) {
        newSize = CGSizeMake(size.height, size.width);
    } else {
        newSize = CGSizeMake(size.width, size.height);
    }
    return newSize;
}

- (CGSize)sizeForPortrait:(CGSize)size {
    CGSize newSize;
    if (size.height > size.width) {
        newSize = CGSizeMake(size.width, size.height);
    } else {
        newSize = CGSizeMake(size.height, size.width);
    }
    return newSize;
}

@end
