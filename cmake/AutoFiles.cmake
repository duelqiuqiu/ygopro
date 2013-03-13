function (AutoFiles _folder _base _pattern)
    if (ARGC GREATER 3)
        set(_exclude ${ARGN})
    else ()
        set(_exclude)
    endif ()
    file (GLOB _files RELATIVE ${CMAKE_CURRENT_SOURCE_DIR}/ ${_folder}/*)
    set (folderFiles)
    foreach (_fname ${_files})
        if (IS_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/${_fname})
            AutoFiles (${_fname} ${_base} ${_pattern} ${_exclude})
        elseif (_fname MATCHES ${_pattern})
            if(_exclude)
                if (NOT _fname MATCHES ${_exclude})
                    set(folderFiles ${folderFiles} ${_fname})
                endif ()
            else ()
                set(folderFiles ${folderFiles} ${_fname})
            endif ()
        endif ()
    endforeach ()

    if (MSVC)
        string(REPLACE "./" "" _folder2 ${_folder})
        string(REPLACE "/" "\\" _folder2 ${_folder2})
        if (_folder2 STREQUAL ".")
            source_group(${_base} FILES ${folderFiles})
        else ()
            source_group(${_base}\\${_folder2} FILES ${folderFiles})
        endif ()
    endif ()

    set(AUTO_FILES_RESULT ${AUTO_FILES_RESULT} ${folderFiles} PARENT_SCOPE)
endfunction ()
