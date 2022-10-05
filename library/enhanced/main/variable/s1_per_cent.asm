\ ******************************************************************************
\
\       Name: S1%
\       Type: Variable
\   Category: Save and load
\    Summary: The drive and directory number used when saving or loading a
\             commander file
\  Deep dive: Commander save files
\
\ ------------------------------------------------------------------------------
\
\ The drive part of this string (the "0") is updated with the chosen drive in
\ the GTNMEW routine, but the directory part (the "E") is fixed. The variable
\ is followed directly by the commander file at NA%, which starts with the
\ commander name, so the full string at S1% is in the format ":0.E.JAMESON",
\ which gives the full filename of the commander file.
\
\ ******************************************************************************

.S1%

 EQUS ":0.E."

