%module SG

%include "std_string.i"
%include "std_vector.i"
%include "std_map.i"
%include "enums.swg"
%javaconst(1);

enum ACCIDENTAL_DISPLAY_TYPE { ADT_SHARP, ADT_FLAT };

enum DISPLAY_ITEM_AS_TYPE { DIA_NOTES, DIA_INTERVAL } ;

typedef struct {
    int stringNumber;
    int fretNumber;
} GUITAR_CANVAS_POSITION;

%{
#include "../include/SGuitar.hpp"
%}

%include "../include/SGuitar.hpp"

%template(StdStringVector) std::vector<std::string>;
%template(IntVector) std::vector<int>;
