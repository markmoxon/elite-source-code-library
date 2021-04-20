\ ******************************************************************************
\
\       Name: Authors' names
\       Type: Variable
\   Category: Copy protection
\    Summary: The authors' names and a copyright notice, buried in the code
\
\ ------------------------------------------------------------------------------
\
\ This copyright notice is not used anywhere and it is obfuscated by EOR'ing
\ each character with 164, but presumably the authors wanted their names buried
\ in the code somewhere. Though they do also have recursive token 94, which
\ reads "BY D.BRABEN & I.BELL" and can be displayed on the title screen using
\ the "X" configuration option, so this isn't the only author name easter egg
\ in the game. It contains the following text:
\
IF _CASSETTE_VERSION
\   (C)Bell/Braben1984
ELIF _ELECTRON_VERSION
ENDIF
\   (C)BellBraben'84
\
\ ******************************************************************************

IF _CASSETTE_VERSION

 EQUB '(' EOR 164
 EQUB 'C' EOR 164
 EQUB ')' EOR 164
 EQUB 'B' EOR 164
 EQUB 'e' EOR 164
 EQUB 'l' EOR 164
 EQUB 'l' EOR 164
 EQUB '/' EOR 164
 EQUB 'B' EOR 164
 EQUB 'r' EOR 164
 EQUB 'a' EOR 164
 EQUB 'b' EOR 164
 EQUB 'e' EOR 164
 EQUB 'n' EOR 164
 EQUB '1' EOR 164
 EQUB '9' EOR 164
 EQUB '8' EOR 164
 EQUB '4' EOR 164

ELIF _ELECTRON_VERSION

 EQUB '(' EOR 164
 EQUB 'C' EOR 164
 EQUB ')' EOR 164
 EQUB 'B' EOR 164
 EQUB 'e' EOR 164
 EQUB 'l' EOR 164
 EQUB 'l' EOR 164
 EQUB 'B' EOR 164
 EQUB 'r' EOR 164
 EQUB 'a' EOR 164
 EQUB 'b' EOR 164
 EQUB 'e' EOR 164
 EQUB 'n' EOR 164
 EQUB ''' EOR 164
 EQUB '8' EOR 164
 EQUB '4' EOR 164

ENDIF
