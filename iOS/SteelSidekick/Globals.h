//
//  Globals.h
//  SteelSidekick
//

#ifndef __Globals_h__
#define __Globals_h__

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define DEGREES_TO_RADIANS(x) (M_PI * (x) / 180.0)

#define PEDAL_LEVER_HEIGHT                  44.0
#define IPHONE_PEDAL_LEVER_HEIGHT           24.0
#define IPHONE_LARGE_PEDAL_LEVER_HEIGHT     28.0
#define IPHONE_XLARGE_PEDAL_LEVER_HEIGHT    32.0
#define IPAD_PEDAL_LEVER_HEIGHT             132.0

#define LEVER_VIEW_WIDTH                    224.0
#define LEVER_VIEW_HEIGHT                   32.0

#define INFO_VIEW_SCALE_CHORD_WIDTH         600.0
#define INFO_VIEW_HEIGHT_TWO_LINES          144.0
#define INFO_VIEW_HEIGHT_ONE_LINE           94.0

#define INFO_VIEW_SCALE_WIDTH               300.0
#define INFO_VIEW_SCALE_HEIGHT              50.0

#define INFO_VIEW_CHORD_WIDTH               300.0
#define INFO_VIEW_CHORD_HEIGHT              50.0

#define RAN_TUTORIAL_KEY                    @"RanTutorial"

#define SCALE_TUTORIAL_TEXT                 @"Select the Scale button to change the scale settings. You can toggle the scale display, change the scale and root note, and display the scale as notes or intervals."
#define CHORD_TUTORIAL_TEXT                 @"Select the Chord button to change the chord settings. You can toggle the chord display and change the scale and root note."
#define INFO_TUTORIAL_TEXT                  @"Select the Info button to view the guitar, chord, and scale settings."
#define SETTINGS_TUTORIAL_TEXT              @"Select the Settings button to change the guitar settings. You can select the guitar type, toggle the note display, display notes as sharp or flat, and change the color scheme. You can also create your own custom guitar."
#define LANDSCAPE_TUTORIAL_TEXT             @"Tap the main display with two fingers to toggle the navigation bar on and off."

#endif
