//
//  SCustomGuitar.hpp
//  SCustomGuitar
//
//  Copyright © 2018 John Sohn. All rights reserved.
//

#ifndef _SCustomGuitar_h_
#define _SCustomGuitar_h_


#ifdef __cplusplus

#include <string>
#include <vector>
#include <memory>
#include "SG/GuitarAdjustment.hpp"
#include "SG/GuitarAdjustmentType.hpp"
#include "SG/StringAdjustment.hpp"
#include "SG/Guitar.hpp"

namespace SG {
    class SCustomGuitar {
    public:
        SCustomGuitar();
        ~SCustomGuitar();

        static SCustomGuitar& sharedInstance();
        void reset();

        std::string getGuitarName();
        void setGuitarName(std::string guitarName);
        
        GUITAR_TYPE getGuitarType();
        void setGuitarType(GUITAR_TYPE type);

        void setNumberOfStrings(int numberOfStrings);
        int getNumberOfStrings();
        
        GUITAR_STRING_TYPE getGuitarStringType();
        void setGuitarStringType(GUITAR_STRING_TYPE type);

        void setStartNoteMIDIValue(int midiValue, int stringNumber);
        int getStartNoteMIDIValue(int stringNumber);

        void setGuitarAdjustment(std::string settingID, SG::GuitarAdjustment adjustment);
        SG::GuitarAdjustment getGuitarAdjustment(std::string adjustmentID);
        SG::StringAdjustment getStringAdjustment(std::string adjustmentID, int stringNumber);
        bool hasGuitarAdjustment(std::string aadjustmentID);

        bool isExistingGuitar();
        void save();
        void load();
    private:
        struct SCustomGuitarImpl;
        std::unique_ptr<SCustomGuitarImpl> impl;
    };
}
#endif

#endif

