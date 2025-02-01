\ ******************************************************************************
\
\       Name: L1M
\       Type: Variable
\   Category: Utility routines
\    Summary: Temporary storage for the new value of the 6510 input/output port
\             register
\
\ ******************************************************************************

.L1M

 EQUB %100              \ By default, this sets the 6510 input/output port to
                        \ the following:
                        \
                        \   * LORAM = 0
                        \   * HIRAM = 0
                        \   * CHAREN = 1
                        \
                        \ This sets the entire 64K memory map to RAM
                        \
                        \ See the memory map at the top of page 265 in the
                        \ "Commodore 64 Programmer's Reference Guide", published
                        \ by Commodore
