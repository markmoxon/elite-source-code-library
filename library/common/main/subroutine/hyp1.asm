\ ******************************************************************************
\
\       Name: hyp1
\       Type: Subroutine
\   Category: Universe
\    Summary: Process a jump to the system closest to (QQ9, QQ10)
\
\ ------------------------------------------------------------------------------
\
\ Do a hyperspace jump to the system closest to galactic coordinates
\ (QQ9, QQ10), and set up the current system's state to those of the new system.
\
\ Returns:
\
\   (QQ0, QQ1)          The galactic coordinates of the new system
\
\   QQ2 to QQ2+6        The seeds of the new system
\
\   EV                  Set to 0
\
\   QQ28                The new system's economy
\
\   tek                 The new system's tech level
\
\   gov                 The new system's government
\
\ Other entry points:
\
\   hyp1+3              Jump straight to the system at (QQ9, QQ10) without
\                       first calculating which system is closest. We do this
\                       if we already know that (QQ9, QQ10) points to a system
\
\ ******************************************************************************

.hyp1

IF NOT(_ELITE_A_FLIGHT OR _NES_VERSION)

 JSR TT111              \ Select the system closest to galactic coordinates
                        \ (QQ9, QQ10)

ENDIF

 JSR jmp                \ Set the current system to the selected system

 LDX #5                 \ We now want to copy the seeds for the selected system
                        \ in QQ15 into QQ2, where we store the seeds for the
                        \ current system, so set up a counter in X for copying
                        \ 6 bytes (for three 16-bit seeds)

.TT112

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION \ Other: Tha main bug fix for the "hyperspace when docking" bug. Without the fix, if your hyperspace counter hits 0 just as you're docking, then you will magically appear in the station in your hyperspace destination, without having to go to the effort of actually flying there

 LDA QQ15,X             \ Copy the X-th byte in QQ15 to the X-th byte in QQ2, to
 STA QQ2,X              \ update the selected system to the new one. Note that
                        \ this approach has a minor bug associated with it: if
                        \ your hyperspace counter hits 0 just as you're docking,
                        \ then you will magically appear in the station in your
                        \ hyperspace destination, without having to go to the
                        \ effort of actually flying there. This bug was fixed in
                        \ later versions by saving the destination seeds in a
                        \ separate location called safehouse, and using those
                        \ instead... but that isn't the case in this version

ELIF _6502SP_VERSION OR _MASTER_VERSION OR _NES_VERSION

 LDA safehouse,X        \ Copy the X-th byte in safehouse to the X-th byte in
 STA QQ2,X              \ QQ2

ENDIF

IF _NES_VERSION

 STA QQ15,X             \ ???

ENDIF

 DEX                    \ Decrement the counter

 BPL TT112              \ Loop back to TT112 if we still have more bytes to
                        \ copy

 INX                    \ Set X = 0 (as we ended the above loop with X = &FF)

 STX EV                 \ Set EV, the extra vessels spawning counter, to 0, as
                        \ we are entering a new system with no extra vessels
                        \ spawned

IF _NES_VERSION

 LDA #%10000000         \ Set bit 7 and clear bit 6 of selectedSystemFlag, to
 STA selectedSystemFlag \ indicate that there is a currently selected system
                        \ but we can't hyperspace to it (because it is the same
                        \ as the currently selected system)

 JSR UpdateIconBar_b3   \ Update the icon bar to remove the hyperspace button
                        \ if present

 JSR TT24_b6            \ Call TT24 to calculate system data from the seeds in
                        \ QQ15 and store them in the relevant locations, so our
                        \ new selected system is fully set up

ENDIF

 LDA QQ3                \ Set the current system's economy in QQ28 to the
 STA QQ28               \ selected system's economy from QQ3

 LDA QQ5                \ Set the current system's tech level in tek to the
 STA tek                \ selected system's economy from QQ5

 LDA QQ4                \ Set the current system's government in gov to the
 STA gov                \ selected system's government from QQ4

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_DOCKED OR _ELITE_A_DOCKED OR _ELITE_A_6502SP_PARA \ Minor

 RTS                    \ Return from the subroutine

ELIF _6502SP_VERSION OR _DISC_FLIGHT OR _ELITE_A_FLIGHT OR _MASTER_VERSION OR _NES_VERSION

                        \ Fall through into GVL to calculate the availability of
                        \ market items in the new system

ENDIF

