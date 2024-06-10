# Idea

Program that takes a dir as input and serializes all files to asingle text file. Can take a list of dirs to ignore. The purpose would be getting a snapshot of a directory that could be fed into and LLM or maybe even versions control to track diffs?

# TODO:

- [ ] better format/dilineation between files
- [ ] doesn't respect gitignore

# Example

Imagine a dir like:

.
└── level1
└── 1a.js
└── 1b.js
└── level2
└── 2a.js

Call like this (where script looks at local ignore.txt list or smth)

    . dir-serializer.sh /path/to/dir

Output something like

```txt
path: level1/1a.js

"console.log('1a.js')"

path: level1/1b.js

"console.log('1b.js')"

path: level1/level2/2a.js

"console.log('2a.js')"
```

#

Looks like this was already done here:

https://github.com/QaisarRajput/codebase_to_text/tree/main
