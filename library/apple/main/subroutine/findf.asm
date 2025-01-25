\ ******************************************************************************
\
\       Name: findf
\       Type: Subroutine
\   Category: Save and load
\    Summary: Search the disk catalog for an existing file
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   C flag              The result of the search:
\
\                         * Clear = file found
\
\                         * Set = file not found
\
\ ******************************************************************************

.findf

 CLC                    \ Clear the C flag to pass to rentry to indicate that we
                        \ should search the disk catalog for an existing file

 BCC rentry             \ Jump to rentry to find the file (this BCC is
                        \ effectively a JMP as we just cleared the C flag

