#!/usr/bin/env bash
#
# hope people have a .bashrc / .bash_profile set up correctly
# so that it has access to pnpm



PURPLE=$'\e[35m'
ENDCOLOR=$'\e[0m'

echo -e "\n\n${PURPLE}Initial Setup${END_COLOR}\n\n"
pnpm install
node ./index.js

git worktree add ./demo-a origin/main

echo -e "\n\n${PURPLE}cd into worktree${END_COLOR}\n\n"
cd demo-a
node ./index.js

echo -e "\n\n${PURPLE}the path after installing locally${END_COLOR}\n\n"
pnpm install
node ./index.js

echo -e "\n\n${PURPLE}cleanup${END_COLOR}\n\n"
cd ..
git worktree remove ./demo-a

