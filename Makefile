BEEBASM?=beebasm
PYTHON?=python

# Change the release by adding 'release=source-disc' to the make command, e.g.
#
#   make encrypt verify
#
# will build the SNG45 version of 6502SP Elite, while:
#
#   make encrypt verify release=source-disc
#
# will build the version from the source disc

ifeq ($(release), source-disc)
  rel=1
  folder='/source-disc'
else
  rel=2
  folder='/sng45'
endif

# The following variables are written into elite-header.h.asm so they can be
# passed to BeebAsm:
#
# _REMOVE_CHECKSUMS
#   TRUE  = Disable all checksums, max commander
#   FALSE = Enable checksums, standard commander
#
# _MATCH_EXTRACTED_BINARIES
#   TRUE  = Match binaries to release version (i.e. fill workspaces with noise)
#   FALSE = Zero-fill workspaces
#
# _VERSION
#   1 = Cassette
#   2 = Disc
#   3 = 6502 Second Processor
#
# _RELEASE (for 6502SP version only)
#   1 = source disc
#   2 = SNG45 (default)
#

.PHONY:build
build:
	echo _VERSION=1 > versions/cassette/sources/elite-header.h.asm
	echo _REMOVE_CHECKSUMS=TRUE >> versions/cassette/sources/elite-header.h.asm
	$(BEEBASM) -i versions/cassette/sources/elite-source.asm -v > versions/cassette/output/compile.txt
	$(BEEBASM) -i versions/cassette/sources/elite-bcfs.asm -v >> versions/cassette/output/compile.txt
	$(BEEBASM) -i versions/cassette/sources/elite-loader.asm -v >> versions/cassette/output/compile.txt
	$(PYTHON) versions/cassette/sources/elite-checksum.py -u
	$(BEEBASM) -i versions/cassette/sources/elite-disc.asm -do versions/cassette/elite-cassette.ssd -boot ELTdata

	echo _VERSION=3 > versions/6502sp/sources/elite-header.h.asm
	echo _RELEASE=$(rel) >> versions/6502sp/sources/elite-header.h.asm
	echo _REMOVE_CHECKSUMS=TRUE >> versions/6502sp/sources/elite-header.h.asm
	echo _MATCH_EXTRACTED_BINARIES=FALSE >> versions/6502sp/sources/elite-header.h.asm
	$(BEEBASM) -i versions/6502sp/sources/elite-source.asm -v > versions/6502sp/output/compile.txt
	$(BEEBASM) -i versions/6502sp/sources/elite-bcfs.asm -v >> versions/6502sp/output/compile.txt
	$(BEEBASM) -i versions/6502sp/sources/elite-z.asm -v >> versions/6502sp/output/compile.txt
	$(BEEBASM) -i versions/6502sp/sources/elite-loader1.asm -v >> versions/6502sp/output/compile.txt
	$(BEEBASM) -i versions/6502sp/sources/elite-loader2.asm -v >> versions/6502sp/output/compile.txt
	$(PYTHON) versions/6502sp/sources/elite-checksum.py -u -rel$(rel)
	$(BEEBASM) -i versions/6502sp/sources/elite-disc.asm -do versions/6502sp/elite-6502sp.ssd -boot ELITE

.PHONY:encrypt
encrypt:
	echo _VERSION=1 > versions/cassette/sources/elite-header.h.asm
	echo _REMOVE_CHECKSUMS=FALSE >> versions/cassette/sources/elite-header.h.asm
	$(BEEBASM) -i versions/cassette/sources/elite-source.asm -v > versions/cassette/output/compile.txt
	$(BEEBASM) -i versions/cassette/sources/elite-bcfs.asm -v >> versions/cassette/output/compile.txt
	$(BEEBASM) -i versions/cassette/sources/elite-loader.asm -v >> versions/cassette/output/compile.txt
	$(PYTHON) versions/cassette/sources/elite-checksum.py
	$(BEEBASM) -i versions/cassette/sources/elite-disc.asm -do versions/cassette/elite-cassette.ssd -boot ELTdata

	echo _VERSION=2 > versions/disc/sources/elite-header.h.asm
	echo _REMOVE_CHECKSUMS=FALSE >> versions/disc/sources/elite-header.h.asm
	$(BEEBASM) -i versions/disc/sources/elite-loader1.asm -v > versions/disc/output/compile.txt
	$(BEEBASM) -i versions/disc/sources/elite-loader2.asm -v >> versions/disc/output/compile.txt
	$(BEEBASM) -i versions/disc/sources/elite-loader3.asm -v >> versions/disc/output/compile.txt
	$(BEEBASM) -i versions/disc/sources/elite-source-d.asm -v >> versions/disc/output/compile.txt
	$(BEEBASM) -i versions/disc/sources/elite-source-t.asm -v >> versions/disc/output/compile.txt
	$(BEEBASM) -i versions/disc/sources/elite-ships-a.asm -v >> versions/disc/output/compile.txt
	$(BEEBASM) -i versions/disc/sources/elite-ships-b.asm -v >> versions/disc/output/compile.txt
	$(BEEBASM) -i versions/disc/sources/elite-ships-c.asm -v >> versions/disc/output/compile.txt
	$(BEEBASM) -i versions/disc/sources/elite-ships-d.asm -v >> versions/disc/output/compile.txt
	$(BEEBASM) -i versions/disc/sources/elite-ships-e.asm -v >> versions/disc/output/compile.txt
	$(BEEBASM) -i versions/disc/sources/elite-ships-f.asm -v >> versions/disc/output/compile.txt
	$(BEEBASM) -i versions/disc/sources/elite-ships-g.asm -v >> versions/disc/output/compile.txt
	$(BEEBASM) -i versions/disc/sources/elite-ships-h.asm -v >> versions/disc/output/compile.txt
	$(BEEBASM) -i versions/disc/sources/elite-ships-i.asm -v >> versions/disc/output/compile.txt
	$(BEEBASM) -i versions/disc/sources/elite-ships-j.asm -v >> versions/disc/output/compile.txt
	$(BEEBASM) -i versions/disc/sources/elite-ships-k.asm -v >> versions/disc/output/compile.txt
	$(BEEBASM) -i versions/disc/sources/elite-ships-l.asm -v >> versions/disc/output/compile.txt
	$(BEEBASM) -i versions/disc/sources/elite-ships-m.asm -v >> versions/disc/output/compile.txt
	$(BEEBASM) -i versions/disc/sources/elite-ships-n.asm -v >> versions/disc/output/compile.txt
	$(BEEBASM) -i versions/disc/sources/elite-ships-o.asm -v >> versions/disc/output/compile.txt
	$(BEEBASM) -i versions/disc/sources/elite-ships-p.asm -v >> versions/disc/output/compile.txt
	$(PYTHON) versions/disc/sources/elite-checksum.py
	$(BEEBASM) -i versions/disc/sources/elite-disc.asm -do versions/disc/elite-disc.ssd -boot ELITE2

	echo _VERSION=3 > versions/6502sp/sources/elite-header.h.asm
	echo _RELEASE=$(rel) >> versions/6502sp/sources/elite-header.h.asm
	echo _REMOVE_CHECKSUMS=FALSE >> versions/6502sp/sources/elite-header.h.asm
	echo _MATCH_EXTRACTED_BINARIES=TRUE >> versions/6502sp/sources/elite-header.h.asm
	$(BEEBASM) -i versions/6502sp/sources/elite-source.asm -v > versions/6502sp/output/compile.txt
	$(BEEBASM) -i versions/6502sp/sources/elite-bcfs.asm -v >> versions/6502sp/output/compile.txt
	$(BEEBASM) -i versions/6502sp/sources/elite-z.asm -v >> versions/6502sp/output/compile.txt
	$(BEEBASM) -i versions/6502sp/sources/elite-loader1.asm -v >> versions/6502sp/output/compile.txt
	$(BEEBASM) -i versions/6502sp/sources/elite-loader2.asm -v >> versions/6502sp/output/compile.txt
	$(PYTHON) versions/6502sp/sources/elite-checksum.py -rel$(rel)
	$(BEEBASM) -i versions/6502sp/sources/elite-disc.asm -do versions/6502sp/elite-6502sp.ssd -boot ELITE

.PHONY:verify
verify:
	@$(PYTHON) versions/cassette/sources/crc32.py versions/cassette/extracted versions/cassette/output
	@$(PYTHON) versions/disc/sources/crc32.py versions/disc/extracted versions/disc/output
	@$(PYTHON) versions/6502sp/sources/crc32.py versions/6502sp/extracted$(folder) versions/6502sp/output
