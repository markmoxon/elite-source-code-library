\ ******************************************************************************
\
\       Name: printflag
\       Type: Variable
\   Category: Text
\    Summary: A flag that determines whether to send text output to the printer
\             as well as the screen
\
\ ------------------------------------------------------------------------------
\
\ This flag can have the following values:
\
\   * Bit 7: 1 = printer enabled
\            0 = printer disabled
\
\ If the printer is enabled, then text output is sent to the printer as well as
\ the screen. This is set when CTRL is held down when displaying a text screen,
\ such as CTRL-f7 to print out the market prices for the current system.
\
\ ******************************************************************************

.printflag

 EQUB 0

