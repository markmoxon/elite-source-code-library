\ ******************************************************************************
\
\       Name: FRIN
\       Type: Variable
\   Category: Loader
\    Summary: A temporary variable that's used for storing addresses
\
\ ******************************************************************************

.FRIN

 JSR &0134              \ This code is never run (it is overwritten when the
                        \ FRIN variable is used), but it was presumably added
                        \ to the code to act as a red herring to confuse any
                        \ crackers exploring the loader code

