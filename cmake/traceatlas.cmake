# Set up AtlasPasses and tracer.
FUNCTION (INJECTTRACER tgt)
  SET (TA_LIB "/usr/lib" CACHE STRING "Path to AtlasPasses.so")
  LINK_DIRECTORIES (${TA_LIB})
  ADD_LIBRARY (AtlasPasses SHARED IMPORTED)
  SET_PROPERTY (TARGET AtlasPasses
    PROPERTY IMPORTED_LOCATION ${TA_LIB}/AtlasPasses.so)
  TARGET_COMPILE_OPTIONS (${tgt} PRIVATE "-flto")
  SET_TARGET_PROPERTIES (${tgt} PROPERTIES
    LINK_FLAGS "-fuse-ld=lld -Wl,--plugin-opt=emit-llvm -Wl,--plugin-opt=save-temps")
  ADD_CUSTOM_COMMAND (OUTPUT opt.bc
    COMMAND ${LLVM_INSTALL_PREFIX}/bin/opt
    -load $<TARGET_FILE:AtlasPasses>
    -EncodedTrace $<TARGET_FILE:${tgt}> -o opt.bc
    DEPENDS $<TARGET_FILE:${tgt}>
    )
  SET_SOURCE_FILES_PROPERTIES (
    opt.bc
    PROPERTIES
    EXTERNAL_OBJECT true
    GENERATED true
    )
  ADD_EXECUTABLE (${tgt}-trace opt.bc)
  SET_TARGET_PROPERTIES (${tgt}-trace PROPERTIES LINKER_LANGUAGE CXX)
  TARGET_LINK_LIBRARIES (${tgt}-trace PRIVATE AtlasBackend z)
ENDFUNCTION()
