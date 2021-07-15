\ ******************************************************************************
\
\       Name: count_offs
\       Type: Variable
\   Category: Buying ships
\    Summary: Offsets from LASER for equipment that takes up space in the hold
\
\ ******************************************************************************

.count_offs

 EQUB 0                 \ LASER+0 = Front laser
 EQUB 1                 \ LASER+1 = Rear laser
 EQUB 2                 \ LASER+2 = Left laser
 EQUB 3                 \ LASER+3 = Right laser
 EQUB 6                 \ LASER+6 = CRGO = I.F.F. system
 EQUB 24                \ LASER+24 = ECM = E.C.M. system
 EQUB 25                \ LASER+25 = BST = Fuel scoops
 EQUB 26                \ LASER+26 = BOMB = Hyperspace unit
 EQUB 27                \ LASER+27 = ENGY = Energy unit
 EQUB 28                \ LASER+28 = DKCMP = Docking computer
 EQUB 29                \ LASER+29 = GHYP = Galactic hyperdrive
 EQUB 30                \ LASER+30 = ESCP = Escape pod

