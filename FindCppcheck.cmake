#
# Searches Cppcheck library. 
#
# Defines CPPCHECK which
# adds a target generating the xml file resulting from cppcheck
#
# author : mboudia
#

if ( NOT CMAKE_CROSSCOMPILING )

  find_program ( CPPCHECK cppcheck )

endif ()

mark_as_advanced ( CPPCHECK )
