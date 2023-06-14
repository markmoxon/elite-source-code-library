\ ******************************************************************************
\
\       Name: FNE
\       Type: Macro
\   Category: Sound
\    Summary: Macro definition for defining a sound envelope
\
\ ------------------------------------------------------------------------------
\
\ The following macro is used to define the four sound envelopes used in the
\ game. It uses OSWORD 8 to create an envelope using the 14 parameters in the
\ I%-th block of 14 bytes at location E%. This OSWORD call is the same as BBC
\ BASIC's ENVELOPE command.
\
\ See variable E% for more details of the envelopes themselves.
\
\ ******************************************************************************

MACRO FNE I%

 LDX #LO(E%+I%*14)      \ Set (Y X) to point to the I%-th set of envelope data
 LDY #HI(E%+I%*14)      \ in E%

 LDA #8                 \ Call OSWORD with A = 8 to set up sound envelope I%
 JSR OSWORD

ENDMACRO

