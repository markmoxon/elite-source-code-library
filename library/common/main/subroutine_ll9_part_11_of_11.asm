\ ******************************************************************************
\
\       Name: LL9 (Part 11 of 11)
\       Type: Subroutine
\   Category: Drawing ships
\    Summary: Draw ship: Draw all the visible edges from the ship line heap
\
\ ------------------------------------------------------------------------------
\
\ This part draws the lines in the ship line heap, which is used both to draw
\ the ship, and to remove it from the screen.
\
\ ******************************************************************************

.LL155

IF _CASSETTE_VERSION

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

 LDA NEEDKEY
 BEQ notneed
 STZ NEEDKEY \++

 JSR RDKEY              \ Scan the keyboard for a key press

.notneed

 LDA (XX19)
 CMP #5
 BCC nolines
 LDA #&81
 JSR OSWRCH
\ CLEAR LINEstr
 LDY #0
 LDA (XX19),Y
 STA XX20

ENDIF

.LL27

IF _CASSETTE_VERSION

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

 LDA (XX19),Y
 JSR OSWRCH

ENDIF

 INY                    \ Increment the heap pointer

 CPY XX20               \ If the heap counter is less than the size of the heap,
 BCC LL27               \ loop back to LL27 to draw the next line from the heap

IF _CASSETTE_VERSION

\LL82                   \ This label is commented out in the original source

ELIF _6502SP_VERSION

.nolines

ENDIF

 RTS                    \ Return from the subroutine

