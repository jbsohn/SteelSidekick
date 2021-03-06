/* ----------------------------------------------------------------------------
 * This file was automatically generated by SWIG (http://www.swig.org).
 * Version 3.0.10
 *
 * Do not make changes to this file unless you know what you are doing--modify
 * the SWIG interface file instead.
 * ----------------------------------------------------------------------------- */

package com.steelsidekick.sguitar;

public class SGuitar {
  private transient long swigCPtr;
  protected transient boolean swigCMemOwn;

  protected SGuitar(long cPtr, boolean cMemoryOwn) {
    swigCMemOwn = cMemoryOwn;
    swigCPtr = cPtr;
  }

  protected static long getCPtr(SGuitar obj) {
    return (obj == null) ? 0 : obj.swigCPtr;
  }

  public synchronized void delete() {
    if (swigCPtr != 0) {
      if (swigCMemOwn) {
        swigCMemOwn = false;
        throw new UnsupportedOperationException("C++ destructor does not have public access");
      }
      swigCPtr = 0;
    }
  }

  public static SGuitar sharedInstance() {
    return new SGuitar(SGJNI.SGuitar_sharedInstance(), false);
  }

  public static void setSystemAndUserPaths(String systemPath, String userPath) {
    SGJNI.SGuitar_setSystemAndUserPaths(systemPath, userPath);
  }

  public SGGuitarOptions getGuitarOptions() {
    return new SGGuitarOptions(SGJNI.SGuitar_getGuitarOptions(swigCPtr, this), true);
  }

  public void setGuitarOptions(SGGuitarOptions options) {
    SGJNI.SGuitar_setGuitarOptions(swigCPtr, this, SGGuitarOptions.getCPtr(options), options);
  }

  public SGScaleOptions getScaleOptions() {
    return new SGScaleOptions(SGJNI.SGuitar_getScaleOptions(swigCPtr, this), true);
  }

  public void setScaleOptions(SGScaleOptions options) {
    SGJNI.SGuitar_setScaleOptions(swigCPtr, this, SGScaleOptions.getCPtr(options), options);
  }

  public SGChordOptions getChordOptions() {
    return new SGChordOptions(SGJNI.SGuitar_getChordOptions(swigCPtr, this), true);
  }

  public void setChordOptions(SGChordOptions options) {
    SGJNI.SGuitar_setChordOptions(swigCPtr, this, SGChordOptions.getCPtr(options), options);
  }

  public IntVector getScaleNoteValues() {
    return new IntVector(SGJNI.SGuitar_getScaleNoteValues(swigCPtr, this), true);
  }

  public IntVector getChordNoteValues() {
    return new IntVector(SGJNI.SGuitar_getChordNoteValues(swigCPtr, this), true);
  }

  public boolean isNoteValueInScale(int noteValue) {
    return SGJNI.SGuitar_isNoteValueInScale(swigCPtr, this, noteValue);
  }

  public boolean isNoteValueInChord(int noteValue) {
    return SGJNI.SGuitar_isNoteValueInChord(swigCPtr, this, noteValue);
  }

  public int getNumberOfStrings() {
    return SGJNI.SGuitar_getNumberOfStrings(swigCPtr, this);
  }

  public int getNumberOfFrets() {
    return SGJNI.SGuitar_getNumberOfFrets(swigCPtr, this);
  }

  public IntVector getNoteValuesForString(int stringNumber) {
    return new IntVector(SGJNI.SGuitar_getNoteValuesForString(swigCPtr, this, stringNumber), true);
  }

  public void reloadGuitar() {
    SGJNI.SGuitar_reloadGuitar(swigCPtr, this);
  }

  public boolean isAdjustmentEnabled(String settingID) {
    return SGJNI.SGuitar_isAdjustmentEnabled(swigCPtr, this, settingID);
  }

  public void activateAdjustment(String settingID, boolean activated) {
    SGJNI.SGuitar_activateAdjustment(swigCPtr, this, settingID, activated);
  }

  public int midiValue(int stringNumber, int fretNumber) {
    return SGJNI.SGuitar_midiValue(swigCPtr, this, stringNumber, fretNumber);
  }

  public GUITAR_CANVAS_POSITION positionAtCoordinates(float x, float y) {
    return new GUITAR_CANVAS_POSITION(SGJNI.SGuitar_positionAtCoordinates(swigCPtr, this, x, y), true);
  }

  public void setSelectedItem(GUITAR_CANVAS_POSITION position) {
    SGJNI.SGuitar_setSelectedItem(swigCPtr, this, GUITAR_CANVAS_POSITION.getCPtr(position), position);
  }

  public void init(float width, float height, float noteWidthHeight, float borderWidth, float scale, float leftSafeArea) {
    SGJNI.SGuitar_init(swigCPtr, this, width, height, noteWidthHeight, borderWidth, scale, leftSafeArea);
  }

  public float cacluateNoteWidthHeight(float width, float height) {
    return SGJNI.SGuitar_cacluateNoteWidthHeight(swigCPtr, this, width, height);
  }

  public void updateCanvasDimensions(float width, float height, float noteWidthHeight, float scale, float leftSafeArea) {
    SGJNI.SGuitar_updateCanvasDimensions(swigCPtr, this, width, height, noteWidthHeight, scale, leftSafeArea);
  }

  public void draw() {
    SGJNI.SGuitar_draw(swigCPtr, this);
  }

  public StdStringVector getScaleNames() {
    return new StdStringVector(SGJNI.SGuitar_getScaleNames(swigCPtr, this), true);
  }

  public StdStringVector getChordNames() {
    return new StdStringVector(SGJNI.SGuitar_getChordNames(swigCPtr, this), true);
  }

  public StdStringVector getGuitarTypeNames() {
    return new StdStringVector(SGJNI.SGuitar_getGuitarTypeNames(swigCPtr, this), true);
  }

  public StdStringVector getGuitarNames(String type) {
    return new StdStringVector(SGJNI.SGuitar_getGuitarNames(swigCPtr, this, type), true);
  }

  public StdStringVector getCustomGuitarNames() {
    return new StdStringVector(SGJNI.SGuitar_getCustomGuitarNames(swigCPtr, this), true);
  }

  public boolean removeCustomGuitar(String name) {
    return SGJNI.SGuitar_removeCustomGuitar(swigCPtr, this, name);
  }

  public static String getNoteNameSharpFlat(int noteValue) {
    return SGJNI.SGuitar_getNoteNameSharpFlat(noteValue);
  }

  public static String getPedalTypeName(int index) {
    return SGJNI.SGuitar_getPedalTypeName(index);
  }

  public static String getLeverTypeName(int index) {
    return SGJNI.SGuitar_getLeverTypeName(index);
  }

  public String getDescription() {
    return SGJNI.SGuitar_getDescription(swigCPtr, this);
  }

}
