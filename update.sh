#!/usr/bin/env sh

git fetch --depth=1 && git reset --hard "@{u}"
git subtree pull --prefix=tools/pdqsort https://github.com/orlp/pdqsort.git master --squash
