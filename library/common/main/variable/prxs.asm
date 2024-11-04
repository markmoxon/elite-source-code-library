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
IF _ELITE_A_VERSION
\ Different ships have different equipment prices (apart from fuel which is the
\ same price for all ships). Each ship type has an offset that is used when
\ accessing this table; the offset to the price table for our current ship is
\ held in the new_costs variable, and the offset values for all the different
\ ships we can buy are defined in the new_details table.
\
ENDIF
\ ******************************************************************************

.PRXS

IF NOT(_ELITE_A_VERSION OR _NES_VERSION)
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
ELIF _NES_VERSION
 EQUW 2                 \ 0  Fuel                         0.2 Cr (per 0.1 LY)
 EQUW 300               \ 1  Missile                     30.0 Cr
 EQUW 4000              \ 2  Large Cargo Bay            400.0 Cr
 EQUW 6000              \ 3  E.C.M. System              600.0 Cr
 EQUW 4000              \ 4  Extra Pulse Lasers         400.0 Cr
 EQUW 10000             \ 5  Extra Beam Lasers         1000.0 Cr
 EQUW 5250              \ 6  Fuel Scoops                525.0 Cr
 EQUW 10000             \ 7  Escape Pod                1000.0 Cr
 EQUW 9000              \ 8  Energy Bomb                900.0 Cr
 EQUW 15000             \ 9  Energy Unit               1500.0 Cr
 EQUW 2000              \ 10 Docking Computer           200.0 Cr
 EQUW 50000             \ 11 Galactic Hyperspace       5000.0 Cr
ENDIF
IF _6502SP_VERSION OR _DISC_DOCKED OR _MASTER_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _NES_VERSION \ Enhanced: The equipment prices table in the enhanced versions contains prices for the two new laser types: military lasers at 6000 Cr each, and mining lasers at 800 Cr each
 EQUW 60000             \ 12 Extra Military Lasers     6000.0 Cr
 EQUW 8000              \ 13 Extra Mining Lasers        800.0 Cr
ENDIF

IF _ELITE_A_VERSION

 EQUW 1                 \ 0  Fuel, calculated in EQSHP  140.0 Cr (full tank)

                        \ Offset 0 (PRXS+0): Boa, Cobra Mk III, Ghavial, Iguana

 EQUW 250               \ 1  Missile                     25.0 Cr
 EQUW 4000              \ 2  I.F.F. System              400.0 Cr
 EQUW 6000              \ 3  E.C.M. System              600.0 Cr
 EQUW 4000              \ 4  Extra Pulse Lasers         400.0 Cr
 EQUW 10000             \ 5  Extra Beam Lasers         1000.0 Cr
 EQUW 5250              \ 6  Fuel Scoops                525.0 Cr
 EQUW 3000              \ 7  Escape Pod                 300.0 Cr
 EQUW 5500              \ 8  Hyperspace Unit            550.0 Cr
 EQUW 15000             \ 9  Energy Unit               1500.0 Cr
 EQUW 15000             \ 10 Docking Computer          1500.0 Cr
 EQUW 50000             \ 11 Galactic Hyperspace       5000.0 Cr
 EQUW 30000             \ 12 Extra Military Lasers     3000.0 Cr
 EQUW 2500              \ 13 Extra Mining Lasers        250.0 Cr

                        \ Offset 1 (PRXS+26): Adder, Cobra Mk I, Gecko, Python

 EQUW 250               \ 1  Missile                     25.0 Cr
 EQUW 2000              \ 2  I.F.F. System              200.0 Cr
 EQUW 4000              \ 3  E.C.M. System              400.0 Cr
 EQUW 2000              \ 4  Extra Pulse Lasers         200.0 Cr
 EQUW 4500              \ 5  Extra Beam Lasers          450.0 Cr
 EQUW 3750              \ 6  Fuel Scoops                375.0 Cr
 EQUW 2000              \ 7  Escape Pod                 200.0 Cr
 EQUW 3750              \ 8  Hyperspace Unit            375.0 Cr
 EQUW 9000              \ 9  Energy Unit                900.0 Cr
 EQUW 8000              \ 10 Docking Computer           800.0 Cr
 EQUW 30000             \ 11 Galactic Hyperspace       3000.0 Cr
 EQUW 23000             \ 12 Extra Military Lasers     2300.0 Cr
 EQUW 2500              \ 13 Extra Mining Lasers        250.0 Cr

                        \ Offset 2 (PRXS+52): Asp Mk II, Fer-de-Lance

 EQUW 250               \ 1  Missile                     25.0 Cr
 EQUW 4000              \ 2  I.F.F. System              400.0 Cr
 EQUW 5000              \ 3  E.C.M. System              500.0 Cr
 EQUW 5000              \ 4  Extra Pulse Lasers         500.0 Cr
 EQUW 10000             \ 5  Extra Beam Lasers         1000.0 Cr
 EQUW 7000              \ 6  Fuel Scoops                700.0 Cr
 EQUW 6000              \ 7  Escape Pod                 600.0 Cr
 EQUW 4000              \ 8  Hyperspace Unit            400.0 Cr
 EQUW 25000             \ 9  Energy Unit               2500.0 Cr
 EQUW 10000             \ 10 Docking Computer          1000.0 Cr
 EQUW 40000             \ 11 Galactic Hyperspace       4000.0 Cr
 EQUW 50000             \ 12 Extra Military Lasers     5000.0 Cr
 EQUW 2500              \ 13 Extra Mining Lasers        250.0 Cr

                        \ Offset 3 (PRXS+78): Anaconda, Monitor

 EQUW 250               \ 1  Missile                     25.0 Cr
 EQUW 3000              \ 2  I.F.F. System              300.0 Cr
 EQUW 8000              \ 3  E.C.M. System              800.0 Cr
 EQUW 6000              \ 4  Extra Pulse Lasers         600.0 Cr
 EQUW 8000              \ 5  Extra Beam Lasers          800.0 Cr
 EQUW 6500              \ 6  Fuel Scoops                650.0 Cr
 EQUW 4500              \ 7  Escape Pod                 450.0 Cr
 EQUW 8000              \ 8  Hyperspace Unit            800.0 Cr
 EQUW 19000             \ 9  Energy Unit               1900.0 Cr
 EQUW 20000             \ 10 Docking Computer          2000.0 Cr
 EQUW 60000             \ 11 Galactic Hyperspace       6000.0 Cr
 EQUW 25000             \ 12 Extra Military Lasers     2500.0 Cr
 EQUW 2500              \ 13 Extra Mining Lasers        250.0 Cr

                        \ Offset 4 (PRXS+104): Chameleon, Moray, Ophidian

 EQUW 250               \ 1  Missile                     25.0 Cr
 EQUW 1500              \ 2  I.F.F. System              150.0 Cr
 EQUW 3000              \ 3  E.C.M. System              300.0 Cr
 EQUW 3500              \ 4  Extra Pulse Lasers         350.0 Cr
 EQUW 7000              \ 5  Extra Beam Lasers          700.0 Cr
 EQUW 4500              \ 6  Fuel Scoops                450.0 Cr
 EQUW 2500              \ 7  Escape Pod                 250.0 Cr
 EQUW 4500              \ 8  Hyperspace Unit            450.0 Cr
 EQUW 7000              \ 9  Energy Unit                700.0 Cr
 EQUW 7000              \ 10 Docking Computer           700.0 Cr
 EQUW 30000             \ 11 Galactic Hyperspace       3000.0 Cr
 EQUW 19000             \ 12 Extra Military Lasers     1900.0 Cr
 EQUW 2500              \ 13 Extra Mining Lasers        250.0 Cr

ENDIF

