\ ******************************************************************************
\
\       Name: PRXS
\       Type: Variable
\   Category: Equipment
\    Summary: Equipment prices
\
\ ------------------------------------------------------------------------------
\
\ Equipment prices are stored as 10 * the actual value, so we can support prices
\ with fractions of credits (0.1 Cr). This is used for the price of fuel only.
\
\ ******************************************************************************

.PRXS

IF NOT(_ELITE_A_VERSION)
 EQUW 1                 \ 0  Fuel, calculated in EQSHP  140.0 Cr (full tank)
 EQUW 300               \ 1  Missile                     30.0 Cr
 EQUW 4000              \ 2  Large Cargo Bay            400.0 Cr
 EQUW 6000              \ 3  E.C.M. System              600.0 Cr
 EQUW 4000              \ 4  Extra Pulse Lasers         400.0 Cr
 EQUW 10000             \ 5  Extra Beam Lasers         1000.0 Cr
 EQUW 5250              \ 6  Fuel Scoops                525.0 Cr
 EQUW 10000             \ 7  Escape Pod                1000.0 Cr
 EQUW 9000              \ 8  Energy Bomb                900.0 Cr
 EQUW 15000             \ 9  Energy Unit               1500.0 Cr
 EQUW 10000             \ 10 Docking Computer          1000.0 Cr
 EQUW 50000             \ 11 Galactic Hyperspace       5000.0 Cr
ENDIF
IF _6502SP_VERSION OR _DISC_DOCKED OR _MASTER_VERSION \ Enhanced: The equipment prices table in the enhanced versions contains prices for the two new laser types: military lasers at 6000 Cr each, and mining lasers at 800 Cr each
 EQUW 60000             \ 12 Extra Military Lasers     6000.0 Cr
 EQUW 8000              \ 13 Extra Mining Lasers        800.0 Cr
ENDIF

IF _ELITE_A_VERSION

 EQUW &0001
 \ 00 Cobra 3, Boa
 EQUW   250,  4000,  6000,  4000, 10000,  5250, 3000
 EQUW  5500, 15000, 15000, 50000, 30000,  2500
 \ 1A Adder, Cobra 1, Python
 EQUW   250,  2000,  4000,  2000,  4500,  3750, 2000
 EQUW  3750,  9000,  8000, 30000, 23000,  2500
 \ 34 Fer-de-Lance, Asp 2
 EQUW   250,  4000,  5000,  5000, 10000,  7000, 6000
 EQUW  4000, 25000, 10000, 40000, 50000,  2500
 \ 4E Monitor, Anaconda
 EQUW   250,  3000,  8000,  6000,  8000,  6500, 4500
 EQUW  8000, 19000, 20000, 60000, 25000,  2500
 \ 68 Moray, Ophidian
 EQUW   250,  1500,  3000,  3500,  7000,  4500, 2500
 EQUW  4500,  7000,  7000, 30000, 19000,  2500

ENDIF

