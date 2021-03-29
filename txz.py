#!/usr/bin/env python3

import lzma as xz
import os
import os.path as path
import sys
import tarfile as tar
import time

if __name__ == '__main__':
    XZ_LVL = 8
    TAR_FORMAT = tar.GNU_FORMAT

    def filter_file(tarinfo: tar.TarInfo) -> 'tar.TarInfo|None':
        if tarinfo.name.startswith('_'): return None
        tarinfo.uid = tarinfo.gid = 0
        tarinfo.uname = tarinfo.gname = ''
        return tarinfo

    if len(sys.argv[1:]) == 1:
        ofname = f'{path.basename(sys.argv[1])}.{"" if path.isfile(sys.argv[1]) else "t"}xz'
    else:
        ofname = f'{path.basename(path.dirname(sys.argv[1]))}.txz'
    while ...:
        if path.isfile(ofname):
            s = f'Filename [{ofname}] exists. Do you want to:\n'\
                f'1) Press ENTER directly to overwrite.\n'\
                f'2) Enter a new name without extension to rename.\n'\
                f'>>> '
        else:
            s = f'Filename will be [{ofname}]. Do you want to:\n'\
                f'1) Press ENTER directly to confirm.\n'\
                f'2) Enter a new name without extension to rename.\n'\
                f'>>> '
        option = input(s).strip()
        print()
        if option: ofname = f'{option}.{"" if len(sys.argv[1:]) == 1 else "t"}xz'
        else: break

    tmpfname = f'{ofname}.tmp'
    try:
        with xz.open(tmpfname, 'wb', preset=XZ_LVL) as fxz:
            if ofname.endswith('.xz'):
                with open(sys.argv[1], 'rb') as ff:
                    while ...:
                        b = ff.read1()
                        if not b: break
                        fxz.write(b)
            else:
                with tar.open(fileobj=fxz, mode='w', format=TAR_FORMAT) as ftar:
                    relpath = path.dirname(sys.argv[1])
                    for x in sys.argv[1:]:
                        ftar.add(path.relpath(x, relpath), filter=filter_file)
        os.rename(tmpfname, ofname)
    except:
        os.remove(tmpfname)

    print(f'File written to [{path.abspath(ofname)}]!')
    time.sleep(5)
