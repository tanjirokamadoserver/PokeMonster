# Findfmt.cmake

find_path(FMT_INCLUDE_DIRS "fmt/format.h")

find_library(FMT_LIBRARIES NAMES fmt)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(fmt REQUIRED_VARS FMT_LIBRARIES FMT_INCLUDE_DIRS)

if(FMT_FOUND)
  set(FMT_LIBRARIES fmt)
  set(FMT_INCLUDE_DIRS ${FMT_INCLUDE_DIRS})
  set(fmt_FOUND ${FMT_FOUND})
endif()
