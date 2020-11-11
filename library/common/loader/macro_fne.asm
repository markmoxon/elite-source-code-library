\ ******************************************************************************
\
\       Name: FNE
\       Type: Macro
\   Category: Sound
\    Summary: Macro definition for defining a sound envelope
\
\ ------------------------------------------------------------------------------
\
\ The following macro is used to defining the four sound envelopes used in the
\ game. It uses OSWORD 8 to create an envelope using the 14 parameters in the
\ the I%-th block of 14 bytes at location E%. This does the same as BBC BASIC's
\ ENVELOPE command.
\
\ See variable E% for more details of the envelopes themselves.
\
\ ******************************************************************************

MACRO FNE I%
  LDX #LO(E%+I%*14)     \ Call OSWORD with A = 8 and (Y X) pointing to the
  LDY #HI(E%+I%*14)     \ I%-th set of envelope data in E%, to set up sound
  LDA #8                \ envelope I%
  JSR OSWORD
ENDMACRO

