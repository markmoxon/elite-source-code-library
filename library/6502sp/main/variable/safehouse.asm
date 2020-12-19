.safehouse

 SKIP 6                 \ Backup storage for the seeds for the selected system
                        \
                        \ The seeds for the current system get stored here as
                        \ soon as a hyperspace is initiated, so we can fetch
                        \ them in the hyp1 routine. This fixes a bug in an
                        \ earlier version where you could hyperspace while
                        \ docking and magically appear in your destination
                        \ station

