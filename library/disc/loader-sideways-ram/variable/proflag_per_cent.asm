\ ******************************************************************************
\
\       Name: proflag%
\       Type: Variable
\   Category: Loader
\    Summary: A flag to record whether we are running this on a co-processor
\
\ ******************************************************************************

.proflag%

 SKIP 1                 \ Gets set to the co-processor status:
                        \
                        \   * 0 = this is not a co-processor
                        \
                        \   * &FF = this is a co-processor

