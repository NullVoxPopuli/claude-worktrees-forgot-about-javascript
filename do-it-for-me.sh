#!/usr/bin/env bash
#
# hope people have a .bashrc / .bash_profile set up correctly
# so that it has access to pnpm



PURPLE=$'\e[35m'
ENDCOLOR=$'\e[0m'

purple() { echo "${PURPLE}$1${ENDCOLOR}" ; }

purple "Initial Setup"
pnpm install
node ./index.js

pruple "create worktree (git worktree add ./demo-a origin/main)"
git worktree add ./demo-a origin/main

purple "cd into worktree (demo-a)"
cd demo-a
node ./index.js

purple "after we run install...."
pnpm install
node ./index.js

purple "cleanup (git worktree remove ./demo-a)"
cd ..
git worktree remove ./demo-a

