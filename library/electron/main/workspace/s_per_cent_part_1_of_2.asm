\ ******************************************************************************
\
\       Name: S% (Part 1 of 2)
\       Type: Workspace
\    Address: &0D00 to &0D0F
\   Category: Workspaces
\    Summary: Vector addresses, compass shape and configuration settings
\
\ ------------------------------------------------------------------------------
\
\ Contains addresses that are used by the loader to set up vectors, the current
\ compass shape, and the game's configuration settings.
\
\ ******************************************************************************

.S%

 RTI                    \ The S% workspace lives at &0D00, which is the NMI
                        \ workspace. We claimed the NMI workspace for our own
                        \ use as part of the loading process, and the RTI makes
                        \ sure we return from any spurious NMIs that still call
                        \ this location

.KEYB

 EQUB 0                 \ This flag indicates whether we are currently reading
                        \ from the keyboard using OSRDCH or OSWORD, so the
                        \ keyboard interrupt handler at KEY1 knows whether to
                        \ pass key presses on to the OS
                        \
                        \   * 0 = we are not reading from the keyboard with an
                        \         OS command
                        \
                        \   * &FF = we are currently reading from the keyboard
                        \           with an OS command

 EQUW 0                 \ Gets set to the original value of IRQ1V by
                        \ elite-loader.asm

 EQUW 0                 \ Gets set to the original value of KEYV by
                        \ elite-loader.asm

 EQUW 0                 \ This flag is flipped between 0 and &FF every time the
                        \ interrupt routine at IRQ1 is called, so we can save
                        \ some time by skipping every other interrupt (see the
                        \ IRQ1 routine for details)

 EQUW TT170             \ The entry point for the main game; once the main code
                        \ has been loaded, decrypted and moved to the right
                        \ place by elite-loader.asm, the game is started by a
                        \ JMP (S%+8) instruction, which jumps to the main entry
                        \ point at TT170 via this location

 EQUW TT26              \ WRCHV is set to the address in these two bytes by
                        \ elite-loader.asm, so WRCHV points to TT26

 EQUW IRQ1              \ IRQ1V is set to the address in these two bytes by
                        \ elite-loader.asm, so IRQ1V points to IRQ1

 EQUW BR1               \ BRKV is set to the address in these two bytes by
                        \ elite-loader.asm, so BRKV points to BR1

