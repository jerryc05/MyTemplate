#!/usr/bin/env python3

# Copyright (c) 2019-2021 Ziyan "Jerry" Chen (@jerryc05).
#                         All rights reserved.

import glob
import math
import multiprocessing as mp
import multiprocessing.synchronize as mp_sync
from multiprocessing.pool import AsyncResult
import os
import re
import shutil
import subprocess as sp
import sys
import time
import typing as tp
from typing import Callable, Iterator, TextIO

if __name__ == '__main__':
    G_VARS: 'dict[str, object]' = {}


def run() -> 'tuple[bool, str, float]':
    start_time = time.time()

    # TODO Begin here...
    import random
    n = random.random()

    # If you want to print something, don't forget to `align`
    p(f'Sleeping {n}s ...', align='l')

    time.sleep(n)

    p(f'{n}s sleeping done!', align='r')

    # If you want a real-time process call:
    """
    proc = sp.Popen(('ping', 'localhost'), stdout=sp.PIPE, stderr=sp.DEVNULL)
    while ...:
        line: bytes = proc.stdout.readline()
        poll = proc.poll()
        if not line:
            if poll is None:
                continue  # Still running
            else:
                break  # Exited successfully
        # Do something below:
        ...
    """

    # If you want a normal process call:
    '''
    stdout = sp.check_output(('ping', 'localhost'), stderr=sp.DEVNULL)
    '''
    return (n > .5, 'testTrue' if n > .5 else 'testFalse',
            time.time() - start_time)


def schedule() -> 'Iterator[tuple[Callable[..., object], tuple[object, ...]]]':
    for _ in range(22):
        yield (run, tuple())


def setup() -> None:
    GLOBAL_VAR0 = "v0"
    GLOBAL_VAR1 = "v1"
    GLOBAL_VAR2 = "v2"
    GLOBAL_VAR3 = "v3"
    GLOBAL_VAR4 = "v4"
    GLOBAL_VAR5 = "v5"
    _add_to_g_vars(locals())


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
    CLR_ALL, BOLD, DIM, UNDERLINE, REVERSE, NORMAL = 0, 1, 2, 4, 7, 22
    BLACK, RED, GREEN, YELLOW, BLUE, MAGENTA, CYAN, WHITE, CLR_COLOR = 30, 31, 32, 33, 34, 35, 36, 37, 39
    L_BLACK_, L_RED_, L_GREEN_, L_YELLOW_, L_BLUE_, L_MAGENTA_, L_CYAN_, L_WHITE_ = 90, 91, 92, 93, 94, 95, 96, 97
    CUR_UP = '\x1b[F'

    def __init__(self, lock: 'mp_sync.SemLock|None' = None) -> None:
        self.lock = lock
        for name in dir(self):
            if isinstance(getattr(self, name), int):
                setattr(self, name, f'\x1b[{getattr(self, name):02}m')

    def __call__(self,
                 *values: object,
                 sep: str = '',
                 end: str = '\n',
                 file: 'TextIO' = sys.stdout,
                 flush: bool = True,
                 align: 'str|None' = None,
                 fill_ch: str = ' ') -> None:
        assert align in (None, 'l', 'c', 'r')
        if align is None:
            if self.lock is not None:
                self.lock.acquire()
            print(*values,
                  sep=sep,
                  end=f'{end}{self.CLR_ALL}',
                  file=file,
                  flush=flush)
            if self.lock is not None:
                self.lock.release()
        else:
            align = align.lower()
            cols = shutil.get_terminal_size(DEF_TERM_SIZE).columns
            if align == 'l':
                if self.lock is not None:
                    self.lock.acquire()
                print(f'{" "*cols}\r',
                      *values,
                      sep=sep,
                      end=f'{end}{self.CLR_ALL}',
                      file=file,
                      flush=flush)
                if self.lock is not None:
                    self.lock.release()
            else:
                orient = '^' if align == 'c' else '>'
                s = sep.join(list(map(str, values)))
                sz = cols + len(s) - strlen(s)
                s = f'{s:{fill_ch[0]}{orient}{sz}}'
                if self.lock is not None:
                    self.lock.acquire()
                print(s,
                      sep=sep,
                      end=f'{end}{self.CLR_ALL}',
                      file=file,
                      flush=flush)
                if self.lock is not None:
                    self.lock.release()


def find_file(name: str, parent: bool = True) -> str:
    if os.path.isfile(name):
        return os.path.abspath(name)
    g_res = glob.glob('../**/{name}', recursive=True) if parent else None
    if not g_res:
        raise FileNotFoundError(
            f'{p.RED}Cannot find file [{p.BOLD}{name}{p.NORMAL}]!{p.CLR_ALL}')
    return os.path.abspath(g_res[0])


def strlen(s: str) -> int:
    return len(s) - 5 * s.count('\x1b[')


def _add_to_g_vars(d: 'dict[str, object]') -> None:
    global G_VARS
    for _k, _v in d.items():
        if not _k.startswith('_') and \
            not any(re.match(x, str(type(_v))[8:-2]) for x in \
                ('^function$', '^module$', '^type$', \
                    r'^typing(\..+)?$')):
            G_VARS[_k] = _v


def _copy_g_vars(g):
    global G_VARS
    G_VARS = g


if __name__ == '__main__':
    _N_PARALLEL = os.cpu_count() or 4
    DEF_TERM_SIZE = (60, -1)
    _term_sz = shutil.get_terminal_size(DEF_TERM_SIZE)

    lock, G_VARS = mp.RLock(), {}
    p = Print(lock)
    p(f"{p.CYAN}Parallel count: {p.BOLD}{_N_PARALLEL}\t{p.NORMAL}Terminal window size: {p.BOLD}{_term_sz[0] if _term_sz != DEF_TERM_SIZE else '?'} x {_term_sz[1] if _term_sz != DEF_TERM_SIZE else '?'}"
      )

    _add_to_g_vars(locals())
    setup()
    tasks = tuple(schedule())
    with mp.Pool(max(1, min(_N_PARALLEL, len(tasks))),
                 initializer=_copy_g_vars,
                 initargs=(G_VARS, )) as pool:
        rets: 'list[AsyncResult[tuple[bool, str, float]]]' = []
        succ, fail = tp.cast('list[list[tuple[str, float]]]', ([], []))
        print(end=f'{p.MAGENTA}{p.BOLD}')
        p(' START! ', align='c', fill_ch='=')
        for fn, args in tasks:
            rets.append(
                tp.cast('AsyncResult[tuple[bool, str, float]]',
                        pool.apply_async(fn, args)))
        n_rets, dg_rets = len(rets), math.ceil(math.log10(len(rets) + .5))

        hint, ul, ur, ll, lr, hs, vs = '>>> Running', '\u250c', '\u2510', '\u2514', '\u2518', '\u2500', '\u2502'
        prog_bars = ('\u00b7', '\u258f', '\u258e', '\u258d', '\u258c',
                     '\u258b', '\u258a', '\u2589', '\u2588')
        while rets:
            for x in rets[:]:
                try:
                    res = x.get(timeout=0)
                    (succ if res[0] else fail).append((res[1], res[2]))
                    rets.remove(x)

                    percent = 1 - len(rets) / n_rets
                    cols = shutil.get_terminal_size(
                        DEF_TERM_SIZE).columns - strlen(
                            hint) - 17 - 2 * dg_rets
                    s = f'Last task finished in {p.CYAN}{res[2]:.3f} s{p.CLR_ALL}: '
                    if res[0]:
                        s += f'{p.BOLD}{p.GREEN}{res[1]} {p.NORMAL}... {"OK!"}'
                    else:
                        s += f'{p.BOLD}{p.RED}{res[1]} {p.NORMAL}... {"ERR!"}'

                    p1 = math.floor(cols * percent)
                    p2 = math.floor((cols * percent - p1) * len(prog_bars))
                    p3 = cols - p1 - (1 if p2 else 0)
                    with lock:
                        p(' ', align='r')
                        p(s, align='l')
                        p(end=
                          f'\r{hint}  {prog_bars[-1]*p1}{prog_bars[p2] if p2 else ""}{prog_bars[0]*p3}  {percent:7.2%} - {n_rets-len(rets):{dg_rets}}/{n_rets:{dg_rets}}{p.CUR_UP}{p.CUR_UP}\r'
                          )
                except mp.TimeoutError:
                    continue
        p('\n\n')

    if succ or fail:
        print(end=f'{p.MAGENTA}{p.BOLD}')
        p(' SUMMARY ', align='c', fill_ch='=')
        digit = str(math.ceil(math.log10(max(len(succ), len(fail)) + .5)))
        for i, (x, t) in enumerate(succ):
            p(f'{p.GREEN}{i+1:>{digit}}.{p.BOLD}{x}{p.NORMAL} ... OK! ({t:.3f} s)'
              )
        i = 1
        for i, (x, t) in enumerate(fail):
            p(f'{p.RED}{i+1:>{digit}}.{p.BOLD}{x}{p.NORMAL} ... ERR! ({t:.3f} s)'
              )
        res = f'{p.GREEN}PASSED: {p.BOLD}{len(succ)}{p.NORMAL}  {p.RED}FAILED: {p.BOLD}{len(fail)}'
        res_len = strlen(res)

        ul, ur, ll, lr, hs, vs = '\u250c', '\u2510', '\u2514', '\u2518', '\u2500', '\u2502'
        p(f'{p.CYAN}{ul}{hs*(res_len+2)}{ur}')
        p(f'{p.CYAN}{vs} {p.CLR_ALL}{res}{p.CYAN} {vs}')
        p(f'{p.CYAN}{ll}{hs*(res_len+2)}{lr}')

    print(end=f'{p.MAGENTA}{p.BOLD}')
    p(' DONE! ', align='c', fill_ch='=')