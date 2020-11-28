#!/usr/bin/env sh

TMP_FILE=$(mktemp)
NPROC=$(nproc)
for i in $(seq 1 30); do
  while jobs -r >${TMP_FILE}; (( $(cat ${TMP_FILE} | wc -l) > ${NPROC} )); do
    sleep .2
  done

  (
    echo "${i}: Do sth in parallel here, for example"
    ping 10.0.0.0 -w ${i}           >/dev/null
    # and much more ...
  ) &
done