\ ******************************************************************************
\
\       Name: UpdateSaveCount
\       Type: Subroutine
\   Category: Save and load
\    Summary: Update the save counter for the current commander
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   A                   A is preserved
\
\ ******************************************************************************

.UpdateSaveCount

 PHA                    \ Store A on the stack so we can retrieve it below

 LDA SVC                \ If bit 7 of SVC is set, then we have already
 BMI scnt1              \ incremented the save counter for the current
                        \ commander, so jump to scnt1 to skip the following and
                        \ leave SVC alone

 CLC                    \ Set A = A + 1, to increment the save counter
 ADC #1

 CMP #100               \ If A < 100, skip the following instruction
 BCC scnt1

 LDA #0                 \ Set A = 0, so the save counter goes from zero to 100
                        \ and around back to zero again

.scnt1

 ORA #%10000000         \ Set bit 7 of A to flag the save counter as increments,
                        \ so the next call to this routine does nothing

 STA SVC                \ Store the updated save counter in SVC

 PLA                    \ Retrieve the value of A we stored on the stack above

 RTS                    \ Return from the subroutine

