\ ******************************************************************************
\
\       Name: CNT3
\       Type: Variable
\   Category: Drawing planets
\    Summary: A counter for use in drawing Saturn's rings
\
\ ------------------------------------------------------------------------------
\
\ Defines the number of iterations of the PLL3 loop, which draws the rings
\ around the loading screen's Saturn.
\
\ ******************************************************************************

.CNT3

IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Standard: In the cassette and Electron versions, the loading screen's Saturn has up to 1280 dots in the planet's ring, while all other versions have up to 819

 EQUW &0500             \ The number of iterations of the PLL3 loop (1280)

ELIF _6502SP_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _MASTER_VERSION

 EQUW &0333             \ The number of iterations of the PLL3 loop (819)

ENDIF

