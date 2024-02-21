\ ******************************************************************************
\
\       Name: Interrupts_b4
\       Type: Subroutine
\   Category: Start and end
\    Summary: The IRQ and NMI handler while the MMC1 mapper reset routine is
\             still running
\
\ ******************************************************************************

.Interrupts_b4

IF _NTSC

 RTI                    \ Return from the IRQ interrupt without doing anything
                        \
                        \ This ensures that while the system is starting up and
                        \ the ROM banks are in an unknown configuration, any IRQ
                        \ interrupts that go via the vector at &FFFE and any NMI
                        \ interrupts that go via the vector at &FFFA will end up
                        \ here and be dealt with
                        \
                        \ Once bank 7 is switched into &C000 by the ResetMMC1
                        \ routine, the vector is overwritten with the last two
                        \ bytes of bank 7, which point to the IRQ routine

ENDIF

