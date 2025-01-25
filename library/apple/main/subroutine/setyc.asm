\ ******************************************************************************
\
\       Name: SETYC
\       Type: Subroutine
\   Category: Text
\    Summary: Move the text cursor to a specific row
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   A                   The text row
\
\ ******************************************************************************

IF _SOURCE_DISK_BUILD OR _SOURCE_DISK_ELT_FILES

\.SETYC                 \ These instructions are commented out in the original
\                       \ source
\STA YC

ELIF _IB_DISK OR _4AM_CRACK OR _SOURCE_DISK_CODE_FILES

.SETYC

 STA YC                 \ Store the new text row in YC

\JMP PUTBACK            \ This instruction is commented out in the original
                        \ source

 RTS                    \ Return from the subroutine

ENDIF

