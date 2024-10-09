#!/usr/bin/env python
#
# ******************************************************************************
#
# APPLE II ELITE CHECKSUM SCRIPT
#
# Written by Mark Moxon, and inspired by Kieran Connell's version for the
# cassette version of Elite
#
# This script applies encryption and checksums to the compiled binaries for the
# Apple II version of Elite
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
        Encrypt = False
    if arg == "-rel2":
        release = 2
    if arg == "-rel3":
        release = 3
    if arg == "-rel4":
        release = 4

print("Apple II Elite Checksum")
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

if release == 1:

    # Ian Bell disk
    b = 0x4000                  # B%
    g = 0x45EA                  # G%
    na2_per_cent = 0x4DF3       # NA2%

elif release == 2 or release == 3 or release == 4:

    # Source disc
    b = 0x4000                  # B%
    g = 0x45E9                  # G%
    na2_per_cent = 0x4DEE       # NA2%

# Load assembled code files that make up the CODE1 and CODE2 files

data_block = bytearray()

# Append all assembled code files

elite_file = open("versions/apple/3-assembled-output/CODE.unprot.bin", "rb")
data_block.extend(elite_file.read())
elite_file.close()

# Encrypt the CODE file

scramble_from = g - b
scramble_to = len(data_block) - 2
seed = 0x15

if Encrypt:
    for n in range(scramble_from, scramble_to):
        data_block[n] = (data_block[n] + data_block[n + 1]) % 256

    data_block[scramble_to] = (data_block[scramble_to] + seed) % 256

# Write output file for CODE1 (first 0x5000 bytes)

output_file = open("versions/apple/3-assembled-output/CODE1.bin", "wb")
output_file.write(data_block[:0x5000])
output_file.close()

print("versions/apple/3-assembled-output/CODE1.bin file saved")

# Write output file for CODE2 (rest of the file)

output_file = open("versions/apple/3-assembled-output/CODE2.bin", "wb")
output_file.write(data_block[0x5000:])
output_file.close()

print("versions/apple/3-assembled-output/CODE2.bin file saved")

# Load assembled code file for DATA

data_block = bytearray()

elite_file = open("versions/apple/3-assembled-output/DATA.unprot.bin", "rb")
data_block.extend(elite_file.read())
elite_file.close()

# Encrypt the DATA file

scramble_from = 0
scramble_to = len(data_block) - 1
seed = 0x69

if Encrypt:
    for n in range(scramble_from, scramble_to):
        data_block[n] = (data_block[n] + data_block[n + 1]) % 256

    data_block[scramble_to] = (data_block[scramble_to] + seed) % 256

# Write output file for DATA

output_file = open("versions/apple/3-assembled-output/DATA.bin", "wb")
output_file.write(data_block)
output_file.close()

print("versions/apple/3-assembled-output/DATA.bin file saved")
