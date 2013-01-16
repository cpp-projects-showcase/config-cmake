# Find Valgrind.
#
# author : mboudia
#
# This module defines VALGRIND which
# adds a target generating the xml file resulting from valgrind check


if ( NOT CMAKE_CROSSCOMPILING )

  find_program ( VALGRIND valgrind )

endif ()

mark_as_advanced ( VALGRIND )