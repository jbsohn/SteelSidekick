//
//  Note.cpp
//  SGuitar
//
//  Created by John Sohn on 12/14/14.
//  Copyright (c) 2014 John Sohn. All rights reserved.
//

#include <string>
#include "SG/Note.h"
#include "SG/NoteName.h"

namespace SG {
    struct Note::NoteImpl {
        int midiValue;
        bool isValid;
        
        void init(int noteValue, int pitch) {
            midiValue = ((pitch * 12) + noteValue);
            isValid = true;
        }
        
        void init(const Note& note) {
            midiValue = note.impl->midiValue;
            isValid = note.impl->isValid;
        }
    };
    
    Note::Note()
        :impl(new NoteImpl) {
        impl->midiValue = -1;
        impl->isValid = false;
    }

    Note::Note(int noteValue, int pitch)
        :impl(new NoteImpl) {
        impl->init(noteValue, pitch);
    }

    Note::Note(int midiValue)
        :impl(new NoteImpl) {
        impl->midiValue = midiValue;
        impl->isValid = true;
    }

    Note::Note(std::string name)
        : impl(new NoteImpl) {
        impl->midiValue = -1;
        impl->isValid = false;

        std::string n = name;
        std::string delimiter = "-";

        size_t dashPos = n.find(delimiter);
        int noteValue = NOTE_VALUE_NONE;
        int pitch = -1;

        if (dashPos == std::string::npos) {
            return;
        }

        std::string noteName = n.substr(0, dashPos);
        std::string notePitch = n.substr(dashPos + 1, std::string::npos);
        noteValue = NoteName::noteValueForName(noteName);

        try {
            pitch = std::stoi(notePitch);
        } catch (...) {
            return;
        }

        impl->init(noteValue, pitch);
    }

    Note::Note(const Note& note)
        : impl(new NoteImpl) {
        impl->init(note);
    }

    Note& Note::operator=(const Note& note) {
        impl->init(note);
        return *this;
    }

    Note::~Note() {
    }

    Note::Note(Note&& note) {
        impl = std::move(note.impl);
        note.impl = nullptr;
    }
    
    Note& Note::operator=(Note&& note) {
        if (this != &note) {
            impl = std::move(note.impl);
            note.impl = nullptr;
        }
        return *this;
    }

    bool Note::isValid() const {
        return impl->isValid;
    }

    int Note::getMIDIValue() const {
        return impl->midiValue;
    }

    int Note::getNoteValue() const {
        int value = (impl->midiValue -12) % 12;
        return (int)value;
    }

    int Note::getPitchValue() const {
        if (impl->midiValue >= 0) {
            int value = impl->midiValue / 12;
            return value;
        }
        return -1;
    }
    
    std::string Note::getNoteNamePitch() const {
        std::string name = NoteName::getNoteNameSharp(getNoteValue());
        int pitch = getPitchValue();
        std::string namePitch = name + "-" + std::to_string(pitch);
        return namePitch;
    }
}
