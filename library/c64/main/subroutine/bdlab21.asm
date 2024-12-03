\ ******************************************************************************
\
\       Name: BDlab21
\       Type: Subroutine
\   Category: Sound
\    Summary: Clean up and return from the interrupt routine
\
\ ******************************************************************************

.BDlab21

IF _GMA_RELEASE

 LDX counter            \ If the rest counter is non-zero, jump to BDexitirq to
 CPX #0                 \ return from the interrupt routine
 BNE BDexitirq

ELIF _SOURCE_DISK

 LDX counter            \ If the rest counter is not 2, jump to BDexitirq to
 CPX #2                 \ return from the interrupt routine
 BNE BDexitirq

ENDIF

                        \ The rest counter is ticking down, which means no new
                        \ notes are being played for the time being, so we need
                        \ to silence all three voices

 LDX value1             \ Set SID register &4 (the voice control register for
 DEX                    \ voice 1) to value1 - 1
 STX SID+&4             \
                        \ This changes bit 0 from a 1 to a 0, which turns off
                        \ voice 1 and starts the release cycle (so this
                        \ effectively terminates any music on voice 1)

 LDX value2             \ Set SID register &B (the voice control register for
 DEX                    \ voice 1) to value2 - 1
 STX SID+&B             \
                        \ This changes bit 0 from a 1 to a 0, which turns off
                        \ voice 2 and starts the release cycle (so this
                        \ effectively terminates any music on voice 2)

 LDX value3             \ Set SID register &12 (the voice control register for
 DEX                    \ voice 1) to value3 - 1
 STX SID+&12            \
                        \ This changes bit 0 from a 1 to a 0, which turns off
                        \ voice 3 and starts the release cycle (so this
                        \ effectively terminates any music on voice 3)

.BDexitirq

 RTS                    \ Return from the subroutine

 RTS                    \ This instruction has no effect as we have already
                        \ returned from the subroutine

