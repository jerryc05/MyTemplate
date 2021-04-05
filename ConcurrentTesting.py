#!/usr/bin/env python3

# Copyright (c) 2019-2021 Ziyan "Jerry" Chen (@jerryc05).
#                         All rights reserved.

from contextlib import suppress
from math import ceil, floor
import multiprocessing as mp
from multiprocessing.pool import AsyncResult
import os
from pathlib import Path
import platform
import shutil
import signal as sig
import subprocess as sp
import sys
import time
import typing as tp
from typing import Callable, Iterator, TextIO

if __name__ == '__main__' or os.environ.get(f'_RERUN_{os.path.basename(__file__)}'):
    VERSION = 1
    n_pools = os.cpu_count() or 6
    with suppress(AttributeError):
        n_pools = len(os.sched_getaffinity(0))
    n_pools = floor(n_pools * 1.5)


def run() -> 'tuple[bool, str, str, float]':
    def sig_handler(signum: 'sig.Signals', frame: 'sig.FrameType'):
        raise TleErr

    test_name, result, reason = 'Sleep test', False, ''
    start_t, time_limit = time.time(), 2
    try:
        if sema_tasks: sema_tasks.acquire()
        PROC_TASKS[mp.current_process().name] = test_name
        if sema_tasks: sema_tasks.release()
        sig.signal(sig.SIGALRM, sig_handler)  # use signal.SIG_IGN as handler to ignore
        sig.alarm(time_limit)  # Only Unix  # use `signal.alarm(0)` to clear the alarm

        # TODO Begin here...
        import random
        n = random.random() * 2.5
        result = n <= 1
        test_name = 'testTrue' if result else 'testFalse'
        reason = 'Slept more than 1 sec'
        if sema_tasks: sema_tasks.acquire()
        PROC_TASKS[mp.current_process().name] = test_name
        if sema_tasks: sema_tasks.release()

        # If you want to print something, don't forget to `align`
        p(f'{GLOBAL_VAR} {n}s ...', align='l')

        time.sleep(n)

        p(f'{n}s sleeping done!', align='r')

        # If you want a real-time process call:
        """
        proc = sp.Popen(('ping', 'localhost'), stdout=sp.PIPE, stderr=sp.PIPE)
        if not proc.stdout or not proc.stderr:
            reason = 'Cannot read stdout/stderr of subprocess'
        else:
            while ...:
                line, poll = proc.stdout.readline(), proc.poll()
                if not line and poll is not None:
                    if poll != 0:
                        result = False
                        code_desc = sig_to_str(poll)
                        if code_desc: code_desc = f' {code_desc}'
                        reason = f'Exit code: [{poll}{code_desc}], stderr: [{proc.stderr.read().strip().decode()}]'
                    break  # Exited
                # Do something below:
                ...
        """

        # If you want a normal process call:
        '''
        stdout = sp.check_output(('ping', 'localhost'), stderr=sp.DEVNULL)
        '''

    except TleErr:
        result, reason = False, f'Time limit {time_limit} sec excceeded'

    except:
        ex_t, ex_v, ex_tb = sys.exc_info()
        assert ex_t and ex_v and ex_tb
        result, reason = False, f'Exception: [{ex_t.__name__}], msg: [{ex_v}]'

    finally:
        sig.alarm(0)
        with suppress(NameError):  # remember to kill/term processes
            proc.terminate()  # pyright:reportUnboundVariable=false
        if sema_tasks: sema_tasks.acquire()  # fixing bug on MacOS on 20+ parallel
        PROC_TASKS[mp.current_process().name] = None
        if sema_tasks: sema_tasks.release()
    return (result, test_name, reason, time.time() - start_t)


def schedule() -> 'Iterator[tuple[Callable[..., object], tuple[object, ...]]]':
    global GLOBAL_VAR
    GLOBAL_VAR = 'Sleeping'
    for _ in range(22):
        yield (run, tuple())


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
    CUR_UP = '\x1b[00F'

    def __init__(self) -> None:
        for name in dir(self):
            if isinstance(getattr(self, name), int):
                setattr(self, name, f'\x1b[{getattr(self, name):02}m')

    def __call__(
        self,
        *values: object,
        sep: str = '',
        end: str = '\n',
        file: 'TextIO' = sys.stdout,
        flush: bool = True,
        align: 'tp.Literal["l"]|tp.Literal["c"]|tp.Literal["r"]|None' = None,
        fill_ch: str = ' '
    ) -> None:
        assert align in (None, 'l', 'c', 'r')
        if align not in ('l', 'c', 'r'):
            if lock is not None:
                lock.acquire()
            print(*values, sep=sep, end=f'{end}{self.CLR_ALL}', file=file, flush=flush)
            if lock is not None:
                lock.release()
        else:
            cols = get_cols()
            if align == 'l':
                if lock is not None:
                    lock.acquire()
                print(f'{" "*cols}\r', *values, sep=sep, end=f'{end}{self.CLR_ALL}', file=file, flush=flush)
                if lock is not None:
                    lock.release()
            else:
                orient = '^' if align == 'c' else '>'
                s = sep.join(list(map(str, values)))
                sz = cols + len(s) - strlen(s)
                s = f'{s:{fill_ch[0]}{orient}{sz}}'
                if lock is not None:
                    lock.acquire()
                print(s, sep=sep, end=f'{end}{self.CLR_ALL}', file=file, flush=flush)
                if lock is not None:
                    lock.release()


class TleErr(RuntimeError):
    ...


def find_file(name: 'Path|str', parent: bool = True) -> 'Path|None':
    path_ = Path(name)
    if path_.is_file():
        return path_.resolve()
    path_ = FILE_PATH.parent if parent else FILE_PATH
    g_res = tuple(x for x in path_.rglob(str(name)))
    if not g_res:
        return None
        # raise FileNotFoundError(f'{p.RED}Cannot find file [{p.BOLD}{name}{p.NORMAL}]!{p.CLR_ALL}')
    elif len(g_res) > 1:
        s = f'{p.RED}Ambiguous files:'
        for i, x in enumerate(g_res):
            s += f'\n{i+1}) \t{x}'
        raise RuntimeError(f'{s}{p.CLR_ALL}')
    return Path(g_res[0]).resolve()


def strlen(s: str) -> int:
    return len(s) - len('\x1b[???') * s.count('\x1b[')


def get_cols() -> int:
    return shutil.get_terminal_size(DEF_TERM_SIZE).columns or DEF_TERM_SIZE[0]


def sig_to_str(code: int) -> 'str|None':
    '''
     1) SIGHUP       2) SIGINT       3) SIGQUIT      4) SIGILL
     5) SIGTRAP      6) SIGABRT      7) SIGBUS       8) SIGFPE
     9) SIGKILL     10) SIGUSR1     11) SIGSEGV     12) SIGUSR2
    13) SIGPIPE     14) SIGALRM     15) SIGTERM     16) SIGSTKFLT
    17) SIGCHLD     18) SIGCONT     19) SIGSTOP     20) SIGTSTP
    21) SIGTTIN     22) SIGTTOU     23) SIGURG      24) SIGXCPU
    25) SIGXFSZ     26) SIGVTALRM   27) SIGPROF     28) SIGWINCH
    29) SIGIO       30) SIGPWR      31) SIGSYS      34) SIGRTMIN
    '''
    arr = [\
        None,
        'SIGHUP (terminal is closed)',
        'SIGINT (interrupted)',
        'SIGQUIT (quit requested + core dumped)',
        'SIGILL (illegal instruction)',
        'SIGTRAP (divide by zero)',
        'SIGABRT (failed assertion)',
        'SIGBUS (unaligned mem access)',
        'SIGFPE (floating point exception/int overflow',
        'SIGKILL (immediately terminate)',
        None,
        'SIGSEGV (segmentation fault)',
        None,
        'SIGPIPE (pipe not connected)',
        'SIGALRM (alarm clock)',
        'SIGTERM (gracefully terminate)',
        None,
        None,
        None,
        None,
        None,
        None,
        None,
        None,
        'SIGXCPU (CPU time limit excceeded)',
        'SIGXFSZ (file size limit excceeded)'
    ]
    return arr[-code] if -code < len(arr) else None


if __name__ == '__main__' or os.environ.get(f'_RERUN_{os.path.basename(__file__)}'):
    DEF_TERM_SIZE, DBG_MODE = (60, -1), os.environ.get('DBG')
    FILE_PATH, p, cols = Path(__file__).parent.resolve(), Print(), get_cols()
    if 'utf' not in sys.stdout.encoding.lower():
        if not os.environ.get(f'_RERUN_{os.path.basename(__file__)}'):
            os.environ[f'_RERUN_{os.path.basename(__file__)}'] = '1'
            os.environ['PYTHONIOENCODING'] = 'utf8'
            try:
                sp.check_call((sys.executable, os.path.abspath(__file__)), env=os.environ)
            except:
                import traceback
                traceback.print_exc()
            finally:
                exit()
        else:
            raise RuntimeError(f'{p.RED}Failed to set UTF-8 encoding!{p.CLR_ALL}')
    try:
        mp.set_start_method('fork')  # Only Unix
    except ValueError:
        raise NotImplementedError(f'{p.RED}Current OS does not support {p.BOLD}fork()!{p.CLR_ALL}')
    lock, sema_tasks = mp.RLock(), (mp.Semaphore(19) if platform.system() == 'Darwin' else None)
    p(f"{p.CYAN}v{VERSION}\t# of pools: {p.BOLD}{n_pools}\t{p.NORMAL}Term cols: {p.BOLD}{cols}")

    PROC_TASKS: 'dict[str, str|None]' = mp.Manager().dict()
    tasks = tuple(schedule())
    with mp.Pool(max(1, min(n_pools, len(tasks)))) as pool:
        rets: 'list[AsyncResult[tuple[bool, str, str, float]]]' = []
        succ, fail = tp.cast('list[list[tuple[str, str, float]]]', ([], []))
        print(end=f'{p.MAGENTA}{p.BOLD}')
        p(' START! ', align='c', fill_ch='=')
        for fn, args in tasks:
            rets.append(tp.cast('AsyncResult[tuple[bool, str, str, float]]', pool.apply_async(fn, args)))
        n_rets, dg_rets = len(rets), len(str(len(rets)))

        hint, ul, ur, ll, lr, hs, vs = '>>> Running', '\u250c', '\u2510', '\u2514', '\u2518', '\u2500', '\u2502'
        prog_bars = ('\u00b7', '\u258f', '\u258e', '\u258d', '\u258c', '\u258b', '\u258a', '\u2589', '\u2588')
        proc_tasks, last_time = PROC_TASKS.copy(), None
        while rets:
            for x in rets[:]:
                with suppress(mp.TimeoutError):
                    res = x.get(timeout=0)
                    (succ if res[0] else fail).append(tuple(res[1:]))  # pyright:reportGeneralTypeIssues=false
                    rets.remove(x)

                    if last_time and time.time() - last_time < 1 / 60: continue
                    last_time = time.time()
                    percent = 1 - len(rets) / n_rets
                    cols = get_cols()
                    cols_ = cols - strlen(hint) - 17 - 2*dg_rets
                    s = f'Last task finished in {p.CYAN}{res[-1]:.3f} s{p.CLR_ALL}: '
                    if res[0]:
                        s += f'{p.BOLD}{p.GREEN}'
                        s2 = f' {p.NORMAL}... OK!'
                    else:
                        s += f'{p.BOLD}{p.RED}'
                        s2 = f' {p.NORMAL}... ERR!'
                    s += f'{res[1][:cols-strlen(s)-strlen(s2)]}{s2}'

                    p1, proc_tasks = floor(cols_ * percent), PROC_TASKS.copy()
                    p2 = floor((cols_*percent - p1) * len(prog_bars))
                    p3 = cols_ - p1 - (1 if p2 else 0)
                    max_proc_name = len(max(proc_tasks.keys(), key=len))

                    with lock:
                        p(align='l')
                        for p_name, t_name in proc_tasks.items():
                            p(
                                f'{p.CYAN}{p_name:{max_proc_name}} ({f"Running): {t_name}" if t_name is not None else "Idle)"}',
                                align='l'
                            )
                        p(align='l')
                        p(s, align='l')
                        p(
                            end=
                            f'\r{hint}  {prog_bars[-1]*p1}{prog_bars[p2] if p2 else ""}{prog_bars[0]*p3}  {percent:7.2%} - {n_rets-len(rets):{dg_rets}}/{n_rets:{dg_rets}}{p.CUR_UP*(3+len(proc_tasks))}\r',
                            align='l'
                        )
        p('\n' * (3 + len(proc_tasks)), align='l')

    if succ or fail:
        print(end=f'{p.MAGENTA}{p.BOLD}')
        p(' SUMMARY ', align='c', fill_ch='=')
        succ.sort(), fail.sort()
        digit, sec_digit = len(str(max(len(succ), len(fail)))), 4
        for i, (x, r, t) in enumerate(succ):
            p(
                f'{p.GREEN}{i+1:>{digit}}. OK ({t:{sec_digit}.{max(0,sec_digit-1-len(str(ceil(t))))}f} s) \u2714 {p.BOLD}{x}{p.NORMAL}'
            )
        i = 1
        for i, (x, r, t) in enumerate(fail):
            p(
                f'{p.RED}{i+1:>{digit}}.ERR ({t:{sec_digit}.{max(0,sec_digit-1-len(str(ceil(t))))}f} s) \u274C {p.BOLD}{x}{p.NORMAL}\t ({r})'
            )
        res = f'{p.GREEN}PASSED: {p.BOLD}{len(succ)}{p.NORMAL}  {p.RED}FAILED: {p.BOLD}{len(fail)}'
        res_len = strlen(res)

        ul, ur, ll, lr, hs, vs = '\u250c', '\u2510', '\u2514', '\u2518', '\u2500', '\u2502'
        p(f'{p.CYAN}{ul}{hs*(res_len+2)}{ur}')
        p(f'{p.CYAN}{vs} {p.CLR_ALL}{res}{p.CYAN} {vs}')
        p(f'{p.CYAN}{ll}{hs*(res_len+2)}{lr}')

    print(end=f'{p.MAGENTA}{p.BOLD}')
    p(' DONE! ', align='c', fill_ch='=')
