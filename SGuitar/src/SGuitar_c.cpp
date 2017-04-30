#include "SGuitar.hpp"

namespace SG {
    SGGuitarOptions getGuitarOptions() {
        return SGuitar::sharedInstance().getGuitarOptions();
    }

    void setGuitarOptions(SGGuitarOptions options) {
        SGuitar::sharedInstance().setGuitarOptions(options);
    }

    SGScaleOptions getScaleOptions() {
        return SGuitar::sharedInstance().getScaleOptions();
    }

    void setScaleOptions(SGScaleOptions options) {
        SGuitar::sharedInstance().setScaleOptions(options);
    }

    SGChordOptions getChordOptions() {
        return SGuitar::sharedInstance().getChordOptions();
    }

    void setChordOptions(SGChordOptions options) {
        SGuitar::sharedInstance().setChordOptions(options);
    }

    std::vector<int> getScaleNoteValues() {
        return SGuitar::sharedInstance().getScaleNoteValues();
    }

    std::vector<int> getChordNoteValues() {
        return SGuitar::sharedInstance().getChordNoteValues();
    }

    // Guitar Settings
    int getNumberOfStrings() {
        return SGuitar::sharedInstance().getNumberOfStrings();
    }

    int getNumberOfFrets() {
        return SGuitar::sharedInstance().getNumberOfFrets();
    }

    std::vector<int> getNoteValuesForString(int stringNumber) {
        return SGuitar::sharedInstance().getNoteValuesForString(stringNumber);
    }

    void reloadGuitar() {
        SGuitar::sharedInstance().reloadGuitar();
    }

    // Guitar Adjustments
    bool isAdjustmentEnabled(std::string settingID) {
        return SGuitar::sharedInstance().isAdjustmentEnabled(settingID);
    }

    void activateAdjustment(std::string settingID, bool activated) {
        SGuitar::sharedInstance().activateAdjustment(settingID, activated);
    }

    int midiValue(int stringNumber, int fretNumber) {
        return SGuitar::sharedInstance().midiValue(stringNumber, fretNumber);
    }

    // Guitar Canvas
    GUITAR_CANVAS_POSITION positionAtCoordinates(float x, float y) {
        return SGuitar::sharedInstance().positionAtCoordinates(x, y);
    }

    void setSelectedItem(GUITAR_CANVAS_POSITION position) {
        return SGuitar::sharedInstance().setSelectedItem(position);
    }

    void init(float width, float height, float noteWidthHeight, float borderWidth, float scale) {
        SGuitar::sharedInstance().init(width, height, noteWidthHeight, borderWidth, scale);
    }

    float cacluateNoteWidthHeight(float width, float height) {
        return SGuitar::sharedInstance().cacluateNoteWidthHeight(width, height);
    }

    void updateCanvasDimensions(float width, float height, float noteWidthHeight, float scale) {
        SGuitar::sharedInstance().updateCanvasDimensions(width, height, noteWidthHeight, scale);
    }

    void draw() {
        SGuitar::sharedInstance().draw();
    }

    // Scale/Chord Names
    std::vector<std::string>getScaleNames() {
        return SGuitar::sharedInstance().getScaleNames();
    }

    std::vector<std::string>getChordNames() {
        return SGuitar::sharedInstance().getChordNames();
    }

    // Guitars
    std::vector<std::string> getGuitarTypeNames() {
        return SGuitar::sharedInstance().getGuitarTypeNames();
    }

    std::vector<std::string> getGuitarNames(std::string type) {
        return SGuitar::sharedInstance().getGuitarNames(type);
    }

    std::vector<std::string> getCustomGuitarNames() {
        return SGuitar::sharedInstance().getCustomGuitarNames();
    }

    bool removeCustomGuitar(std::string name) {
        return SGuitar::sharedInstance().removeCustomGuitar(name);
    }

    // Note Name for note value
    std::string getNoteNameSharpFlat(int noteValue) {
        return NoteName::getNoteNameSharpFlat(noteValue);
    }

    std::string getPedalTypeName(int index) {
        return GuitarAdjustmentType::getPedalTypeName(index);
    }

    std::string getLeverTypeName(int index) {
        return GuitarAdjustmentType::getLeverTypeName(index);
    }
}
