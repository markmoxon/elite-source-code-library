\ ******************************************************************************
\
\       Name: LL9 (Part 12 of 12)
\       Type: Subroutine
\   Category: Drawing ships
\    Summary: Draw ship: Draw all the visible edges from the ship line heap
\  Deep dive: Drawing ships
\
\ ------------------------------------------------------------------------------
\
\ This part draws the lines in the ship line heap, which is used both to draw
\ the ship, and to remove it from the screen.
\
IF _6502SP_VERSION \ Comment
\ If NEEDKEY is non-zero, then this routine also scans the keyboard for a key
\ press and returns the internal key number in X (or 0 for no key press).
\
ENDIF
\ ******************************************************************************

.LL155

IF _6502SP_VERSION \ Tube

 LDA NEEDKEY            \ If NEEDKEY is zero, jump to notneed to skip the next
 BEQ notneed            \ two instructions, so we only read the keyboard if
                        \ NEEDKEY is non-zero

 STZ NEEDKEY            \ Set NEEDKEY = 0

 JSR RDKEY              \ Scan the keyboard for a key press and return the
                        \ internal key number in X (or 0 for no key press)

.notneed

ENDIF

IF _CASSETTE_VERSION OR _DISC_VERSION \ Tube

 LDY #0                 \ Fetch the first byte from the ship line heap into A,
 LDA (XX19),Y           \ which contains the number of bytes in the heap

 STA XX20               \ Store the heap size in XX20

 CMP #4                 \ If the heap size is less than 4, there is nothing to
 BCC LL118-1            \ draw, so return from the subroutine (as LL118-1
                        \ contains an RTS)

 INY                    \ Set Y = 1, which we will use as an index into the ship
                        \ line heap, starting at byte #1 (as byte #0 contains
                        \ the heap size)

ELIF _6502SP_VERSION

 LDA (XX19)             \ Fetch the first byte from the ship line heap into A,
                        \ which contains the number of bytes in the heap

 CMP #5                 \ If the heap size is less than 5, there is nothing to
 BCC nolines            \ draw, so return from the subroutine (as nolines
                        \ contains an RTS)

 LDA #129               \ Send an OSWRCH 129 command to the I/O processor to
 JSR OSWRCH             \ tell it to start receiving a new line to draw (so
                        \ when we send it OSWRCH commands from now on, the I/O
                        \ processor will add these bytes to this line until
                        \ they are all sent, at which point it will draw the
                        \ line)

 LDY #0                 \ Fetch the first byte from the ship line heap into A,
 LDA (XX19),Y           \ which contains the number of bytes in the heap

 STA XX20               \ Store the heap size in XX20

ENDIF

.LL27

IF _CASSETTE_VERSION OR _DISC_VERSION \ Tube

 LDA (XX19),Y           \ Fetch the X1 line coordinate from the heap and store
 STA XX15               \ it in XX15

 INY                    \ Increment the heap pointer

 LDA (XX19),Y           \ Fetch the Y1 line coordinate from the heap and store
 STA XX15+1             \ it in XX15+1

 INY                    \ Increment the heap pointer

 LDA (XX19),Y           \ Fetch the X2 line coordinate from the heap and store
 STA XX15+2             \ it in XX15+2

 INY                    \ Increment the heap pointer

 LDA (XX19),Y           \ Fetch the Y2 line coordinate from the heap and store
 STA XX15+3             \ it in XX15+3

 JSR LL30               \ Draw a line from (X1, Y1) to (X2, Y2)

ELIF _6502SP_VERSION

 LDA (XX19),Y           \ Fetch the Y-th line coordinate from the heap and send
 JSR OSWRCH             \ it to the I/O processor to add to the line buffer

ENDIF

 INY                    \ Increment the heap pointer

 CPY XX20               \ If the heap counter is less than the size of the heap,
 BCC LL27               \ loop back to LL27 to draw the next line from the heap

IF _CASSETTE_VERSION OR _DISC_VERSION \ Label

\LL82                   \ This label is commented out in the original source

ELIF _6502SP_VERSION

                        \ By the time we get here, we have sent all the line
                        \ coordinates to the I/O processor, so it will have
                        \ drawn the line after we sent the last one

.nolines

ENDIF

 RTS                    \ Return from the subroutine

