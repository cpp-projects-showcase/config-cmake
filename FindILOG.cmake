#
# Searches ILOG's Cplex libraries.
#
# author : daniperez
#

##############################
## You can use the following variables in you cache/conf file: 
#set ( ILOG_ROOT_DIR   "/opt/ilog" CACHE LOCATION "Ilog's suite prefix" )
#set ( CPLEX_VERSION         "121" CACHE LOCATION "Cplex version"       )
#set ( CONCERT_VERSION        "29" CACHE LOCATION "Concert version"     )
##############################
include(LibFindMacros)

if (NOT ILOG_ROOT_DIR)

  message (FATAL_ERROR "You didn't supply ILOG_ROOT_DIR")

elseif (NOT CPLEX_VERSION)

  message (FATAL_ERROR "You didn't supply CPLEX_VERSION")

elseif (NOT CONCERT_VERSION)

  message (FATAL_ERROR "You didn't supply CONCERT_VERSION")

endif()

##############################################################
##############################################################
###                        FLAGS                           ###
##############################################################
##############################################################
if (WIN32) 
  set ( ILOG_NEEDED_ARCH "x86_win32" CACHE INTERNAL "")
  set ( ILOG_CPLEX_INCLUDE_DIR "${ILOG_ROOT_DIR}/cplex121/include" CACHE STRING "" ) 
  set ( ILOG_CONCERT_INCLUDE_DIR "${ILOG_ROOT_DIR}/concert29/include" CACHE STRING "" ) 
  set ( ILOG_CPLEX_LIBRARY "${ILOG_ROOT_DIR}/cplex121/bin/x86_win32" CACHE STRING "" ) 
  set ( ILOG_ILOCPLEX_LIBRARY "${ILOG_ROOT_DIR}/cplex121/bin/x86_win32" CACHE STRING "" ) 
  set ( ILOG_CONCERT_LIBRARY "${ILOG_ROOT_DIR}/cplex121/bin/x86_win32" CACHE STRING "" ) 
  set ( ILOG_LIBRARIES "${ILOG_CPLEX_LIBRARY}/cplex121.lib;${ILOG_CPLEX_LIBRARY}/cplex121.dll" )
  set ( ILOG_CFLAGS "-I${ILOG_CONCERT_INCLUDE_DIR} -I${ILOG_CPLEX_INCLUDE_DIR} -DIL_STD" CACHE INTERNAL "")
  set ( HAVE_ILOG true CACHE INTERNAL "")
else ()   
  if (EXISTS /usr/lib64)
    set (ARCHI 64 CACHE INTERNAL "" )
    set (FULL_ARCHI x86-64 CACHE INTERNAL "")
  else()
    set (ARCHI 32 CACHE INTERNAL "")
    set (FULL_ARCHI x86 CACHE INTERNAL "")
  endif()

  if ( NOT DEFINED  full_gcc_major_version )
    execute_process( COMMAND "${PROJECT_SOURCE_DIR}/guess_compiler_version.sh" OUTPUT_VARIABLE full_gcc_major_version)
  endif ()

  if (full_gcc_major_version STREQUAL "x3")
    set (ILOG_NEEDED_ARCH "${FULL_ARCHI}_sles9.0_3.3" CACHE INTERNAL "")
  else()
    set (ILOG_NEEDED_ARCH "${FULL_ARCHI}_debian4.0_4.1" CACHE INTERNAL "")
  endif()

  # Include dir (we use previous folders as a hint)
  find_path(ILOG_CPLEX_INCLUDE_DIR
    NAMES ilcplex/cplex.h
    PATHS ${ILOG_PKGCONF_INCLUDE_DIRS} ${ILOG_ROOT_DIR}/cplex${CPLEX_VERSION}/include
  )

  find_path(ILOG_CONCERT_INCLUDE_DIR
    NAMES ilconcert/ilomodel.h
    PATHS ${ILOG_PKGCONF_INCLUDE_DIRS} ${ILOG_ROOT_DIR}/concert${CONCERT_VERSION}/include
  )

  # Libraries 
  find_library(ILOG_CPLEX_LIBRARY
    NAMES "cplex${CPLEX_VERSION}"
    PATHS ${ILOG_PKGCONF_LIBRARY_DIRS} ${ILOG_ROOT_DIR}/cplex${CPLEX_VERSION}/bin/${ILOG_NEEDED_ARCH}
  )

  find_library(ILOG_ILOCPLEX_LIBRARY
    NAMES ilocplex
    PATHS ${ILOG_PKGCONF_LIBRARY_DIRS} ${ILOG_ROOT_DIR}/cplex${CPLEX_VERSION}/lib/${ILOG_NEEDED_ARCH}/static_pic
  )

  find_library(ILOG_CONCERT_LIBRARY
    NAMES concert 
    PATHS ${ILOG_PKGCONF_LIBRARY_DIRS} ${ILOG_ROOT_DIR}/concert${CONCERT_VERSION}/lib/${ILOG_NEEDED_ARCH}/static_pic
  )

  # Set the include dir variables and the libraries and let libfind_process do the rest.
  # NOTE: Singular variables for this library, plural for libraries this this lib depends on.
  set(ILOG_PROCESS_INCLUDES ILOG_CPLEX_INCLUDE_DIR ILOG_CONCERT_INCLUDE_DIR)
  set(ILOG_PROCESS_LIBS ILOG_CPLEX_LIBRARY ILOG_ILOCPLEX_LIBRARY ILOG_CONCERT_LIBRARY)
  libfind_process(ILOG)

  set (ILOG_CFLAGS "${ILOG_CFLAGS} -DIL_STD" CACHE INTERNAL "")
  set (HAVE_ILOG ${ILOG_FOUND} CACHE INTERNAL "")
endif()
