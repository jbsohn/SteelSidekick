#!/usr/bin/env bash
rm java/sguitar/*
swig -java -c++ -cppext .cpp -package sguitar -outdir java/sguitar -o SG.cpp swiginclude/SG.i 

