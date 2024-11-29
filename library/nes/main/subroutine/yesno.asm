\ ******************************************************************************
\
\       Name: YESNO
\       Type: Subroutine
\   Category: Controllers
\    Summary: Display "YES" or "NO" and wait until one is chosen
\
\ ------------------------------------------------------------------------------
\
\ This routine does a similar job to the routine of the same name in the BBC
\ Master version of Elite, but the code is significantly different.
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   A                   The result:
\
\                         * 1 if "YES" was chosen
\
\                         * 2 if "NO" was chosen
\
\ ******************************************************************************

.YESNO

 LDA fontStyle          \ Store the current font style on the stack, so we can
 PHA                    \ restore it when we return from the subroutine

 LDA #2                 \ Set the font style to print in the highlight font
 STA fontStyle

 LDA #1                 \ Push a value of 1 onto the stack, so the following
 PHA                    \ prints extended token 1 ("YES")

.yeno1

 JSR CLYNS              \ Clear the bottom two text rows of the upper screen,
                        \ and move the text cursor to the first cleared row

 LDA #15                \ Move the text cursor to column 15
 STA XC

 PLA                    \ Print the extended token whose number is on the stack,
 PHA                    \ so this will be "YES" (token 1) or "NO" (token 2)
 JSR DETOK_b2

 JSR DrawMessageInNMI   \ Configure the NMI to display the YES/NO message that
                        \ we just printed

 LDA controller1A       \ If the A button is being pressed on the controller,
 BMI yeno3              \ jump to yeno3 to record the choice

 LDA controller1Up      \ If neither the up nor down arrow is being pressed on
 ORA controller1Down    \ the controller, jump to yeno2 to pause and loop back
 BPL yeno2              \ to keep waiting for a choice to be made

                        \ If we get here then either the up or down arrow is
                        \ being pressed, so we toggle the on-screen choice
                        \ between "YES" and "NO"

 PLA                    \ Flip the value on the top of the stack between 1 and 2
 EOR #3                 \ by EOR'ing with 3, which toggles the token between
 PHA                    \ "YES" and "NO"

.yeno2

 LDY #8                 \ Wait until eight NMI interrupts have passed (i.e. the
 JSR DELAY              \ next eight VBlanks)

 JMP yeno1              \ Loop back to print "YES" or NO" and wait for a choice

.yeno3

 LDA #0                 \ Reset the key logger entry for the icon bar button
 STA iconBarKeyPress    \ choice to clear any icon bar choices that might have
                        \ been processed in the background (via the pause menu,
                        \ for example)

 STA controller1A       \ Reset the key logger for the A button as we have
                        \ consumed the button press

 PLA                    \ Set X to the value from the top of the stack, which
 TAX                    \ will be 1 for "YES" or 2 for "NO", giving us our
                        \ result to return

 PLA                    \ Restore the font style that we stored on the stack
 STA fontStyle          \ so it's unchanged by the routine

 TXA                    \ Copy X to A, so we return the result in both A and X

 RTS                    \ Return from the subroutine

