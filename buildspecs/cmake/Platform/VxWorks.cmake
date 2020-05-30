set(VXWORKS 1)
set(PYTHON_SOABI cpython-38-vxworks)
# Maximize build community package without changing for they
# often check UNIX to determine the platform, VxWorks should
# be compatible in many respects. If it's proper for VxWorks,
# then add extra VXWORKS check for VxWorks

set(UNIX 1)

# GCC/CLANG build options.
set(CMAKE_SHARED_LIBRARY_C_FLAGS "-fPIC")
set(CMAKE_SHARED_LIBRARY_CREATE_C_FLAGS "-shared")
set(CMAKE_SHARED_LIBRARY_RUNTIME_C_FLAG "-Wl,-rpath,")
set(CMAKE_SHARED_LIBRARY_RUNTIME_C_FLAG_SEP ":")
set(CMAKE_SHARED_LIBRARY_RPATH_LINK_C_FLAG "-Wl,-rpath-link,")
set(CMAKE_SHARED_LIBRARY_SONAME_C_FLAG "-Wl,-soname,")
set(CMAKE_EXE_EXPORTS_C_FLAG "-Wl,--export-dynamic")

foreach(type SHARED_LIBRARY SHARED_MODULE EXE)
    set(CMAKE_${type}_LINK_STATIC_C_FLAGS "-Wl,-Bstatic")
    set(CMAKE_${type}_LINK_DYNAMIC_C_FLAGS "-Wl,-Bdynamic")
endforeach()

# set VxWorks root
set(CMAKE_SYSTEM_PREFIX_PATH ${__VXWORKS_PREFIX_PATH__})

# set VxWorks header path
set(CMAKE_SYSTEM_INCLUDE_PATH ${__VXWORKS_INCLUDE_PATH__})

# set VxWorks library path
set(CMAKE_SYSTEM_LIBRARY_PATH ${__VXWORKS_LIBRARY_PATH__})

# set VxWorks default install prefix
if(CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
    set(CMAKE_INSTALL_PREFIX ${__VXWORKS_DEF_INSTALL_PREFIX__} CACHE PATH "..." FORCE)
endif()
