# * Find GL2PS
#
# gl2ps::gl2ps - Imported target to use
# GL2PS_FOUND - True if gl2ps # was found.

find_path(GL2PS_INCLUDE_DIR NAMES gl2ps.h)

find_library(GL2PS_LIBRARY NAMES gl2ps)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args( gl2ps
  FOUND_VAR GL2PS_FOUND
  REQUIRED_VARS
    GL2PS_LIBRARY
    GL2PS_INCLUDE_DIR
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
