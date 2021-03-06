#!/usr/bin/env python3

import multiprocessing as mp
from multiprocessing.pool import AsyncResult, Pool
import os
import shutil
import sys
from typing import List, TextIO

if __name__ == '__main__':

    def run(p: 'Print'):
        import random, time
        n = random.random() * 2
        p('start sleeping ', n, ' sec')
        time.sleep(n)
        p('end   sleeping ', n, ' sec')

    def schedule(pool: Pool, p: 'Print'):
        rets: List[AsyncResult[object]] = []
        for _ in range(18):
            rets.append(pool.apply_async(run, (p, )))
        _pool.close()
        _pool.join()
        # for ret in rets:
        #     ...

    class Print:
        BRIGHT, DIM, NORMAL, CLR_ALL = '01', '02', '22', '00'
        BLACK, RED, GREEN, YELLOW, BLUE, MAGENTA, CYAN, WHITE, CLR_COLOR = 30, 31, 32, 33, 34, 35, 36, 37, 39
        L_BLACK_, L_RED_, L_GREEN_, L_YELLOW_, L_BLUE_, L_MAGENTA_, L_CYAN_, L_WHITE_ = 90, 91, 92, 93, 94, 95, 96, 97

        def __init__(self):
            for name in dir(self):
                if not name.startswith('_'):
                    setattr(self, name,
                            '\x1b[' + str(getattr(self, name)) + 'm')

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
                cols, _ = shutil.get_terminal_size()
                s = sep.join(list(map(str, values)))
                f: str = '{:' + fill_ch + orient + str(cols + 5 *
                                                       s.count('\x1b[')) + '}'
                s = f.format(s)
                print(s,
                      self.CLR_ALL,
                      sep=sep,
                      end=end,
                      file=file,
                      flush=flush)

    p = Print()

    _N_PARALLEL = os.cpu_count() or 4
    _TERM_SIZE = shutil.get_terminal_size()
    p(p.YELLOW, 'Parallel count: ', p.BRIGHT, _N_PARALLEL, '\t', p.CYAN,
      'Terminal size: ', p.BRIGHT, _TERM_SIZE.columns, ' x ', _TERM_SIZE.lines)

    _pool = mp.Pool(_N_PARALLEL)
    print(p.MAGENTA, p.BRIGHT, sep='', end='')
    p(' START! ', align='c', fill_ch='=')
    schedule(_pool, p)
    _pool.close()
    _pool.join()
    print(p.MAGENTA, p.BRIGHT, sep='', end='')
    p(' DONE! ', align='c', fill_ch='=')
