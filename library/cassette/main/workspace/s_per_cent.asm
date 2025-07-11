\ ******************************************************************************
\
\       Name: S%
\       Type: Workspace
\    Address: &0F40 to &0F50
\   Category: Workspaces
\    Summary: Vector addresses, compass colour and configuration settings
\
\ ------------------------------------------------------------------------------
\
\ Contains addresses that are used by the loader to set up vectors, the current
\ compass colour, and the game's configuration settings.
\
\ ******************************************************************************

.S%

 EQUW TT170             \ The entry point for the main game; once the main code
                        \ has been loaded, decrypted and moved to the right
                        \ place by elite-loader.asm, the game is started by a
                        \ JMP (S%) instruction, which jumps to the main entry
                        \ point at TT170 via this location

 EQUW TT26              \ WRCHV is set to the address in these two bytes by
                        \ elite-loader.asm, so WRCHV points to TT26

 EQUW IRQ1              \ IRQ1V is set to the address in these two bytes by
                        \ elite-loader.asm, so IRQ1V points to IRQ1

 EQUW BR1               \ BRKV is set to the address in these two bytes by
                        \ elite-loader.asm, so BRKV points to BR1

INCLUDE "library/common/main/variable/comc.asm"
INCLUDE "library/common/main/variable/dnoiz.asm"
INCLUDE "library/common/main/variable/damp.asm"
INCLUDE "library/common/main/variable/djd.asm"
INCLUDE "library/common/main/variable/patg.asm"
INCLUDE "library/common/main/variable/flh.asm"
INCLUDE "library/common/main/variable/jstgy.asm"
INCLUDE "library/common/main/variable/jste.asm"
INCLUDE "library/common/main/variable/jstk.asm"

 PRINT "S% workspace from ", ~S%, "to ", ~P%-1, "inclusive"

