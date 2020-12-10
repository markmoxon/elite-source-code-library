\ ******************************************************************************
\
\       Name: SCANpars
\       Type: Variable
\   Category: Dashboard
\    Summary: The scanner buffer to send with the #onescan command
\
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   SCANflg             The sign of the stick height (in bit 7)
\
\   SCANlen             The stick height for the ship on the scanner
\
\   SCANcol             The colour of the ship on the scanner
\
\   SCANx1              The screen x-coordinate of the dot on the scanner
\
\   SCANy1              The screen y-coordinate of the dot on the scanner
\
\ ******************************************************************************

.SCANpars

 EQUB 7                 \ The number of bytes to transmit with this command

 EQUB 0                 \ The number of bytes to receive with this command

.SCANflg

 EQUB 0                 \ The sign of the stick height (in bit 7)

.SCANlen

 EQUB 0                 \ The stick height for this ship on the scanner

.SCANcol

 EQUB 0                 \ The colour of the ship on the scanner

.SCANx1

 EQUB 0                 \ The screen x-coordinate of the dot on the scanner

.SCANy1

 EQUB 0                 \ The screen y-coordinate of the dot on the scanner

