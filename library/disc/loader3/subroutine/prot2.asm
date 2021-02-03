\ ******************************************************************************
\
\       Name: PROT2
\       Type: Subroutine
\   Category: Copy protection
\    Summary: Part of the CHKSM copy protection checksum calculation
\
\ ******************************************************************************

.PROT2

 LDA RAND+2             \ Fetch the checksum we calculated in PROT1

 EOR CHKSM              \ Set A = A EOR CHKSM

 ASL A                  \ Shift A left, moving bit 7 into the C flag and
                        \ clearing bit 0

 CMP #147               \ If A >= 147, set the C flag, otherwise clear it

 ROR A                  \ Shift A right, moving the C flag into bit 7 and
                        \ clearing the C flag

 STA CHKSM              \ Store the updated A in CHKSM

 BCC out                \ Return from the subroutine (as we cleared the C flag
                        \ above and out contains an RTS)

