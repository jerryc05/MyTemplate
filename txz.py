import lzma as xz
import os.path as path
import sys
import tarfile as tar

if __name__ == '__main__':

    def filter_file(tarinfo: tar.TarInfo) -> 'tar.TarInfo|None':
        if tarinfo.name.startswith('_'): return None
        tarinfo.uid = tarinfo.gid = 0
        tarinfo.uname = tarinfo.gname = "root"
        return tarinfo

    if len(sys.argv[1:]) == 1:
        ofname = f'{path.basename(sys.argv[1])}.txz'
    else:
        ofname = f'{path.basename(path.dirname(sys.argv[1]))}.txz'
    if path.isfile(ofname):
        option = input(
            f'Filename [{ofname}.txz] exists. Choose one of the following:\n'
            '1) Enter a new name without extension to rename.\n'
            '2) Press ENTER directly to overwrite.\n'
            '>>> '
        )
        if option: ofname = f'{option}.txz'

    with xz.open(ofname, 'wb', preset=8) as fxz:
        with tar.open(fileobj=fxz, mode="w", format=tar.GNU_FORMAT) as ftar:
            for x in sys.argv[1:]:
                ftar.add(x, filter=filter_file)
