\ ******************************************************************************
\
\       Name: TALLYFRAC
\       Type: Variable
\   Category: Status
\    Summary: Fractional kills awarded for killing each type of ship (not used)
\
\ ------------------------------------------------------------------------------
\
\ Gets added to L1266 for destroying ship, L1266 is not used anywhere
\ See EXNO3, ADC &8062,X
\
\ Looks like it's similar to the fractional kill table from C64
\ http://www.elitehomepage.org/faq.htm#A4
\
\ ******************************************************************************

.TALLYFRAC

 EQUB &95               \ Missile
 EQUB 0                 \ Coriolis space station
 EQUB 16                \ Escape pod
 EQUB 10                \ Alloy plate
 EQUB 10                \ Cargo canister
 EQUB 6                 \ Boulder
 EQUB 8                 \ Asteroid
 EQUB 10                \ Splinter
 EQUB 16                \ Shuttle
 EQUB 17                \ Transporter
 EQUB 234               \ Cobra Mk III
 EQUB 170               \ Python
 EQUB 213               \ Boa
 EQUB 0                 \ Anaconda
 EQUB 85                \ Rock hermit (asteroid)
 EQUB 26                \ Viper
 EQUB 85                \ Sidewinder
 EQUB 128               \ Mamba
 EQUB 85                \ Krait
 EQUB 90                \ Adder
 EQUB 85                \ Gecko
 EQUB 170               \ Cobra Mk I
 EQUB 50                \ Worm
 EQUB 42                \ Cobra Mk III (pirate)
 EQUB 21                \ Asp Mk II
 EQUB 42                \ Python (pirate)
 EQUB 64                \ Fer-de-lance
 EQUB 192               \ Moray
 EQUB 170               \ Thargoid
 EQUB 33                \ Thargon
 EQUB 85                \ Constrictor
 EQUB 85                \ Cougar
 EQUB 0                 \ Dodecahedron ("Dodo") space station

