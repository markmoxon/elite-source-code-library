BEEBASM?=beebasm
PYTHON?=python

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
	echo _REMOVE_CHECKSUMS=TRUE >> versions/6502sp/sources/elite-header.h.asm
	echo _MATCH_EXTRACTED_BINARIES=FALSE >> versions/6502sp/sources/elite-header.h.asm
	$(BEEBASM) -i versions/6502sp/sources/elite-source.asm -v > versions/6502sp/output/compile.txt
	$(BEEBASM) -i versions/6502sp/sources/elite-bcfs.asm -v >> versions/6502sp/output/compile.txt
	$(BEEBASM) -i versions/6502sp/sources/elite-z.asm -v >> versions/6502sp/output/compile.txt
	$(BEEBASM) -i versions/6502sp/sources/elite-loader1.asm -v >> versions/6502sp/output/compile.txt
	$(BEEBASM) -i versions/6502sp/sources/elite-loader2.asm -v >> versions/6502sp/output/compile.txt
	$(PYTHON) versions/6502sp/sources/elite-checksum.py -u
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

	echo _VERSION=3 > versions/6502sp/sources/elite-header.h.asm
	echo _REMOVE_CHECKSUMS=FALSE >> versions/6502sp/sources/elite-header.h.asm
	echo _MATCH_EXTRACTED_BINARIES=TRUE >> versions/6502sp/sources/elite-header.h.asm
	$(BEEBASM) -i versions/6502sp/sources/elite-source.asm -v > versions/6502sp/output/compile.txt
	$(BEEBASM) -i versions/6502sp/sources/elite-bcfs.asm -v >> versions/6502sp/output/compile.txt
	$(BEEBASM) -i versions/6502sp/sources/elite-z.asm -v >> versions/6502sp/output/compile.txt
	$(BEEBASM) -i versions/6502sp/sources/elite-loader1.asm -v >> versions/6502sp/output/compile.txt
	$(BEEBASM) -i versions/6502sp/sources/elite-loader2.asm -v >> versions/6502sp/output/compile.txt
	$(PYTHON) versions/6502sp/sources/elite-checksum.py
	$(BEEBASM) -i versions/6502sp/sources/elite-disc.asm -do versions/6502sp/elite-6502sp.ssd -boot ELITE

.PHONY:verify
verify:
	@$(PYTHON) versions/cassette/sources/crc32.py versions/cassette/extracted versions/cassette/output
	@$(PYTHON) versions/6502sp/sources/crc32.py versions/6502sp/extracted versions/6502sp/output
