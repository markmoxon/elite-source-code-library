\ ******************************************************************************
\
\       Name: sram%
\       Type: Variable
\   Category: Loader
\    Summary: A table for storing the status of each ROM bank
\
\ ******************************************************************************

.sram%

 SKIP 16                \ Gets set to the RAM status of each ROM bank:
                        \
                        \   * 0 = does not contain writeable sideways RAM
                        \
                        \   * &FF = contains writeable sideways RAM

