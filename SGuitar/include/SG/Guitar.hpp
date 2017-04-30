//
//  Guitar.h
//  Guitar
//
//  Created by John Sohn on 12/9/14.
//  Copyright (c) 2014 John Sohn. All rights reserved.
//

#ifndef __Guitar_h__
#define __Guitar_h__

#include "GuitarString.hpp"
#include "GuitarAdjustment.hpp"

typedef enum {
    GT_NONE = -1,
    GT_PEDAL_STEEL = 0,
    GT_LAP_STEEL
} GUITAR_TYPE;


typedef enum {
    GST_NONE = -1,
    GST_STRINGS_6 = 0,
    GST_STRINGS_8,
    GST_STRINGS_10,
    GST_STRINGS_12
} GUITAR_STRING_TYPE;




#define DEFAULT_NUMBER_OF_STRINGS       12

#ifdef __cplusplus
#include <string>

namespace SG {
    class Guitar {
    public:
        Guitar();
        Guitar(const Guitar& guitar);
        Guitar& operator=(const Guitar& guitar);
        Guitar(Guitar&& guitar);
        Guitar& operator=(Guitar&& guitar);
        ~Guitar();

        bool isValid() const;
        void reset();

        // read from string or file
        bool readFile(std::string filename);
        bool writeFile(std::string filename);

        void setNumberOfFrets(int numberOfFrets);
        int getNumberOfFrets() const;

        void setGuitarType(GUITAR_TYPE type);
        GUITAR_TYPE getGuitarType();

        // strings
        std::vector<SG::GuitarString> getStrings() const;
        void setString(int stringNumber, SG::GuitarString guitarString);
        SG::GuitarString getString(int stringNumber) const;
        void setNumberOfStrings(int numberOfStrings);
        int getNumberOfStrings() const;

        // adjustment
        bool isAdjustmentEnabled(std::string settingID);
        void activateAdjustment(std::string settingID, bool activated);
        void setAdjustment(std::string settingID, SG::GuitarAdjustment adjustment);
        SG::GuitarAdjustment getAdjustment(std::string settingID) const;
        
        void resetStrings();

        void initSettings();
        bool isAdjustmentActivated(std::string settingID);

        std::vector<int> stringNumbersAdjusted(std::string settingID);

        int noteValue(int stringNumber, int fret);
        int midiValue(int stringNumber, int fretNumber);
        bool toggleSettingID(std::string settingID);

        std::string getDescription() const;
        
        static int numberOfStringsForType(GUITAR_STRING_TYPE type);
        static GUITAR_STRING_TYPE typeForNumberOfStrings(int numberOfStrings);
        static GUITAR_TYPE typeForGuitarTypeName(std::string type);

        static std::string getGuitarTypeName(int index);
        static std::string getGuitarStringTypeName(int index);

    protected:
        static std::string GUITAR_TYPE_NAMES[];
        static std::string GUITAR_STRING_TYPE_NAMES[];
        
    protected:
        bool readJsonString(std::string json);

    private:
        struct GuitarImpl;
        std::unique_ptr<GuitarImpl> impl;
    };
}
#endif

#endif
