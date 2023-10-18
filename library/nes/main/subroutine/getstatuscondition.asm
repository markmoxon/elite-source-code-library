\ ******************************************************************************
\
\       Name: GetStatusCondition
\       Type: Subroutine
\   Category: Status
\    Summary: Calculate our ship's status condition
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   statusCondition     Our ship's status condition:
\
\                         * 0 = Docked
\
\                         * 1 = Green
\
\                         * 2 = Yellow
\
\                         * 3 = Red
\
\   X                   Also contains the status condition
\
\ ******************************************************************************

.GetStatusCondition

 LDX #0                 \ We start with a status condition of 0, which means
                        \ there is nothing to worry about

 LDY QQ12               \ Fetch the docked status from QQ12, and if we are
 BNE cond2              \ docked, jump to cond2 to return 0 ("Docked") as our
                        \ status condition

 INX                    \ We are in space, so increment X to 1 ("Green")

 LDY JUNK               \ Set Y to the number of junk items in our local bubble
                        \ of universe (where junk is asteroids, canisters,
                        \ escape pods and so on)

 LDA FRIN+2,Y           \ The ship slots at FRIN are ordered with the first two
                        \ slots reserved for the planet and sun/space station,
                        \ and then any ships, so if the slot at FRIN+2+Y is not
                        \ empty (i.e. is non-zero), then that means the number
                        \ of non-asteroids in the vicinity is at least 1

 BEQ cond2              \ So if X = 0, there are no ships in the vicinity, so
                        \ jump to cond2 to store 1 ("Green") as our status
                        \ condition

 INX                    \ Otherwise there are non-asteroids in the vicinity, so
                        \ increment X to 2 ("Yellow")

 LDY statusCondition    \ If the previous condition in statusCondition was 3
 CPY #3                 \ ("Red"), then jump to cond3
 BEQ cond3

 LDA ENERGY             \ If our energy levels are 128 or greater, jump to cond2
 BMI cond2              \ to store 2 ("Yellow") as our status condition

.cond1

                        \ If we get here then either our energy levels are less
                        \ than 128, or our previous condition was "Red" and our
                        \ energy levels are less than 160
                        \
                        \ So once our energy levels are low enough to trigger a
                        \ "Red" status, it stays that way until our energy
                        \ levels recover to a higher level

 INX                    \ Increment X to 3 ("Red")

.cond2

 STX statusCondition    \ Store our new status condition in statusCondition

 RTS                    \ Return from the subroutine

.cond3

 LDA ENERGY             \ If our energy levels are less than 160, jump to cond1
 CMP #160               \ to return a "Red" status condition
 BCC cond1

 BCS cond2              \ Jump to cond2 to return a "Yellow" status condition
                        \ (this BCS is effectively a JMP as we just passed
                        \ through a BCC)

