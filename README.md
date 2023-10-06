# Source code builder for Elite

This repository contains a library and scripts to build the following repositories:

* [BBC Micro (cassette)](https://github.com/markmoxon/cassette-elite-beebasm)
* [BBC Micro (disc)](https://github.com/markmoxon/disc-elite-beebasm)
* [6502 Second Processor](https://github.com/markmoxon/6502sp-elite-beebasm)
* [BBC Master](https://github.com/markmoxon/master-elite-beebasm)
* [Acorn Electron](https://github.com/markmoxon/electron-elite-beebasm)
* [Elite-A](https://github.com/markmoxon/elite-a-beebasm)
* [NES](https://github.com/markmoxon/nes-a-beebasm)

It is a companion to the [bbcelite.com website](https://www.bbcelite.com).

# Notes

* In the conditional statements that control which code is used in which versions ("version-ifs"), any `ELIF`s that solely contain `_ELITE_A_*` directives must be the last `ELIF`s in version-if block.

* A commented out `INCLUDE` file in Elite-A, commented out with a single \ character, denotes a section that was removed by Angus when creating Elite-A:

```
\INCLUDE "library/disc/main/subroutine/deeor.asm"
```

* A commented out INCLUDE file in Elite-A, commented out with a double \ character, denotes a section that was moved by Angus when creating Elite-A

```
\\INCLUDE "library/enhanced/main/subroutine/detok3.asm"
```

---

Right on, Commanders!

_Mark Moxon_