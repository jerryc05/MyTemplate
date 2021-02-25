#!/usr/bin/env bash

NPROC=$(nproc)
for i in $(seq 1 30); do  
  while [ "$(jobs -r | wc -l)" -ge 3 ];do wait -n;done

  {
    echo "$i: Do sth in parallel here, for example"
    ping 10.0.0.0 -w "$i" >/dev/null
    # and much more ...
  }&
done

wait
echo "===== DONE ====="
