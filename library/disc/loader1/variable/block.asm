\ ******************************************************************************
\
\       Name: BLOCK
\       Type: Variable
\   Category: Copy protection
\    Summary: These bytes are copied and decrypted by the loader routine (not
\             used in this version as disc protection is disabled)
\
\ ******************************************************************************

.BLOCK

 EQUB &19, &7A, &02, &01, &EC, &19, &00, &56
 EQUB &FF, &00, &00

