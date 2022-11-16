\ ******************************************************************************
\
\       Name: PROT1
\       Type: Subroutine
\   Category: Copy protection
\    Summary: Part of the CHKSM copy protection checksum calculation
\
\ ******************************************************************************

.PROT1

 LDA #85                \ We start by calculating a checksum in A, with an
                        \ initial value of 85

 LDX #64                \ The checksum calculation in CHECK gets run 65 times,
                        \ so set a counter in X to count them

.p1a

 JSR CHECK              \ Call CHECK to calculate the checksum and add it to A

 DEX                    \ Decrement the loop counter

 BPL p1a                \ Loop back until we have run the checksum 65 times

 STA RAND+2             \ Store the checksum result in the random number seeds
                        \ used to generate the Saturn

 ORA #0                 \ If bit 7 of the checksum is clear, skip to p1b
 BPL p1b

 LSR CHKSM              \ Bit 7 of the checksum is set, so shift the C flag that
                        \ was returned by CHECK into bit 7 of CHKSM

.p1b

 JMP PROT2              \ Jump to PROT2 for more checksums, returning from the
                        \ subroutine using a tail call

