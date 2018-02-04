//
//  SCustomGuitar.cpp
//  SteelSidekick
//
//  Created by John Sohn on 7/4/16.
//
//

#include "SCustomGuitar.hpp"
#include "Guitar.hpp"
#include "FileUtils.hpp"

// the defaults for createing a new guitar, 6 string lap steel with 26 frets
#define NEW_DEFAULT_NUMBER_OF_STRINGS       6
#define NEW_DEFAULT_GUITAR_TYPE             GT_LAP_STEEL
#define NEW_DEFAULT_NUMBER_OF_FRETS         26

namespace SG {
    struct SCustomGuitar::SCustomGuitarImpl {
        SG::Guitar guitar;
        std::string guitarName;
    };

    SCustomGuitar::SCustomGuitar() : impl(new SCustomGuitarImpl) {

    }
    
    SCustomGuitar::~SCustomGuitar() {
        
    }
    
    SCustomGuitar& SCustomGuitar::sharedInstance() {
        static SCustomGuitar instance;
        return instance;
    }

    std::string SCustomGuitar::getGuitarName() {
        return impl->guitarName;
    }
    
    void SCustomGuitar::setGuitarName(std::string guitarName) {
        impl->guitarName = guitarName;
    }
    
    GUITAR_TYPE SCustomGuitar::getGuitarType() {
        return impl->guitar.getGuitarType();
    }
    
    void SCustomGuitar::setGuitarType(GUITAR_TYPE type) {
        impl->guitar.setGuitarType(type);
    }
    
    GUITAR_STRING_TYPE SCustomGuitar::getGuitarStringType() {
        return SG::Guitar::typeForNumberOfStrings(impl->guitar.getNumberOfStrings());
    }

    void SCustomGuitar::setGuitarStringType(GUITAR_STRING_TYPE type) {
        int curNumberOfStrings = impl->guitar.getNumberOfStrings();
        int numberOfStrings = SG::Guitar::numberOfStringsForType(type);
        impl->guitar.setNumberOfStrings(numberOfStrings);
        
        if (curNumberOfStrings < numberOfStrings) {
            SG::Note note(NOTE_VALUE_C, 4);
            for (int i = curNumberOfStrings + 1; i <= numberOfStrings; i++) {
                setStartNoteMIDIValue(note.getMIDIValue(), i);
            }
        }
    }

    void SCustomGuitar::setStartNoteMIDIValue(int midiValue, int stringNumber) {
        SG::GuitarString guitarString(midiValue, NEW_DEFAULT_NUMBER_OF_FRETS);
        impl->guitar.setString(stringNumber, guitarString);
    }

    int SCustomGuitar::getStartNoteMIDIValue(int stringNumber) {
        SG::GuitarString guitarString = impl->guitar.getString(stringNumber);
        SG::Note note = guitarString.getStartNote();
        return note.getMIDIValue();
    }

    void SCustomGuitar::setGuitarAdjustment(std::string settingID, SG::GuitarAdjustment adjustment) {
        impl->guitar.setAdjustment(settingID, adjustment);
    }

    SG::GuitarAdjustment SCustomGuitar::getGuitarAdjustment(std::string adjustmentID) {
        SG::GuitarAdjustment guitarAdjustment = impl->guitar.getAdjustment(adjustmentID);
        return guitarAdjustment;
    }

    SG::StringAdjustment SCustomGuitar::getStringAdjustment(std::string adjustmentID, int stringNumber) {
        SG::GuitarAdjustment guitarAdjustment = impl->guitar.getAdjustment(adjustmentID);
        SG::StringAdjustment stringAdjustment;
        if (guitarAdjustment.isValid()) {
             stringAdjustment = guitarAdjustment.getStringAdjustment(stringNumber);
        }

        return stringAdjustment;
    }

    bool SCustomGuitar::isExistingGuitar() {
        std::string path = SG::FileUtils::getRootPathForUserFiles() + "/Custom Guitars" + "/";
        return FileUtils::isExistingFile(impl->guitarName, path);
    }

    void SCustomGuitar::reset() {
        impl->guitar.reset();

        impl->guitarName = "";
        impl->guitar.setGuitarType(NEW_DEFAULT_GUITAR_TYPE);
        impl->guitar.setNumberOfStrings(NEW_DEFAULT_NUMBER_OF_STRINGS);

        SG::Note note(NOTE_VALUE_C, 4);
        // default all strings to middle c
        for (int i = 1; i <= NEW_DEFAULT_NUMBER_OF_STRINGS; i++) {
            setStartNoteMIDIValue(note.getMIDIValue(), i);
        }
    }

    void SCustomGuitar::save() {
        std::string path = SG::FileUtils::getRootPathForUserFiles() + "/Custom Guitars" + "/";
        path += impl->guitarName;
        impl->guitar.writeFile(path);
    }

    void SCustomGuitar::load() {
        std::string path = SG::FileUtils::getRootPathForUserFiles() + "/Custom Guitars" + "/";
        path += impl->guitarName;
        impl->guitar.readFile(path);
    }
}
