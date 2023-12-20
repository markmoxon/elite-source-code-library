\ ******************************************************************************
\
\       Name: TT114
\       Type: Subroutine
\   Category: Charts
\    Summary: Display either the Long-range or Short-range Chart
\
\ ------------------------------------------------------------------------------
\
\ Display either the Long-range or Short-range Chart, depending on the current
\ view setting. Called from TT18 once we know the current view is one of the
\ charts.
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   A                   The current view, loaded from QQ11
\
\ ******************************************************************************

.TT114

IF NOT(_NES_VERSION)

 BMI TT115              \ If bit 7 of the current view is set (i.e. the view is
                        \ the Short-range Chart, 128), skip to TT115 below to
                        \ jump to TT23 to display the chart

ELIF _NES_VERSION

 CMP #&9C               \ If this is the Short-range Chart, skip to TT115 below
 BEQ TT115              \ to jump to TT23 to display the chart

ENDIF

 JMP TT22               \ Otherwise the current view is the Long-range Chart, so
                        \ jump to TT22 to display it

.TT115

 JMP TT23               \ Jump to TT23 to display the Short-range Chart

