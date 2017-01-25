//
//  SGuitar.cpp
//  SGuitar
//
//  Created by John Sohn on 2/28/16.
//  Copyright © 2016 John Sohn. All rights reserved.
//

#include "SG/SGuitar.h"
#include "SG/GuitarOptions.h"
#include "SG/ScaleOptions.h"
#include "SG/ChordOptions.h"
#include "SG/Scales.h"
#include "SG/Chords.h"
#include "SG/GuitarTypes.h"
#include "SG/Guitar.h"
#include "SG/Guitars.h"
#include "SG/GuitarCanvas.h"
#include "SG/FileUtils.h"

namespace SG {
    struct SGuitar::SGuitarImpl {
        GuitarOptions guitarOptions;
        ScaleOptions scaleOptions;
        ChordOptions chordOptions;
        GuitarCanvas guitarCanvas;
        GuitarTypes guitarTypes;
        Guitar guitar;
        Guitars guitars;
        Chords chords;
        Scales scales;
        
        void initScales() {
            std::string pathName = FileUtils::getRootPathForFiles() + "/Settings/Scales.settings";
            scales.readFile(pathName);
        }
        
        void initChords() {
            std::string pathName = FileUtils::getRootPathForFiles() + "/Settings/Chords.settings";
            chords.readFile(pathName);
        }
        
        void initGuitarTypes() {
            std::string pathName = FileUtils::getRootPathForFiles() + "/Settings/GuitarTypes.settings";
            guitarTypes.readFile(pathName);
        }
        
        void initGuitars() {
            std::string guitarsPath = FileUtils::getRootPathForFiles() + "/Guitars";
            guitars.setGuitarsPath(guitarsPath);
        }

        void setupGuitar() {
            std::string type = guitarOptions.getGuitarType();
            std::string name = guitarOptions.getGuitarName();
            std::string path;
    
            if (type == "Custom") {
                path = FileUtils::getRootPathForUserFiles() + "/Custom Guitars/" + name;
            } else {
                path = FileUtils::getRootPathForFiles() + "/Guitars/" + type + "/" + name;
            }
            guitar.readFile(path);
        }
        
        void initDefaultOptions() {
            scaleOptions.setScaleName("Major");
            scaleOptions.setScaleRootNoteValue(NOTE_VALUE_C);
            scaleOptions.setDisplayItemsAs(DIA_NOTES);
            scaleOptions.setShowScale(true);
            
            chordOptions.setChordName("Major");
            chordOptions.setChordRootNoteValue(NOTE_VALUE_C);
            chordOptions.setDisplayItemsAs(DIA_NOTES);
            chordOptions.setShowChord(true);
            
            guitarOptions.setGuitarType("Pedal Steel");
            guitarOptions.setGuitarName("E9 10 String");
            guitarOptions.setShowNotesAs(ADT_SHARP);
        }
    };

    SGuitar::SGuitar() : impl(new SGuitarImpl) {
        impl->initScales();
        impl->initChords();
        impl->initGuitarTypes();
        impl->initGuitars();
        impl->initDefaultOptions(); // before setting Guitar, Scale, Chord
        
        impl->setupGuitar();
    }
    
    SGuitar::~SGuitar() {
        
    }
    
    SGuitar& SGuitar::sharedInstance() {
        static SGuitar instance;
        return instance;
    }
    
    GuitarOptions& SGuitar::getGuitarOptions() {
        return impl->guitarOptions;
    }
    
    ScaleOptions& SGuitar::getScaleOptions() {
        return impl->scaleOptions;
    }
    
    ChordOptions& SGuitar::getChordOptions() {
        return impl->chordOptions;
    }

    void SGuitar::reloadGuitar() {
        impl->setupGuitar();
    }

    
    int SGuitar::getNumberOfStrings() {
        return impl->guitar.getNumberOfStrings();
    }
    
    int SGuitar::getNumberOfFrets() {
        return impl->guitar.getNumberOfFrets();
    }

    std::vector<int> SGuitar::getNoteValuesForString(int stringNumber) {
        std::vector<GuitarString> strings = impl->guitar.getStrings();
        GuitarString string = strings[stringNumber];
        return string.getNoteValues();
    }
    
    bool SGuitar::isAdjustmentEnabled(std::string settingID) const {
        return impl->guitar.isAdjustmentEnabled(settingID);
    }
    
    void SGuitar::activateAdjustment(std::string settingID, bool activated) {
        impl->guitar.activateAdjustment(settingID, activated);
    }

    int SGuitar::midiValue(int stringNumber, int fretNumber) {
        if (stringNumber >= 1 && stringNumber <= impl->guitar.getNumberOfStrings() && fretNumber >= 0) {
            return impl->guitar.midiValue(stringNumber, fretNumber);
        }
        return -1;
    }
    
    void SGuitar::init(float width, float height, float noteWidthHeight, float borderWidth, float scale) {
        impl->guitarCanvas.init(width, height, noteWidthHeight, borderWidth, scale);
    }
    
    float SGuitar::cacluateNoteWidthHeight(float width, float height) {
        return impl->guitarCanvas.cacluateNoteWidthHeight(width, height);
    }
    
    void SGuitar::updateCanvasDimensions(float width, float height, float noteWidthHeight, float scale) {
        impl->guitarCanvas.updateCanvasDimensions(width, height, noteWidthHeight, scale);
    }

    void SGuitar::draw() {
        impl->guitarCanvas.draw(*this);
    }
    
    GUITAR_CANVAS_POSITION SGuitar::positionAtCoordinates(float x, float y) {
        return impl->guitarCanvas.positionAtCoordinates(x, y);
    }
    
    void SGuitar::setSelectedItem(GUITAR_CANVAS_POSITION position) {
        impl->guitarCanvas.setSelectedItem(position);
    }
    
    Scale SGuitar::getScale() const {
        std::string scaleName = impl->scaleOptions.getScaleName();
        ScaleType scaleType = impl->scales.getScaleType(scaleName);
        std::vector<int> semitones = scaleType.getSemitones();
        return Scale(impl->scaleOptions.getScaleRootNoteValue(), semitones);
    }
    
    Chord SGuitar::getChord() const {
        std::string chordName = impl->chordOptions.getChordName();
        ChordType chordType = impl->chords.getChordType(chordName);
        std::vector<int> intervals = chordType.getintervals();
        return Chord(impl->chordOptions.getChordRootNoteValue(), intervals);
    }
    
    std::vector<std::string> SGuitar::getScaleNames() const {
        std::vector<ScaleType> scales = impl->scales.getScales();
        std::vector<std::string> names;
        
        for (ScaleType scale : scales) {
            std::string name = scale.getName();
            names.push_back(name);
        }
        return names;
    }
    
    std::vector<std::string> SGuitar::getChordNames() const {
        std::vector<ChordType> chords = impl->chords.getChords();
        std::vector<std::string> names;
        
        for (ChordType chord : chords) {
            std::string name = chord.getName();
            names.push_back(name);
        }
        return names;
    }

    std::vector<std::string> SGuitar::getGuitarTypeNames() const {
        std::vector<GuitarType> guitarTypes = impl->guitarTypes.getGuitarTypes();
        std::vector<std::string> names;
        
        for (GuitarType guitarType : guitarTypes) {
            std::string name = guitarType.getName();
            names.push_back(name);
        }
        return names;
    }

    std::vector<std::string> SGuitar::getGuitarNames(std::string type) const {
        return impl->guitars.getGuitarNames(type);
    }

    std::vector<std::string> SGuitar::getCustomGuitarNames() const {
        return impl->guitars.getCustomGuitarNames();
    }
    
    bool SGuitar::removeCustomGuitar(std::string name) {
        return impl->guitars.removeCustomGuitar(name);
    }
    
    std::string SGuitar::getDescription() {
        return impl->guitar.getDescription();
    }
    
}

