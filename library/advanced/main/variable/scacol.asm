\ ******************************************************************************
\
\       Name: scacol
\       Type: Variable
\   Category: Drawing ships
\    Summary: Ship colours on the scanner
\  Deep dive: The elusive Cougar
\
\ ******************************************************************************

.scacol

 EQUB 0

IF NOT(_NES_VERSION)

 EQUB YELLOW2           \ Missile
 EQUB GREEN2            \ Coriolis space station
 EQUB BLUE2             \ Escape pod
 EQUB BLUE2             \ Alloy plate
 EQUB BLUE2             \ Cargo canister
 EQUB RED2              \ Boulder
 EQUB RED2              \ Asteroid
 EQUB RED2              \ Splinter
 EQUB CYAN2             \ Shuttle
 EQUB CYAN2             \ Transporter
 EQUB CYAN2             \ Cobra Mk III
 EQUB MAG2              \ Python
 EQUB MAG2              \ Boa
 EQUB MAG2              \ Anaconda
 EQUB RED2              \ Rock hermit (asteroid)
 EQUB CYAN2             \ Viper
 EQUB CYAN2             \ Sidewinder
 EQUB CYAN2             \ Mamba
 EQUB CYAN2             \ Krait
 EQUB CYAN2             \ Adder
 EQUB CYAN2             \ Gecko
 EQUB CYAN2             \ Cobra Mk I
 EQUB BLUE2             \ Worm
 EQUB CYAN2             \ Cobra Mk III (pirate)
 EQUB CYAN2             \ Asp Mk II
 EQUB MAG2              \ Python (pirate)
 EQUB CYAN2             \ Fer-de-lance
 EQUB CYAN2             \ Moray
 EQUB WHITE2            \ Thargoid
 EQUB CYAN2             \ Thargon
 EQUB CYAN2             \ Constrictor
ENDIF
IF _6502SP_VERSION \ Master: In the Master version, the Cougar has a cloaking device that hides it from the scanner, unlike in the 6502 Second Processor version, where the Cougar appears on the scanner in cyan
 EQUB 0                 \ The Elite logo
 EQUB CYAN2             \ Cougar
ELIF _MASTER_VERSION
 EQUB 0                 \ Cougar

 EQUB CYAN2             \ This byte appears to be unused
ENDIF

IF _NES_VERSION

 EQUB 3                 \ Missile
 EQUB 0                 \ Coriolis space station
 EQUB 1                 \ Escape pod
 EQUB 1                 \ Alloy plate
 EQUB 1                 \ Cargo canister
 EQUB 1                 \ Boulder
 EQUB 1                 \ Asteroid
 EQUB 1                 \ Splinter
 EQUB 2                 \ Shuttle
 EQUB 2                 \ Transporter
 EQUB 2                 \ Cobra Mk III
 EQUB 2                 \ Python
 EQUB 2                 \ Boa
 EQUB 2                 \ Anaconda
 EQUB 1                 \ Rock hermit (asteroid)
 EQUB 2                 \ Viper
 EQUB 2                 \ Sidewinder
 EQUB 2                 \ Mamba
 EQUB 2                 \ Krait
 EQUB 2                 \ Adder
 EQUB 2                 \ Gecko
 EQUB 2                 \ Cobra Mk I
 EQUB 2                 \ Worm
 EQUB 2                 \ Cobra Mk III (pirate)
 EQUB 2                 \ Asp Mk II
 EQUB 2                 \ Python (pirate)
 EQUB 2                 \ Fer-de-lance
 EQUB 2                 \ Moray
 EQUB 0                 \ Thargoid
 EQUB 3                 \ Thargon
 EQUB 2                 \ Constrictor
 EQUB 255               \ Cougar

 EQUB 0                 \ This byte appears to be unused

ENDIF

 EQUD 0                 \ These bytes appear to be unused

