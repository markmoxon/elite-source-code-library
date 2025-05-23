\ ******************************************************************************
\
\       Name: S1%
\       Type: Variable
\   Category: Save and load
\    Summary: The drive and directory number used when saving or loading a
\             commander file
\  Deep dive: Commander save files
\
IF _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION \ Comment
\ ------------------------------------------------------------------------------
\
\ The drive part of this string (the "0") is updated with the chosen drive in
\ the GTNMEW routine, but the directory part (the "E") is fixed. The variable
\ is followed directly by the commander file at NA%, which starts with the
\ commander name, so the full string at S1% is in the format ":0.E.JAMESON",
\ which gives the full filename of the commander file.
\
ELIF _C64_VERSION OR _APPLE_VERSION
\ ------------------------------------------------------------------------------
\
\ This is a BBC Micro drive and directory string. It is not used in this version
\ of Elite and is left over from the BBC Micro version.
\
ENDIF
\ ******************************************************************************

.S1%

 EQUS ":0.E."

