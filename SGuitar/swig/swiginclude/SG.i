%module SG
%include "std_string.i"
%include "std_vector.i"
%include "std_map.i"
%include "enums.swg"


#define __ANDROID__

%{
#include "../include/SG/SGuitar.h"
%}
%include "../include/SG/SGuitar.h"

%include Chord.i
%include ChordOptions.i
%include ChordType.i
%include Chords.i
%include FileUtils.i
%include Guitar.i
%include GuitarCanvas.i
%include GuitarAdjustment.i
%include GuitarAdjustmentType.i
%include GuitarOptions.i
%include Guitars.i
%include GuitarString.i
%include GuitarType.i
%include Note.i
%include NoteName.i
%include OptionTypes.i
%include Scale.i
%include ScaleOptions.i
%include Scales.i
%include ScaleType.i
%include SGuitar.i
%include StringAdjustment.i

%template(GuitarStringVector) std::vector<SG::GuitarString>;
%template(NoteVector) std::vector<SG::Note>;
%template(GuitarTypeVector) std::vector<SG::GuitarType>;
%template(ScaleTypeVector) std::vector<SG::ScaleType>;
%template(ChordTypeVector) std::vector<SG::ChordType>;
%template(StringAdjustmentVector) std::vector<SG::StringAdjustment>;
%template(StdStringVector) std::vector<std::string>;
%template(IntVector) std::vector<int>;
