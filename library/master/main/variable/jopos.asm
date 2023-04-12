.JOPOS

 SKIP 1                 \ Contains the high byte of the latest value from ADC
                        \ channel 1 (the joystick X value), which gets updated
                        \ regularly by the IRQ1 interrupt handler

 SKIP 1                 \ Contains the high byte of the latest value from ADC
                        \ channel 2 (the joystick Y value), which gets updated
                        \ regularly by the IRQ1 interrupt handler

 SKIP 1                 \ Contains the high byte of the latest value from ADC
                        \ channel 3 (the Bitstik rotation value), which gets
                        \ updated regularly by the IRQ1 interrupt handler

