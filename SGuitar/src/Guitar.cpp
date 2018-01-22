//
//  Guitar.cpp
//  Guitar
//
//  Created by John Sohn on 12/14/14.
//  Copyright (c) 2014 John Sohn. All rights reserved.
//

#include <fstream>
#include <sstream>
#include <vector>
#include <map>
#include <JsonBox.h>
#include "SG/Note.hpp"
#include "SG/NoteName.hpp"
#include "SG/GuitarString.hpp"
#include "SG/GuitarAdjustment.hpp"
#include "SG/GuitarAdjustmentType.hpp"
#include "SG/Guitar.hpp"
#include "SG/FileUtils.hpp"

namespace SG {
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //  GuitarImpl
    struct Guitar::GuitarImpl {
        int numberOfFrets;
        std::vector<GuitarString> strings;
        std::map<std::string, GuitarAdjustment> adjustments;
        bool isValid;
        std::map<std::string, bool> settings;
        GUITAR_TYPE guitarType;

        void init(const Guitar& guitar) {
            numberOfFrets = guitar.impl->numberOfFrets;
            guitarType = guitar.impl->guitarType;
            strings = guitar.impl->strings;
            adjustments = guitar.impl->adjustments;
            isValid = guitar.impl->isValid;
            settings = guitar.impl->settings;
        }

        std::string readFile(std::string filename) {
            std::ifstream t(filename);
            std::stringstream buffer;
            buffer << t.rdbuf();
            return buffer.str();
        }
        
        void reset() {
            numberOfFrets = 0;
            guitarType = GT_NONE;
            strings.clear();
            adjustments.clear();
            isValid = false;
        }
        
        bool writeJonGuitarStrings() {
            return false;
        }
    
        bool readJSONGuitarStrings(const JsonBox::Value& jGuitarStringsRoot, int numberOfFrets) {
            if (jGuitarStringsRoot.isNull()) {
                return false;
            }
            JsonBox::Array jGuitarStrings = jGuitarStringsRoot.getArray();
            
            if (jGuitarStrings.empty()) {
                return false;
            }
            
            strings.resize(jGuitarStrings.size() + 1);

            for (int i = 0; i < jGuitarStrings.size(); i++) {
                JsonBox::Value jCurGuitarStringRoot = jGuitarStrings[i];
                
                if (!jCurGuitarStringRoot.isNull()) {
                    JsonBox::Object jCurGuitarString = jCurGuitarStringRoot.getObject();
                    
                    if (!jCurGuitarString.empty()) {
                        JsonBox::Value jStringNumber = jCurGuitarString["StringNumber"];
                        JsonBox::Value jStartNote = jCurGuitarString["StartNote"];
                        
                        if (!jStringNumber.isNull() && !jStartNote.isNull()) {
                            int stringNumber = jStringNumber.getInteger();
                            std::string startNote = jStartNote.getString();
                            Note note(startNote);
                            
                            GuitarString curString(note.getMIDIValue(), numberOfFrets);
                            strings[stringNumber] = curString;
                        }
                    }
                }
            }
            
            return true;
        }
        
        bool readJSONGuitarAdjustments(const JsonBox::Value& jGuitarAdjustmentsRoot) {
            if (jGuitarAdjustmentsRoot.isNull()) {
                return false;
            }
            JsonBox::Array jGuitarAdjustments = jGuitarAdjustmentsRoot.getArray();
            
            if (jGuitarAdjustments.empty()) {
                return false;
            }
            
            for (int i = 0; i < jGuitarAdjustments.size(); i++) {
                JsonBox::Value jCurGuitarAdjustmentRoot = jGuitarAdjustments[i];
                
                if (!jCurGuitarAdjustmentRoot.isNull()) {
                    JsonBox::Object jCurGuitarAdjustment = jCurGuitarAdjustmentRoot.getObject();
                    
                    if (!jCurGuitarAdjustment.empty()) {
                        JsonBox::Value jID = jCurGuitarAdjustment["ID"];
                        
                        if (!jID.isNull()) {
                            std::string id = jID.getString();
                            GuitarAdjustment guitarAdjustment(id);
                            
                            JsonBox::Value jStringAdjustmentRoot = jCurGuitarAdjustment["StringAdjustments"];
                            if (!jStringAdjustmentRoot.isNull()) {
                                JsonBox::Array jStringAdjustmentArray = jStringAdjustmentRoot.getArray();
                                
                                for (int j = 0; j < jStringAdjustmentArray.size(); j++) {
                                    JsonBox::Value jCurStringAdjustmentRoot = jStringAdjustmentArray[j];
                                    JsonBox::Object jCurStringAdjustment = jCurStringAdjustmentRoot.getObject();
                                    JsonBox::Value jStringNumber = jCurStringAdjustment["StringNumber"];
                                    JsonBox::Value jStep = jCurStringAdjustment["Step"];
                                    
                                    if (!jStringNumber.isNull() && !jStep.isNull()) {
                                        int stringNumber = jStringNumber.getInteger();
                                        int step = jStep.getInteger();
                                        
                                        StringAdjustment stringAdjustment(stringNumber, step);
                                        guitarAdjustment.addStringAdjustment(stringAdjustment);
                                    }
                                }
                            }
                            adjustments[id] = guitarAdjustment;
                        }
                    }
                }
            }
            return true;
        }
        
        JsonBox::Object createGuitarAdjustment(std::string adjustmentID) {
            GuitarAdjustment guitarAdjustment = adjustments[adjustmentID];
            JsonBox::Object jGuitarAdjustment;
            JsonBox::Array jStringAdjustments;
            
            if (!guitarAdjustment.getStringAdjustments().empty()) {
                for (StringAdjustment stringAdjustment : guitarAdjustment.getStringAdjustments()) {
                    JsonBox::Object jStringAdjustment;
                    jStringAdjustment["StringNumber"] = stringAdjustment.getStringNumber();
                    jStringAdjustment["Step"] = stringAdjustment.getStep();
                    jStringAdjustments.push_back(jStringAdjustment);
                }

                jGuitarAdjustment["ID"] = adjustmentID;
                jGuitarAdjustment["StringAdjustments"] = jStringAdjustments;
            }
            return jGuitarAdjustment;
        }

        JsonBox::Array createGuitarAdjustments() {
            JsonBox::Array jGuitarAdjustments;
            for (int i = PT_P1; i <= PT_P10; i++) {
                JsonBox::Object jGuitarAdjustment = createGuitarAdjustment(GuitarAdjustmentType::getPedalTypeName(i));
                if (!jGuitarAdjustment.empty()) {
                    jGuitarAdjustments.push_back(jGuitarAdjustment);
                }
            }
            
            for (int i = LT_LKL; i <= LT_RKRR; i++) {
                JsonBox::Object jGuitarAdjustment = createGuitarAdjustment(GuitarAdjustmentType::getLeverTypeName(i));
                if (!jGuitarAdjustment.empty()) {
                    jGuitarAdjustments.push_back(jGuitarAdjustment);
                }
            }
    

            return jGuitarAdjustments;
        }

        JsonBox::Array createGuitarStrings() {
            JsonBox::Array guitarStrings;
            for (int i = 1; i <= strings.size() - 1; i++) {
                GuitarString gs = strings[i];
                
                JsonBox::Object string;
                Note startNote = gs.getStartNote();
                string["StringNumber"] = i;
                string["StartNote"] = startNote.getNoteNamePitchUTF8();
                guitarStrings.push_back(string);
            }
            return guitarStrings;
        }
        
        void activateStringAdjustment(const StringAdjustment& adjustment, bool enabled) {
            int stringNumber = adjustment.getStringNumber();
            int step = 0;
            
            if (enabled) {
                step = adjustment.getStep();
            } else {
                step = -(adjustment.getStep());
            }
            
            GuitarString& string = strings.at(stringNumber);
            string.adjustStringBySteps(step);
        }
        
        void resetString(int stringNumber) {
            GuitarString& string = strings.at(stringNumber);
            string.reset();
        }
        
        void printStringsAtFret0() {
            for (int i = 0; i < strings.size(); i++) {
                const GuitarString& curString = strings[i];
                
                if (curString.isValid()) {
                    std::vector<int> noteValues = curString.getNoteValues();
                    Note firstNote(noteValues[0]);
                }
            }
        }
    };

    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //  Guitar

    std::string Guitar::GUITAR_TYPE_NAMES[] = {
        "Pedal Steel",
        "Lap Steel"
    };
    
    std::string Guitar::GUITAR_STRING_TYPE_NAMES[] = {
        "6 Strings",
        "8 Strings",
        "10 Strings",
        "12 Strings"
    };
    
    Guitar::Guitar()
        : impl(new GuitarImpl) {
        impl->strings.clear();
        impl->numberOfFrets = 0;
        impl->isValid = false;
    }

    Guitar::Guitar(const Guitar& guitar) : impl(new GuitarImpl) {
        impl->init(guitar);
    }

    Guitar::~Guitar() {

    }
    
    Guitar& Guitar::operator=(const Guitar& guitar) {
        impl->init(guitar);
        return *this;
    }

    Guitar::Guitar(Guitar&& guitar) {
        impl = std::move(guitar.impl);
        guitar.impl = nullptr;
    }
    
    Guitar& Guitar::operator=(Guitar&& guitar) {
        if (this != &guitar) {
            impl = std::move(guitar.impl);
            guitar.impl = nullptr;
        }
        return *this;
    }
    
    bool Guitar::isValid() const {
        return impl->isValid;
    }

    void Guitar::reset() {
        impl->reset();
    }

    void Guitar::setGuitarType(GUITAR_TYPE type) {
        impl->guitarType = type;
    }
    
    GUITAR_TYPE Guitar::getGuitarType() {
        return impl->guitarType;
    }

    std::vector<GuitarString> Guitar::getStrings() const {
        return impl->strings;
    }

    void Guitar::setString(int stringNumber, GuitarString guitarString) {
        impl->strings[stringNumber] = guitarString;
    }

    GuitarString Guitar::getString(int stringNumber) const {
        return impl->strings[stringNumber];
    }
    
    void Guitar::setNumberOfStrings(int numberOfStrings) {
        impl->strings.resize(numberOfStrings + 1);
    }

    int Guitar::getNumberOfStrings() const {
        return (int) impl->strings.size() - 1;
    }

    void Guitar::setNumberOfFrets(int numberOfFrets) {
        impl->numberOfFrets = numberOfFrets;
    }

    int Guitar::getNumberOfFrets() const {
        return impl->numberOfFrets;
    }

    bool Guitar::isAdjustmentEnabled(std::string settingID) {
        if (impl->adjustments.find(settingID) != impl->adjustments.end()) {
            GuitarAdjustment adjustment = impl->adjustments[settingID];
            return adjustment.isValid();
        }
        return false;
    }

    void Guitar::resetStrings() {
        for (int i = 1; i < impl->strings.size(); i++) {
            impl->resetString(i);
        }
    }

    bool Guitar::readFile(std::string filename) {
        std::string json = FileUtils::readFile(filename);
        return readJsonString(json);
    }

    bool Guitar::writeFile(std::string filename) {
        JsonBox::Object root;
        root["NumberOfFrets"] = 26;
        
        if (impl->guitarType != GT_NONE) {
            root["GuitarType"] = GUITAR_TYPE_NAMES[impl->guitarType];
        }

        root["GuitarStrings"] = impl->createGuitarStrings();
        root["GuitarAdjustments"] = impl->createGuitarAdjustments();
        JsonBox::Value v(root);
        v.writeToFile(filename);
        return true;
    }

    bool Guitar::readJsonString(std::string json) {
        try {
            impl->reset();
            impl->isValid = false;

            JsonBox::Value root;
            root.loadFromString(json);

            if (root.isNull()) {
                return false;
            }

            JsonBox::Object rootObject = root.getObject();

            if (rootObject.empty()) {
                impl->isValid = false;
                return false;
            }

            JsonBox::Value jNumberOfFrets = rootObject["NumberOfFrets"];

            if (jNumberOfFrets.isNull()) {
                impl->isValid = false;
                return false;
            }

            impl->numberOfFrets = jNumberOfFrets.getInteger();

            
            JsonBox::Value jGuitarType = rootObject["GuitarType"];
            if (!jGuitarType.isNull()) {
                std::string type = jGuitarType.getString();
                GUITAR_TYPE guitarType = typeForGuitarTypeName(type);
                impl->guitarType = guitarType;
            }
            
            JsonBox::Value jGuitarStringsRoot = rootObject["GuitarStrings"];
            if (!impl->readJSONGuitarStrings(jGuitarStringsRoot, impl->numberOfFrets)) {
                impl->isValid = false;
                return false;
            }

            JsonBox::Value jGuitarAdjustmentsRoot = rootObject["GuitarAdjustments"];
            if (!impl->readJSONGuitarAdjustments(jGuitarAdjustmentsRoot)) {
                impl->isValid = false;
                return false;
            }
        } catch (...) {
            impl->isValid = false;
            return false;
        }

        impl->isValid = true;
        return true;
    }

    void Guitar::activateAdjustment(std::string settingID, bool activated) {
        GuitarAdjustment adjustment = impl->adjustments[settingID];
        for (int i = 0; i < adjustment.getNumberOfStringAdjustments(); i++) {
            StringAdjustment curAdjustment = adjustment.getStringAdjustment(i);
            impl->activateStringAdjustment(curAdjustment, activated);
        }

        impl->settings[settingID] = activated;
    }
    
    void Guitar::setAdjustment(std::string settingID, GuitarAdjustment adjustment) {
        impl->adjustments[settingID] = adjustment;
    }

    GuitarAdjustment Guitar::getAdjustment(std::string settingID) const {
        static const GuitarAdjustment none;

        try {
            const GuitarAdjustment& adjustment = impl->adjustments[settingID];
            return adjustment;
        } catch (...) {

        }
        return none;
    }

    void Guitar::initSettings() {
        impl->settings[GuitarAdjustmentType::getLeverTypeName(LT_LKL)] = false;
        impl->settings[GuitarAdjustmentType::getLeverTypeName(LT_LKLR)] = false;
        impl->settings[GuitarAdjustmentType::getLeverTypeName(LT_LKV)] = false;
        impl->settings[GuitarAdjustmentType::getLeverTypeName(LT_LKR)] = false;
        impl->settings[GuitarAdjustmentType::getLeverTypeName(LT_LKRR)] = false;
        impl->settings[GuitarAdjustmentType::getLeverTypeName(LT_RKL)] = false;
        impl->settings[GuitarAdjustmentType::getLeverTypeName(LT_RKLR)] = false;
        impl->settings[GuitarAdjustmentType::getLeverTypeName(LT_RKV)] = false;
        impl->settings[GuitarAdjustmentType::getLeverTypeName(LT_RKR)] = false;
        impl->settings[GuitarAdjustmentType::getLeverTypeName(LT_RKRR)] = false;

        impl->settings[GuitarAdjustmentType::getPedalTypeName(PT_P1)] = false;
        impl->settings[GuitarAdjustmentType::getPedalTypeName(PT_P2)] = false;
        impl->settings[GuitarAdjustmentType::getPedalTypeName(PT_P3)] = false;
        impl->settings[GuitarAdjustmentType::getPedalTypeName(PT_P4)] = false;
        impl->settings[GuitarAdjustmentType::getPedalTypeName(PT_P5)] = false;
        impl->settings[GuitarAdjustmentType::getPedalTypeName(PT_P6)] = false;
        impl->settings[GuitarAdjustmentType::getPedalTypeName(PT_P7)] = false;
        impl->settings[GuitarAdjustmentType::getPedalTypeName(PT_P8)] = false;
        impl->settings[GuitarAdjustmentType::getPedalTypeName(PT_P9)] = false;
        impl->settings[GuitarAdjustmentType::getPedalTypeName(PT_P10)] = false;
    }

    bool Guitar::isAdjustmentActivated(std::string settingID) {
        return impl->settings[settingID];
    }

    std::vector<int> Guitar::stringNumbersAdjusted(std::string settingID) {
        const GuitarAdjustment& adjustment = getAdjustment(settingID);
        std::vector<int> stringNumbers;
        //std::vector<StringAdjustment> adjustments = adjustment.getStringAdjustments();

        for (int i = 0; i < adjustment.getNumberOfStringAdjustments(); i++) {
            StringAdjustment curStringAdjustment = adjustment.getStringAdjustment(i);
//        for (const StringAdjustment& curStringAdjustment : adjustments) {
            int stringNumber = curStringAdjustment.getStringNumber();
            stringNumbers.push_back(stringNumber);
        }
        return stringNumbers;
    }
	
    int Guitar::noteValue(int stringNumber, int fret) {
        const GuitarString& string = impl->strings[stringNumber];
        std::vector<int> notes = string.getNoteValues();
        Note note(notes[fret]);
        return note.getNoteValue();
    }

    int Guitar::midiValue(int stringNumber, int fretNumber) {
        if (stringNumber > 0 && fretNumber >= 0) {
            const GuitarString& string = impl->strings[stringNumber];
            std::vector<int> notes = string.getNoteValues();
            return notes[fretNumber];
        }
        return -1;
    }

    bool Guitar::toggleSettingID(std::string settingID) {
        bool activated = isAdjustmentActivated(settingID);
        activated = !activated;
        activateAdjustment(settingID, activated);
        return activated;
    }

    std::string Guitar::getDescription() const {
        std::string description = "\r\n";
        for (int i = 0; i < impl->strings.size(); i++) {
            GuitarString curString = impl->strings[i];
            if (curString.isValid()) {
                std::vector<int> noteValues = curString.getNoteValues();
                Note curNote(noteValues[0]);
                description += "string ";
                description += std::to_string(i);
                description += ": ";
                description += NoteName::getNoteNameSharp(curNote.getNoteValue());
                description += "\r\n";
            }
        }

        description += impl->adjustments[GuitarAdjustmentType::getLeverTypeName(LT_LKL)].getDescription() + "\r\n";
        description += impl->adjustments[GuitarAdjustmentType::getLeverTypeName(LT_LKLR)].getDescription() + "\r\n";
        description += impl->adjustments[GuitarAdjustmentType::getLeverTypeName(LT_LKV)].getDescription() + "\r\n";
        description += impl->adjustments[GuitarAdjustmentType::getLeverTypeName(LT_LKR)].getDescription() + "\r\n";
        description += impl->adjustments[GuitarAdjustmentType::getLeverTypeName(LT_LKRR)].getDescription() + "\r\n";
        description += impl->adjustments[GuitarAdjustmentType::getLeverTypeName(LT_RKL)].getDescription() + "\r\n";
        description += impl->adjustments[GuitarAdjustmentType::getLeverTypeName(LT_RKLR)].getDescription() + "\r\n";
        description += impl->adjustments[GuitarAdjustmentType::getLeverTypeName(LT_RKV)].getDescription() + "\r\n";
        description += impl->adjustments[GuitarAdjustmentType::getLeverTypeName(LT_RKR)].getDescription() + "\r\n";
        description += impl->adjustments[GuitarAdjustmentType::getLeverTypeName(LT_RKRR)].getDescription() + "\r\n";
        
        description += impl->adjustments[GuitarAdjustmentType::getPedalTypeName(PT_P1)].getDescription() + "\r\n";
        description += impl->adjustments[GuitarAdjustmentType::getPedalTypeName(PT_P2)].getDescription() + "\r\n";
        description += impl->adjustments[GuitarAdjustmentType::getPedalTypeName(PT_P3)].getDescription() + "\r\n";
        description += impl->adjustments[GuitarAdjustmentType::getPedalTypeName(PT_P4)].getDescription() + "\r\n";
        description += impl->adjustments[GuitarAdjustmentType::getPedalTypeName(PT_P5)].getDescription() + "\r\n";
        description += impl->adjustments[GuitarAdjustmentType::getPedalTypeName(PT_P6)].getDescription() + "\r\n";
        description += impl->adjustments[GuitarAdjustmentType::getPedalTypeName(PT_P7)].getDescription() + "\r\n";
        description += impl->adjustments[GuitarAdjustmentType::getPedalTypeName(PT_P8)].getDescription() + "\r\n";
        description += impl->adjustments[GuitarAdjustmentType::getPedalTypeName(PT_P9)].getDescription() + "\r\n";
        description += impl->adjustments[GuitarAdjustmentType::getPedalTypeName(PT_P10)].getDescription() + "\r\n";
        return description;
    }
    
    int Guitar::numberOfStringsForType(GUITAR_STRING_TYPE type) {
        int numberOfStrings = 0;
        if (type == GST_STRINGS_6) {
            numberOfStrings = 6;
        } else if (type == GST_STRINGS_8) {
            numberOfStrings = 8;
        } else if (type == GST_STRINGS_10) {
            numberOfStrings = 10;
        } else if (type == GST_STRINGS_12) {
            numberOfStrings = 12;
        }
        return numberOfStrings;
    }
    
    GUITAR_STRING_TYPE Guitar::typeForNumberOfStrings(int numberOfStrings) {
        GUITAR_STRING_TYPE type = GST_NONE;
        
        if (numberOfStrings == 6) {
            type = GST_STRINGS_6;
        } else if (numberOfStrings == 8) {
            type = GST_STRINGS_8;
        } else if (numberOfStrings == 10) {
            type = GST_STRINGS_10;
        } else if (numberOfStrings == 12) {
            type = GST_STRINGS_12;
        }
        return type;
    }
    
    GUITAR_TYPE Guitar::typeForGuitarTypeName(std::string type) {
        if (type == GUITAR_TYPE_NAMES[GT_LAP_STEEL]) {
            return GT_LAP_STEEL;
        } else if (type == GUITAR_TYPE_NAMES[GT_PEDAL_STEEL]) {
            return GT_PEDAL_STEEL;
        }
        return GT_NONE;
    }
    
    std::string Guitar::getGuitarTypeName(int index) {
        return Guitar::GUITAR_TYPE_NAMES[index];
    }
    std::string Guitar::getGuitarStringTypeName(int index) {
        return Guitar::GUITAR_STRING_TYPE_NAMES[index];
    }
}
