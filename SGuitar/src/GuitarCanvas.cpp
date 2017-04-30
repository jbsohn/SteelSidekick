//
//  SGuitarCanvas.cpp
//  SGuitar
//
//  Created by John Sohn on 2/2/16.
//  Copyright © 2016 John Sohn. All rights reserved.
//

#include <string>
#include <vector>

#ifdef __APPLE__
    #include "TargetConditionals.h"
    #if TARGET_OS_IPHONE
        #include <OpenGLES/ES2/glext.h>
        #define NANOVG_GLES2_IMPLEMENTATION
        #define nvgCreateGL     nvgCreateGLES2
        #define nvgDeleteGL     nvgDeleteGLES2
    #else
        #include <OpenGL/gl3.h>
        #define NANOVG_GL3_IMPLEMENTATION
        #define nvgCreateGL     nvgCreateGL3
        #define nvgDeleteGL     nvgDeleteGL3
    #endif
#else
    #ifdef __ANDROID__
        #include <GLES2/gl2.h>
        #define NANOVG_GLES2_IMPLEMENTATION
        #define nvgCreateGL     nvgCreateGLES2
        #define nvgDeleteGL     nvgDeleteGLES2
    #endif
#endif

#include <fstream>
#include "nanovg.h"
#include "nanovg_gl.h"
#include "SG/GuitarString.hpp"
#include "SG/Note.hpp"
#include "SG/FileUtils.hpp"
#include "SG/SGuitar.hpp"
#include "SG/GuitarCanvas.hpp"

#define DEFAULT_NUMBER_OF_STRINGS       12

#define NOTE_C                          "/Images/Note-C.png"
#define NOTE_C_SHARP                    "/Images/Note-C-Sharp.png"
#define NOTE_D_FLAT                     "/Images/Note-D-Flat.png"
#define NOTE_D                          "/Images/Note-D.png"
#define NOTE_D_SHARP                    "/Images/Note-D-Sharp.png"
#define NOTE_E_FLAT                     "/Images/Note-E-Flat.png"
#define NOTE_E                          "/Images/Note-E.png"
#define NOTE_F                          "/Images/Note-F.png"
#define NOTE_F_SHARP                    "/Images/Note-F-Sharp.png"
#define NOTE_G_FLAT                     "/Images/Note-G-Flat.png"
#define NOTE_G                          "/Images/Note-G.png"
#define NOTE_G_SHARP                    "/Images/Note-G-Sharp.png"
#define NOTE_A_FLAT                     "/Images/Note-A-Flat.png"
#define NOTE_A                          "/Images/Note-A.png"
#define NOTE_A_SHARP                    "/Images/Note-A-Sharp.png"
#define NOTE_B_FLAT                     "/Images/Note-B-Flat.png"
#define NOTE_B                          "/Images/Note-B.png"

#define INTERVAL_1                      "/Images/Interval-1.png"
#define INTERVAL_2                      "/Images/Interval-2.png"
#define INTERVAL_3                      "/Images/Interval-3.png"
#define INTERVAL_4                      "/Images/Interval-4.png"
#define INTERVAL_5                      "/Images/Interval-5.png"
#define INTERVAL_6                      "/Images/Interval-6.png"
#define INTERVAL_7                      "/Images/Interval-7.png"

#define NOTE_BACKGROUND                 "/Images/Note-Background.png"
#define NOTE_CHORD_BACKGROUND           "/Images/Note-ChordBackground.png"
#define NOTE_SCALE_BACKGROUND           "/Images/Note-ScaleBackground.png"
#define NOTE_SCALE_CHORD_BACKGROUND     "/Images/Note-ScaleChordBackground.png"
#define NOTE_SELECTED_BACKGROUND        "/Images/Note-SelectedBackground.png"

#define ROLLER_BAR                      "/Images/RollerBar.png"
#define ROLLER                          "/Images/Roller.png"
#define ROLLER_BAR_90                   "/Images/RollerBar-90.png"
#define ROLLER_90                       "/Images/Roller-90.png"

#define STRING_NON_WOUND_4              "/Images/Strong Non-Wound 4.png"
#define STRING_NON_WOUND_3              "/Images/Strong Non-Wound 3.png"
#define STRING_NON_WOUND_2              "/Images/Strong Non-Wound 2.png"
#define STRING_6                        "/Images/String 6.png"
#define STRING_5                        "/Images/String 5.png"
#define STRING_4                        "/Images/String 4.png"

#define STRING_WOUND                    "/Images/StringWound.png"
#define STRING_FLAT                     "/Images/StringFlat.png"

#define STRING_WOUND_90                 "/Images/StringWound-90.png"
#define STRING_FLAT_90                  "/Images/StringFlat-90.png"

#define FRET                            "/Images/Fret.png"
#define FRET_RED                        "/Images/FretRed.png"

#define FRET_NUMBER_3                   "/Images/Fret3.png"
#define FRET_NUMBER_5                   "/Images/Fret5.png"
#define FRET_NUMBER_7                   "/Images/Fret7.png"
#define FRET_NUMBER_9                   "/Images/Fret9.png"
#define FRET_NUMBER_12                  "/Images/Fret12.png"
#define FRET_NUMBER_15                  "/Images/Fret15.png"
#define FRET_NUMBER_17                  "/Images/Fret17.png"
#define FRET_NUMBER_19                  "/Images/Fret19.png"
#define FRET_NUMBER_21                  "/Images/Fret21.png"
#define FRET_NUMBER_23                  "/Images/Fret23.png"

#define FRET_MARKER_BLUE                "/Images/FretMarkerBlue.png"
#define FRET_MARKER_GREEN               "/Images/FretMarkerGreen.png"
#define FRET_MARKER_YELLOW              "/Images/FretMarkerYellow.png"
#define FRET_MARKER_RED                 "/Images/FretMarkerRed.png"

#define ROLLER_WIDTH_HEIGHT             15.0
#define MAX_STRING_HEIGHT               15.0

#define FRET_WIDTH                      3.0

#define DEFAULT_STRING_COUNT            10
#define DEFAULT_FRET_COUNT              26

#define NOTE_SPACING_PERCENT            0.38

namespace SG {
    
    class Canvas {
    protected:
        NVGcontext* context;
        float top;
        float left;
        float width;
        float height;
        float scale;
    public:
        Canvas() {
            context = NULL;
            top = 0.0;
            left = 0.0;
            width = 0.0;
            height = 0.0;
            scale = 1.0;
        }

        void init(float width, float height, float scale) {
            this->top = 0.0;
            this->left = 0.0;
            this->width = width;
            this->height = height;
            this->scale = scale;

            if (context) {
                nvgDeleteGL(context);
            }
            context = nvgCreateGL(NVG_STENCIL_STROKES | NVG_DEBUG);
        }

        void updateCanvasDimensions(float width, float height, float scale) {
            this->width = width;
            this->height = height;
            
            if (height > width) {
                this->width = width;
                this->height = height;
            }
            this->scale = scale;
        }

        float getTop() {
            return top;
        }
        
        float getLeft() {
            return left;
        }
        
        float getWidth() {
            return width;
        }
        
        float getHeight() {
            return height;
        }
        
        float getScale() {
            return scale;
        }
        
        friend class CanvasImage;
        friend class CanvasFrame;
    };

    class CanvasFrame {
    protected:
        Canvas* canvas;
    public:
        CanvasFrame(Canvas* canvas) {
            this->canvas = canvas;
            nvgBeginFrame(canvas->context, canvas->getWidth(), canvas->getHeight(), canvas->getScale());
        }
        
        ~CanvasFrame() {
            nvgEndFrame(canvas->context);
        }
    };

    class CanvasImage {
    protected:
        int image;
        NVGcontext* context;
    public:
        CanvasImage() {
            image = -1;
            context = NULL;
        }

        CanvasImage(Canvas *canvas, std::string pathName) {
            image = -1;
            loadImage(canvas, pathName);
        }

        CanvasImage(const CanvasImage& other) {
            image = other.image;
            context = other.context;
        }
        
        CanvasImage& operator=(const CanvasImage& other) {
            image = other.image;
            context = other.context;
            return *this;
        }
        
        CanvasImage(CanvasImage&& chord) {
            image = chord.image;
            context = chord.context;
            chord.image = -1;
            chord.context = NULL;
        }
        
        CanvasImage& operator=(CanvasImage&& other) {
            if (this != &other) {
                image = other.image;
                context = other.context;
                other.image = -1;
                other.context = nullptr;
            }
            return *this;
        }
    
        ~CanvasImage() {
            
        }
        
        bool loadImage(Canvas* canvas, std::string pathName) {
            context = canvas->context;
            int loadedImage = nvgCreateImage(context, pathName.c_str(), 0);
            if (loadedImage >= 0) {
                image = loadedImage;
                return true;
            }
            return false;
        }
        
        int getImageID() {
            return image;
        }
        
        void drawImage(float x, float y, float width, float height) {
            if (context) {
                NVGpaint paint = nvgImagePattern(context, x, y, width, height, 0.0f/180.0f*NVG_PI, image, 1.0);
                nvgBeginPath(context);
                nvgRect(context, x, y, width, height);
                nvgFillPaint(context, paint);
                nvgStrokeColor(context, nvgRGBf(0.0, 0.0, 0.0));
                nvgFill(context);
            }
        }
    };


    struct GuitarCanvas::GuitarCanvasImpl {
        Canvas canvas;
        float borderWidthHeight;
        float noteWidthHeight;
        float borderWidth;
        int fretCount;
        int stringCount;
        GUITAR_CANVAS_POSITION selectedItem;
        
        // images
        std::vector<CanvasImage> notesSharp;
        std::vector<CanvasImage> notesFlat;
        std::vector<CanvasImage> intervals;
        CanvasImage noteBackground;
        CanvasImage noteChordBackground;
        CanvasImage noteScaleBackground;
        CanvasImage noteScaleChordBackground;
        CanvasImage noteSelectedBackground;
        CanvasImage rollerBar;
        CanvasImage roller;
        CanvasImage rollerBar90;
        CanvasImage roller90;
        CanvasImage stringNonWound4;
        CanvasImage stringNonWound3;
        CanvasImage stringNonWound2;
        CanvasImage string6;
        CanvasImage string5;
        CanvasImage string4;
        CanvasImage stringWound;
        CanvasImage stringFlat;
        CanvasImage stringWound90;
        CanvasImage stringFlat90;
        CanvasImage fret;
        CanvasImage fretRed;
        CanvasImage fretNumber3;
        CanvasImage fretNumber5;
        CanvasImage fretNumber7;
        CanvasImage fretNumber9;
        CanvasImage fretNumber12;
        CanvasImage fretNumber15;
        CanvasImage fretNumber17;
        CanvasImage fretNumber19;
        CanvasImage fretNumber21;
        CanvasImage fretNumber23;
        CanvasImage fretMarkerBlue;
        CanvasImage fretMarkerGreen;
        CanvasImage fretMarkerYellow;
        CanvasImage fretMarkerRed;

        inline float calcStringHeight(int stringNumber) {
            float mult = MAX_STRING_HEIGHT / stringCount;
            return (mult * stringNumber / 4) + 3;
        }
        
        inline float calcLeftAdjustment() {
            return noteWidthHeight + (noteWidthHeight * NOTE_SPACING_PERCENT);
        }
        
        inline float calcTopSpacing(bool isLandscape) {
            float topSpacing = (canvas.getHeight() - (borderWidth * 2)) / stringCount;
            if (!isLandscape) {
                topSpacing = (canvas.getWidth() - (borderWidth * 2)) / stringCount;
            }
            return topSpacing;
        }
        
        inline float calcTop() {
            float top = canvas.getTop() + borderWidth;
            return top;
        }
        
        inline float calcLeft() {
            float left = canvas.getLeft();
            return left;
        }
        
        inline CanvasImage imageForFretMarkerColor(FRET_MARKER_COLOR color) {
            CanvasImage image = fretMarkerRed;
            if (color == FMC_GREEN) {
                image = fretMarkerGreen;
            } else if (color == FMC_BLUE) {
                image = fretMarkerBlue;
            } else if (color == FMC_RED) {
                image = fretMarkerRed;
            } else if (color == FMC_YELLOW) {
                image = fretMarkerYellow;
            }
            return image;
        }
    };

    GuitarCanvas::GuitarCanvas()
        : impl(new GuitarCanvasImpl) {
            impl->fretCount = DEFAULT_FRET_COUNT;
            impl->stringCount = DEFAULT_STRING_COUNT;
    }

    GuitarCanvas::GuitarCanvas(float width, float height, float noteWidthHeight, float borderWidth, float scale)
        : impl(new GuitarCanvasImpl) {
        init(width, height, noteWidthHeight, borderWidth, scale);
    }

    GuitarCanvas::~GuitarCanvas() {
        
    }

    void GuitarCanvas::init(float width, float height, float noteWidthHeight, float borderWidth, float scale) {
        impl->canvas.init(width, height, scale);
        impl->borderWidth = borderWidth;
        impl->fretCount = DEFAULT_FRET_COUNT;
        impl->stringCount = DEFAULT_STRING_COUNT;
        impl->noteWidthHeight = noteWidthHeight;
        
        loadImages();
    }

    void GuitarCanvas::updateCanvasDimensions(float width, float height, float noteWidthHeight, float scale) {
        impl->canvas.updateCanvasDimensions(width, height, scale);
        impl->noteWidthHeight = noteWidthHeight;
    }
    
    void GuitarCanvas::draw(Guitar guitar, GuitarOptions guitarOptions, ScaleOptions scaleOptions, ChordOptions chordOptions,
                            Scale scale, Chord chord) {
        glClearColor(0.08, 0.08, 0.18, 1.0f);
        glClear(GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT|GL_STENCIL_BUFFER_BIT);
        
        CanvasFrame frame(&impl->canvas);
        drawBackground();
        drawRollerBar();
        drawFrets();
        drawFretMarkers();
        drawStrings();
        drawNotes(guitar, guitarOptions, scaleOptions, chordOptions, scale, chord);
    }
    
    void GuitarCanvas::loadImages() {
        std::string pathName = FileUtils::getRootPathForFiles();
        
        impl->notesSharp = std::vector<CanvasImage> {
            CanvasImage(&impl->canvas, pathName + NOTE_C),
            CanvasImage(&impl->canvas, pathName + NOTE_C_SHARP),
            CanvasImage(&impl->canvas, pathName + NOTE_D),
            CanvasImage(&impl->canvas, pathName + NOTE_D_SHARP),
            CanvasImage(&impl->canvas, pathName + NOTE_E),
            CanvasImage(&impl->canvas, pathName + NOTE_F),
            CanvasImage(&impl->canvas, pathName + NOTE_F_SHARP),
            CanvasImage(&impl->canvas, pathName + NOTE_G),
            CanvasImage(&impl->canvas, pathName + NOTE_G_SHARP),
            CanvasImage(&impl->canvas, pathName + NOTE_A),
            CanvasImage(&impl->canvas, pathName + NOTE_A_SHARP),
            CanvasImage(&impl->canvas, pathName + NOTE_B)
        };
        
        impl->notesFlat = std::vector<CanvasImage> {
            CanvasImage(&impl->canvas, pathName + NOTE_C),
            CanvasImage(&impl->canvas, pathName + NOTE_D_FLAT),
            CanvasImage(&impl->canvas, pathName + NOTE_D),
            CanvasImage(&impl->canvas, pathName + NOTE_E_FLAT),
            CanvasImage(&impl->canvas, pathName + NOTE_E),
            CanvasImage(&impl->canvas, pathName + NOTE_F),
            CanvasImage(&impl->canvas, pathName + NOTE_G_FLAT),
            CanvasImage(&impl->canvas, pathName + NOTE_G),
            CanvasImage(&impl->canvas, pathName + NOTE_A_FLAT),
            CanvasImage(&impl->canvas, pathName + NOTE_A),
            CanvasImage(&impl->canvas, pathName + NOTE_B_FLAT),
            CanvasImage(&impl->canvas, pathName + NOTE_B)
        };
        
        impl->intervals = std::vector<CanvasImage> {
            CanvasImage(&impl->canvas, pathName + INTERVAL_1),
            CanvasImage(&impl->canvas, pathName + INTERVAL_2),
            CanvasImage(&impl->canvas, pathName + INTERVAL_3),
            CanvasImage(&impl->canvas, pathName + INTERVAL_4),
            CanvasImage(&impl->canvas, pathName + INTERVAL_5),
            CanvasImage(&impl->canvas, pathName + INTERVAL_6),
            CanvasImage(&impl->canvas, pathName + INTERVAL_7)
        };

        impl->noteBackground = CanvasImage(&impl->canvas, pathName + NOTE_BACKGROUND);
        impl->noteChordBackground = CanvasImage(&impl->canvas, pathName + NOTE_CHORD_BACKGROUND);
        impl->noteScaleBackground = CanvasImage(&impl->canvas, pathName + NOTE_SCALE_BACKGROUND);
        impl->noteScaleChordBackground = CanvasImage(&impl->canvas, pathName + NOTE_SCALE_CHORD_BACKGROUND);
        impl->noteSelectedBackground = CanvasImage(&impl->canvas, pathName + NOTE_SELECTED_BACKGROUND);

        impl->roller = CanvasImage(&impl->canvas, pathName + ROLLER);
        impl->rollerBar = CanvasImage(&impl->canvas, pathName + ROLLER_BAR);

        impl->roller90 = CanvasImage(&impl->canvas, pathName + ROLLER_90);
        impl->rollerBar90 = CanvasImage(&impl->canvas, pathName + ROLLER_BAR_90);
        
        impl->stringNonWound4 = CanvasImage(&impl->canvas, pathName + STRING_NON_WOUND_4);
        impl->stringNonWound3 = CanvasImage(&impl->canvas, pathName + STRING_NON_WOUND_3);
        impl->stringNonWound2 = CanvasImage(&impl->canvas, pathName + STRING_NON_WOUND_2);
        impl->string6 = CanvasImage(&impl->canvas, pathName + STRING_6);
        impl->string5 =CanvasImage(&impl->canvas, pathName + STRING_5);
        impl->string4 = CanvasImage(&impl->canvas, pathName + STRING_4);
        
        impl->stringWound = CanvasImage(&impl->canvas, pathName + STRING_WOUND);
        impl->stringFlat = CanvasImage(&impl->canvas, pathName + STRING_FLAT);
        impl->stringWound90 = CanvasImage(&impl->canvas, pathName + STRING_WOUND_90);
        impl->stringFlat90 = CanvasImage(&impl->canvas, pathName + STRING_FLAT_90);
        
        impl->fret = CanvasImage(&impl->canvas, pathName + FRET);
        impl->fretRed = CanvasImage(&impl->canvas, pathName + FRET_RED);

        impl->fretNumber3 = CanvasImage(&impl->canvas, pathName + FRET_NUMBER_3);
        impl->fretNumber5 = CanvasImage(&impl->canvas, pathName + FRET_NUMBER_5);
        impl->fretNumber7 = CanvasImage(&impl->canvas, pathName + FRET_NUMBER_7);
        impl->fretNumber9 = CanvasImage(&impl->canvas, pathName + FRET_NUMBER_9);
        impl->fretNumber12 = CanvasImage(&impl->canvas, pathName + FRET_NUMBER_12);
        impl->fretNumber15 = CanvasImage(&impl->canvas, pathName + FRET_NUMBER_15);
        impl->fretNumber17 = CanvasImage(&impl->canvas, pathName + FRET_NUMBER_17);
        impl->fretNumber19 = CanvasImage(&impl->canvas, pathName + FRET_NUMBER_19);
        impl->fretNumber21 = CanvasImage(&impl->canvas, pathName + FRET_NUMBER_21);
        impl->fretNumber23 = CanvasImage(&impl->canvas, pathName + FRET_NUMBER_23);
        
        impl->fretMarkerBlue = CanvasImage(&impl->canvas, pathName + FRET_MARKER_BLUE);
        impl->fretMarkerGreen = CanvasImage(&impl->canvas, pathName + FRET_MARKER_GREEN);
        impl->fretMarkerYellow = CanvasImage(&impl->canvas, pathName + FRET_MARKER_YELLOW);
        impl->fretMarkerRed = CanvasImage(&impl->canvas, pathName + FRET_MARKER_RED);
    }
    
    void GuitarCanvas::drawBackground() {
        if (isLandscape()) {
            impl->fret.drawImage(impl->noteWidthHeight * 0.25, impl->canvas.getTop(), impl->canvas.getWidth(), impl->borderWidth); // top horizontal
            impl->fret.drawImage(impl->noteWidthHeight * 0.25, impl->canvas.getHeight() - impl->borderWidth, impl->canvas.getWidth(), impl->canvas.getHeight()); // bottom horizontal
        } else {
            impl->fret.drawImage(impl->canvas.getLeft(), impl->noteWidthHeight * 0.25, impl->borderWidth, impl->canvas.getHeight()); // left vertical
            impl->fret.drawImage(impl->canvas.getWidth() - impl->borderWidth, impl->noteWidthHeight * 0.25, impl->borderWidth, impl->canvas.getHeight()); // right vertical
        }
    }

    void GuitarCanvas::drawRollerBar() {
        CanvasImage image;
        float x;
        float y;
        float width;
        float height;
        
        if (isLandscape()) {
            x = impl->noteWidthHeight * 0.10;
            y = 0.0;
            width = impl->noteWidthHeight * 0.8;
            height = impl->canvas.getHeight();
            image = impl->rollerBar;
        } else {
            x = impl->canvas.getTop();
            y = impl->noteWidthHeight * 0.10;
            height = impl->noteWidthHeight * 0.8;
            width = impl->canvas.getWidth();
            image = impl->rollerBar90;
        }
        
        image.drawImage(x, y, width, height);
    }

    void GuitarCanvas::drawString(int stringNumber, float y, float stringHeight) {
        float left = impl->canvas.getLeft();
        float top = y + (impl->noteWidthHeight * 0.5) - (stringHeight * 0.5);

        if (isLandscape()) {
            impl->stringFlat.drawImage(left, top, impl->canvas.getWidth(), stringHeight);
        } else {
            impl->stringFlat90.drawImage(top, left, stringHeight, impl->canvas.getHeight());
        }
    }
    
    void GuitarCanvas::drawStringRoller(float left, float top, float stringHeight) {
        CanvasImage image;
        float x;
        float y;
        float width;
        float height;
        
        if (isLandscape()) {
            x = left;
            y = top + (impl->noteWidthHeight * 0.5 - ROLLER_WIDTH_HEIGHT * 0.5);
            image = impl->roller;
            width = impl->noteWidthHeight;
            height = ROLLER_WIDTH_HEIGHT;
        } else {
            x = top + (impl->noteWidthHeight * 0.5 - ROLLER_WIDTH_HEIGHT * 0.5);
            y = left;
            image = impl->roller90;
            width = ROLLER_WIDTH_HEIGHT;
            height = impl->noteWidthHeight;
        }
        image.drawImage(x, y, width, height);
    }
    
    void GuitarCanvas::drawStrings() {
        bool landscape = isLandscape();
        float topSpacing = impl->calcTopSpacing(landscape);
        float topAdjust = (topSpacing - impl->noteWidthHeight) / 2;
        float top = impl->calcTop();
        
        for (int s = 1; s <= impl->stringCount; s++) {
            float left = impl->calcLeft();
            float stringHeight = 0.0;
        
            if (landscape) {
                stringHeight = impl->calcStringHeight(s);
            } else {
                int sP = (impl->stringCount + 1) - s;
                stringHeight = impl->calcStringHeight(sP);
            }
    
            drawStringRoller(left, top + topAdjust, stringHeight);
            drawString(s, top + topAdjust, stringHeight);
            top += topSpacing;
        }
    }

    void GuitarCanvas::drawFret(float left, bool red) {
        float x;
        float y;
        float width;
        float height;
    
        if (isLandscape()) {
            x = left;
            y = impl->canvas.getTop();
            width = FRET_WIDTH;
            height = impl->canvas.getHeight();
        } else {
            x = impl->canvas.getLeft();
            y = left;
            width = impl->canvas.getWidth();
            height = FRET_WIDTH;
        }

        CanvasImage image = impl->fret;
        if (red) {
            image = impl->fretRed;
        }
        image.drawImage(x, y, width, height);
    }
    
    void GuitarCanvas::drawFretMarker(int fret, FRET_MARKER_COLOR color) {
        float x;
        float y;
        float width;
        float height;
        float markerLeft;
        CanvasImage image;

        float left = impl->calcLeft();
        float leftAdjustment = impl->calcLeftAdjustment();
        float fretLeft = (leftAdjustment * fret) + (left + (impl->noteWidthHeight /2) - (FRET_WIDTH /2));
        float nextFretLeft = fretLeft + leftAdjustment;
        float fretWidth = nextFretLeft - fretLeft;
        markerLeft = (fretLeft + ((fretWidth * 0.5) - (impl->noteWidthHeight * 0.5))) + (FRET_WIDTH * 0.5);
        
        if (color == FMC_ALL) {
            
            if (isLandscape()) {
                width = impl->noteWidthHeight;
                height = impl->canvas.getHeight() * 0.125;
                x = markerLeft;
                
                float gap = impl->canvas.getHeight() / 4.0;
                y = height * 0.5;
                impl->fretMarkerRed.drawImage(x, y, width, height);
                y += gap;
                impl->fretMarkerGreen.drawImage(x, y, width, height);
                y += gap;
                impl->fretMarkerBlue.drawImage(x, y, width, height);
                y += gap;
                impl->fretMarkerYellow.drawImage(x, y, width, height);
            } else {
                height = impl->noteWidthHeight;
                width = impl->canvas.getWidth() * 0.125;
                y = markerLeft;
                
                float gap = impl->canvas.getWidth() / 4.0;
                x = width * 0.5;
                impl->fretMarkerRed.drawImage(x, y, width, height);
                x += gap;
                impl->fretMarkerGreen.drawImage(x, y, width, height);
                x += gap;
                impl->fretMarkerBlue.drawImage(x, y, width, height);
                x += gap;
                impl->fretMarkerYellow.drawImage(x, y, width, height);
            }
            
        } else {
            image = impl->imageForFretMarkerColor(color);

            if (isLandscape()) {
                width = impl->noteWidthHeight;
                height = impl->canvas.getHeight() * 0.25;
                x = markerLeft;
                y = (impl->canvas.getHeight() * 0.5) - (height * 0.5);
            } else {
                height = impl->noteWidthHeight;
                width = impl->canvas.getWidth() * 0.25;
                y = markerLeft;
                x = (impl->canvas.getWidth() * 0.5) - (width * 0.5);
            }
            
            image.drawImage(x, y, width, height);
        }
    }
    
    
    void GuitarCanvas::drawFretMarkers() {
        drawFretMarker(2, FMC_RED);
        drawFretMarker(4, FMC_GREEN);
        drawFretMarker(6, FMC_BLUE);
        drawFretMarker(8, FMC_YELLOW);
        drawFretMarker(11, FMC_ALL);
        drawFretMarker(14, FMC_RED);
        drawFretMarker(16, FMC_GREEN);
        drawFretMarker(18, FMC_BLUE);
        drawFretMarker(20, FMC_YELLOW);
        drawFretMarker(23, FMC_ALL);
    }
    
    CanvasImage GuitarCanvas::imageForFretNumber(int fretNumber) {
        if (fretNumber == 3) {
            return impl->fretNumber3;
        } else if (fretNumber == 5) {
            return impl->fretNumber5;
        } else if (fretNumber == 7) {
            return impl->fretNumber7;
        } else if (fretNumber == 9) {
            return impl->fretNumber9;
        } else if (fretNumber == 12) {
            return impl->fretNumber12;
        } else if (fretNumber == 15) {
            return impl->fretNumber15;
        } else if (fretNumber == 17) {
            return impl->fretNumber17;
        } else if (fretNumber == 19) {
            return impl->fretNumber19;
        } else if (fretNumber == 21) {
            return impl->fretNumber21;
        } else if (fretNumber == 23) {
            return impl->fretNumber23;
        }
        return CanvasImage();
    }

    void GuitarCanvas::drawFretNumber(int fretNumber, float left) {
        CanvasImage image = imageForFretNumber(fretNumber);
        
        if (isLandscape()) {
            float x = left - (impl->borderWidth * 0.5) + (FRET_WIDTH * 0.5);
            float y1 = impl->canvas.getTop();
            float y2 = impl->canvas.getHeight() - impl->borderWidth;
            float width = impl->borderWidth;
            float height = impl->borderWidth;
            image.drawImage(x, y1, width, height);
            image.drawImage(x, y2, width, height);
        } else {
            float x1 = 0;
            float x2 = impl->canvas.getWidth() - impl->borderWidth;
            float y = left - (impl->borderWidth * 0.5) + (FRET_WIDTH * 0.5);
            float width = impl->borderWidth;
            float height = impl->borderWidth;

            image.drawImage(x1, y, width, height);
            image.drawImage(x2, y, width, height);
        }
    }

    void GuitarCanvas::drawFrets() {
        float left = impl->calcLeft();
        float leftAdjustment = impl->calcLeftAdjustment();
        
        for (int f = 0; f < impl->fretCount; f++) {
            if (f > 0) {
                float fretLeft = left + (impl->noteWidthHeight /2) - (FRET_WIDTH /2);
                bool red = false;
                if (f == 12) {
                    red = true;
                }

                drawFret(fretLeft, red);
                drawFretNumber(f, fretLeft);
                
            }
            left += leftAdjustment;
        }
    }
    
    void GuitarCanvas::drawFretboard() {
        
    }

    
    void GuitarCanvas::drawNote(CanvasImage backgroundImage, int noteValue, float left, float top,
                                ACCIDENTAL_DISPLAY_TYPE type) {
        float x;
        float y;
        
        CanvasImage noteImage;
        if (type == ADT_SHARP) {
            noteImage = impl->notesSharp[noteValue];
        } else {
            noteImage = impl->notesFlat[noteValue];
        }

        if (isLandscape()) {
            x = left;
            y = top;
        } else {
            x = top;
            y = left;
        }

        backgroundImage.drawImage(x, y, impl->noteWidthHeight, impl->noteWidthHeight);
        noteImage.drawImage(x, y, impl->noteWidthHeight, impl->noteWidthHeight);
    }

    void GuitarCanvas::drawInterval(CanvasImage backgroundImage, int interval, float left, float top) {
        float x;
        float y;
        CanvasImage intervalImage = impl->intervals[interval];
        
        if (isLandscape()) {
            x = left;
            y = top;
        } else {
            x = top;
            y = left;
        }
        
        backgroundImage.drawImage(x, y, impl->noteWidthHeight, impl->noteWidthHeight);
        intervalImage.drawImage(x, y, impl->noteWidthHeight, impl->noteWidthHeight);
    }

    void GuitarCanvas::drawNoteAndInterval(CanvasImage backgroundImage, int noteValue, int interval, float left, float top, ACCIDENTAL_DISPLAY_TYPE type) {
        float x;
        float y;

        CanvasImage noteImage;
        if (type == ADT_SHARP) {
            noteImage = impl->notesSharp[noteValue];
        } else {
            noteImage = impl->notesFlat[noteValue];
        }

        CanvasImage intervalImage = impl->intervals[interval];
        
        if (isLandscape()) {
            x = left;
            y = top;
        } else {
            x = top;
            y = left;
        }
        
        backgroundImage.drawImage(x, y, impl->noteWidthHeight, impl->noteWidthHeight);
        intervalImage.drawImage(x + impl->noteWidthHeight * 0.33, y - impl->noteWidthHeight * 0.10, impl->noteWidthHeight * 0.75, impl->noteWidthHeight * 0.75);
        noteImage.drawImage(x - impl->noteWidthHeight * 0.05, y + impl->noteWidthHeight * 0.25, impl->noteWidthHeight * 0.75, impl->noteWidthHeight * 0.75);
    }

    void GuitarCanvas::drawNotes(Guitar guitar, GuitarOptions guitarOptions, ScaleOptions scaleOptions,
                                 ChordOptions chordOptions, Scale scale, Chord chord) {
        bool landscape = isLandscape();
        float topSpacing = impl->calcTopSpacing(landscape);
        float topAdjust = (topSpacing - impl->noteWidthHeight) / 2;
        float top = impl->calcTop();
        float leftAdjustment = impl->calcLeftAdjustment();
        bool showScale = scaleOptions.getShowScale();
        bool showChord = chordOptions.getShowChord();
        bool showAllNotes = guitarOptions.getShowAllNotes();
        ACCIDENTAL_DISPLAY_TYPE showNotesAs = guitarOptions.getShowNotesAs();
        DISPLAY_ITEM_AS_TYPE displayItemsAs = scaleOptions.getDisplayItemsAs();
        
        for (int s = 1; s <= impl->stringCount; s++) {
            float left = impl->calcLeft();
            int stringNumber = s;
            if (!isLandscape()) {
                stringNumber = (impl->stringCount + 1) - s;
            }
            
            GuitarString curString = guitar.getString(s);
            std::vector<int> notes = curString.getNoteValues();
            
            int fretNumber = 0;
            for (Note curNote : notes) {
                bool isScale = scale.isNoteValueInScale(curNote.getNoteValue()) && showScale;
                bool isChord = chord.isNoteValueInChord(curNote.getNoteValue()) && showChord;
                CanvasImage imageBackground;

                if (isScale && isChord) {
                    if (showScale && showChord) {
                        imageBackground = impl->noteScaleChordBackground;
                    }
                } else if (isScale) {
                    if (showScale) {
                        imageBackground = impl->noteScaleBackground;
                    }
                } else if (isChord) {
                    if (showChord) {
                        imageBackground = impl->noteChordBackground;
                    }
                } else {
                    if (showAllNotes) {
                        imageBackground = impl->noteBackground;
                    }
                }

                if (fretNumber == impl->selectedItem.fretNumber &&
                    stringNumber == impl->selectedItem.stringNumber) {
                    imageBackground = impl->noteSelectedBackground;
                }

                if (imageBackground.getImageID() == impl->noteSelectedBackground.getImageID()) {
                    // if select note ALWAYS draw note name
                    drawNote(imageBackground, curNote.getNoteValue(), left, top + topAdjust, showNotesAs);
                } else if (imageBackground.getImageID() != -1) {
                    if (displayItemsAs == DIA_INTERVAL && showScale) {
                        int interval = scale.intervalForNoteValue(curNote.getNoteValue());
                        
                        if (interval >= 0) {
                            if (isScale && isChord && showChord && showScale) {
                                drawNoteAndInterval(imageBackground, curNote.getNoteValue(), interval, left, top + topAdjust,
                                                    showNotesAs);
                            } else {
                                drawInterval(imageBackground, interval, left, top + topAdjust);
                            }
                        } else {
                            drawNote(imageBackground, curNote.getNoteValue(), left, top + topAdjust,
                                     showNotesAs);
                        }
                    } else {
                        drawNote(imageBackground, curNote.getNoteValue(), left, top + topAdjust,
                                 showNotesAs);
                    }
                }
                left += leftAdjustment;
                fretNumber++;
            }
            top += topSpacing;
        }
    }

    GUITAR_CANVAS_POSITION GuitarCanvas::positionAtCoordinates(float x, float y) {
        GUITAR_CANVAS_POSITION position;
        bool landscape = isLandscape();
        const float topSpacing = impl->calcTopSpacing(landscape);
        float top = impl->calcTop();
        float theTop = impl->calcTop();
        const float topAdjust = (topSpacing - impl->noteWidthHeight) / 2;
        
        if (!isLandscape()) {
            float temp = x;
            x = y;
            y = temp;
        }
        // string number = y - top / (topSpacing - topAdjust)
        int stringNumber = (int) trunc((y - (top + topAdjust)) / topSpacing) + 1;
        if (!isLandscape()) {
            stringNumber = (impl->stringCount + 1) - stringNumber;
        }
        
        float stringTopAbove = ((stringNumber -1) * topSpacing) + theTop + topAdjust;
        if (!isLandscape()) {
            int stringPos = (int) trunc((y - (top + topAdjust)) / topSpacing) + 1;
            stringTopAbove = ((stringPos -1) * topSpacing) + theTop + topAdjust;
        }

        if (y >= stringTopAbove && y <= stringTopAbove + impl->noteWidthHeight) {
            position.stringNumber = stringNumber;
        }
        
        float leftAdjustment = impl->calcLeftAdjustment();
        int fretNumber = (int) trunc(x / leftAdjustment);
        float fretPos = fretNumber * leftAdjustment;
        if (x >= fretPos && x <= (fretPos + impl->noteWidthHeight)) {
            position.fretNumber = fretNumber;
        }
        
        return position;
    }

    void GuitarCanvas::setSelectedItem(GUITAR_CANVAS_POSITION position) {
        impl->selectedItem = position;
    }

    float GuitarCanvas::calculateWidth() {
        float width = impl->fretCount * impl->calcLeftAdjustment();
        return width;
    }

    float GuitarCanvas::cacluateNoteWidthHeight(float width, float height) {
        float calcHeight;
        if (height < width) {
            calcHeight = height * 0.95;
        } else {
            calcHeight = width * 0.95;
        }
        
        float noteWidthHeight = (calcHeight - (impl->borderWidth * 2)) / DEFAULT_NUMBER_OF_STRINGS;
        return noteWidthHeight;
    }

    bool GuitarCanvas::isLandscape() {
        if (impl->canvas.getWidth() > impl->canvas.getHeight()) {
            return true;
        }
        return false;
    }
}
