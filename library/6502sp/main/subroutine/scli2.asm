\ ******************************************************************************
\
\       Name: SCLI2
\       Type: Subroutine
\   Category: Utility routines
\    Summary: Execute an OS command, setting the SVN flag while it's running
\
\ ------------------------------------------------------------------------------
\
\ SVN is set to 255 before the command is run, to indicate that disc access is
\ in progress, and is reset to 0 once it has finished.
\
\ Arguments:
\
\   (Y X)               The address of a string containing the command to run,
\                       terminated by a carriage return (ASCII 13)
\
\ ******************************************************************************

.SCLI2

 LDA #255               \ Set the SVN flag to 255
 JSR DODOSVN

 JSR OSCLI              \ Call OSCLI to execute the OS command at (Y X)

 LDA #0                 \ Set A = 0 for the new value of the SVN flag

                        \ Fall through into DODOSVN to set the SVN flag to 0

