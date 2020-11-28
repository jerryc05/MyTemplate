#!/usr/bin/env sh

for i in $(seq 100 300); do
  (( __ = __ % $(nproc) )); (( __++ == 0 )) && wait

  (
    echo "Do sth in parallel here"
    echo "and here"
  ) &
done