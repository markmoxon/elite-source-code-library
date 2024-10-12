# Source code library for every version of Elite on bbcelite.com

[Scripts for generating bbcelite.com](https://github.com/markmoxon/bbcelite-scripts) | [Static content for bbcelite.com](https://github.com/markmoxon/bbcelite-websites) | **Elite source code library**

This repository contains a source code library that is used as a single source of truth when building the following repositories:

* [BBC Micro (cassette) Elite source code](https://github.com/markmoxon/elite-source-code-bbc-micro-cassette)
* [BBC Micro (disc) Elite source code](https://github.com/markmoxon/elite-source-code-bbc-micro-disc)
* [6502 Second Processor Elite source code](https://github.com/markmoxon/elite-source-code-6502-second-processor)
* [BBC Master Elite source code](https://github.com/markmoxon/elite-source-code-bbc-master)
* [Acorn Electron Elite source code](https://github.com/markmoxon/elite-source-code-acorn-electron)
* [Elite-A source code](https://github.com/markmoxon/elite-a-source-code-bbc-micro)
* [NES Elite source code](https://github.com/markmoxon/elite-source-code-nes)

It is also used when building the [elite.bbcelite.com website](https://elite.bbcelite.com).

For details of how the site and source code repositories are built, see the [bbcelite.com website](https://www.bbcelite.com/disassembly_websites/).

# Building Elite from the library

As well as being a source code library, this repository is fully buildable in its own right, and is able to produce all variants of all the different versions of Elite listed above, in exactly the same way as the repositories that it generates. The library is the core resource for managing the commentary across all the documented versions of Elite, and it can be built regularly as updates are made to the commentary, to ensure that the code still compiles correctly as those changes are made.

The build process is as follows:

* A simple `make` will build the default variants for all seven versions of Elite. This is equivalent to `make all`.

* To build a single version, add the version name to the `make` command, so `make master` will only build the BBC Master version, for example.

* To build a specific variant, add `variant-<version>=xxx` to the `make` command, so `make master variant-master=compact` will build the Compact variant of the BBC Master version, while `make variant-master=compact variant-6502sp=executive` will build all seven versions of Elite, with the Master and 6502 Second Processor versions building the Compact and Executive variants respectively.

* To build a specific version and automatically run it in the b2 emulator, add `b2-<version>` to the `make` command, so `make master b2-master` will build and load the BBC Master version into b2, for example.

## Acknowledgements

BBC Micro Elite was written by Ian Bell and David Braben and is copyright &copy; Acornsoft 1984.

The code on this site has been reconstructed from a disassembly of the version released on [Ian Bell's personal website](http://www.elitehomepage.org/).

Electron Elite was written by Ian Bell and David Braben and is copyright &copy; Acornsoft 1984.

The code on this site has been reconstructed from a disassembly of the version released on [Ian Bell's personal website](http://www.elitehomepage.org/).

6502 Second Processor Elite was written by Ian Bell and David Braben and is copyright &copy; Acornsoft 1985.

The 6502 Second Processor code on this site is identical to the source discs released on [Ian Bell's personal website](http://www.elitehomepage.org/) (it's just been reformatted to be more readable).

BBC Master Elite was written by Ian Bell and David Braben and is copyright &copy; Acornsoft 1986.

The BBC Master code on this site has been reconstructed from a disassembly of the version released on [Ian Bell's personal website](http://www.elitehomepage.org/).

NES Elite was written by Ian Bell and David Braben and is copyright &copy; D. Braben and I. Bell 1991/1992.

The code on this site has been reconstructed from a disassembly of the version released on [Ian Bell's personal website](http://www.elitehomepage.org/).

Elite-A was written by Angus Duggan, and is an extended version of the BBC Micro disc version of Elite; the extra code is copyright Angus Duggan. The original Elite was written by Ian Bell and David Braben and is copyright &copy; Acornsoft 1984.

The code on this site is identical to Angus Duggan's source discs (it's just been reformatted, and the label names have been changed to be consistent with the sources for the original BBC Micro disc version on which it is based).

The commentary is copyright &copy; Mark Moxon. Any misunderstandings or mistakes in the documentation are entirely my fault.

Huge thanks are due to the original authors for not only creating such an important piece of my childhood, but also for releasing the source code for us to play with; to Paul Brink for his annotated disassembly; and to Kieran Connell for his [BeebAsm version](https://github.com/kieranhj/elite-beebasm), which I forked as the original basis for this project. You can find more information about this project in the [accompanying website's project page](https://elite.bbcelite.com/about_site/about_this_project.html).

The following archives from Ian Bell's personal website form the basis for this project:

* [Cassette sources as a disc image](http://www.elitehomepage.org/archive/a/a4080602.zip)

* [Cassette sources as text files](http://www.elitehomepage.org/archive/a/a4080610.zip)

* [BBC Elite, disc version](http://www.elitehomepage.org/archive/a/a4100000.zip)

* [Electron Elite, Acornsoft version](http://www.elitehomepage.org/archive/a/a4090000.zip)

* [Electron Elite, Superior Software version](http://www.elitehomepage.org/archive/a/a4090010.zip)

* [6502 Second Processor sources as a disc image](http://www.elitehomepage.org/archive/a/a5022201.zip)

* [BBC Elite, Master version](http://www.elitehomepage.org/archive/a/b8020001.zip)

* [NES Elite, NTSC version](http://www.elitehomepage.org/archive/a/b7120500.zip)

# A note on licences, copyright etc.

This repository is _not_ provided with a licence, and there is intentionally no `LICENSE` file provided.

According to [GitHub's licensing documentation](https://docs.github.com/en/free-pro-team@latest/github/creating-cloning-and-archiving-repositories/licensing-a-repository), this means that "the default copyright laws apply, meaning that you retain all rights to your source code and no one may reproduce, distribute, or create derivative works from your work".

The reason for this is that my commentary is intertwined with the original Elite source code, and the original source code is copyright. The whole site is therefore covered by default copyright law, to ensure that this copyright is respected.

Under GitHub's rules, you have the right to read and fork this repository... but that's it. No other use is permitted, I'm afraid.

My hope is that the educational and non-profit intentions of this repository will enable it to stay hosted and available, but the original copyright holders do have the right to ask for it to be taken down, in which case I will comply without hesitation. I do hope, though, that along with the various other disassemblies and commentaries of this source, it will remain viable.

---

Right on, Commanders!

_Mark Moxon_