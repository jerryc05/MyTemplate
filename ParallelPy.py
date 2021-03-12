#!/usr/bin/env python3

import glob
import math
import multiprocessing as mp
from multiprocessing.pool import AsyncResult
import os
import re
import shutil
import subprocess as sp
import sys
import time
from typing import Callable, Dict, List, TextIO, Tuple


def run(G_VARS: Dict[str, object]) -> Tuple[bool, str]:
    for _k, _v in G_VARS.items():
        if _k not in globals(): globals()[_k] = _v
    import random
    n = random.random()
    with lock:
        p('start sleeping ', n, ' sec, GLOBAL_VAR%d' % (n * 6), '=',
          globals()['GLOBAL_VAR%d' % (n * 6)])
    time.sleep(n)
    with lock:
        p('end sleeping ', n, ' sec', align='r')
    proc = sp.Popen(('ping', 'localhost'), stdout=sp.PIPE, stderr=sp.DEVNULL)
    while ...:
        line: bytes = proc.stdout.readline()
        poll_res = proc.poll()
        if not line and poll_res is not None:
            break
        if line:
            proc.kill()
    return (n > .5, str('testTrue' if n > .5 else 'testFalse'))


def schedule() -> List[Tuple[Callable[..., object], Tuple[object, ...]]]:
    global G_VARS
    tasks: List[Tuple[Callable[..., object], Tuple[object, ...]]] = []
    for _ in range(18):
        tasks.append((run, (G_VARS, )))
    return tasks


def setup() -> None:
    GLOBAL_VAR0 = "v0"
    GLOBAL_VAR1 = "v1"
    GLOBAL_VAR2 = "v2"
    GLOBAL_VAR3 = "v3"
    GLOBAL_VAR4 = "v4"
    GLOBAL_VAR5 = "v5"
    add_to_g_vals(locals())


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
        align = align.lower()
        if align != 'c' and align != 'r':
            print(*values,
                  self.CLR_ALL,
                  sep=sep,
                  end=end,
                  file=file,
                  flush=flush)
        else:
            orient = '^' if align == 'c' else '>'
            cols, _ = shutil.get_terminal_size(DEF_TERM_SIZE)
            s = sep.join(list(map(str, values)))
            f: str = '{:' + fill_ch + orient + \
                    str(cols + 5 * s.count('\x1b[')) + '}'
            s = f.format(s)
            print(s, self.CLR_ALL, sep=sep, end=end, file=file, flush=flush)


def find_file(name: str, parent: bool = True) -> str:
    if os.path.isfile(name):
        return os.path.abspath(name)
    g_res = glob.glob('../**/%s' % name, recursive=True) if parent else None
    if not g_res:
        raise Exception('%s%sCannot find file [%s]!%s' %
                        (p.RED, p.BRIGHT, name, p.CLR_ALL))
    return os.path.abspath(g_res[0])


def add_to_g_vals(d: Dict[str, object]) -> None:
    global G_VARS
    for _k, _v in d.items():
        if not _k.startswith('_') and \
            not any(re.match(x, str(type(_v))[8:-2]) for x in \
                ('^module$', '^typing(\..+)?$')):
            G_VARS[_k] = _v


if __name__ == '__main__':
    p, lock = Print(), mp.Manager().Lock()
    G_VARS = {}  # type: Dict[str, object]

    _N_PARALLEL = os.cpu_count() or 4
    DEF_TERM_SIZE = (30, -1)
    _TERM_SIZE = shutil.get_terminal_size(DEF_TERM_SIZE)
    p(p.YELLOW, 'Parallel count: ', p.BRIGHT, _N_PARALLEL, '\t', p.CLR_ALL,
      p.CYAN, 'Terminal window size: ', p.BRIGHT,
      _TERM_SIZE[0] if _TERM_SIZE != DEF_TERM_SIZE else '?', ' x ',
      _TERM_SIZE[1] if _TERM_SIZE != DEF_TERM_SIZE else '?')

    add_to_g_vals(locals())
    setup()
    tasks = schedule()
    with mp.Pool(max(1, min(_N_PARALLEL, len(tasks)))) as pool:
        print(end='%s%s' % (p.MAGENTA, p.BRIGHT))
        p(' START! ', align='c', fill_ch='=')
        rets = []  # type: List[AsyncResult[Tuple[bool, str]]]
        for fn, args in tasks:
            rets.append(pool.apply_async(fn, args))

        succ: List[str] = []
        fail: List[str] = []
        for x in rets:
            (succ if x.get()[0] else fail).append(x.get()[1])

    if succ or fail:
        print(end='%s%s' % (p.MAGENTA, p.BRIGHT))
        p(' SUMMARY ', align='c', fill_ch='=')
        digit = str(math.ceil(math.log10(max(len(succ), len(fail)) + 1)))
        for i, x in enumerate(succ):
            p(p.GREEN, ('%' + digit + 'd') % (i + 1), '. ', p.BRIGHT, x,
              p.CLR_ALL, p.GREEN, ' ... OK!')
        i = 1
        for i, x in enumerate(fail):
            p(p.RED, ('%' + digit + 'd') % (i + 1), '. ', p.BRIGHT, x,
              p.CLR_ALL, p.RED, ' ... ERR!')

    print(end='%s%s' % (p.MAGENTA, p.BRIGHT))
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
