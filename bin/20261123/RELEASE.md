# modus release 2026-11-23

> **`modus.com` has been withdrawn from this release** (2026-11-28): Windows Defender flags the
> one-file polyglot.  The other files are unchanged and `SHA256SUMS` lists them.  What follows
> describes the release as it was built.

Source: `modus-lisp/modus` commit `378aca65793a9852789f06246af1bdce0fb9db03`
(branch `selfhost-build`).  Build ID `58240166` (`$((16#378aca6))`).

| file | built by | how |
|---|---|---|
| `modus-linux-x64` | compiled | `mvm/build-generic-cli.lisp` |
| `modus-windows-x64.exe` | compiled | `mvm/build-win64-cli.lisp` |
| `modus-builder-linux-x64` | compiled | `MODUS_BUILDER=1 MODUS_NARROW_STRINGS=1 mvm/build-generic-cli.lisp` |
| `modus-builder-windows-x64.exe` | compiled | `MODUS_BUILDER=1 MODUS_NARROW_STRINGS=1 mvm/build-win64-cli.lisp` |
| `modus.com` | derived | `scripts/make-ape.lisp` (commit `7de80c03`) from `modus-windows-x64.exe` and `modus-linux-x64` |

Every compiled file was built three times, on three different hosts, and the three are
byte-identical:

1. SBCL (`sbcl --dynamic-space-size 12288 --script SCRIPT`);
2. `modus-builder-linux-x64` from step 1, on Linux;
3. `modus-builder-windows-x64.exe` from step 1, under Wine.

Each with

```sh
MODUS_SOURCE_COMMIT=378aca65793a9852789f06246af1bdce0fb9db03 MODUS_BUILD_ID=58240166 MODUS_FASL=0
```

and no vessel checkout (the hosted CLIs need none).  `modus.com` is not compiled: it is the
two CLIs joined by `make-ape`, which gives the same bytes under SBCL, the Linux builder and the
Windows builder.  On Unix it runs `modus-linux-x64`'s exact bytes (copied to
`~/.cache/modus/`; compare that file with `SHA256SUMS`); on Windows it runs as the PE.

To rebuild and check: `docs/building.md` in modus.
