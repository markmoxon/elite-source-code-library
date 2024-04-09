\ ******************************************************************************
\
\       Name: used%
\       Type: Variable
\   Category: Loader
\    Summary: A table for storing the status of each ROM bank
\
\ ******************************************************************************

.used%

 SKIP 16                \ Gets set to the usage status of each ROM bank:
                        \
                        \   * 0 = does not contain a ROM image
                        \
                        \   * &FF = contains a RAM image

