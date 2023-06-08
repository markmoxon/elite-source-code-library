\ ******************************************************************************
\
\       Name: shpcol
\       Type: Variable
\   Category: Drawing ships
\    Summary: Ship colours
\
\ ******************************************************************************

.shpcol

 EQUB 0

 EQUB YELLOW            \ Missile
 EQUB CYAN              \ Coriolis space station
 EQUB CYAN              \ Escape pod
 EQUB CYAN              \ Alloy plate
 EQUB CYAN              \ Cargo canister
 EQUB RED               \ Boulder
 EQUB RED               \ Asteroid
 EQUB RED               \ Splinter
 EQUB CYAN              \ Shuttle
 EQUB CYAN              \ Transporter
 EQUB CYAN              \ Cobra Mk III
 EQUB CYAN              \ Python
 EQUB CYAN              \ Boa
 EQUB CYAN              \ Anaconda
 EQUB RED               \ Rock hermit (asteroid)
 EQUB CYAN              \ Viper
 EQUB CYAN              \ Sidewinder
 EQUB CYAN              \ Mamba
 EQUB CYAN              \ Krait
 EQUB CYAN              \ Adder
 EQUB CYAN              \ Gecko
 EQUB CYAN              \ Cobra Mk I
 EQUB CYAN              \ Worm
 EQUB CYAN              \ Cobra Mk III (pirate)
 EQUB CYAN              \ Asp Mk II
 EQUB CYAN              \ Python (pirate)
 EQUB CYAN              \ Fer-de-lance
 EQUB %11001001         \ Moray (colour 3, 2, 0, 1 = cyan/red/black/yellow)
 EQUB WHITE             \ Thargoid
 EQUB WHITE             \ Thargon
 EQUB CYAN              \ Constrictor
IF _6502SP_VERSION \ Comment
 EQUB CYAN              \ The Elite logo
 EQUB CYAN              \ Cougar
ELIF _MASTER_VERSION
 EQUB CYAN              \ Cougar

 EQUB CYAN              \ This byte appears to be unused
ENDIF

