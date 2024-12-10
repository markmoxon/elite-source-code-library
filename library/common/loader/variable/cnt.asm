\ ******************************************************************************
\
\       Name: CNT
\       Type: Variable
\   Category: Drawing planets
\    Summary: A counter for use in drawing Saturn's planetary body
\
\ ------------------------------------------------------------------------------
\
\ Defines the number of iterations of the PLL1 loop, which draws the planet part
\ of the loading screen's Saturn.
\
\ ******************************************************************************

.CNT

IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Standard: In the cassette and Electron versions, the loading screen's Saturn has up to 1280 dots in the planet part, while all other versions have up to 768

 EQUW &0500             \ The number of iterations of the PLL1 loop (1280)

ELIF _6502SP_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _MASTER_VERSION

 EQUW &0300             \ The number of iterations of the PLL1 loop (768)

ENDIF

