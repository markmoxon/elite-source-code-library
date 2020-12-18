.PARAMS

 SKIP 0                 \ PARAMS points to the start of the dashboard parameter
                        \ block that is populated by the parasite when it sends
                        \ the #RDPARAMS and OSWRCH 137 <param> commands
                        \
                        \ These commands update the dashboard, but because the
                        \ parameter block uses the same locations as the flight
                        \ variables, these commands also have the effect of
                        \ updating the following variables, from ENERGY to ESCP

