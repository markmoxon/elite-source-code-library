\ ******************************************************************************
\
\       Name: startbd
\       Type: Subroutine
\   Category: Sound
\    Summary: Start playing the docking music, if configured
\
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   april16             Start playing the docking music, irrespective of the
\                       current configuration settings
\
\   startat2            Start playing the music at address (A X) + 1
\
\ ******************************************************************************

.startbd

IF _GMA85_NTSC OR _GMA86_PAL

 BIT MUSWAP             \ If bit 7 of MUSWAP is set then the docking computer
 BMI startat            \ has been configured to play the title music rather
                        \ than the docking music, so jump to startat to set
                        \ (A X) to the address of the title music to play when
                        \ docking

 LDA #LO(musicstart)    \ Set (A X) = musicstart, the address before the start
 LDX #HI(musicstart)    \ of the docking music

.startat2

 STA value5             \ Set value5(1 0) = (A X)
 STX value5+1           \
                        \ So value5 contains the address before the start of the
                        \ music we want to play

ENDIF

 BIT MUPLA              \ If bit 7 of MUPLA is set then there is already music
 BMI itsoff             \ playing so we don't want to start any more, so jump to
                        \ itsoff to return from the subroutine (as itsoff
                        \ contains an RTS)

 BIT MUFOR              \ If bit 7 of MUFOR is set then the docking music is
 BMI april16            \ configured so that it cannot be disabled, so skip the
                        \ following check for MUTOK

 BIT MUTOK              \ If bit 7 of MUTOK is set then the docking music is
 BMI itsoff             \ disabled, so jump to itsoff to return from the
                        \ subroutine without playing the docking music (as
                        \ itsoff contains an RTS)

.april16

 LDA #%101              \ Call SETL1 to set the 6510 input/output port to the
 JSR SETL1              \ following:
                        \
                        \   * LORAM = 1
                        \   * HIRAM = 0
                        \   * CHAREN = 1
                        \
                        \ This sets the entire 64K memory map to RAM except for
                        \ the I/O memory map at $D000-$DFFF, which gets mapped
                        \ to registers in the VIC-II video controller chip, the
                        \ SID sound chip, the two CIA I/O chips, and so on
                        \
                        \ See the memory map at the top of page 264 in the
                        \ Programmer's Reference Guide

 JSR BDENTRY            \ Start playing the configured background music

 LDA #&FF               \ Set MUPLA to &FF to indicate that music is now playing
 STA MUPLA

 BNE coffeeex           \ Jump to coffeeex to restore the memory configuration
                        \ and return from the subroutine (this BNE is
                        \ effectively a JMP as A is never zero)

