import { fileURLToPath } from 'node:url';
import { execSync } from 'node:child_process';

/**
 * For all worktrees there exists only one .git directory
 *
 * When invoking this in a worktree, we get the full absolute path.
 * But when invoking in the main directory, git returns just ".git",
 * as if that's helpful.
 */
let root = 
  execSync(`git rev-parse --git-dir`).toString().trim().split('.git')[0] 
  || execSync(`git rev-parse --show-toplevel`).toString().trim();

let aDepsLocation = import.meta.resolve('typescript');
let aDepsPath = fileURLToPath(aDepsLocation);
let cleaned = aDepsPath.replace(root, "<repo>")

console.log(cleaned)
