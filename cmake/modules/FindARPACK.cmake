## ---------------------------------------------------------------------
##
## Copyright (C) 2012 - 2015 by the deal.II authors
##
## This file is part of the deal.II library.
##
## The deal.II library is free software; you can use it, redistribute
## it, and/or modify it under the terms of the GNU Lesser General
## Public License as published by the Free Software Foundation; either
## version 2.1 of the License, or (at your option) any later version.
## The full text of the license can be found in the file LICENSE at
## the top level of the deal.II distribution.
##
## ---------------------------------------------------------------------

#
# Try to find the ARPACK library
#
# This module exports
#
#   ARPACK_LIBRARIES
#   ARPACK_LINKER_FLAGS
#   ARPACK_WITH_PARPACK
#

SET(ARPACK_DIR "" CACHE PATH "An optional hint to an ARPACK installation")
SET_IF_EMPTY(ARPACK_DIR "$ENV{ARPACK_DIR}")

DEAL_II_FIND_LIBRARY(ARPACK_LIBRARY
  NAMES arpack
  HINTS ${ARPACK_DIR}
  PATH_SUFFIXES lib${LIB_SUFFIX} lib64 lib
  )

IF(DEAL_II_WITH_MPI)
  #
  # Sanity check: Only search the parpack library in the same directory as
  # the arpack library...
  #
  GET_FILENAME_COMPONENT(_path "${ARPACK_LIBRARY}" PATH)
  DEAL_II_FIND_LIBRARY(PARPACK_LIBRARY
    NAMES parpack
    HINTS ${_path}
    NO_DEFAULT_PATH
    NO_CMAKE_ENVIRONMENT_PATH
    NO_CMAKE_PATH
    NO_SYSTEM_ENVIRONMENT_PATH
    NO_CMAKE_SYSTEM_PATH
    NO_CMAKE_FIND_ROOT_PATH
    )
ELSE()
  SET(PARPACK_LIBRARY "PARPACK_LIBRARY-NOTFOUND")
ENDIF()

IF(NOT PARPACK_LIBRARY MATCHES "-NOTFOUND")
  SET(ARPACK_WITH_PARPACK TRUE)
ELSE()
  SET(ARPACK_WITH_PARPACK FALSE)
ENDIF()

DEAL_II_PACKAGE_HANDLE(ARPACK
  LIBRARIES
    OPTIONAL PARPACK_LIBRARY
    REQUIRED ARPACK_LIBRARY LAPACK_LIBRARIES
    OPTIONAL MPI_C_LIBRARIES
  LINKER_FLAGS OPTIONAL LAPACK_LINKER_FLAGS
  CLEAR ARPACK_LIBRARY PARPACK_LIBRARY
  )
