/* ----------------------------------------------------------------------------
 * This file was automatically generated by SWIG (http://www.swig.org).
 * Version 3.0.12
 *
 * Do not make changes to this file unless you know what you are doing--modify
 * the SWIG interface file instead.
 * ----------------------------------------------------------------------------- */

package com.steelsidekick.sguitar;

public enum ACCIDENTAL_DISPLAY_TYPE {
  ADT_SHARP,
  ADT_FLAT;

  public final int swigValue() {
    return swigValue;
  }

  public static ACCIDENTAL_DISPLAY_TYPE swigToEnum(int swigValue) {
    ACCIDENTAL_DISPLAY_TYPE[] swigValues = ACCIDENTAL_DISPLAY_TYPE.class.getEnumConstants();
    if (swigValue < swigValues.length && swigValue >= 0 && swigValues[swigValue].swigValue == swigValue)
      return swigValues[swigValue];
    for (ACCIDENTAL_DISPLAY_TYPE swigEnum : swigValues)
      if (swigEnum.swigValue == swigValue)
        return swigEnum;
    throw new IllegalArgumentException("No enum " + ACCIDENTAL_DISPLAY_TYPE.class + " with value " + swigValue);
  }

  @SuppressWarnings("unused")
  private ACCIDENTAL_DISPLAY_TYPE() {
    this.swigValue = SwigNext.next++;
  }

  @SuppressWarnings("unused")
  private ACCIDENTAL_DISPLAY_TYPE(int swigValue) {
    this.swigValue = swigValue;
    SwigNext.next = swigValue+1;
  }

  @SuppressWarnings("unused")
  private ACCIDENTAL_DISPLAY_TYPE(ACCIDENTAL_DISPLAY_TYPE swigEnum) {
    this.swigValue = swigEnum.swigValue;
    SwigNext.next = this.swigValue+1;
  }

  private final int swigValue;

  private static class SwigNext {
    private static int next = 0;
  }
}

