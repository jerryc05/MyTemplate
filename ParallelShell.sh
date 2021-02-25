#!/usr/bin/env bash

red=$(tput setaf 1 2>/dev/null)
bld=$(tput bold 2>/dev/null)
udl=$(tput smul 2>/dev/null)
clr=$(tput sgr0 2>/dev/null)

[ -z "$BASH" ]&&echo "${red}${bld}=====Test script may not work well under non-BASH shell\!=====" >&2
NPROC=$(getconf _NPROCESSORS_ONLN 2>/dev/null || getconf NPROCESSORS_ONLN)


for i in $(seq 1 30); do
  while (($(jobs -r | wc -l)>=NPROC)); do wait -n; done

  {
    echo "$i: Do sth in parallel here, for example"
    ping 10.0.0.0 -w "$i" >/dev/null
    # and much more ...
  }&
done

wait
echo "===== DONE ====="
