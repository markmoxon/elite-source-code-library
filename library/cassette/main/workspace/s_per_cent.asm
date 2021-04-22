\ ******************************************************************************
\
\       Name: S%
\       Type: Workspace
IF _CASSETTE_VERSION \ Comment
\    Address: &0F40 to &0F50
ELIF _ELECTRON_VERSION
\    Address: &0D00 to &0D24
ENDIF
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

IF _ELECTRON_VERSION \ Platform

 EQUB &40               \ This gets set to &40 by elite-loader.asm ???

.L0D01

 EQUB 0                 \ ???

 EQUW 0                 \ Gets set to the original value of IRQ1V by
                        \ elite-loader.asm

 EQUW 0                 \ Gets set to the original value of KEYV by
                        \ elite-loader.asm

.L0D06

 EQUW 0                 \ ???

ENDIF

IF _CASSETTE_VERSION \ Comment

 EQUW TT170             \ The entry point for the main game; once the main code
                        \ has been loaded, decrypted and moved to the right
                        \ place by elite-loader.asm, the game is started by a
                        \ JMP (S%) instruction, which jumps to the main entry
                        \ point at TT170 via this location

ELIF _ELECTRON_VERSION

 EQUW TT170             \ The entry point for the main game; once the main code
                        \ has been loaded, decrypted and moved to the right
                        \ place by elite-loader.asm, the game is started by a
                        \ JMP (S%+8) instruction, which jumps to the main entry
                        \ point at TT170 via this location

ENDIF

 EQUW TT26              \ WRCHV is set to point here by elite-loader.asm

 EQUW IRQ1              \ IRQ1V is set to point here by elite-loader.asm

 EQUW BR1               \ BRKV is set to point here by elite-loader.asm

IF _ELECTRON_VERSION \ Platform

.KEY1

 PHP                    \ KEYV jumps here, as set by elite-loader.asm ???

 BIT &0D01
 BMI P%+4
 PLP
 RTS

 PLP

 JMP (S%+4)             \ Jump to the original value of KEYV to process the key
                        \ press as normal

ENDIF

INCLUDE "library/common/main/variable/comc.asm"
INCLUDE "library/common/main/variable/dnoiz.asm"
INCLUDE "library/common/main/variable/damp.asm"
INCLUDE "library/common/main/variable/djd.asm"
INCLUDE "library/common/main/variable/patg.asm"
INCLUDE "library/common/main/variable/flh.asm"
INCLUDE "library/common/main/variable/jstgy.asm"
INCLUDE "library/common/main/variable/jste.asm"
INCLUDE "library/common/main/variable/jstk.asm"

