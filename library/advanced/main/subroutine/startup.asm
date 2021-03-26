\ ******************************************************************************
\
\       Name: STARTUP
\       Type: Subroutine
\   Category: Loader
IF _6502SP_VERSION \ Comment
\    Summary: Set the various vectors, interrupts and timers, and terminate the
\             loading process so the vector handlers can take over
ELIF _MASTER_VERSION
\    Summary: Set the various vectors, interrupts and timers
ENDIF
\
\ ******************************************************************************

.STARTUP

IF _6502SP_VERSION \ Tube

 LDA RDCHV              \ Store the current RDCHV vector in newosrdch(2 1),
 STA newosrdch+1        \ which modifies the address portion of the JSR &FFFF
 LDA RDCHV+1            \ instruction at the start of the newosrdch routine and
 STA newosrdch+2        \ changes it to a JSR to the existing RDCHV address

 LDA #LO(newosrdch)     \ Disable interrupts and set WRCHV to newosrdch, so
 SEI                    \ calls to OSRDCH are now handled by newosrdch, which
 STA RDCHV              \ lets us implement all our custom OSRDCH commands
 LDA #HI(newosrdch)
 STA RDCHV+1

ELIF _MASTER_VERSION

 SEI                    \ Disable interrupts

ENDIF

 LDA #%00111001         \ Set 6522 System VIA interrupt enable register IER
 STA VIA+&4E            \ (SHEILA &4E) bits 0 and 3-5 (i.e. disable the Timer1,
                        \ CB1, CB2 and CA2 interrupts from the System VIA)

 LDA #%01111111         \ Set 6522 User VIA interrupt enable register IER
 STA &FE6E              \ (SHEILA &6E) bits 0-7 (i.e. disable all hardware
                        \ interrupts from the User VIA)

 LDA IRQ1V              \ Store the current IRQ1V vector in VEC, so VEC(1 0) now
 STA VEC                \ contains the original address of the IRQ1 handler
 LDA IRQ1V+1
 STA VEC+1

 LDA #LO(IRQ1)          \ Set the IRQ1V vector to IRQ1, so IRQ1 is now the
 STA IRQ1V              \ interrupt handler
 LDA #HI(IRQ1)
 STA IRQ1V+1

IF _6502SP_VERSION \ Minor

 LDA #VSCAN             \ Set 6522 System VIA T1C-L timer 1 high-order counter
 STA VIA+&45            \ (SHEILA &45) to VSCAN (57) to start the T1 counter
                        \ counting down from 14592 at a rate of 1 MHz (this is
                        \ a different value to the main game code and to the
                        \ loader's IRQ1 routine in the cassette version)

ELIF _MASTER_VERSION

 LDA VSCAN              \ Set 6522 System VIA T1C-L timer 1 high-order counter
 STA VIA+&45            \ (SHEILA &45) to the contents of VSCAN (57) to start
                        \ the T1 counter counting down from 14592 at a rate of
                        \ 1 MHz

ENDIF

 CLI                    \ Enable interrupts again

IF _6502SP_VERSION \ Tube

.NOINT

 LDA WORDV              \ Store the current WORDV vector in notours(2 1)
 STA notours+1
 LDA WORDV+1
 STA notours+2

 LDA #LO(NWOSWD)        \ Disable interrupts and set WORDV to NWOSWD, so calls
 SEI                    \ calls to OSWORD are now handled by NWOSWD, which lets
 STA WORDV              \ us implement all our custom OSWORD commands
 LDA #HI(NWOSWD)
 STA WORDV+1

 CLI                    \ Enable interrupts again

ELIF _MASTER_VERSION

 RTS                    \ Return from the subroutine

ENDIF

IF _6502SP_VERSION \ Advanced: The 6502SP version implements a hook that enables you to add arbitrary code to the startup process. The code needs to be inserted at location &0B00 in the I/O processor, and it needs to start with the characters "TINA"

 LDA #&FF               \ Set the text and graphics colour to cyan
 STA COL

 LDA Tina               \ If the contents of locations &0B00 to &0B03 are "TINA"
 CMP #'T'               \ then keep going, otherwise jump to PUTBACK to point
 BNE PUTBACK            \ WRCHV to USOSWRCH, and then end the program, as from
 LDA Tina+1             \ now on the handlers pointed to by the vectors will
 CMP #'I'               \ handle everything
 BNE PUTBACK
 LDA Tina+2
 CMP #'N'
 BNE PUTBACK
 LDA Tina+3
 CMP #'A'
 BNE PUTBACK

 JSR Tina+4             \ &0B00 to &0B03 contains "TINA", so call the subroutine
                        \ at &B04. This allows us to add a hook to the startup
                        \ process by populating page &B with TINA plus the code
                        \ for a subroutine, and it will be called just before
                        \ the setup code terminates on the I/O processor

                        \ Fall through into PUTBACK to point WRCHV to USOSWRCH,
                        \ and then end the program, as from now on the handlers
                        \ pointed to by the vectors will handle everything

ENDIF

