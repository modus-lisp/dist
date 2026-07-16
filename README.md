# modus-lisp Quicklisp distribution

A self-hosted [Quicklisp](https://www.quicklisp.org/) dist for the pure-Common-Lisp
`modus-lisp` libraries (no FFI): `cl-consensus`, `cl-tor`, `seal`, `natrium`,
`cl-transport`, `pagetree`, `secp256k1-fast`, `zstd-pure`.

## Use

```lisp
(ql-dist:install-dist "https://modus-lisp.github.io/dist/modus.txt" :prompt nil)
(ql:quickload "cl-consensus")      ; or cl-consensus/tor, cl-tor, seal, zstd-pure, ...
```

Regenerated with [quickdist](https://github.com/blytkerchan/quickdist) from each repo's
`master`. Served via GitHub Pages.
