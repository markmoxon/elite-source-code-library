\ ******************************************************************************
\
\       Name: Vectors
\       Type: Variable
\   Category: Text
\    Summary: Vectors and padding at the end of the ROM bank
\
\ ******************************************************************************

 FOR I%, P%, &BFF9

  EQUB &FF              \ Pad out the rest of the ROM bank with &FF

 NEXT

 EQUW NMIRQ_MMC1+&4000  \ Vector to the NMI handler in case this bank is loaded
                        \ into &C000 during startup (the handler contains an RTI
                        \ so the interrupt is processed but has no effect)

 EQUW RESET_MMC1+&4000  \ Vector to the RESET handler in case this bank is
                        \ loaded into &C000 during startup (the handler resets
                        \ the MMC1 mapper to map bank 7 into &C000 instead)

 EQUW NMIRQ_MMC1+&4000  \ Vector to the IRQ/BRK handler in case this bank is
                        \ loaded into &C000 during startup (the handler contains
                        \ an RTI so the interrupt is processed but has no
                        \ effect)


