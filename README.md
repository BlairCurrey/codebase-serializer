# codebase-serializer

Takes a directory as input and stores all file paths and their contents into a single markdown file. Observes the `.gitignore` file, if any.

Output is like:

````
# /Users/me/myapp/src/app.js
```javascript
console.log("hello world");
```

# /Users/me/myapp/src/config.js
```javascript
export const FOO = bar;
```
````

See [./test/expected_output/test_codebase_1.md](./test/expected_output/test_codebase_1.md) for a fuller example of the output.

## Motivation

This makes it easier to copy/paste code into an LLM. It's ideal for small codebases and prototypes where you can actually fit the entire codebase into the context window. I found myself prefering to write all code in a single file for the purposes of easy copy/pasting (1 long typescript file, or an html file with styles and scripts inlined, etc). This script basically lets you seperate code into different files like a normal person.

## Usage

```bash
git clone https://github.com/BlairCurrey/codebase-serializer
```

```bash
cd codebase-serializer
```

```bash
./main.sh /Users/me/code/myapp myapp-serialized.md
```

# Why markdown?

It's structured enough for LLMs yet still readable for humans. The serialized markdown file is essentially a key (filepath) value (file content) pair but the file content in particular limits viable formats. Yaml or toml handle multiline strings fine but JSON does not. Ultimately, the output is meant to be passed into an LLM so the stricter structure of yaml or toml is not really necessary (like it might be if we were parsing the output ourselves).

# Development

git clone this repo and run `./test/run-tests.sh` to run the tests.

# TODO:

- [ ] handle more filetypes in the outputted md codeblocks
- [ ] copy to clipboard

Some additional args to help control what's included:

- [ ] `excludes` argument to ignore certain files (in addition to .gitignore)
- [ ] `includes` argument to include certain files

This would be useful but perhaps tedious to configure. To alleviate this we could add a `--config` option to avoid having to form the `--exclude` and `--include` lists in the command. Perhap we could also add an `--interactive` flag which would prompt the user to include/exclude files and optionally save the choices to a config file. The scope of common cases (always ignore `package-lock.json`, etc.) are probably too large to handle intelligiently and would require a lot of assumptions about what should be included.

# Shoutout

Shoutout to a similar project that I found when searching for this idea. Ultimately I wanted something in bash and which output to other formats than docx and txt but this is the same idea:

https://github.com/QaisarRajput/codebase_to_text/tree/main
