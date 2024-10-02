#!/usr/bin/env python
#
# ******************************************************************************
#
# COMMODORE 64 ELITE CHECKSUM SCRIPT
#
# Written by Mark Moxon, and inspired by Kieran Connell's version for the
# cassette version of Elite
#
# This script applies encryption and checksums to the compiled binaries for the
# Commodore 64 version of Elite
#
# ******************************************************************************

from __future__ import print_function
import sys

argv = sys.argv
Encrypt = True
release = 1

for arg in argv[1:]:
    if arg == "-u":
        Encrypt = False
    if arg == "-rel1":
        release = 1
    if arg == "-rel2":
        release = 2

print("Commodure 64 Elite Checksum")
print("Encryption = ", Encrypt)

# Configuration variables for scrambling code and calculating checksums
#
# Values must match those in 3-assembled-output/compile.txt
#
# If you alter the source code, then you should extract the correct values for
# the following variables and plug them into the following, otherwise the game
# will fail the checksum process and will hang on loading
#
# You can find the correct values for these variables by building your updated
# source, and then searching compile.txt for "elite-checksum.py", where the new
# values will be listed

# SNG47
b = 0x1D00                  # B%
s = 0x1D1F                  # S%
g = 0x1D7E                  # G%
r = 0x3ECF                  # R%
c = 0x7300                  # C%
f = 0xCA61                  # F%
na2_per_cent = 0x34CD       # NA2%

# Load assembled code files that make up LOCODE file

data_block = bytearray()
eliteb_offset = 0
elited_offset = 0

# Append all assembled code files

elite_names = ("ELTA", "ELTB", "ELTC", "ELTD", "ELTE", "ELTF", "ELTG", "ELTH", "ELTI", "ELTJ", "ELTK")

for file_name in elite_names:
    print(str(len(data_block)), file_name)
    if file_name == "ELTB":
        eliteb_offset = len(data_block)
    if file_name == "ELTD":
        elited_offset = len(data_block)
    elite_file = open("versions/c64/3-assembled-output/" + file_name + ".bin", "rb")
    data_block.extend(elite_file.read())
    elite_file.close()

# Write output file for LOCODE.unprot.bin

output_file = open("versions/c64/3-assembled-output/LOCODE.unprot.bin", "wb")
output_file.write(data_block[:elited_offset])
output_file.close()

print("versions/c64/3-assembled-output/LOCODE.unprot.bin file saved")

# Write output file for HICODE.unprot.bin

output_file = open("versions/c64/3-assembled-output/HICODE.unprot.bin", "wb")
output_file.write(data_block[elited_offset:])
output_file.close()

print("versions/c64/3-assembled-output/HICODE.unprot.bin file saved")

# Encrypt the LOCODE file

scramble_from = g - b
scramble_to = r - b - 1
seed = 0x36

if Encrypt:
    for n in range(scramble_from, scramble_to):
        data_block[n] = (data_block[n] + data_block[n + 1]) % 256

    data_block[scramble_to] = (data_block[scramble_to] + seed) % 256

# Write output file for LOCODE

output_file = open("versions/c64/3-assembled-output/LOCODE.bin", "wb")
output_file.write(data_block[:elited_offset])
output_file.close()

print("versions/c64/3-assembled-output/LOCODE.bin file saved")

# Encrypt the HICODE file

scramble_from = r - b
scramble_to = scramble_from + (f - c - 1)
seed = 0x49

print(hex(scramble_from))
print(hex(scramble_to))
print(hex(len(data_block)))

if Encrypt:
    for n in range(scramble_from, scramble_to):
        print("{}/{} = {} + {} = {}".format(hex(n - scramble_from), hex(n), hex(data_block[n]), hex(data_block[n + 1]), hex((data_block[n] + data_block[n + 1]) % 256)))
        data_block[n] = (data_block[n] + data_block[n + 1]) % 256

    data_block[scramble_to] = (data_block[scramble_to] + seed) % 256

# Write output file for HICODE

output_file = open("versions/c64/3-assembled-output/HICODE.bin", "wb")
output_file.write(data_block[elited_offset:])
output_file.close()

print("versions/c64/3-assembled-output/HICODE.bin file saved")

exit(0)

#elite_names = ("ELThead", "ELTA", "ELTB", "ELTC", "ELTD", "ELTE", "ELTF", "ELTG")


# Configuration variables for LOCODE

load_address = 0x1300
seed = 0x19

if release == 1:
    # SNG47
    scramble_to = f - 1
elif release == 2:
    # Compact
    scramble_to = f - 1

# Load assembled code file for LOCODE

data_block = bytearray()

elite_file = open("versions/c64/3-assembled-output/LOCODE.unprot.bin", "rb")
data_block.extend(elite_file.read())
elite_file.close()

# Commander data checksum

commander_start = na2_per_cent - load_address
commander_offset = 0x52
CH = 0x4B - 2
CY = 0
for i in range(CH, 0, -1):
    CH = CH + CY + data_block[commander_start + i + 7]
    CY = (CH > 255) & 1
    CH = CH % 256
    CH = CH ^ data_block[commander_start + i + 8]

print("Commander checksum = ", hex(CH))

# Must have Commander checksum otherwise game will lock

if Encrypt:
    data_block[commander_start + commander_offset] = CH ^ 0xA9
    data_block[commander_start + commander_offset + 1] = CH

# Encrypt game code

for n in range(scramble_from, scramble_to):
    data_block[n - load_address] = (data_block[n - load_address] + data_block[n + 1 - load_address]) % 256

data_block[scramble_to - load_address] = (data_block[scramble_to - load_address] + seed) % 256

# Write output file for BCODE

output_file = open("versions/c64/3-assembled-output/BCODE.bin", "wb")
output_file.write(data_block)
output_file.close()

print("3-assembled-output/BCODE.bin file saved")

# Configuration variables for BDATA

load_address = 0x1300 + 0x5D00
seed = 0x62
scramble_from = 0x8000
scramble_to = 0xB1FF

data_block = bytearray()

# Load assembled code file for BDATA

elite_file = open("versions/c64/3-assembled-output/BDATA.unprot.bin", "rb")
data_block.extend(elite_file.read())
elite_file.close()

for n in range(scramble_from, scramble_to):
    data_block[n - load_address] = (data_block[n - load_address] + data_block[n + 1 - load_address]) % 256

data_block[scramble_to - load_address] = (data_block[scramble_to - load_address] + seed) % 256

# Write output file for BDATA

output_file = open("versions/c64/3-assembled-output/BDATA.bin", "wb")
output_file.write(data_block)
output_file.close()

print("3-assembled-output/BDATA.bin file saved")
