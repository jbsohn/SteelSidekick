//
//  SGuitar.h
//  SGuitar
//
//  Created by John Sohn on 2/28/16.
//  Copyright © 2016 John Sohn. All rights reserved.
//

#ifndef _SGuitar_h_
#define _SGuitar_h_

#include "SG/NoteName.hpp"
#include "SG/ScaleOptions.hpp"
#include "SG/ChordOptions.hpp"
#include "SG/GuitarOptions.hpp"
#include "SG/Scale.hpp"
#include "SG/Chord.hpp"
#include "SG/GuitarCanvas.hpp"
#include "SG/Guitar.hpp"
#include "SG/FileUtils.hpp"
#include "SG/GuitarAdjustmentType.hpp"

#ifdef __cplusplus
#include <string>
#include <vector>

namespace SG {
    typedef struct SGGuitarOptions {
        std::string guitarType;
        std::string guitarName;
        bool showAllNotes;
        ACCIDENTAL_DISPLAY_TYPE showNotesAs;
    } SGGuitarOptions;
    
    typedef struct SGScaleOptions {
        bool showScale;
        std::string scaleName;
        int scaleRootNoteValue;
        DISPLAY_ITEM_AS_TYPE displayItemsAs;
    } SGScaleOptions;
    
    typedef struct SGChordOptions {
        bool showChord;
        std::string chordName;
        int chordRootNoteValue;
        DISPLAY_ITEM_AS_TYPE displayItemsAs;
    } SGChordOptions;

    //
    // the exposed interface/API to the target platform
    //
    class SGuitar {
    protected:
        SGuitar();
        ~SGuitar();
    public:
        static SGuitar& sharedInstance();

        static void setSystemAndUserPaths(std::string systemPath, std::string userPath);

        SGGuitarOptions getGuitarOptions();
        void setGuitarOptions(SGGuitarOptions options);
        
        SGScaleOptions getScaleOptions();
        void setScaleOptions(SGScaleOptions options);
        
        SGChordOptions getChordOptions();
        void setChordOptions(SGChordOptions options);

        std::vector<int> getScaleNoteValues();
        std::vector<int> getChordNoteValues();
        bool isNoteValueInScale(int noteValue);
        bool isNoteValueInChord(int noteValue);

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
        void init(float width, float height, float noteWidthHeight, float borderWidth, float scale, float leftSafeArea);
        float cacluateNoteWidthHeight(float width, float height);
        void updateCanvasDimensions(float width, float height, float noteWidthHeight, float scale, float leftSafeArea);
        void draw();

        // Scale/Chord Names
        std::vector<std::string>getScaleNames() const;
        std::vector<std::string>getChordNames() const;
        
        // Guitars
        std::vector<std::string> getGuitarTypeNames() const;
        std::vector<std::string> getGuitarNames(std::string type) const;
        std::vector<std::string> getCustomGuitarNames() const;
        bool removeCustomGuitar(std::string name);
        bool addCustomGuitarFromPath(std::string path, std::string name);
        
        // Note Name for note value
        static std::string getNoteNameSharpFlat(int noteValue) {
            return NoteName::getNoteNameSharpFlat(noteValue);
        }
        
        static std::string getPedalTypeName(int index) {
            return GuitarAdjustmentType::getPedalTypeName(index);
        }
        
        static std::string getLeverTypeName(int index) {
            return GuitarAdjustmentType::getLeverTypeName(index);
        }
        
        std::string getDescription();

    protected:
        Scale getScale() const;
        Chord getChord() const;
        
    private:
        struct SGuitarImpl;
        std::unique_ptr<SGuitarImpl> impl;
    };
}

#endif

#endif
