\ ******************************************************************************
\
\       Name: UNMUTILATE
\       Type: Variable
\   Category: Save and load
\    Summary: Decrypt the commander file in the buffer at comfil
\
\ ******************************************************************************

.UNMUTILATE

 LDY #3                 \ To decrypt the commander file, we need to set the four
                        \ random number seeds at RAND to RAND+3 to the four
                        \ bytes at comfil2 in the encrypted commander file, so
                        \ set a byte counter in Y to copy four bytes

.MUTIL2

 LDA comfil2,Y          \ Copy the Y-th seed from the commander file to the Y-th
 STA RAND,Y             \ random number seed at RAND

 DEY                    \ Decrement the byte counter

 BPL MUTIL2             \ Loop back until we have copied all four bytes

 BMI MUTIL3             \ Jump to MUTIL3 to apply the decryption process to the
                        \ commander file, which is simply a repeat of the
                        \ encryption process with the same seeds (this BMI is
                        \ effectively a JMP as we just passed through a BPL)

