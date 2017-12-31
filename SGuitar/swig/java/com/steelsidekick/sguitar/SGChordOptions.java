/* ----------------------------------------------------------------------------
 * This file was automatically generated by SWIG (http://www.swig.org).
 * Version 3.0.12
 *
 * Do not make changes to this file unless you know what you are doing--modify
 * the SWIG interface file instead.
 * ----------------------------------------------------------------------------- */

package com.steelsidekick.sguitar;

public class SGChordOptions {
  private transient long swigCPtr;
  protected transient boolean swigCMemOwn;

  protected SGChordOptions(long cPtr, boolean cMemoryOwn) {
    swigCMemOwn = cMemoryOwn;
    swigCPtr = cPtr;
  }

  protected static long getCPtr(SGChordOptions obj) {
    return (obj == null) ? 0 : obj.swigCPtr;
  }

  protected void finalize() {
    delete();
  }

  public synchronized void delete() {
    if (swigCPtr != 0) {
      if (swigCMemOwn) {
        swigCMemOwn = false;
        SGJNI.delete_SGChordOptions(swigCPtr);
      }
      swigCPtr = 0;
    }
  }

  public void setShowChord(boolean value) {
    SGJNI.SGChordOptions_showChord_set(swigCPtr, this, value);
  }

  public boolean getShowChord() {
    return SGJNI.SGChordOptions_showChord_get(swigCPtr, this);
  }

  public void setChordName(String value) {
    SGJNI.SGChordOptions_chordName_set(swigCPtr, this, value);
  }

  public String getChordName() {
    return SGJNI.SGChordOptions_chordName_get(swigCPtr, this);
  }

  public void setChordRootNoteValue(int value) {
    SGJNI.SGChordOptions_chordRootNoteValue_set(swigCPtr, this, value);
  }

  public int getChordRootNoteValue() {
    return SGJNI.SGChordOptions_chordRootNoteValue_get(swigCPtr, this);
  }

  public void setDisplayItemsAs(DISPLAY_ITEM_AS_TYPE value) {
    SGJNI.SGChordOptions_displayItemsAs_set(swigCPtr, this, value.swigValue());
  }

  public DISPLAY_ITEM_AS_TYPE getDisplayItemsAs() {
    return DISPLAY_ITEM_AS_TYPE.swigToEnum(SGJNI.SGChordOptions_displayItemsAs_get(swigCPtr, this));
  }

  public SGChordOptions() {
    this(SGJNI.new_SGChordOptions(), true);
  }

}
