//
//  SGuitar.h
//  SGuitar
//
//  Created by John Sohn on 2/28/16.
//  Copyright © 2016 John Sohn. All rights reserved.
//

#ifndef _SGuitar_h_
#define _SGuitar_h_

#include "OptionTypes.h"
#include "Note.h"
#include "ScaleOptions.h"
#include "ChordOptions.h"
#include "GuitarOptions.h"
#include "Scale.h"
#include "Chord.h"
#include "StringAdjustment.h"
#include "GuitarAdjustment.h"
#include "GuitarCanvas.h"
#include "Guitar.h"
#include "FileUtils.h"
#include "GuitarString.h"

#ifdef __cplusplus
#include <string>
#include <vector>

namespace SG {
    class SGuitar {
    protected:
        SGuitar();
        ~SGuitar();
    public:
        static SGuitar& sharedInstance();
        
        SG::GuitarOptions& getGuitarOptions();
        SG::ScaleOptions& getScaleOptions();
        SG::ChordOptions& getChordOptions();
        SG::Scale getScale() const;
        SG::Chord getChord() const;

        // Guitar Settings
        int getNumberOfStrings();
        int getNumberOfFrets();
        std::vector<int> getNoteValuesForString(int stringNumber);
        void reloadGuitar();

        // Guitar Adjustments
        bool isAdjustmentEnabled(std::string settingID) const;
        void activateAdjustment(std::string settingID, bool activated);
        int midiValue(int stringNumber, int fretNumber);

        // Guitar Canvas
        GUITAR_CANVAS_POSITION positionAtCoordinates(float x, float y);
        void setSelectedItem(GUITAR_CANVAS_POSITION position);
        void init(float width, float height, float noteWidthHeight, float borderWidth, float scale);
        float cacluateNoteWidthHeight(float width, float height);
        void updateCanvasDimensions(float width, float height, float noteWidthHeight, float scale);
        void draw();

        // Scale/Chord Names
        std::vector<std::string>getScaleNames() const;
        std::vector<std::string>getChordNames() const;
        
        // Guitars
        std::vector<std::string> getGuitarTypeNames() const;
        std::vector<std::string> getGuitarNames(std::string type) const;
        std::vector<std::string> getCustomGuitarNames() const;
        bool removeCustomGuitar(std::string name);
        
        std::string getDescription();
    private:
        struct SGuitarImpl;
        std::unique_ptr<SGuitarImpl> impl;
    };
}

#endif

#ifdef __OBJC__
@interface SGuitar : NSObject 

+ (SGuitar*) sharedInstance;

- (GuitarOptions *) getGuitarOptions;
- (ScaleOptions *) getScaleOptions;
- (ChordOptions *) getChordOptions;
- (Scale *) getScale;
- (Chord *) getChord;

// Guitar Settings
- (int)getNumberOfStrings;
- (int)getNumberOfFrets;
- (NSArray *)getNoteValuesForString:(int)stringNumber;
- (void)reloadGuitar;

    // Guitar Adjustments
- (BOOL)isAdjustmentEnabled:(NSString *)settingID;
- (void)activateAdjustment:(NSString *)settingID activated:(BOOL)activated;
- (int)midiValue:(int)stringNumber fretNumber:(int)fretNumber;

// Guitar Canvas
- (GUITAR_CANVAS_POSITION)positionAtCoordinates:(float)x y:(float)y;
- (void)setSelectedItem:(GUITAR_CANVAS_POSITION)position;
- (void)initCanvas:(float)width height:(float)height noteWidthHeight:(float)noteWidthHeight borderWidth:(float)borderWidth scale:(float)scale;
- (float)cacluateNoteWidthHeight:(float)width height:(float)height;
- (void)updateCanvasDimensions:(float)width height:(float)height noteWidthHeight:(float)noteWidthHeight scale:(float)scale;
- (void)draw;

// Scale/Chord Names
- (NSArray *)getScaleNames;
- (NSArray *)getChordNames;
    
// Guitars
- (NSArray *)getGuitarTypeNames;
- (NSArray *)getGuitarNames:(NSString *)type;
- (NSArray *)getCustomGuitarNames;
- (BOOL)removeCustomGuitar:(NSString *)name;

- (NSString *)getDescription;
@end
#endif

#endif
