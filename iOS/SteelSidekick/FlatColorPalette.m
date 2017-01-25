//
//  FlatColorPalette.m
//  SteelSidekick
//
//  Created by John Sohn on 6/26/16.
//
//

#import "FlatColorPalette.h"

@implementation FlatColorPalette

+ (NSArray *)defaultColorPalettes {
    NSMutableArray *palettes = [[NSMutableArray alloc] init];

    {
        FlatColorPalette *palette = [[FlatColorPalette alloc] init];
        palette.name = @"Light";
        palette.primaryColor = nil;
        palette.secondaryColor = nil;
        palette.textColor = [UIColor colorWithHexString:@"#0c92ee"];
        palette.isSystem = NO;
        [palettes addObject:palette];
    }
    {
        FlatColorPalette *palette = [[FlatColorPalette alloc] init];
        palette.name = @"Dark";
        palette.primaryColor = [UIColor colorWithHexString:@"#212121"];
        palette.secondaryColor = [UIColor colorWithHexString:@"#424242"];
        palette.textColor = [UIColor colorWithHexString:@"#2196F3"];
        palette.isSystem = NO;
        [palettes addObject:palette];
    }
    {
        FlatColorPalette *palette = [[FlatColorPalette alloc] init];
        palette.name = @"Subtle Blue Sky";
        palette.primaryColor = nil;
        palette.secondaryColor = nil;
        palette.textColor = [UIColor colorWithHexString:@"#2980b9"];
        [palettes addObject:palette];
    }
    {
        FlatColorPalette *palette = [[FlatColorPalette alloc] init];
        palette.name = @"Blue Sky";
        palette.primaryColor = [UIColor colorWithHexString:@"#2980b9"];
        palette.secondaryColor = [UIColor colorWithHexString:@"#3498db"];
        palette.textColor = [UIColor whiteColor];
        [palettes addObject:palette];
    }
    {
        FlatColorPalette *palette = [[FlatColorPalette alloc] init];
        palette.name = @"Subtle Midnight Blue";
        palette.primaryColor = nil;
        palette.secondaryColor = nil;
        palette.textColor = [UIColor colorWithHexString:@"#2c3e50"];
        [palettes addObject:palette];
    }
    {
        FlatColorPalette *palette = [[FlatColorPalette alloc] init];
        palette.name = @"Midnight Blue";
        palette.primaryColor = [UIColor colorWithHexString:@"#2c3e50"];
        palette.secondaryColor = [UIColor colorWithHexString:@"#34495e"];
        palette.textColor = [UIColor whiteColor];
        [palettes addObject:palette];
    }
    {
        FlatColorPalette *palette = [[FlatColorPalette alloc] init];
        palette.name = @"Subtle Green Sea";
        palette.primaryColor = nil;
        palette.secondaryColor = nil;
        palette.textColor = [UIColor colorWithHexString:@"#16a085"];
        [palettes addObject:palette];
    }
    {
        FlatColorPalette *palette = [[FlatColorPalette alloc] init];
        palette.name = @"Green Sea";
        palette.primaryColor = [UIColor colorWithHexString:@"#16a085"];
        palette.secondaryColor = [UIColor colorWithHexString:@"#1abc9c"];
        palette.textColor = [UIColor whiteColor];
        [palettes addObject:palette];
    }
    {
        FlatColorPalette *palette = [[FlatColorPalette alloc] init];
        palette.name = @"Subtle Green Emerald";
        palette.primaryColor = nil;
        palette.secondaryColor = nil;
        palette.textColor = [UIColor colorWithHexString:@"#27ae60"];
        [palettes addObject:palette];
    }
    {
        FlatColorPalette *palette = [[FlatColorPalette alloc] init];
        palette.name = @"Green Emerald";
        palette.primaryColor = [UIColor colorWithHexString:@"#27ae60"];
        palette.secondaryColor = [UIColor colorWithHexString:@"#2ecc71"];
        palette.textColor = [UIColor whiteColor];
        [palettes addObject:palette];
    }
    {
        FlatColorPalette *palette = [[FlatColorPalette alloc] init];
        palette.name = @"Subtle Orange";
        palette.primaryColor = nil;
        palette.secondaryColor = nil;
        palette.textColor = [UIColor colorWithHexString:@"#f39c12"];
        [palettes addObject:palette];
    }
    {
        FlatColorPalette *palette = [[FlatColorPalette alloc] init];
        palette.name = @"Orange";
        palette.primaryColor = [UIColor colorWithHexString:@"#f39c12"];
        palette.secondaryColor = [UIColor colorWithHexString:@"#f1c40f"];
        palette.textColor = [UIColor whiteColor];
        [palettes addObject:palette];
    }
    {
        FlatColorPalette *palette = [[FlatColorPalette alloc] init];
        palette.name = @"Subtle Pumpkin Orange";
        palette.primaryColor = nil;
        palette.secondaryColor = nil;
        palette.textColor = [UIColor colorWithHexString:@"#d35400"];
        [palettes addObject:palette];
    }
    {
        FlatColorPalette *palette = [[FlatColorPalette alloc] init];
        palette.name = @"Pumpkin Orange";
        palette.primaryColor = [UIColor colorWithHexString:@"#d35400"];
        palette.secondaryColor = [UIColor colorWithHexString:@"#e67e22"];
        palette.textColor = [UIColor whiteColor];
        [palettes addObject:palette];
    }
    {
        FlatColorPalette *palette = [[FlatColorPalette alloc] init];
        palette.name = @"Subtle Purple Amethyst";
        palette.primaryColor = nil;
        palette.secondaryColor = nil;
        palette.textColor = [UIColor colorWithHexString:@"#8e44ad"];
        [palettes addObject:palette];
    }
    {
        FlatColorPalette *palette = [[FlatColorPalette alloc] init];
        palette.name = @"Purple Amethyst";
        palette.primaryColor = [UIColor colorWithHexString:@"#8e44ad"];
        palette.secondaryColor = [UIColor colorWithHexString:@"#9b59b6"];
        palette.textColor = [UIColor whiteColor];
        [palettes addObject:palette];
    }
    {
        FlatColorPalette *palette = [[FlatColorPalette alloc] init];
        palette.name = @"Subtle Dark Violet Purple";
        palette.primaryColor = nil;
        palette.secondaryColor = nil;
        palette.textColor = [UIColor colorWithHexString:@"#9400D3"];
        [palettes addObject:palette];
    }
    {
        FlatColorPalette *palette = [[FlatColorPalette alloc] init];
        palette.name = @"Dark Violet Purple";
        palette.primaryColor = [UIColor colorWithHexString:@"#9400D3"];
        palette.secondaryColor = [UIColor colorWithHexString:@"#8A2BE2	"];
        palette.textColor = [UIColor whiteColor];
        [palettes addObject:palette];
    }
    {
        FlatColorPalette *palette = [[FlatColorPalette alloc] init];
        palette.name = @"Subtle Pomegranate Red";
        palette.primaryColor = nil;
        palette.secondaryColor = nil;
        palette.textColor = [UIColor colorWithHexString:@"#c0392b"];
        [palettes addObject:palette];
    }
    {
        FlatColorPalette *palette = [[FlatColorPalette alloc] init];
        palette.name = @"Pomegranate Red";
        palette.primaryColor = [UIColor colorWithHexString:@"#c0392b"];
        palette.secondaryColor = [UIColor colorWithHexString:@"#e74c3c"];
        palette.textColor = [UIColor whiteColor];
        [palettes addObject:palette];
    }
    {
        FlatColorPalette *palette = [[FlatColorPalette alloc] init];
        palette.name = @"Subtle Crimson Red";
        palette.primaryColor = nil;
        palette.secondaryColor = nil;
        palette.textColor  = [UIColor colorWithHexString:@"#DC143C"];
        [palettes addObject:palette];
    }
    {
        FlatColorPalette *palette = [[FlatColorPalette alloc] init];
        palette.name = @"Crimson Red";
        palette.primaryColor  = [UIColor colorWithHexString:@"#DC143C"];
        palette.secondaryColor = [UIColor colorWithHexString:@"#CD5C5C"];
        palette.textColor = [UIColor whiteColor];
        [palettes addObject:palette];
    }
    return palettes;
}

+ (FlatColorPalette *)defaultPaletteForName:(NSString *)name {
    int index = [FlatColorPalette defaultPaletteIndexForName:name];
    FlatColorPalette *palette = nil;
    
    if (index >= 0) {
        NSArray *palettes = [FlatColorPalette defaultColorPalettes];
        palette = palettes[index];
    }
    return palette;
}

+ (int)defaultPaletteIndexForName:(NSString *)name {
    NSArray *palettes = [FlatColorPalette defaultColorPalettes];
    for (int i = 0; i < palettes.count; i++) {
        FlatColorPalette *curPalette = palettes[i];
        if ([curPalette.name isEqualToString:name]) {
            return i;
        }
    }
    return -1;
}

@end
