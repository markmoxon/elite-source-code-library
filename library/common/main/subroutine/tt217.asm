\ ******************************************************************************
\
\       Name: TT217
\       Type: Subroutine
\   Category: Keyboard
\    Summary: Scan the keyboard until a key is pressed
\
\ ------------------------------------------------------------------------------
\
\ Scan the keyboard until a key is pressed, and return the key's ASCII code.
\ If, on entry, a key is already being held down, then wait until that key is
\ released first (so this routine detects the first key down event following
\ the subroutine call).
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   X                   The ASCII code of the key that was pressed
\
\   A                   Contains the same as X
\
\   Y                   Y is preserved
\
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   out                 Contains an RTS
\
IF _6502SP_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION \ Comment
\   t                   As TT217 but don't preserve Y, set it to YSAV instead
\
ENDIF
\ ******************************************************************************

.TT217

 STY YSAV               \ Store Y in temporary storage, so we can restore it
                        \ later

.t

IF _CASSETTE_VERSION \ Platform

 JSR DELAY-5            \ Wait for 8/50 of a second (0.16 seconds) to implement
                        \ a simple keyboard debounce and prevent multiple key
                        \ presses being recorded

ELIF _6502SP_VERSION OR _DISC_DOCKED OR _ELITE_A_VERSION OR _APPLE_VERSION OR _MASTER_VERSION

 LDY #2                 \ Wait for 2/50 of a second (0.04 seconds) to implement
 JSR DELAY              \ a simple keyboard debounce and prevent multiple key
                        \ presses being recorded

ELIF _C64_VERSION

 LDY #2                 \ Wait for 2/50 of a second (0.04 seconds) on PAL
 JSR DELAY              \ systems, or 2/60 of a second (0.33 seconds) on NTSC,
                        \ to implement a simple keyboard debounce and prevent
                        \ multiple key presses being recorded

ENDIF

IF _CASSETTE_VERSION OR _DISC_DOCKED OR _ELITE_A_VERSION OR _6502SP_VERSION OR _C64_VERSION \ Platform

 JSR RDKEY              \ Scan the keyboard for a key press and return the
                        \ internal key number in A and X (or 0 for no key press)

 BNE t                  \ If a key was already being held down when we entered
                        \ this routine, keep looping back up to t, until the
                        \ key is released

.t2

ELIF _ELECTRON_VERSION

 DEC KEYB               \ Decrement KEYB, so it is now &FF, to indicate that we
                        \ are reading from the keyboard using an OS command

 JSR OSRDCH             \ Call OSRDCH to read a character from the keyboard

 INC KEYB               \ Increment KEYB back to 0 to indicate we are done
                        \ reading the keyboard

ELIF _MASTER_VERSION OR _APPLE_VERSION

 JSR RDKEY              \ Scan the keyboard for a key press and return the
                        \ ASCII code of the key pressed in A and X (or 0 for no
                        \ key press)

 BNE t                  \ If a key was already being held down when we entered
                        \ this routine, keep looping back up to t, until the
                        \ key is released

.t2

ENDIF

IF _CASSETTE_VERSION OR _DISC_DOCKED OR _ELITE_A_VERSION OR _6502SP_VERSION OR _C64_VERSION \ Platform

 JSR RDKEY              \ Any pre-existing key press is now gone, so we can
                        \ start scanning the keyboard again, returning the
                        \ internal key number in A and X (or 0 for no key press)

ELIF _MASTER_VERSION OR _APPLE_VERSION

 JSR RDKEY              \ Any pre-existing key press is now gone, so we can
                        \ start scanning the keyboard again, returning the
                        \ ASCII code of the key pressed in X (or 0 for no key
                        \ press)

ENDIF

IF _CASSETTE_VERSION OR _DISC_DOCKED OR _ELITE_A_VERSION OR _6502SP_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION \ Platform

 BEQ t2                 \ Keep looping up to t2 until a key is pressed

ENDIF

IF _CASSETTE_VERSION OR _DISC_DOCKED OR _ELITE_A_VERSION \ Tube

 TAY                    \ Copy A to Y, so Y contains the internal key number
                        \ of the key pressed

 LDA (TRTB%),Y          \ The address in TRTB% points to the MOS key
                        \ translation table, which is used to translate
                        \ internal key numbers to ASCII, so this fetches the
                        \ key's ASCII code into A

ELIF _6502SP_VERSION

 TAY                    \ Copy A to Y, so Y contains the internal key number
                        \ of the key pressed

 LDA TRANTABLE,Y        \ TRANTABLE points to the MOS key translation table,
                        \ which is used to translate internal key numbers to
                        \ ASCII, so this fetches the key's ASCII code into A

ELIF _C64_VERSION

 LDA TRANTABLE,X        \ TRANTABLE points to the key translation table, which
                        \ is used to translate internal key numbers to ASCII, so
                        \ this fetches the key's ASCII code into A

ENDIF

IF _CASSETTE_VERSION OR _DISC_DOCKED OR _ELITE_A_VERSION OR _6502SP_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION \ Platform

 LDY YSAV               \ Restore the original value of Y we stored above

ENDIF

 TAX                    \ Copy A into X

.out

 RTS                    \ Return from the subroutine

