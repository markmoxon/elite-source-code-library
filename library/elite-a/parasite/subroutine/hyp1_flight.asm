\ ******************************************************************************
\
\       Name: hyp1_FLIGHT
\       Type: Subroutine
\   Category: Universe
\    Summary: Process a jump to the system closest to (QQ9, QQ10) (flight
\             version)
\
\ ******************************************************************************

.hyp1_FLIGHT

 JSR jmp                \ Set the current system to the selected system

 LDX #5                 \ We now want to copy the seeds for the selected system
                        \ in QQ15 into QQ2, where we store the seeds for the
                        \ current system, so set up a counter in X for copying
                        \ 6 bytes (for three 16-bit seeds)

.TT112_FLIGHT

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

 DEX                    \ Decrement the counter

 BPL TT112_FLIGHT       \ Loop back to TT112_FLIGHT if we still have more bytes
                        \ to copy

 INX                    \ Set X = 0 (as we ended the above loop with X = &FF)

 STX EV                 \ Set EV, the extra vessels spawning counter, to 0, as
                        \ we are entering a new system with no extra vessels
                        \ spawned

 LDA QQ3                \ Set the current system's economy in QQ28 to the
 STA QQ28               \ selected system's economy from QQ3

 LDA QQ5                \ Set the current system's tech level in tek to the
 STA tek                \ selected system's economy from QQ5

 LDA QQ4                \ Set the current system's government in gov to the
 STA gov                \ selected system's government from QQ4

 JSR DORND              \ Set A and X to random numbers

 STA QQ26               \ Set QQ26 to the random byte that's used in the market
                        \ calculations

 JMP GVL                \ Jump to GVL to calculate the availability of market
                        \ items, returning from the subroutine using a tail call

