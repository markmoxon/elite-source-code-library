\ ******************************************************************************
\
\       Name: iconBarButtons
\       Type: Variable
\   Category: Icon bar
\    Summary: A list of button numbers for each icon bar type
\
\ ******************************************************************************

.iconBarButtons

                        \ Icon bar 0 (Docked)

 EQUB  1                \ Launch
 EQUB  2                \ Market Price
 EQUB  3                \ Status Mode
 EQUB  4                \ Charts
 EQUB  5                \ Equip Ship
 EQUB  6                \ Save and Load
 EQUB  7                \ Change Commander Name (only on save screen)
 EQUB 35                \ Data on System
 EQUB  8                \ Inventory
 EQUB  0                \ (blank)
 EQUB  0                \ (blank)
 EQUB 12                \ Fast-forward

 EQUD  0

                        \ Icon bar 1 (Flight)

 EQUB 17                \ Docking Computer
 EQUB  2                \ Market Price
 EQUB  3                \ Status Mode
 EQUB  4                \ Charts
 EQUB 21                \ Front Space View (and rear, left, right)
 EQUB 22                \ Hyperspace (only when system is selected)
 EQUB 23                \ E.C.M. (if fitted)
 EQUB 24                \ Target Missile
 EQUB 25                \ Fire Targeted Missile
 EQUB 26                \ Energy Bomb (if fitted)
 EQUB 27                \ Escape Pod (if fitted)
 EQUB 12                \ Fast-forward

 EQUD  0

                        \ Icon bar 2 (Charts)

 EQUB  1                \ Launch
 EQUB  2                \ Market Price
 EQUB 36                \ Switch Chart Range (long, short)
 EQUB 35                \ Data on System
 EQUB 21                \ Front Space View (only in flight)
 EQUB 38                \ Return Pointer to Current System
 EQUB 39                \ Search for System
 EQUB 22                \ Hyperspace (only when system is selected)
 EQUB 41                \ Galactic Hyperspace (if fitted)
 EQUB 23                \ E.C.M. (if fitted)
 EQUB 27                \ Escape Pod (if fitted)
 EQUB 12                \ Fast-forward

 EQUD  0

                        \ Icon bar 3 (Pause)

 EQUB 49                \ Direction of y-axis
 EQUB 50                \ Damping toggle
 EQUB 51                \ Music toggle
 EQUB 52                \ Sound toggle
 EQUB 53                \ Number of Pilots
 EQUB  0                \ (blank)
 EQUB  0                \ (blank)
 EQUB  0                \ (blank)
 EQUB  0                \ (blank)
 EQUB  0                \ (blank)
 EQUB  0                \ (blank)
 EQUB 60                \ Restart

 EQUD  0

