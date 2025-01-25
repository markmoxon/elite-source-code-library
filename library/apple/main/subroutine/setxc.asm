\ ******************************************************************************
\
\       Name: SETXC
\       Type: Subroutine
\   Category: Text
\    Summary: Move the text cursor to a specific column
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   A                   The text column
\
\ ******************************************************************************

IF _SOURCE_DISK_BUILD OR _SOURCE_DISK_ELT_FILES

\.SETXC                 \ These instructions are commented out in the original
\                       \ source
\STA XC
\JMP PUTBACK

 RTS                    \ Return from the subroutine

ELIF _IB_DISK OR _4AM_CRACK OR _SOURCE_DISK_CODE_FILES

.SETXC

 STA XC                 \ Store the new text column in XC

ENDIF

\JMP PUTBACK            \ This instruction is commented out in the original
                        \ source

 RTS                    \ Return from the subroutine

