# * Find GL2PS
#
# gl2ps::gl2ps - Imported target to use
# GL2PS_FOUND - True if gl2ps # was found.

find_path(GL2PS_INCLUDE_DIR NAMES gl2ps.h)

find_library(GL2PS_LIBRARY NAMES gl2ps)

set ( _VERSION_FILE ${GL2PS_INCLUDE_DIR}/gl2ps.h )
if ( EXISTS ${_VERSION_FILE} )
  foreach(_ver MAJOR MINOR PATCH EXTRA)
    file ( STRINGS ${_VERSION_FILE} _VERSION_LINE REGEX "define[ ]+GL2PS_${_ver}_VERSION" )
    if ( _VERSION_LINE )
      string ( REGEX REPLACE ".*define[ ]+GL2PS_${_ver}_VERSION[ ]+\"?([^ \"]*)\"?.*" "\\1" GL2PS_${_ver}_VERSION "${_VERSION_LINE}" )
    endif ()
  endforeach()
  set(GL2PS_VERSION_STRING "${GL2PS_MAJOR_VERSION}.${GL2PS_MINOR_VERSION}.${GL2PS_PATCH_VERSION}")
  if(GL2PS_EXTRA_VERSION)
    set(GL2PS_VERSION_STRING "${GL2PS_VERSION_STRING}${GL2PS_EXTRA_VERSION}")
  endif()
endif ()
unset ( _VERSION_FILE )

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args( gl2ps
  FOUND_VAR GL2PS_FOUND
  REQUIRED_VARS
    GL2PS_LIBRARY
    GL2PS_INCLUDE_DIR
  VERSION_VAR
    GL2PS_VERSION_STRING
)

if(GL2PS_FOUND)
  set(GL2PS_INCLUDE_DIRS ${GL2PS_INCLUDE_DIR})
  set(GL2PS_LIBRARIES ${GL2PS_LIBRARY})
  if(NOT TARGET gl2ps::gl2ps)
    add_library(gl2ps::gl2ps UNKNOWN IMPORTED)
    set_target_properties( gl2ps::gl2ps
      PROPERTIES
        IMPORTED_LOCATION "${GL2PS_LIBRARY}"
        INTERFACE_INCLUDE_DIRECTORIES "${GL2PS_INCLUDE_DIR}" 
    )
  endif()
endif()

mark_as_advanced(GL2PS_INCLUDE_DIR GL2PS_LIBRARY)
