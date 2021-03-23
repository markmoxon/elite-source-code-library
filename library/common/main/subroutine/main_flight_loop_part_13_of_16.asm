\ ******************************************************************************
\
\       Name: Main flight loop (Part 13 of 16)
\       Type: Subroutine
\   Category: Main loop
\    Summary: Show energy bomb effect, charge shields and energy banks
\  Deep dive: Program flow of the main game loop
\             Scheduling tasks with the main loop counter
\
\ ------------------------------------------------------------------------------
\
\ The main flight loop covers most of the flight-specific aspects of Elite. This
\ section covers the following:
\
\   * Show energy bomb effect (if applicable)
\
\   * Charge shields and energy banks (every 7 iterations of the main loop)
\
\ ******************************************************************************

.MA18

 LDA BOMB               \ If we set off our energy bomb by pressing TAB (see
 BPL MA77               \ MA24 above), then BOMB is now negative, so this skips
                        \ to MA77 if our energy bomb is not going off

IF _CASSETTE_VERSION OR _DISC_FLIGHT OR _6502SP_VERSION

 ASL BOMB               \ We set off our energy bomb, so rotate BOMB to the
                        \ left by one place. BOMB was rotated left once already
                        \ during this iteration of the main loop, back at MA24,
                        \ so if this is the first pass it will already be
                        \ %11111110, and this will shift it to %11111100 - so
                        \ if we set off an energy bomb, it stays activated
                        \ (BOMB > 0) for four iterations of the main loop

 JSR WSCAN              \ Call WSCAN to wait for the vertical sync, so the whole
                        \ screen gets drawn and the following palette change
                        \ won't kick in while the screen is still refreshing

ELIF _MASTER_VERSION

 JSR BOMBFX

 ASL BOMB
 BMI MA77

 JSR L31AC

ENDIF

IF _CASSETTE_VERSION OR _DISC_FLIGHT \ Tube

 LDA #%00110000         \ Set the palette byte at SHEILA &21 to map logical
 STA VIA+&21            \ colour 0 to physical colour 7 (white), but with only
                        \ one mapping (rather than the 7 mappings required to
                        \ do the mapping properly). This makes the space screen
                        \ flash with black and white stripes. See p.382 of the
                        \ Advanced User Guide for details of why this single
                        \ palette change creates a special effect

ELIF _6502SP_VERSION

 LDA #DOFE21            \ Send a #DOFE21 %00110000 command to the I/O processor
 JSR OSWRCH             \ to map logical colour 0 to physical colour 7 (white),
 LDA #%00110000         \ but with only one mapping (rather than the 7
 JSR OSWRCH             \ mappings required to do the mapping properly). This
                        \ makes the space screen flash with coloured stripes.
                        \ See p.382 of the Advanced User Guide for details of
                        \ why this single palette change creates a special
                        \ effect

ENDIF

.MA77

 LDA MCNT               \ Fetch the main loop counter and calculate MCNT mod 7,
 AND #7                 \ jumping to MA22 if it is non-zero (so the following
 BNE MA22               \ code only runs every 8 iterations of the main loop)

 LDX ENERGY             \ Fetch our ship's energy levels and skip to b if bit 7
 BPL b                  \ is not set, i.e. only charge the shields from the
                        \ energy banks if they are at more than 50% charge

 LDX ASH                \ Call SHD to recharge our aft shield and update the
 JSR SHD                \ shield status in ASH
 STX ASH

 LDX FSH                \ Call SHD to recharge our forward shield and update
 JSR SHD                \ the shield status in FSH
 STX FSH

.b

 SEC                    \ Set A = ENERGY + ENGY + 1, so our ship's energy
 LDA ENGY               \ level goes up by 2 if we have an energy unit fitted,
 ADC ENERGY             \ otherwise it goes up by 1

IF _CASSETTE_VERSION OR _DISC_FLIGHT OR _6502SP_VERSION

 BCS P%+5               \ If the value of A did not overflow (the maximum
 STA ENERGY             \ energy level is &FF), then store A in ENERGY

ELIF _MASTER_VERSION

 BCS P%+4               \ If the value of A did not overflow (the maximum
 STA ENERGY             \ energy level is &FF), then store A in ENERGY ???

ENDIF

