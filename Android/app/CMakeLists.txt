# Sets the minimum version of CMake required to build the native
# library. You should either keep the default value or only pass a
# value of 3.4.0 or lower.

cmake_minimum_required(VERSION 3.4.1)

# Creates and names a library, sets it as either STATIC
# or SHARED, and provides the relative paths to its source code.
# You can define multiple libraries, and CMake builds it for you.
# Gradle automatically packages shared libraries with your APK.

add_library( # Sets the name of the library.
             sguitar

             # Sets the library as a shared library.
             SHARED


             # Provides a relative path to your source file(s).
             # Associated headers in the same location as their source
             # file are automatically included.
             src/main/cpp/sguitar.cpp
            ../../SGuitar/src/Chord.cpp
            ../../SGuitar/src/GuitarString.cpp
            ../../SGuitar/src/ChordOptions.cpp
            ../../SGuitar/src/GuitarType.cpp
            ../../SGuitar/src/ChordType.cpp
            ../../SGuitar/src/GuitarTypes.cpp
            ../../SGuitar/src/Chords.cpp
            ../../SGuitar/src/Guitars.cpp
            ../../SGuitar/src/FileUtils.cpp
            ../../SGuitar/src/FileUtils_Android.cpp
            ../../SGuitar/src/Note.cpp
            ../../SGuitar/src/OptionTypes.cpp
            ../../SGuitar/src/SGuitar.cpp
            ../../SGuitar/src/Guitar.cpp
            ../../SGuitar/src/Scale.cpp
            ../../SGuitar/src/GuitarAdjustment.cpp
            ../../SGuitar/src/ScaleOptions.cpp
            ../../SGuitar/src/GuitarCanvas.cpp
            ../../SGuitar/src/ScaleType.cpp
            ../../SGuitar/src/Scales.cpp
            ../../SGuitar/src/GuitarOptions.cpp
            ../../SGuitar/src/StringAdjustment.cpp
            ../../SGuitar/src/NoteName.cpp
            ../../SGuitar/src/GuitarAdjustmentType.cpp
            ../../SGuitar/swig/cpp/SG.cpp
            ../../SGuitar/External/JsonBox/src/Convert.cpp
            ../../SGuitar/External/JsonBox/src/Escaper.cpp
            ../../SGuitar/External/JsonBox/src/IndentCanceller.cpp
            ../../SGuitar/External/JsonBox/src/Indenter.cpp
            ../../SGuitar/External/JsonBox/src/JsonParsingError.cpp
            ../../SGuitar/External/JsonBox/src/JsonWritingError.cpp
            ../../SGuitar/External/JsonBox/src/SolidusEscaper.cpp
            ../../SGuitar/External/JsonBox/src/Value.cpp
            ../../SGuitar/External/nanovg/nanovg.c
            )

include_directories(
            ../../SGuitar/include
            ../../SGuitar/External/JsonBox/include
            ../../SGuitar/External/JsonBox
            ../../SGuitar/External/nanovg
            ../../SGuitar/External/STK/include
            )

# Searches for a specified prebuilt library and stores the path as a
# variable. Because system libraries are included in the search path by
# default, you only need to specify the name of the public NDK library
# you want to add. CMake verifies that the library exists before
# completing its build.

find_library(
              GLESv2
              atomic
              android
              log )

# Specifies libraries CMake should link to your target library. You
# can link multiple libraries, such as libraries you define in the
# build script, prebuilt third-party libraries, or system libraries.

target_link_libraries( # Specifies the target library.
                       sguitar

              GLESv2
              atomic
              android
              log

                       # Links the target library to the log library
                       # included in the NDK.
                       ${log-lib} )
