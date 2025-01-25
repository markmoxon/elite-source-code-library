\ ******************************************************************************
\
\       Name: finde
\       Type: Subroutine
\   Category: Save and load
\    Summary: Search the disk catalog for an empty file entry
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   C flag              The result of the search:
\
\                         * Clear = empty entry found
\
\                         * Set = no empty entry found (i.e. catalog is full)
\
\ ******************************************************************************

.finde

 SEC                    \ Set the C flag to pass to rentry to indicate that we
                        \ should search the disk catalog for an empty file entry

                        \ Fall through into rentry to perform the search

