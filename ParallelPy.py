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
import typing as tp
from typing import Callable, TextIO

if __name__ == '__main__':
    G_VARS: 'dict[str, object]' = {}


def run(G_VARS: 'dict[str, object]') -> 'tuple[bool, str]':
    for _k, _v in G_VARS.items():
        if _k not in globals(): globals()[_k] = _v
    import random
    n = random.random()
    # with lock:
    #     p(f'start sleeping {n} sec, GLOBAL_VAR{int(n * 6)}={globals()[f"GLOBAL_VAR{int(n*6)}"]}'
    #       )
    time.sleep(n)
    # with lock:
    #     p(f'end sleeping {n} sec', align='r')
    proc = sp.Popen(('ping', 'localhost'), stdout=sp.PIPE, stderr=sp.DEVNULL)
    while ...:
        line: bytes = proc.stdout.readline()
        poll_res = proc.poll()
        if not line and poll_res is not None:
            break
        if line:
            proc.kill()
    return (n > .5, str('testTrue' if n > .5 else 'testFalse'))


def schedule() -> 'list[tuple[Callable[..., object], tuple[object, ...]]]':
    global G_VARS
    tasks: 'list[tuple[Callable[..., object], tuple[object, ...]]]' = []
    for _ in range(20):
        tasks.append((run, (G_VARS, )))
    return tasks


def setup() -> None:
    GLOBAL_VAR0 = "v0"
    GLOBAL_VAR1 = "v1"
    GLOBAL_VAR2 = "v2"
    GLOBAL_VAR3 = "v3"
    GLOBAL_VAR4 = "v4"
    GLOBAL_VAR5 = "v5"
    add_to_g_vars(locals())


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
#
#
#
#
#
#
#


class Print:
    BRIGHT, DIM, NORMAL, CLR_ALL = 1, 2, 22, 0
    BLACK, RED, GREEN, YELLOW, BLUE, MAGENTA, CYAN, WHITE, CLR_COLOR = 30, 31, 32, 33, 34, 35, 36, 37, 39
    L_BLACK_, L_RED_, L_GREEN_, L_YELLOW_, L_BLUE_, L_MAGENTA_, L_CYAN_, L_WHITE_ = 90, 91, 92, 93, 94, 95, 96, 97
    CUR_UP = '\x1b[F'

    def __init__(self) -> None:
        for name in dir(self):
            if isinstance(getattr(self, name), int):
                setattr(self, name, f'\x1b[{getattr(self, name):02}m')

    def __call__(self,
                 *values: object,
                 sep: str = '',
                 end: str = '\n',
                 file: TextIO = sys.stdout,
                 flush: bool = True,
                 align: str = 'l',
                 fill_ch: str = ' ') -> None:
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
            sz = cols + len(s) - strlen(s)
            s = f'{s:{fill_ch[0]}{orient}{sz}}'
            print(s, self.CLR_ALL, sep=sep, end=end, file=file, flush=flush)


def find_file(name: str, parent: bool = True) -> str:
    if os.path.isfile(name):
        return os.path.abspath(name)
    g_res = glob.glob('../**/{name}', recursive=True) if parent else None
    if not g_res:
        raise FileNotFoundError(
            f'{p.RED}Cannot find file [{p.BRIGHT}{name}{p.CLR_ALL}{p.RED}]!{p.CLR_ALL}'
        )
    return os.path.abspath(g_res[0])


def add_to_g_vars(d: 'dict[str, object]') -> None:
    global G_VARS
    for _k, _v in d.items():
        if not _k.startswith('_') and \
            not any(re.match(x, str(type(_v))[8:-2]) for x in \
                ('^function$', '^module$', '^type$', \
                    r'^typing(\..+)?$')):
            G_VARS[_k] = _v


def strlen(s: str) -> int:
    return len(s) - 5 * s.count('\x1b[')


if __name__ == '__main__':
    _N_PARALLEL = os.cpu_count() or 4
    DEF_TERM_SIZE = (30, -1)
    _term_sz = shutil.get_terminal_size(DEF_TERM_SIZE)

    p, lock = Print(), mp.Manager().Lock()
    p(f"{p.CYAN}Parallel count: {p.BRIGHT}{_N_PARALLEL}\t{p.CLR_ALL}{p.CYAN}Terminal window size: {p.BRIGHT}{_term_sz[0] if _term_sz != DEF_TERM_SIZE else '?'} x {_term_sz[1] if _term_sz != DEF_TERM_SIZE else '?'}"
      )

    add_to_g_vars(locals())
    setup()
    tasks = schedule()
    with mp.Pool(max(1, min(_N_PARALLEL, len(tasks)))) as pool:
        p(end=f'{p.MAGENTA}{p.BRIGHT}')
        p(' START! ', align='c', fill_ch='=')
        # using str for type annotation for compatiblity
        rets: 'list[tuple[AsyncResult[tuple[bool, str]], float]]' = []
        for fn, args in tasks:
            rets.append((tp.cast('AsyncResult[tuple[bool, str]]',
                                 pool.apply_async(fn, args)), time.time()))
        n_rets, dg_rets = len(rets), math.ceil(math.log10(len(rets) + .5))

        succ, fail = tp.cast('list[str]', []), tp.cast('list[str]', [])
        full_b, half_b, testing = '\u2588', '\u2027', 'Testing'
        p()
        while rets:
            for x in rets[:]:
                try:
                    res = x[0].get(timeout=0)
                    (succ if res[0] else fail).append(res[1])
                    rets.remove(x)
                    percent = 1 - len(rets) / n_rets
                    cols = shutil.get_terminal_size(
                        DEF_TERM_SIZE).columns - strlen(
                            testing) - 11 - 2 * dg_rets
                    s = f'Last finished in {p.BLUE}{time.time()-x[1]:3.2f}s: {p.CLR_ALL}'
                    if res[0]:
                        s += f'{p.BRIGHT}{p.GREEN}{res[1]} {p.CLR_ALL}{p.GREEN}{"OK!"}'
                    else:
                        s += f'{p.BRIGHT}{p.RED}{res[1]} {p.CLR_ALL}{p.RED}{"ERR!"}'
                    with lock:
                        p(f'{p.CUR_UP}\r{s}{" "*(cols-strlen(s))}')
                        p(end=
                          f'\r{testing} {full_b*int(cols*percent)}{half_b*(cols-int(cols*(percent)))} {percent:2.0%} - {n_rets-len(rets):{dg_rets}}/{n_rets:{dg_rets}}'
                          )
                except mp.TimeoutError:
                    ...
        p()

    if succ or fail:
        p(end=f'{p.MAGENTA}{p.BRIGHT}')
        p(' SUMMARY ', align='c', fill_ch='=')
        digit = str(math.ceil(math.log10(max(len(succ), len(fail)) + .5)))
        for i, x in enumerate(succ):
            p(f'{p.GREEN}{i+1:>{digit}}.{p.BRIGHT}{x}{p.CLR_ALL}{p.GREEN} ... OK!'
              )
        i = 1
        for i, x in enumerate(fail):
            p(f'{p.RED}{i+1:>{digit}}.{p.BRIGHT}{x}{p.CLR_ALL}{p.RED} ... ERR!'
              )
        res = f' {p.GREEN}PASSED: {p.BRIGHT}{len(succ)}{p.CLR_ALL} {p.RED}FAILED: {p.BRIGHT}{len(fail)} '
        res_len = strlen(res)

        ul, ur, ll, lr, hs, vs = '\u250c', '\u2510', '\u2514', '\u2518', '\u2500', '\u2502'
        p(f'{p.CYAN}{ul}{hs*(res_len)}{ur}')
        p(f'{p.CYAN}{vs}{p.CLR_ALL}{res}{p.CYAN}{vs}')
        p(f'{p.CYAN}{ll}{hs*(res_len)}{lr}')

    p(end=f'{p.MAGENTA}{p.BRIGHT}')
    p(' DONE! ', align='c', fill_ch='=')

    try:
        import psutil
        pname: 'str|None' = psutil.Process(os.getppid()).name()
    except:
        try:
            import subprocess as sp
            pname = sp.check_output(f'ps -p {os.getppid()} -o comm=',
                                    stderr=sp.DEVNULL).decode()
        except:
            pname = None
    if pname and not pname.endswith('sh') and not pname.startswith('python'):
        input('You can now end this program by [ENTER] ...')
