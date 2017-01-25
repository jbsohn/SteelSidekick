//
//  UIViewController+Orientation.h
//  SteelSidekick
//
//  Created by John Sohn on 12/12/16.
//
//

#import <UIKit/UIKit.h>

typedef enum  {
    O_LANDSCAPE,
    O_PORTRAIT
} ORIENTATION;

@interface UIViewController (Orientation)

- (ORIENTATION)getOrientationForSize:(CGSize)size;
- (ORIENTATION)getOrientationForView:(UIView *)view;
- (ORIENTATION)getOrientation;
- (ORIENTATION)orientationForUIInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;
- (BOOL)isLandscape:(CGSize)size;
- (CGSize)sizeForLandscape:(CGSize)size;
- (CGSize)sizeForPortrait:(CGSize)size;
    
@end
