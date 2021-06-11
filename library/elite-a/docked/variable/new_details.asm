\ ******************************************************************************
\
\       Name: new_details
\       Type: Variable
\   Category: Elite-A: Buying ships
\    Summary: AJD
\
\ ******************************************************************************

.new_details

 EQUB &0E, &8E, &92, &19, &02, &02 \ adder
 EQUB &04, &01,  36, &09,  60, &1A
 EQUB &DF \, &21, &05, &00

 EQUB &0E, &8F, &93, &19, &04, &03 \ gecko
 EQUB &05, &01,  45, &0A,  70, &1A
 EQUB &EF \, &11, &06, &00

 EQUB &10, &8F, &96, &19, &04, &03 \ moray
 EQUB &06, &01,  38, &0C,  80, &68
 EQUB &EF \, &11, &07, &00

 EQUB &0E, &8E, &94, &19, &04, &04 \ cobra 1
 EQUB &05, &01,  39, &0F,  60, &1A
 EQUB &CF \, &31, &08, &00

 EQUB &0E, &8E, &94, &19, &04, &04 \ iguana
 EQUB &07, &01,  50, &16,  75, &00
 EQUB &DF \, &21, &08, &00

 EQUB &0D, &8D, &90, &0C, &01, &03 \ ophidian
 EQUB &04, &01,  51, &19,  70, &68
 EQUB &FF \, &01, &06, &00

 EQUB &10, &8F, &97, &32, &02, &04 \ chameleon
 EQUB &08, &01,  43, &24,  80, &68
 EQUB &DF \, &21, &05, &00

 EQUB &12, &8F, &98, &32, &04, &05 \ cobra 3
 EQUB &07, &01,  42, &2B,  70, &00
 EQUB &EF \, &11, &0A, &00

IF _SOURCE_DISC

 EQUB &11, &90, &99, &32, &04, &04 \ ghavial
 EQUB &09, &01,  37, &38,  80, &00
 EQUB &CF \, &31, &09, &00

 EQUB &12, &92, &9C, &32, &04, &04 \ fer-de-lance
 EQUB &08, &02,  45, &0A,  85, &34
 EQUB &DF \, &21, &09, &00

ELIF _RELEASED

 EQUB &12, &92, &9C, &32, &04, &04 \ fer-de-lance
 EQUB &08, &02,  45, &0A,  85, &34
 EQUB &DF \, &21, &09, &00

 EQUB &11, &90, &99, &32, &04, &04 \ ghavial
 EQUB &09, &01,  37, &38,  80, &00
 EQUB &CF \, &31, &09, &00

ENDIF

 EQUB &18, &93, &9C, &32, &04, &09 \ monitor
 EQUB &0A, &01,  24, &52, 110, &4E
 EQUB &BF \, &41, &0C, &00

 EQUB &18, &92, &9B, &32, &04, &05 \ python
 EQUB &0B, &01,  30, &6B,  80, &1A
 EQUB &AF \, &51, &09, &00

 EQUB &14, &8E, &98, &32, &02, &07 \ boa
 EQUB &0A, &01,  36, &85,  90, &00
 EQUB &BF \, &41, &0A, &00

IF _SOURCE_DISC

 EQUB &1C, &90, &7F, &32, &04, &11 \ anaconda
 EQUB &0D, &01,  21, &FE, 100, &4E
 EQUB &AF \, &51, &0C, &00

 EQUB &10, &91, &9F, &0C, &01, &02 \ asp 2
 EQUB &0A, &01,  60, &07, 125, &34
 EQUB &DF \, &21, &07, &00

ELIF _RELEASED

 EQUB &10, &91, &9F, &0C, &01, &02 \ asp 2
 EQUB &0A, &01,  60, &07, 125, &34
 EQUB &DF \, &21, &07, &00

 EQUB &1C, &90, &7F, &32, &04, &11 \ anaconda
 EQUB &0D, &01,  21, &FE, 100, &4E
 EQUB &AF \, &51, &0C, &00

ENDIF

