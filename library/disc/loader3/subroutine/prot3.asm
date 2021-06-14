\ ******************************************************************************
\
\       Name: PROT3
\       Type: Subroutine
\   Category: Copy protection
\    Summary: Part of the CHKSM copy protection checksum calculation
\
\ ******************************************************************************

.PROT3

 LDA CHKSM              \ Update the checksum
 AND CHKSM+1
 ORA #&0C
 ASL A
 STA CHKSM

 RTS                    \ Return from the subroutine

IF NOT(_ELITE_A_VERSION)

 JMP P%                 \ This would hang the computer, but we never get here as
                        \ the checksum code has been disabled

ENDIF

