\ ******************************************************************************
\
\       Name: LL9 (Part 12 of 12)
\       Type: Subroutine
\   Category: Drawing ships
IF NOT(_NES_VERSION)
\    Summary: Draw ship: Draw all the visible edges from the ship line heap
ELIF _NES_VERSION
\    Summary: Does nothing in the NES version
ENDIF
\  Deep dive: Drawing ships
\
\ ------------------------------------------------------------------------------
\
IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION OR _C64_VERSION \ Comment
\ This part draws the lines in the ship line heap, which is used both to draw
\ the ship, and to remove it from the screen.
\
ELIF _MASTER_VERSION OR _APPLE_VERSION
\ This part draws any remaining lines from the old ship that are still in the
\ ship line heap.
\
ELIF _NES_VERSION
\ The NES version does not have a ship line heap as the screen is redrawn for
\ every frame, so this part of LL9 does nothing (in the other versions it draws
\ all the visible edges from the ship line heap).
\
ENDIF
IF _6502SP_VERSION \ Comment
\ If NEEDKEY is non-zero, then this routine also scans the keyboard for a key
\ press and returns the internal key number in X (or 0 for no key press).
\
ENDIF
IF _MASTER_VERSION OR _APPLE_VERSION \ Comment
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   LSCLR               Draw any remaining lines from the old ship that are
\                       still in the ship line heap
\
\   LSC3                Contains an RTS
\
ENDIF
\ ******************************************************************************

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION OR _C64_VERSION \ Label

.LL155

ELIF _MASTER_VERSION OR _APPLE_VERSION

.LSCLR

ENDIF

IF _6502SP_VERSION \ Tube

 LDA NEEDKEY            \ If NEEDKEY is zero, jump to notneed to skip the next
 BEQ notneed            \ two instructions, so we only read the keyboard if
                        \ NEEDKEY is non-zero

 STZ NEEDKEY            \ Set NEEDKEY = 0

 JSR RDKEY              \ Scan the keyboard for a key press and return the
                        \ internal key number in A and X (or 0 for no key press)

.notneed

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION \ Tube

 LDY #0                 \ Fetch the first byte from the ship line heap into A,
 LDA (XX19),Y           \ which contains the number of bytes in the heap

 STA XX20               \ Store the heap size in XX20

 CMP #4                 \ If the heap size is less than 4, there is nothing to
 BCC LL118-1            \ draw, so return from the subroutine (as LL118-1
                        \ contains an RTS)

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

ELIF _C64_VERSION

 LDY #0                 \ Fetch the first byte from the ship line heap into A,
 LDA (XX19),Y           \ which contains the number of bytes in the heap

 STA XX20               \ Store the heap size in XX20

 CMP #4                 \ If the heap size is less than 4, there is nothing to
 BCC LL82               \ draw, so return from the subroutine (as LL82 contains
                        \ an RTS)

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _C64_VERSION \ Master: Group A: The cassette, disc and 6502SP versions do all their line drawing at the very end of the LL9 ship-drawing routine, but the Master has already redrawn most of the ship by this point and only needs to erase any remaining lines

 INY                    \ Set Y = 1, which we will use as an index into the ship
                        \ line heap, starting at byte #1 (as byte #0 contains
                        \ the heap size)

ELIF _6502SP_VERSION

 LDY #0                 \ Fetch the first byte from the ship line heap into A,
 LDA (XX19),Y           \ which contains the number of bytes in the heap

 STA XX20               \ Store the heap size in XX20

ELIF _MASTER_VERSION OR _APPLE_VERSION

 LDY LSNUM              \ Set Y to the offset in the line heap LSNUM

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _C64_VERSION \ Master: See group A

.LL27

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

ELIF _MASTER_VERSION OR _APPLE_VERSION

.LSC1

 CPY LSNUM2             \ If Y >= LSNUM2, jump to LSC2 to return from the ship
 BCS LSC2               \ drawing routine, because the index in Y is greater
                        \ than the size of the existing ship line heap, which
                        \ means we have already erased all the old ship's lines
                        \ when drawing the new ship

                        \ If we get here then Y < LSNUM2, which means Y is
                        \ pointing to an on-screen line from the old ship that
                        \ we need to erase

 LDA (XX19),Y           \ Fetch the X1 line coordinate from the heap and store
 INY                    \ it in XX15, incrementing the heap pointer
 STA XX15

 LDA (XX19),Y           \ Fetch the Y1 line coordinate from the heap and store
 INY                    \ it in XX15+1, incrementing the heap pointer
 STA XX15+1

 LDA (XX19),Y           \ Fetch the X2 line coordinate from the heap and store
 INY                    \ it in XX15+2, incrementing the heap pointer
 STA XX15+2

 LDA (XX19),Y           \ Fetch the Y2 line coordinate from the heap and store
 INY                    \ it in XX15+3, incrementing the heap pointer
 STA XX15+3

 JSR LOIN               \ Draw a line from (X1, Y1) to (X2, Y2) to erase it from
                        \ the screen

ELIF _6502SP_VERSION

.LL27

 LDA (XX19),Y           \ Fetch the Y-th line coordinate from the heap and send
 JSR OSWRCH             \ it to the I/O processor to add to the line buffer

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION OR _C64_VERSION \ Master: See group A

 INY                    \ Increment the heap pointer

 CPY XX20               \ If the heap counter is less than the size of the heap,
 BCC LL27               \ loop back to LL27 to draw the next line from the heap

ELIF _MASTER_VERSION OR _APPLE_VERSION

 JMP LSC1               \ Loop back to LSC1 to draw (i.e. erase) the next line
                        \ from the heap

.LSC2

 LDA LSNUM              \ Store LSNUM in the first byte of the ship line heap
 LDY #0
 STA (XX19),Y

.LSC3

ENDIF

IF _CASSETTE_VERSION \ Comment

\.LL82                  \ This label is commented out in the original source

ELIF _6502SP_VERSION

                        \ By the time we get here, we have sent all the line
                        \ coordinates to the I/O processor, so it will have
                        \ drawn the line after we sent the last one

.nolines

ELIF _C64_VERSION

.LL82

ENDIF

 RTS                    \ Return from the subroutine

