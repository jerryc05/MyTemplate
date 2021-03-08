#!/usr/bin/env python3

import math
import multiprocessing as mp
from multiprocessing.pool import AsyncResult, Pool
import os
import shutil
import sys
import time
from typing import Any, List, TextIO


def run():
    import random
    n = random.random()
    p('start sleeping ', n, ' sec')
    time.sleep(n)
    p('end EXEC=', EXEC)
    return (n > .5, str('testTrue' if n > .5 else 'testFalse'))


def schedule(pool: Pool):
    rets: List[AsyncResult[Any]] = []
    for _ in range(18):
        rets.append(pool.apply_async(run, []))
    pool.close()
    pool.join()
    return rets


def preprocess():
    global EXEC
    EXEC = 'echo'


#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#


class Print:
    BRIGHT, DIM, NORMAL, CLR_ALL = '01', '02', '22', '00'
    BLACK, RED, GREEN, YELLOW, BLUE, MAGENTA, CYAN, WHITE, CLR_COLOR = 30, 31, 32, 33, 34, 35, 36, 37, 39
    L_BLACK_, L_RED_, L_GREEN_, L_YELLOW_, L_BLUE_, L_MAGENTA_, L_CYAN_, L_WHITE_ = 90, 91, 92, 93, 94, 95, 96, 97

    def __init__(self):
        for name in dir(self):
            if not name.startswith('_'):
                setattr(self, name, '\x1b[' + str(getattr(self, name)) + 'm')

    def __call__(self,
                 *values: object,
                 sep: str = '',
                 end: str = '\n',
                 file: TextIO = sys.stdout,
                 flush: bool = True,
                 align: str = 'l',
                 fill_ch: str = ' '):
        if align != 'c' and align != 'r':
            print(*values,
                  self.CLR_ALL,
                  sep=sep,
                  end=end,
                  file=file,
                  flush=flush)
        else:
            orient = '^' if align == 'c' else '>'
            cols, _ = shutil.get_terminal_size(_DEF_TERM_SIZE)
            s = sep.join(list(map(str, values)))
            f: str = '{:' + fill_ch + orient + str(cols +
                                                   5 * s.count('\x1b[')) + '}'
            s = f.format(s)
            print(s, self.CLR_ALL, sep=sep, end=end, file=file, flush=flush)


if __name__ == '__main__':
    p = Print()

    _N_PARALLEL = os.cpu_count() or 4
    _DEF_TERM_SIZE = (30, '?')
    _TERM_SIZE = shutil.get_terminal_size(_DEF_TERM_SIZE)
    p(p.YELLOW, 'Parallel count: ', p.BRIGHT, _N_PARALLEL, '\t', p.CLR_ALL,
      p.CYAN, 'Terminal window size: ', p.BRIGHT,
      _TERM_SIZE[0] if _TERM_SIZE != _DEF_TERM_SIZE else '?', ' x ',
      _TERM_SIZE[1])

    preprocess()
    with mp.Pool(_N_PARALLEL) as pool:
        print(p.MAGENTA, p.BRIGHT, sep='', end='')
        p(' START! ', align='c', fill_ch='=')
        rets = schedule(pool)

    if rets:
        print(p.MAGENTA, p.BRIGHT, sep='', end='')
        p(' SUMMARY ', align='c', fill_ch='=')
        i = 1
        fail: List[str] = []
        digit = str(math.ceil(math.log10(len(rets) + 1)))
        for x in rets:
            if x.get()[0]:
                p(p.GREEN, ('%' + digit + 'd') % i, '. ', p.BRIGHT,
                  x.get()[1], p.CLR_ALL, p.GREEN, ' ... OK!')
                i += 1
            else:
                fail.append(x.get()[1])
        i = 1
        for x in fail:
            p(p.RED, ('%' + digit + 'd') % i, '. ', p.BRIGHT, x, p.CLR_ALL,
              p.RED, ' ... failed!')
            i += 1

    print(p.MAGENTA, p.BRIGHT, sep='', end='')
    p(' DONE! ', align='c', fill_ch='=')

    try:
        import psutil
        pname: str = psutil.Process(os.getppid()).name()
    except:
        try:
            import subprocess as sp
            pname = sp.run('ps -p %d -o comm=' % os.getppid(),
                           stderr=sp.DEVNULL).stdout
        except:
            ...
    try:
        if not pname.endswith('sh') and not pname.startswith('python'):
            input(pname +
                  ': You can now terminate this program by [ENTER] ...')
    except:
        ...