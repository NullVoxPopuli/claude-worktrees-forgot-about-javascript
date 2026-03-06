# Claude's does not support worktrees well with JavaScript projects

Claude, by default, creates worktrees in a sub-folder of the main git root.

_This is bad_.

It's bad for JavaScript especially, because when node, bun, whatever using node's resolve algorithm searcehes for a `bin` or dependency, it searches _up_ the directory structure (yarn 1 relied on this to its detriment).


Example:
```
.                root
  ./index.js     main file    
  ./worktree-a   some worktree
      index.js   main file
````

If `index.js` has require/import:

- `./wortree-a/index.js` resolves the root's dependency if dependencies are not installed

This can be catestrophic in big repos where dependencies can move around or be upgraded frequently.

We can see how the mismatch manifests with this simple one liner:

```bash
# typescript is the only dependency in this repo
node -e "console.log(require.resolve('typescript'))"
```

> [!NOTE]
> There is a script you can run `./do-it-for-me.sh` that automates all this

1. at `.` of this repo, 
    1. `pnpm install`
    1. `node ./index.js` or run the above, you'll get: 
        ```bash
        <repo>/node_modules/.pnpm/typescript@5.9.3/node_modules/typescript/lib/typescript.js
        ```
    1. create a worktree -- if you don't have `ignore-scripts=true` set in youn `~/.npmrc`, I did this for you.
       (manually do: `git worktree add ./some-sister-path`
    1. cd `./the-work-tree-path`
        1. run `node './index.js` or the above script, and you'll get:
            ```bash
            <repo>/node_modules/.pnpm/typescript@5.9.3/node_modules/typescript/lib/typescript.js
            ```
            This is bad because versions and the whole dep graph could be different between worktrees
        1. run `pnpm install`
        1. run `node './index.js` or the above script, and you'll get:
            ```bash
            <repo>/the-work-tree-path/node_modules/.pnpm/typescript@5.9.3/node_modules/typescript/lib/typescript.js
            ```

  
And with npm 

1. at `.` of this repo, 
    1. `npm install`
    1. `node ./index.js` or run the above, you'll get: 
        ```bash
        <repo>/node_modules/typescript/lib/typescript.js
        ```
    1. create a worktree -- if you don't have `ignore-scripts=true` set in youn `~/.npmrc`, I did this for you.
       (manually do: `git worktree add ./some-sister-path`
    1. cd `./the-work-tree-path`
        1. run `node './index.js` or the above script, and you'll get:
            ```bash
            <repo>/node_modules/typescript/lib/typescript.js
            ```
            This is bad because versions and the whole dep graph could be different between worktrees
        1. run `npm install`
        1. run `node './index.js` or the above script and you'll get:
            ```bash
            <repo>/demo-a/node_modules/typescript/lib/typescript.js
            ```

## So what, the paths are different?

While this demonstration is simple, and doesn't show _what_ can go wrong, a common thing I've been seeing:
- TypeScript private brand types do not match (and they must match, else the private types are considered "different")
- Graphs of build dependencies need to be upgraded together, and resolve to incorrect versions (versions from other worktrees)
- Result in duplicate modules being bundled in vite apps (or any project that uses "bundling")


## Solution?

Use Sister Worktrees, and don't ever nest worktrees.

e.g:
```
./repo
./repo-1
./repo-2
```

Also valid:
```
./repo
./repo-worktrees/
    ./repo-1
    ./repo-2
```
