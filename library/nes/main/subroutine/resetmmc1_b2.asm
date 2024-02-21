\ ******************************************************************************
\
\       Name: ResetMMC1_b2
\       Type: Subroutine
\   Category: Start and end
\    Summary: The MMC1 mapper reset routine at the start of the ROM bank
\  Deep dive: Splitting NES Elite across multiple ROM banks
\
\ ------------------------------------------------------------------------------
\
\ When the NES is switched on, it is hardwired to perform a JMP (&FFFC). At this
\ point, there is no guarantee as to which ROM banks are mapped to &8000 and
\ &C000, so to ensure that the game starts up correctly, we put the same code
\ in each ROM at the following locations:
\
\   * We put &C000 in address &FFFC in every ROM bank, so the NES always jumps
\     to &C000 when it starts up via the JMP (&FFFC), irrespective of which
\     ROM bank is mapped to &C000.
\
\   * We put the same reset routine (this routine, ResetMMC1) at the start of
\     every ROM bank, so the same routine gets run, whichever ROM bank is mapped
\     to &C000.
\
\ This ResetMMC1 routine is therefore called when the NES starts up, whatever
\ the bank configuration ends up being. It then switches ROM bank 7 to &C000 and
\ jumps into bank 7 at the game's entry point BEGIN, which starts the game.
\
\ ******************************************************************************

.ResetMMC1_b2

 SEI                    \ Disable interrupts

 INC &C006              \ Reset the MMC1 mapper, which we can do by writing a
                        \ value with bit 7 set into any address in ROM space
                        \ (i.e. any address from &8000 to &FFFF)
                        \
                        \ The INC instruction does this in a more efficient
                        \ manner than an LDA/STA pair, as it:
                        \
                        \   * Fetches the contents of address &C006, which
                        \     contains the high byte of the JMP destination
                        \     below, i.e. the high byte of BEGIN, which is &C0
                        \
                        \   * Adds 1, to give &C1
                        \
                        \   * Writes the value &C1 back to address &C006
                        \
                        \ &C006 is in the ROM space and &C1 has bit 7 set, so
                        \ the INC does all that is required to reset the mapper,
                        \ in fewer cycles and bytes than an LDA/STA pair
                        \
                        \ Resetting MMC1 maps bank 7 to &C000 and enables the
                        \ bank at &8000 to be switched, so this instruction
                        \ ensures that bank 7 is present

 JMP BEGIN              \ Jump to BEGIN in bank 7 to start the game

