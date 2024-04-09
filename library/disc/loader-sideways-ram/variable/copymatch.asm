\ ******************************************************************************
\
\       Name: copyMatch
\       Type: Variable
\   Category: Loader
\    Summary: The start of the copyright string from a valid ROM bank, used to
\             check whether a ROM bank contains a ROM image
\
\ ******************************************************************************

.copyMatch

 EQUB 0                 \ NULL and "(C)", required for the MOS to recognise the
 EQUS "(C)"             \ ROM

