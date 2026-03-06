#!/usr/bin/env bash
#
# hope people have a .bashrc / .bash_profile set up correctly
# so that it has access to pnpm

echo -e "\n\nInitial Setup\n\n"
pnpm install
node ./index.js

git worktree add ./demo-a origin/main

echo -e "\n\ncd into worktree\n\n"
cd demo-a
node ./index.js

echo -e "\n\nthe path after installing locally\n\n"
pnpm install
node ./index.js

echo -e "\n\ncleanup\n\n"
cd ..
git worktree remove ./demo-a

