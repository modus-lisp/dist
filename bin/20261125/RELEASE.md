# modus release 2026-11-25

> **`modus.com` has been withdrawn from this release** (2026-11-28): Windows Defender flags the
> one-file polyglot.  The other files are unchanged and `SHA256SUMS` lists them.  What follows
> describes the release as it was built.

Source: `modus-lisp/modus` commit `f947e42f0b0bae230c3234428b83ade21f3d9204`.  Build ID `261389890` (`$((16#f947e42))`).

New since `20261124`:

- **macOS.**  `modus-macos-arm64` is the CLI for macOS on Apple silicon (macOS 14.4 or
  later), built from source on Linux with no Apple toolchain: the Darwin image in an
  ad-hoc-signed Mach-O that `mvm/build-macos-cli.lisp` writes.  Run on a Mac, it passes
  `host/macos/mac-test.sh` with output identical to the `build-macos.sh` (Apple `ld`) control.
- **`modus.com` carries all three CLIs, each gzip'd: 49.6 MB, down from 99.9 MB.**  Its
  shell half picks the Linux or macOS image by `uname -sm`; on Windows its PE is a small
  launcher that inflates the Windows CLI once into `%LOCALAPPDATA%\modus\` and runs it.
- **`modus-windows-x64.exe` takes `--dynamic-space-size`**, as the Linux CLI does.

| file | built by | how |
|---|---|---|
| `modus-linux-x64` | compiled | `mvm/build-generic-cli.lisp` |
| `modus-windows-x64.exe` | compiled | `mvm/build-win64-cli.lisp` |
| `modus-builder-linux-x64` | compiled | `MODUS_BUILDER=1 MODUS_NARROW_STRINGS=1 mvm/build-generic-cli.lisp` |
| `modus-builder-windows-x64.exe` | compiled | `MODUS_BUILDER=1 MODUS_NARROW_STRINGS=1 mvm/build-win64-cli.lisp` |
| `modus-macos-arm64` | compiled | `mvm/build-macos-cli.lisp` around the Darwin image (below) |
| `modus.com` | derived | `scripts/make-ape.lisp` from the three CLIs, the launcher and three segments (below) |

Two more files were compiled as steps and are not shipped on their own:

| file | sha256 | how |
|---|---|---|
| `modus-darwin-arm64.elf` (inside `modus-macos-arm64`) | `c70bbe0897ce588e084c792333cc6416699324e66e68d1f90c9fc81002f6c1bf` | `MODUS_DARWIN=1 MODUS_CODE_BASE=7000010000 MODUS_CONV_DELTA=7040000000 MODUS_HEAP_BASE=7080000000 MODUS_JIT_ARENA_BASE=7100000000 mvm/build-aarch64-cli.lisp` |
| `modus-ape-stub.exe` (`modus.com`'s PE) | `fddcdba96671b12206b545a458f9e6e2094784ff4f8dc2e3c46ce9e9f957a696` | `mvm/build-ape-stub.lisp` |

Every compiled file, these two included, was built three times, on three different hosts,
and the three are byte-identical:

1. SBCL (`sbcl --dynamic-space-size 16384 --script SCRIPT`);
2. `modus-builder-linux-x64` from step 1, on Linux;
3. `modus-builder-windows-x64.exe` from step 1, under Wine.

Each with

```sh
MODUS_SOURCE_COMMIT=f947e42f0b0bae230c3234428b83ade21f3d9204 MODUS_BUILD_ID=261389890 MODUS_FASL=0
MODUS_NATRIUM=<natrium at the commit below>      # the Mach-O's code signature (SHA-256)
```

and no vessel checkout (the hosted CLIs need none).

`modus.com` (`MODUS_APE_PE`, `MODUS_APE_ELF`, `MODUS_APE_MACHO`, `MODUS_APE_STUB`,
`MODUS_APE_CRAM`, `MODUS_APE_SEGMENTS`) is the same bytes made by SBCL and by
`modus-linux-x64`.  Besides the three CLIs it holds three segments:

- `main.lisp`: modus's `scripts/ape-main.lisp` (the menu: `desk`, `repl`, `sources`);
- `cram.lisp`: cram's `src/` files in `cram.asd`'s order (also `MODUS_APE_CRAM`, the gzip);
- `src.tar.z`: `scripts/make-source-tar.lisp` over the repositories below (the closure of
  glass/wm, cram, fs-fat and fs-apple, plus modus, natrium and vessel: 10 repositories,
  1524 files), the same bytes made by SBCL and by `modus-linux-x64`
  (`8e471858f5d64c92263f0ce034cde3058d0ffe687d81ac780caba78f6df0ff1b`).

What `modus.com` runs is a release file's exact bytes: compare the copy it caches
(`~/.cache/modus/` on Linux and macOS, `%LOCALAPPDATA%\modus\` on Windows) with
`SHA256SUMS`.

Source tree for `src.tar.z` (each a `git archive` of the commit named):

```
brotli-pure e7ba1fc305ca2b735dddfeecd02b7ad6de79de1b
cl-transport e8767dad3dc958e5800d01cb047a8737526a4ce2
cram 3b2ebfbd1881a2a815092e2ad60d1837ed8f6e42
fs-apple 2afde9bec56bd762cbc5bf99fec0c4506b73fcfc
fs-fat 7f8f7e38c298909c94d9d946752f7d196c2b9dd8
glass 462f81a2dcfef7796f1687080c6bd59970aeb2f1
modus f947e42f0b0bae230c3234428b83ade21f3d9204
natrium cde4e44b9929dee78ba49a641c5f9f72915d2d7a
scribe d6c6442f0f49ad0d885d722085c21080a80e5a67
vessel 34eb1f53e4e32a008852356db47b5407ad16b97b
```

To rebuild and check: `docs/building.md` in modus.
