//
//  GuitarCanvas.h
//  SGuitar
//
//  Created by John Sohn on 2/2/16.
//  Copyright © 2016 John Sohn. All rights reserved.
//

#ifndef __GuitarCanvas_h__
#define __GuitarCanvas_h__

#include "SG/Guitar.hpp"
#include "SG/GuitarOptions.hpp"
#include "SG/ScaleOptions.hpp"
#include "SG/ChordOptions.hpp"
#include "SG/Scale.hpp"
#include "SG/Chord.hpp"

typedef enum {
    FMC_ALL,
    FMC_GREEN,
    FMC_RED,
    FMC_BLUE,
    FMC_YELLOW
} FRET_MARKER_COLOR;

typedef struct {
    int stringNumber;
    int fretNumber;
} GUITAR_CANVAS_POSITION;

#ifdef __cplusplus
#include <vector>

namespace SG {
    class Canvas;
    class CanvasImage;
    class SGuitar;
    
    //
    // responsible for drawing the guitar fretboard
    //
    class GuitarCanvas {
    public:
        GuitarCanvas();
        GuitarCanvas(float width, float height, float noteWidthHeight, float borderWidth, float scale);
        ~GuitarCanvas();
        
        void init(float width, float height, float noteWidthHeight, float borderWidth, float scale);
        
        float calculateWidth();
        float cacluateNoteWidthHeight(float width, float height);
        bool isLandscape();
        
        void updateCanvasDimensions(float width, float height, float noteWidthHeight, float scale);
        void draw(Guitar guitar, GuitarOptions guitarOptions, ScaleOptions scaleOptions, ChordOptions chordOptions,
                  Scale scale, Chord chord);

        GUITAR_CANVAS_POSITION positionAtCoordinates(float x, float y);
        void setSelectedItem(GUITAR_CANVAS_POSITION position);

    protected:
        void loadImages();
        void drawBackground();
        void drawStringRoller(float left, float top, float stringHeight);
        void drawRollerBar();
        void drawString(int stringNumber, float top, float stringHeight);
        void drawStrings();
        void drawFretMarker(int fret, FRET_MARKER_COLOR color);
        void drawFretMarkers();
        void drawFret(float left, bool red);
        void drawFretNumber(int fretNumber, float left);
        void drawFrets();
        void drawFretboard();
        void drawNote(CanvasImage backgroundImage, int noteValue, float left, float top,
                      ACCIDENTAL_DISPLAY_TYPE type);
        void drawInterval(CanvasImage backgroundImage, int interval, float left, float top);
        void drawNoteAndInterval(CanvasImage backgroundImage, int noteValue, int interval, float left, float top, ACCIDENTAL_DISPLAY_TYPE type);
        void drawNotes(Guitar guitar, GuitarOptions guitarOptions, ScaleOptions scaleOptions,
                       ChordOptions chordOptions, Scale scale, Chord chord);
        void createNotes();

        CanvasImage imageForFretNumber(int fretNumber);
        
        void highlightNote(int backgroundImage, int noteValue, float left, float top);

    private:
        struct GuitarCanvasImpl;
        std::unique_ptr<GuitarCanvasImpl> impl;
    };
}
#endif

#endif
