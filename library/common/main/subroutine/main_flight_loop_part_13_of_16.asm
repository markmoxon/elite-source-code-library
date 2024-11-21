\ ******************************************************************************
\
\       Name: Main flight loop (Part 13 of 16)
\       Type: Subroutine
\   Category: Main loop
IF NOT(_ELITE_A_VERSION)
\    Summary: Show energy bomb effect, charge shields and energy banks
ELIF _ELITE_A_VERSION
\    Summary: Charge shields and energy banks
ENDIF
\  Deep dive: Program flow of the main game loop
\             Scheduling tasks with the main loop counter
\
\ ------------------------------------------------------------------------------
\
\ The main flight loop covers most of the flight-specific aspects of Elite. This
\ section covers the following:
\
IF NOT(_ELITE_A_VERSION)
\   * Show energy bomb effect (if applicable)
\
ENDIF
\   * Charge shields and energy banks (every 7 iterations of the main loop)
\
IF _NES_VERSION
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   MA18                Entry point for part 13 of the main flight loop
\
ENDIF
\ ******************************************************************************

.MA18

IF _NES_VERSION

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

ENDIF

IF NOT(_ELITE_A_VERSION)

 LDA BOMB               \ If we set off our energy bomb (see MA24 above), then
 BPL MA77               \ BOMB is now negative, so this skips to MA21 if our
                        \ energy bomb is not going off

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_FLIGHT OR _6502SP_VERSION \ Master: The Master version's energy bomb lightning bolt flashes on the screen, just like real lightning

 ASL BOMB               \ We set off our energy bomb, so rotate BOMB to the
                        \ left by one place. BOMB was rotated left once already
                        \ during this iteration of the main loop, back at MA24,
                        \ so if this is the first pass it will already be
                        \ %11111110, and this will shift it to %11111100 - so
                        \ if we set off an energy bomb, it stays activated
                        \ (BOMB > 0) for four iterations of the main loop

ELIF _MASTER_VERSION OR _APPLE_VERSION

 JSR BOMBEFF2           \ Call BOMBEFF2 to erase the energy bomb zig-zag
                        \ lightning bolt that we drew in part 3, make the sound
                        \ of the energy bomb going off, draw a new lightning
                        \ bolt, and repeat the process four times so the bolt
                        \ flashes

 ASL BOMB               \ We set off our energy bomb, so rotate BOMB to the
                        \ left by one place. BOMB was rotated left once already
                        \ during this iteration of the main loop, back at MA24,
                        \ so if this is the first pass it will already be
                        \ %11111110, and this will shift it to %11111100 - so
                        \ if we set off an energy bomb, it stays activated
                        \ (BOMB > 0) for four iterations of the main loop

 BMI MA77               \ If the result has bit 7 set, skip the following
                        \ instruction as the bomb is still going off

 JSR BOMBOFF            \ Our energy bomb has finished going off, so call
                        \ BOMBOFF to draw the zig-zag lightning bolt, which
                        \ erases it from the screen

ELIF _C64_VERSION

 ASL BOMB               \ We set off our energy bomb, so rotate BOMB to the
                        \ left by one place. BOMB was rotated left once already
                        \ during this iteration of the main loop, back at MA24,
                        \ so if this is the first pass it will already be
                        \ %11111110, and this will shift it to %11111100 - so
                        \ if we set off an energy bomb, it stays activated
                        \ (BOMB > 0) for four iterations of the main loop

 BMI MA77               \ If the result has bit 7 set, skip the following
                        \ instruction as the bomb is still going off

 JSR BOMBOFF            \ Our energy bomb has finished going off, so call
                        \ BOMBOFF to turn off the bomb effect

ELIF _NES_VERSION

 ASL BOMB               \ We set off our energy bomb, so rotate BOMB to the
                        \ left by one place. BOMB was rotated left once already
                        \ during this iteration of the main loop, back at MA24,
                        \ so if this is the first pass it will already be
                        \ %11111110, and this will shift it to %11111100 - so
                        \ if we set off an energy bomb, it stays activated
                        \ (BOMB > 0) for four iterations of the main loop

 BMI MA77               \ If the result has bit 7 set, skip the following
                        \ instruction as the bomb is still going off

 JSR HideHiddenColour   \ Set the hidden colour to black, to switch off the
                        \ energy bomb effect (as the effect works by showing
                        \ hidden content instead of the visible content)

 JSR UpdateIconBar_b3   \ Update the icon bar to remove the energy bomb icon,
                        \ as it is a single-use weapon

ENDIF

IF _CASSETTE_VERSION OR _DISC_FLIGHT OR _6502SP_VERSION \ Platform

 JSR WSCAN              \ Call WSCAN to wait for the vertical sync, so the whole
                        \ screen gets drawn and the following palette change
                        \ won't kick in while the screen is still refreshing

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

IF NOT(_NES_VERSION)

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

ELIF _NES_VERSION

 JSR ChargeShields      \ Charge the shields and energy banks

ENDIF

IF NOT(_ELITE_A_VERSION OR _NES_VERSION)

 SEC                    \ Set A = ENERGY + ENGY + 1, so our ship's energy
 LDA ENGY               \ level goes up by 2 if we have an energy unit fitted,
 ADC ENERGY             \ otherwise it goes up by 1

ELIF _ELITE_A_VERSION

 SEC                    \ Set A = ENERGY + ENGY + 1, so our ship's energy
 LDA ENGY               \ level goes up by the correct amount for our current
 ADC ENERGY             \ ship, depending on whether we have an energy unit
                        \ fitted

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _6502SP_VERSION OR _C64_VERSION \ Platform

 BCS P%+5               \ If the value of A did not overflow (the maximum
 STA ENERGY             \ energy level is &FF), then store A in ENERGY

ELIF _MASTER_VERSION OR _APPLE_VERSION

 BCS paen1              \ If the value of A did not overflow (the maximum
 STA ENERGY             \ energy level is &FF), then store A in ENERGY

.paen1

ENDIF

