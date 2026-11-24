# modus release 2026-11-24

Source: `modus-lisp/modus` commit `d2d6d67fed800895353a88ba0d084b0801ac6454`.  Build ID `221080935` (`$((16#d2d6d67))`).

New since `20261123`: hosted x64 sizes its heap at startup (`--dynamic-space-size`, as SBCL
takes it); an allocation that does not fit after a collection stops with "heap exhausted"
instead of corrupting the heap; the builder also builds the Darwin AArch64 CLI byte-identical
to SBCL's; and `modus.com` carries segments: run it with no options for a menu --
`modus.com desk` (the glass window manager over VNC), `repl`, `sources`.

| file | built by | how |
|---|---|---|
| `modus-linux-x64` | compiled | `mvm/build-generic-cli.lisp` |
| `modus-windows-x64.exe` | compiled | `mvm/build-win64-cli.lisp` |
| `modus-builder-linux-x64` | compiled | `MODUS_BUILDER=1 MODUS_NARROW_STRINGS=1 mvm/build-generic-cli.lisp` |
| `modus-builder-windows-x64.exe` | compiled | `MODUS_BUILDER=1 MODUS_NARROW_STRINGS=1 mvm/build-win64-cli.lisp` |
| `modus.com` | derived | `scripts/make-ape.lisp` from the two CLIs and three segments (below) |

Every compiled file was built three times, on three different hosts, and the three are
byte-identical:

1. SBCL (`sbcl --dynamic-space-size 12288 --script SCRIPT`);
2. `modus-builder-linux-x64` from step 1, on Linux;
3. `modus-builder-windows-x64.exe` from step 1, under Wine.

Each with

```sh
MODUS_SOURCE_COMMIT=d2d6d67fed800895353a88ba0d084b0801ac6454 MODUS_BUILD_ID=221080935 MODUS_FASL=0
```

and no vessel checkout (the hosted CLIs need none).

`modus.com` is the Windows image with the Linux image appended, then three segments
(`MODUS_APE_SEGMENTS`), the same bytes made by SBCL and by `modus-linux-x64`:

- `main.lisp`: modus's `scripts/ape-main.lisp`;
- `cram.lisp`: cram's `src/` files in `cram.asd`'s order;
- `src.tar.z`: `scripts/make-source-tar.lisp` over the repositories below (the closure of
  glass/wm, cram, fs-fat and fs-apple, plus modus and vessel: 9 repositories, 1474 files),
  the same bytes made by SBCL and by `modus-linux-x64`.

On Unix it runs `modus-linux-x64`'s exact bytes (copied to `~/.cache/modus/`; compare that
file with `SHA256SUMS`); on Windows it runs as the PE.

Source tree for `src.tar.z` (each a `git archive` of the commit named):

```
brotli-pure e7ba1fc305ca2b735dddfeecd02b7ad6de79de1b
cl-transport e8767dad3dc958e5800d01cb047a8737526a4ce2
cram 3b2ebfbd1881a2a815092e2ad60d1837ed8f6e42
fs-apple 2afde9bec56bd762cbc5bf99fec0c4506b73fcfc
fs-fat 7f8f7e38c298909c94d9d946752f7d196c2b9dd8
glass 462f81a2dcfef7796f1687080c6bd59970aeb2f1
modus d2d6d67fed800895353a88ba0d084b0801ac6454
scribe d6c6442f0f49ad0d885d722085c21080a80e5a67
vessel 34eb1f53e4e32a008852356db47b5407ad16b97b
```

To rebuild and check: `docs/building.md` in modus.
