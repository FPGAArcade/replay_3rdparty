#!/usr/bin/env python
import sys
sys.path.append('../../replay_common/scripts')

import bin2hex

roms = {
  'pacrom_1m',
  'pacrom_4a',
  'pacrom_5e',
  'pacrom_5f',
  'pacrom_6e',
  'pacrom_6f',
  'pacrom_6h',
  'pacrom_6j',
  'pacrom_7f'
}
path = './rtl/roms/'

for rom in roms:
    print('converting ROM :',rom)
    rom_src = rom + '.bin'
    rom_dst = rom + '.hex'

    bin2hex.conv(path + rom_src, path + rom_dst)
