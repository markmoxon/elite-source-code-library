\ ******************************************************************************
\
\       Name: DODOSVN
\       Type: Subroutine
\   Category: Save and load
\    Summary: Set the SVN ("save in progress") flag by sending a #DOsvn command
\             to the I/O processor
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   A                   The new value of SVN
\
\ ******************************************************************************

.DODOSVN

 PHA                    \ Store A and Y on the stack
 PHY

 LDA #DOsvn             \ Send the first part of a #DOsvn command to the I/O
 JSR OSWRCH             \ processor

 PLY                    \ Retrieve the values of A and Y from the stack
 PLA

 JSR OSWRCH             \ Send the new value of SVN to the I/O processor, so
                        \ we've now sent a #DOsvn <flag> command

                        \ Fall through into CLDELAY to pause for 1280 empty
                        \ loops

