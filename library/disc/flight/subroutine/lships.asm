\ ******************************************************************************
\
\       Name: LSHIPS
\       Type: Subroutine
\   Category: Loader
\    Summary: Load a new ship blueprints file
\
\ ******************************************************************************

.LSHIPS

 JSR THERE              \ Call THERE to see if we are in the Constrictor's
                        \ system in mission 1

 LDA #6                 \ Set A to the number of the ship blueprints file
                        \ containing the Constrictor (ship blueprints file G)

 BCS SHIPinA            \ If the C flag is set then we are in the Constrictor's
                        \ system, so skip to SHIPinA

 JSR DORND              \ Set A and X to random numbers and reduce A to a
 AND #3                 \ random number in the range 0-3 (i.e. just bits 0-1)

 LDX gov                \ If the system's government type is 0-2 (anarchy,
 CPX #3                 \ feudal or multi-government), shift a 0 into bit 0 of
 ROL A                  \ A, otherwise shift a 1

 LDX tek                \ If the system's tech level is 0-9, shift a 0 into bit
 CPX #10                \ 0 of A, otherwise shift a 1
 ROL A

                        \ By this point, A is:
                        \
                        \   * Bit 0    = 0 for low tech level (Coriolis station)
                        \                1 for high tech level (Dodo station)
                        \   * Bit 1    = 0 for more dangerous systems
                        \                1 for safer systems
                        \   * Bit 2    = random
                        \   * Bit 3    = random
                        \   * Bits 4-7 = 0
                        \
                        \ So A is in the range 0-15, which corresponds to the
                        \ appropriate ship blueprints file (where 0 is file
                        \ D.MOA and 15 is file D.MOP)

 TAX                    \ Store A in X so we can retrieve it after the mission 2
                        \ progress check

 LDA TP                 \ If mission 2 has started and we have picked up the
 AND #%00001100         \ plans, then bits 2-3 of TP will be %10, so this jumps
 CMP #%00001000         \ to TPnot8 if this is not the case
 BNE TPnot8

 TXA                    \ Retrieve the value of A we calculated above

 AND #%00000001         \ We have picked up the plans in mission 2 so we need to
 ORA #%00000010         \ load a ship blueprints file containing Thargoids, so
                        \ set A to either 

 TAX                    \ Store the amended A in X again

.TPnot8

 TXA                    \ Retrieve the value of A we calculated above

.SHIPinA

 CLC                    \ Convert A from 0-15 to 'A' to 'P'
 ADC #'A'

 STA SHIPI+6            \ Store the letter of the ship blueprints file we want
                        \ in the sixth byte of the command string at SHIPI, so
                        \ it overwrites the "0" in "D.MO0" with the file letter
                        \ to load, from D.MOA to D.MOP

 JSR CATD               \ Call CATD to reload the disc catalogue

 LDX #LO(SHIPI)         \ Set (Y X) to point to the OS command at SHIPI, which
 LDY #HI(SHIPI)         \ loads the relevant ship blueprints file

 JMP OSCLI              \ Call OSCLI to execute the OS command at (Y X), which
                        \ loads the relevant ship blueprints file, and return
                        \ from the subroutine using a tail call

