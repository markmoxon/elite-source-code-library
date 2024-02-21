\ ******************************************************************************
\
\       Name: Vectors_b6
\       Type: Variable
\   Category: Utility routines
\    Summary: Vectors and padding at the end of ROM bank 6
\  Deep dive: Splitting NES Elite across multiple ROM banks
\
\ ******************************************************************************

 FOR I%, P%, &BFF9

  EQUB &FF              \ Pad out the rest of the ROM bank with &FF

 NEXT

IF _NTSC

 EQUW Interrupts_b6+&4000   \ Vector to the NMI handler in case this bank is
                            \ loaded into &C000 during start-up (the handler
                            \ contains an RTI so the interrupt is processed but
                            \ has no effect)

 EQUW ResetMMC1_b6+&4000    \ Vector to the RESET handler in case this bank is
                            \ loaded into &C000 during start-up (the handler
                            \ resets the MMC1 mapper to map bank 7 into &C000
                            \ instead)

 EQUW Interrupts_b6+&4000   \ Vector to the IRQ/BRK handler in case this bank is
                            \ loaded into &C000 during start-up (the handler
                            \ contains an RTI so the interrupt is processed but
                            \ has no effect)

ELIF _PAL

 EQUW NMI                   \ Vector to the NMI handler

 EQUW ResetMMC1_b6+&4000    \ Vector to the RESET handler in case this bank is
                            \ loaded into &C000 during start-up (the handler
                            \ resets the MMC1 mapper to map bank 7 into &C000
                            \ instead)

 EQUW IRQ                   \ Vector to the IRQ/BRK handler

ENDIF

