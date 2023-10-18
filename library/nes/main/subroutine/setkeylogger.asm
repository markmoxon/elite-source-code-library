\ ******************************************************************************
\
\       Name: SetKeyLogger
\       Type: Subroutine
\   Category: Controllers
\    Summary: Populate the key logger table with the controller button presses
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   X                   The button number of an icon bar button if an icon bar
\                       button has been chosen (0 if no icon bar button has been
\                       chosen)
\
\   Y                   Y is preserved
\
\ ******************************************************************************

.SetKeyLogger

 TYA                    \ Store Y on the stack so we can restore it at the end
 PHA                    \ of the subroutine

                        \ We start by clearing the key logger table at KL

 LDX #5                 \ We want to clear the 6 key logger locations from
                        \ KY1 to KY6, so set a counter in X

 LDA #0                 \ Set A = 0 to store in the key logger table to clear it

 STA iconBarKeyPress    \ Set iconBarKeyPress = 0 as the default value to return
                        \ if an icon bar button has not been chosen

.klog1

 STA KL,X               \ Store 0 in the X-th byte of the key logger

 DEX                    \ Decrement the counter

 BPL klog1              \ Loop back for the next key, until we have cleared from
                        \ KY1 through KY6

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDA numberOfPilots     \ If the game is configured for one pilot, jump to klog7
 BEQ klog7              \ to skip setting the key logger for controller 2

 LDX #&FF               \ Set X to &FF to use as the non-zero value in the key
                        \ logger to indicate that a key is being pressed

 LDA controller2Down    \ If the down button is not being pressed on controller
 BPL klog2              \ 2, jump to klog2 to skip the following instruction

 STX KY5                \ The down button is being pressed on controller 2, so
                        \ set KY5 = &FF

.klog2

 LDA controller2Up      \ If the up button is not being pressed on controller 2,
 BPL klog3              \ jump to klog3 to skip the following instruction

 STX KY6                \ The up button is being pressed on controller 2, so
                        \ set KY6 = &FF

.klog3

 LDA controller2Left    \ If the left button is not being pressed on controller
 BPL klog4              \ 2, jump to klog4 to skip the following instruction

 STX KY3                \ The left button is being pressed on controller 2, so
                        \ set KY3 = &FF

.klog4

 LDA controller2Right   \ If the right button is not being pressed on controller
 BPL klog5              \ 2, jump to klog5 to skip the following instruction

 STX KY4                \ The right button is being pressed on controller 2, so
                        \ set KY4 = &FF

.klog5

 LDA controller2A       \ If the A button is not being pressed on controller 2,
 BPL klog6              \ jump to klog6 to skip the following instruction

 STX KY2                \ The A button is being pressed on controller 2, so
                        \ set KY2 = &FF

.klog6

 LDA controller2B       \ If the B button is not being pressed on controller 2,
 BPL klog13             \ 2, jump to klog13 to scan the A button on controller 1
                        \ and return from the subroutine

 STX KY1                \ The B button is being pressed on controller 2, so
                        \ set KY1 = &FF

 BMI klog13             \ Jump to klog13 to scan the A button on controller 1
                        \ and return from the subroutine

.klog7

 LDX #&FF               \ Set X to &FF to use as the non-zero value in the key
                        \ logger to indicate that a key is being pressed

 LDA controller1B       \ If the B button is being pressed on controller 1, jump
 BMI klog11             \ to klog11 to skip recording the direction keys in KY3
                        \ to KY4, and just record the up and down buttons in KY2
                        \ and KY3

 LDA controller1Down    \ If the down button is not being pressed on controller
 BPL klog8              \ 1, jump to klog8 to skip the following instruction

 STX KY5                \ The down button is being pressed on controller 1 (and
                        \ the B button is not being pressed), so set KY5 = &FF

.klog8

 LDA controller1Up      \ If the up button is not being pressed on controller 1,
 BPL klog9              \ jump to klog9 to skip the following instruction

 STX KY6                \ The up button is being pressed on controller 1 (and
                        \ the B button is not being pressed), so set KY6 = &FF

.klog9

 LDA controller1Left    \ If the left button is not being pressed on controller
 BPL klog10             \ 1, jump to klog10 to skip the following instruction

 STX KY3                \ The left button is being pressed on controller 1 (and
                        \ the B button is not being pressed), so set KY3 = &FF

.klog10

 LDA controller1Right   \ If the right button is not being pressed on controller
 BPL klog13             \ 1, jump to klog13 to skip the following instruction

 STX KY4                \ The right button is being pressed on controller 1 (and
                        \ the B button is not being pressed), so set KY4 = &FF

 BMI klog13             \ Jump to klog13 to scan the A button on controller 1
                        \ and return from the subroutine

.klog11

 LDA controller1Up      \ If the up button is not being pressed on controller 1,
 BPL klog12             \ jump to klog12 to skip the following instruction

 STX KY2                \ The up button is being pressed on controller 2, and so
                        \ is the B button, so set KY2 = &FF

.klog12

 LDA controller1Down    \ If the down button is not being pressed on controller
 BPL klog13             \ 1, jump to klog13 to skip the following instruction

 STX KY1                \ The down button is being pressed on controller 1, and
                        \ so is the B button, so set KY1 = &FF

.klog13

 LDA controller1A       \ If the A button is being pressed on controller 1 but
 CMP #%10000000         \ wasn't being pressed before, shift a 1 into bit 7 of
 ROR KY7                \ KY7 (as A = %10000000), otherwise shift a 0

 LDX #0                 \ Copy the value of iconBarChoice to iconBarKeyPress and
 LDA iconBarChoice      \ set iconBarChoice = 0, so if an icon bar button is
 STX iconBarChoice      \ chosen then the first time it is pressed we return the
 STA iconBarKeyPress    \ button number, and if it is pressed again, we return 0
                        \
                        \ This lets us use the Start button to toggle the pause
                        \ menu on and off, for example

 PLA                    \ Restore the value of Y that we stored on the stack, so
 TAY                    \ that Y is preserved

 LDA iconBarKeyPress    \ Set X = iconBarKeyPress to return the icon bar button
 TAX                    \ number from the subroutine, if any

 RTS                    \ Return from the subroutine

