\ ******************************************************************************
\
\       Name: Cartridge WRAM
\       Type: Workspace
\    Address: &6000 to &7FFF
\   Category: Workspaces
\    Summary: The 8K of battery-backed RAM in the Elite cartridge, which is used
\             for the graphics buffers and storing saved commanders
\
\ ******************************************************************************

 ORG &6000

INCLUDE "library/nes/main/variable/pattbuffer0.asm"
INCLUDE "library/nes/main/variable/pattbuffer1.asm"
INCLUDE "library/nes/main/variable/namebuffer0.asm"
INCLUDE "library/nes/main/variable/attrbuffer0.asm"
INCLUDE "library/nes/main/variable/namebuffer1.asm"
INCLUDE "library/nes/main/variable/attrbuffer1.asm"
INCLUDE "library/nes/main/variable/currentslot.asm"
INCLUDE "library/nes/main/variable/saveslotpart1.asm"
INCLUDE "library/nes/main/variable/saveslotpart2.asm"
INCLUDE "library/nes/main/variable/saveslotpart3.asm"

 SKIP 40                \ These bytes appear to be unused

