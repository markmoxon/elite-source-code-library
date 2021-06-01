# Source code builder for Elite

This repository contains a library and scripts to build the following repositories:

* [BBC Micro (cassette)](https://github.com/markmoxon/cassette-elite-beebasm)
* [BBC Micro (disc)](https://github.com/markmoxon/disc-elite-beebasm)
* [6502 Second Processor](https://github.com/markmoxon/6502sp-elite-beebasm)
* [BBC Master](https://github.com/markmoxon/master-elite-beebasm)
* [Acorn Electron](https://github.com/markmoxon/electron-elite-beebasm)
* [Elite-A](https://github.com/markmoxon/elite-a-beebasm)

It is a companion to the [bbcelite.com website](https://www.bbcelite.com).

# Notes

* In the conditional statements that control which code is used in which versions ("version-ifs"), any ELIFs that solely contain _ELITE_A_* directives must be the last ELIFs in version-if block.

---

Right on, Commanders!

_Mark Moxon_