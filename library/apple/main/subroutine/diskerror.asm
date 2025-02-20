
\ ******************************************************************************
\
\       Name: diskerror
\       Type: Subroutine
\   Category: Save and load
\    Summary: Print a disk error, make a beep and wait for a key press
\  Deep dive: File operations with embedded Apple DOS
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   A                   The error to display:
\
\                         * 1 = Disk write protected
\
\                         * 2 = Disk full
\
\                         * 3 = Catalog full
\
\                         * 4 = Disk I/O error
\
\                         * 5 = File not found
\
\ ******************************************************************************

.diskerror

 ASL A                  \ Set X to the error number in A, shifted left by one
 TAX                    \ place to double it, so X can be used as an index into
                        \ the ERTAB table, which contains two-byte addresses
                        \ that point to the relevant error messages

 LDA ERTAB-2,X          \ Set XX15(1 0) to the address of the error message, so
 STA XX15               \ that error number 1 points to the address in the first
 LDA ERTAB-1,X          \ entry at ERTAB
 STA XX15+1

 LDY #0                 \ Set Y to a character counter for printing the error
                        \ message one character at a time, starting at character
                        \ zero

.dskerllp

 LDA (XX15),Y           \ Set A to the Y-th character from the error message

 BEQ dskerllp2          \ If A = 0 then we have reached the end of the
                        \ null-terminated string, so jump to dskerllp2 to stop
                        \ printing characters

 JSR TT26               \ Print the character in A

 INY                    \ Increment the character counter

 BNE dskerllp           \ Loop back to print the next character

.dskerllp2

 JSR BOOP               \ Make a long, low beep

 JSR t                  \ Scan the keyboard until a key is pressed, returning
                        \ the ASCII code in A and X

 JMP SVE                \ Jump to SVE to display the disk access menu and return
                        \ from the subroutine using a tail call

