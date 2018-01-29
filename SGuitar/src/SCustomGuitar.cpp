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

#define DEFAULT_NUMBER_OF_FRETS     26
#define MAX_NUMBER_OF_STRINGS       12

namespace SG {
    struct SCustomGuitar::SCustomGuitarImpl {
        SG::Guitar guitar;
        std::string guitarName;
        GUITAR_TYPE guitarType;
        GUITAR_STRING_TYPE guitarStringType;
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
        return impl->guitarType;
    }
    
    void SCustomGuitar::setGuitarType(GUITAR_TYPE type) {
        impl->guitarType = type;
    }
    
    GUITAR_STRING_TYPE SCustomGuitar::getGuitarStringType() {
        return impl->guitarStringType;
    }
    
    void SCustomGuitar::setGuitarStringType(GUITAR_STRING_TYPE type) {
        impl->guitarStringType = type;
    }

    void SCustomGuitar::setStartNote(int midiValue, int stringNumber) {
        SG:Note note(midiValue);
        SG::GuitarString guitarString(note, DEFAULT_NUMBER_OF_FRETS);
        impl->guitar.setString(stringNumber, guitarString);
    }

    int SCustomGuitar::getStartNoteMidiValue(int stringNumber) {
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

    void SCustomGuitar::reset() {
        impl->guitar.reset();

        impl->guitar.setGuitarType(GT_PEDAL_STEEL);

        // set to the maximum so we can resize as editing
        // without losing any entered values
        impl->guitar.setNumberOfStrings(MAX_NUMBER_OF_STRINGS);

        SG::Note note(NOTE_VALUE_C, 4);
        // default all strings to middle c
        for (int i = 1; i <= MAX_NUMBER_OF_STRINGS; i++) {
            setStartNote(note.getMIDIValue(), i);
        }
    }

    void SCustomGuitar::save() {
        Guitar saveGuitar = impl->guitar;
        
        // resize to the number of strings used
        saveGuitar.setNumberOfStrings(Guitar::numberOfStringsForType(impl->guitarStringType));
        saveGuitar.setGuitarType(impl->guitarType);
        
        std::string path = SG::FileUtils::getRootPathForUserFiles() + "/Custom Guitars" + "/";
        path += impl->guitarName;
        saveGuitar.writeFile(path);

        // TODO: check for duplicate
//        SG::SGuitar& sguitar = SG::SGuitar::sharedInstance();
//        sguitar.removeCustomGuitar([self.editingGuitarName UTF8String]);
//        NSString *selectedGuitarName = options.guitarName;
//        if ([selectedGuitarName isEqualToString:self.editingGuitarName]) {
//            // the selected guitar has been renamed, set to new guitar name
//            options.guitarName = self.guitarName;
//        }
//
//        self.editingGuitarName = self.guitarName;
    }

    void SCustomGuitar::load() {
        Guitar loadGuitar;
        std::string path = SG::FileUtils::getRootPathForUserFiles() + "/Custom Guitars" + "/";
        path += impl->guitarName;
        loadGuitar.readFile(path);

        int numberOfStrings = loadGuitar.getNumberOfStrings();
        impl->guitarType = loadGuitar.getGuitarType();
        impl->guitarStringType = Guitar::typeForNumberOfStrings(numberOfStrings);
        loadGuitar.setNumberOfStrings(MAX_NUMBER_OF_STRINGS);
    }
}

