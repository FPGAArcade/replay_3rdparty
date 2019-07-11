#!/usr/bin/env python
import runpy, sys
#sys.argv.append('--root=../../../') # default is ../../
sys.argv.append('--group=3rdparty')
sys.argv.append('--core=pacman')
sys.argv.append('--target=')
runpy.run_path('../../replay_common/scripts/common.py')

