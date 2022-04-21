cmake_minimum_required(VERSION 3.16)

project( QwtPlot3D
  VERSION 0.3.0
  LANGUAGES CXX
  )

if(CMAKE_VERSION VERSION_LESS "3.21" AND "${CMAKE_SOURCE_DIR}" STREQUAL "${PROJECT_SOURCE_DIR}")
  set(PROJECT_IS_TOP_LEVEL TRUE)
endif()

set( CMAKE_MODULE_PATH "$CMAKE_MODULE_PATH" "${CMAKE_CURRENT_SOURCE_DIR}/cmake" )

set( CMAKE_CXX_STANDARD 17 )
set( CMAKE_CXX_STANDARD_REQUIRED TRUE )
set( CMAKE_CXX_EXTENSIONS OFF )

set( CMAKE_AUTOUIC OFF )
set( CMAKE_AUTORCC OFF )
set( CMAKE_AUTOMOC ON )

if( MSVC )
  # /wd4458 Silent "declaration of %1 hides %2 ..."
  set( CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /EHsc /W4 /permissive- /wd4458" )
  if( CMAKE_CXX_COMPILER_ID STREQUAL "Clang" )
    set( CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wno-nonportable-include-path" )
    add_compile_definitions( _CRT_SECURE_NO_WARNINGS )
  else()
    add_compile_options( "/MP" )
  endif()
else()
  set( CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fexceptions -Wall -Wextra -pedantic" )
  set( CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wall -Wextra -pedantic" )
endif()

if( APPLE )
  add_compile_definitions( GL_SILENCE_DEPRECATION )
endif()

if( NOT QT_VERSION_MAJOR AND NOT Qt6_FOUND AND NOT Qt5_FOUND )
  find_package( Qt6 COMPONENTS Core QUIET )
  if( Qt6_FOUND  )
    set( QT_VERSION_MAJOR 6 )
  else()
    find_package( Qt5 COMPONENTS Core REQUIRED )
    set( QT_VERSION_MAJOR 5 )
  endif()
elseif( Qt6_FOUND )
  set( QT_VERSION_MAJOR 6 )
elseif( Qt5_FOUND )
  set( QT_VERSION_MAJOR 5 )
endif()

if( QT_VERSION_MAJOR VERSION_EQUAL 6 )
  find_package( Qt6 COMPONENTS Gui OpenGLWidgets REQUIRED )
else()
  find_package( Qt5 COMPONENTS Gui OpenGL REQUIRED )
endif()

find_package( OpenGL COMPONENTS OpenGL REQUIRED )

find_package( gl2ps )

set( SRCS
  "src/qwt3d_axis.cpp"
  "src/qwt3d_color.cpp"
  "src/qwt3d_coordsys.cpp"
  "src/qwt3d_drawable.cpp"
  "src/qwt3d_mousekeyboard.cpp"
  "src/qwt3d_movements.cpp"
  "src/qwt3d_lighting.cpp"
  "src/qwt3d_colorlegend.cpp"
  "src/qwt3d_plot.cpp"
  "src/qwt3d_label.cpp"
  "src/qwt3d_types.cpp"
  "src/qwt3d_enrichment_std.cpp"
  "src/qwt3d_autoscaler.cpp"
  "src/qwt3d_io_reader.cpp"
  "src/qwt3d_io.cpp"
  "src/qwt3d_scale.cpp"
  "src/qwt3d_gridmapping.cpp"
  "src/qwt3d_parametricsurface.cpp"
  "src/qwt3d_function.cpp"
  "src/qwt3d_surfaceplot.cpp"
  "src/qwt3d_gridplot.cpp"
  "src/qwt3d_meshplot.cpp"
  "src/qwt3d_io_gl2ps.cpp"
)

set( HEADERS
  "include/qwt3d_color.h"
  "include/qwt3d_global.h"
  "include/qwt3d_types.h"
  "include/qwt3d_axis.h"
  "include/qwt3d_coordsys.h"
  "include/qwt3d_drawable.h"
  "include/qwt3d_helper.h"
  "include/qwt3d_label.h"
  "include/qwt3d_openglhelper.h"
  "include/qwt3d_colorlegend.h"
  "include/qwt3d_plot.h"
  "include/qwt3d_enrichment.h"
  "include/qwt3d_enrichment_std.h"
  "include/qwt3d_autoscaler.h"
  "include/qwt3d_autoptr.h"
  "include/qwt3d_io.h"
  "include/qwt3d_io_reader.h"
  "include/qwt3d_scale.h"
  "include/qwt3d_portability.h"
  "include/qwt3d_mapping.h"
  "include/qwt3d_gridmapping.h"
  "include/qwt3d_parametricsurface.h"
  "include/qwt3d_function.h"
  "include/qwt3d_surfaceplot.h"
  "include/qwt3d_volumeplot.h"
  "include/qwt3d_graphplot.h"
  "include/qwt3d_multiplot.h"
  "include/qwt3d_io_gl2ps.h"
)
configure_file( "include/qwt3d_version.h.in" "qwt3d_version.h" @ONLY )

add_library( qwtplot3d ${SRCS} ${HEADERS} )

target_link_libraries( qwtplot3d PUBLIC
  Qt${QT_VERSION_MAJOR}::Core
  Qt${QT_VERSION_MAJOR}::Gui
  OpenGL::GLU
  )

if( QT_VERSION_MAJOR VERSION_GREATER_EQUAL 6 )
  target_link_libraries( qwtplot3d PUBLIC Qt${QT_VERSION_MAJOR}::OpenGLWidgets )
else()
  target_link_libraries( qwtplot3d PUBLIC Qt${QT_VERSION_MAJOR}::OpenGL )
endif()

target_include_directories( qwtplot3d PUBLIC include ${CMAKE_CURRENT_BINARY_DIR} )

if( GL2PS_FOUND )
  target_link_libraries( qwtplot3d PUBLIC gl2ps::gl2ps )
else()
  enable_language( C )
  target_sources( qwtplot3d PRIVATE "3rdparty/gl2ps/gl2ps.c" "3rdparty/gl2ps/gl2ps.h" )
  target_include_directories( qwtplot3d PRIVATE "3rdparty/gl2ps" )
endif()

if( BUILD_SHARED_LIBS )
  # DLL export/import
  if( WIN32 )
    target_compile_definitions( qwtplot3d
      PUBLIC QWT3D_DLL
      PRIVATE QWT3D_MAKEDLL
    )
  endif()
  # Install
  install( TARGETS qwtplot3d
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
  )
endif()

# Don't install qwtplot3d static library and headers if it is built as a subproject
if( PROJECT_IS_TOP_LEVEL )
  add_subdirectory( examples )
  if( BUILD_SHARED_LIBS )
    # Library version
    set_target_properties( qwtplot3d PROPERTIES
      VERSION ${PROJECT_VERSION}
      SOVERSION ${PROJECT_VERSION_MAJOR}
    )
  endif()
  install( TARGETS qwtplot3d
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
    PUBLIC_HEADER DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/qwtplot3d
  )
endif()
