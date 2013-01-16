#
# Some handy targets for cygwin.
#
# author : daniperez
#

# Adds a makefile target called exe_${NAME} which executes ${EXECUTABLE}
# within gdb and with the environment correctly set (i.e. path, library path).
#
function ( add_cygwin_debug_target NAME EXECUTABLE LD_LIBRARY_PATH)
    if ( CYGWIN )
        add_custom_target ( ${NAME}
            "/cygdrive/c/cygwin/bin/bash.exe"
            "-c"
            "\""
            "PATH=$ENV{PATH}:${LD_LIBRARY_PATH}"
            "gdb"
            "${EXECUTABLE}"
            "\""
            DEPENDS ${EXECUTABLE}
        )
    endif()
endfunction ()
