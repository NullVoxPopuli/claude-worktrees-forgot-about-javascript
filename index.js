import { fileURLToPath } from 'node:url';
import { execSync } from 'node:child_process';

let root = execSync(`git rev-parse --show-toplevel`).toString().trim();


let aDepsLocation = import.meta.resolve('typescript');
let aDepsPath = fileURLToPath(aDepsLocation);
let cleaned = aDepsPath.replace(root, "<repo>")

console.log(cleaned)
