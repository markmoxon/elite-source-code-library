\ ******************************************************************************
\
\       Name: dupl%
\       Type: Variable
\   Category: Loader
\    Summary: A table for storing the status of each ROM bank
\
\ ******************************************************************************

.dupl%

 SKIP 16                \ Gets set to the duplicate of each ROM bank:
                        \
                        \   * If dupl%+X contains X then bank X is not a
                        \     duplicate of a ROM in a higher bank number
                        \
                        \   * If dupl%+X > X then bank X is a duplicate of the
                        \     ROM in bank number dupl%+X

