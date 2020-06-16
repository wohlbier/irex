#!/bin/bash
dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"/../

#CXXFLAGS=
TA_LIB="/home/jgwohlbier/DSSoC/DASH/TraceAtlas/build/lib"

cmake \
  -DCMAKE_BUILD_TYPE=RelWithDebInfo \
  -DCMAKE_CXX_FLAGS=${CXXFLAGS} \
  -DTA_LIB:STRING=${TA_LIB} \
  $dir
