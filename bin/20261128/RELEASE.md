# modus release 2026-11-28

Five files are the same bytes as in [`20261126`](../20261126/RELEASE.md): `modus-linux-x64`,
`modus-windows-x64.exe`, `modus-builder-linux-x64`, `modus-builder-windows-x64.exe` and
`modus-macos-arm64`.  That release's notes say how they were built (modus
`057780f88ed6d68cd10d43c193ebf7693f709872`, three hosts, byte-identical).

New since `20261126`:

- **`modus-20261128.zip` replaces `modus.com`** (withdrawn: Windows Defender flags the
  one-file polyglot).  One folder: the three executables above, `desk` and `repl`
  launchers for Windows (`.cmd`), Linux (`.sh`) and macOS (`.command`), and every
  modus-lisp repository's source under `src/`.  `desk` starts the glass desk, serves it to a
  browser on http://127.0.0.1:6080/ and opens it there; `desk --help` lists its flags.
  Built by `scripts/make-release-zip.lisp`: SBCL and `modus-linux-x64` give the same bytes.
  Its `src/` is every modus-lisp repository but dist (69), each a `git archive` of the
  commit below; the executables are this release's.  `test/run-release-zip.sh` in modus
  unpacks it and checks the layout, `repl.sh` and `desk.sh --help`.

  ```sh
  sbcl --script scripts/make-release-zip.lisp --release 20261128 --tree TREE/ --bin BIN/   # or modus-linux-x64 --script
  ```

  ```
  .github 42df2a89467594ce93340a954e25bd537fb5932d
  beacon 8f101a222aade0f9b70ae8427a5e1ad6dd668797
  bobbin 74be16843a6eb0953fa81080b152b686b47779a8
  brotli-pure e7ba1fc305ca2b735dddfeecd02b7ad6de79de1b
  cabinet 8064e5c9f7489ece3675c104af912dbedb789d13
  cairn 2d276514cedc117a4c93e46b96b31ee2cc3b8064
  cassette 249c6751166b729de1414cca763ed62d745056ad
  chirp d2b72fd5e815c33e874ae7d9d210d4717edf2151
  chord 04134a5dc9fb49329e4925a15c4a79eba372c30f
  cl-consensus a6a64b3f1f2b92f5c9eb887edd411b7ec89dd1db
  cl-deposits d1dfc07bf1ca149f2f6f6dfba8cab01d3623b92b
  cl-fips 87e24baa09c1c4f6c9a93eeb8e1663fe604afde0
  cl-frpc 5b29c27497282f1c65bf011add0bbdf49bf872ba
  cl-marmot 5d1cbe18e372aefe834cf425bcb1730427594d85
  cl-nostr 4d0ed506399a9a88a0d42525425047332956bf90
  cl-payments ff72529ea94b49053cdb404a73cd5b57a57f6165
  cl-sev-snp dfa76291c00f13f68c46e14cc59e542ec28b0619
  cl-smb fce9a074a2af49925f9008f08c11c5c01e211c84
  cl-tor 7f5e27064d0d1fb897be3b9e3ee805fa40dee652
  cl-transport 03d1d280b163b8a51e843c37f5e52320bc2f8c6e
  comb b977f100a08cfa3e69855f57bff24658f935c983
  conch 1463a607e504a5b3067615ad9c4239b7e7939eaf
  cram 1783d7885e8ce7beff608df97c7a36f40c1efce8
  emissary fb81df2f0ed732e50fd77ad501fcb5b931d70116
  ex-nihilo a6f6907d8be05a909ce3f04ba48975b0abe28e3b
  folio c6db791463c022364d1a443f15cebd40a81051ed
  fs-apple 2afde9bec56bd762cbc5bf99fec0c4506b73fcfc
  fs-fat 7f8f7e38c298909c94d9d946752f7d196c2b9dd8
  gesso 3db03a9d33c0ba4507482145f9b0c893359cf99e
  glass 1e69bb31e63cff73865da1a4a270ca7e2195b823
  glass-mcclim e9c4a06efd7e2e94365b40af6ebb86a38a5c8a01
  glass-sdl 5a5e0e10cbe49a853d1758576f0cb6af6f86eb61
  glass-webrtc e5dde753c23fa3a803e06104fa8ab2f1b09bf594
  illatio 3f449cfe1f15cac9650f2af643115797ef7934df
  json-simple a562e5a4251df5010477ba879bd7ceb8ed522588
  kiln 8d7037a7bd22be1c4b4912a00c2654a0bfeb3014
  loom 5a179149d27db46a9ea77ada05efdde42aa59ff2
  mill 7ebb9ac87eb6ad409f4b2b876a652a2ad61d0f3b
  modus 5d3ef6b5b311aab8d91f1838847c4066ef135ac8
  modus-lisp.github.io 270551423f5799d3cd21073fbffde7b302d81e9c
  natrium 5da1a8b7bd54af742e74c241914895598761cbce
  operandi 051e5f7bebe109f4378c5f94051dd2ab162bf426
  operandi-gui e6c06630e9aed0fe341aac04f179b07a2e1caa40
  pagetree aee0f0fa897db04058a52f4670dcf724c115759e
  pigment f10025f4cf549ff60f6cabcaf1e8dc9c387fc92e
  png-pure 074357cd479638960faf07fb45d0199a9d440e4b
  quill af1e68ad60e67daa90227280c5099bbfce51749d
  reed 9992a5a51576944fc584e6d9af5095de2db92e25
  reel 8dcaa237ce74c4923f2bf827ba8dfcb3cdff3093
  scribe d6c6442f0f49ad0d885d722085c21080a80e5a67
  seal 17403a5bab34e68b57ddd71fc6a8319b87e0ad6d
  secp256k1-fast e49023e0617024638b46713273c784aefc6d3ab9
  shuttle 9d5bd1be59b21d84099347630176d3e3a194e123
  skep b407ec43b8aeea1fef8287f35b30fe5776d7525b
  spool 44a63c3961bdd31da555577005de9885d2691afa
  sqlite-pure c125a6fe8c439e66ae6d38bc385146d29a1d3a8c
  stave 12940fb63fa2cc80c58e528c6c8bff0c5965770c
  stencil 0a7da387844c889d3a1319037c29a68777685e49
  trellis 881011eb026b0d6b1ed2faecfa9633c4ce3dd1a7
  vessel 076ba81eb66bc67f2301aad8873b79c13d07212a
  warp 627f4ee8ad7becab1d51b50bf4b307c2ffd1f7a2
  warren 1a85384aeb84c9e4ae8f80bb612c973b14784b7f
  wax 0b48716cfce52be990e0ef43fcecb2c5fa899b44
  webp-pure ff5c1e93331ebd7f318464700bebddbc3392d4c4
  webrtc-data baea9bf27f394e892b4f0b596cb93684829a5414
  webrtc-media 318513223559c109be1cd5fdcf01df80e096750c
  weft 5d0e9e17023206d8953571317297b323a27bb294
  witness 8b5267740d02147d79ef81ae39a3d34da09d023c
  zstd-pure ebbd28eab4401caf3ad6fba34d5d5353602cc8ff
  ```

- **`modus-kiln-windows-x64.exe`**: kiln on Windows with nothing else installed.  It is
  `modus-builder-windows-x64.exe` with kiln and kiln's git (cairn and what it loads)
  appended as source, so `--kiln` works:

  ```bat
  mkdir modus-lisp & cd modus-lisp
  modus-kiln-windows-x64.exe --kiln sync      &REM every repo in repos.lock, cloned with cairn
  modus-kiln-windows-x64.exe --kiln windows   &REM sync, build modus.exe from the checkout, install
  ```

  No git, bash, SBCL or administrator rights are needed.  kiln's README ("On Windows, with
  nothing but modus.exe") has the details.

| file | built by | how |
|---|---|---|
| `modus-kiln-windows-x64.exe` | derived | `kiln/boot/bundle.lisp modus-builder-windows-x64.exe OUT` over the workspace below |

The bundler appends two segments (modus's `scripts/ape-segments.lisp` trailer):

- `kiln/main.lisp`: kiln's `boot/main.lisp`, which unpacks the pack and runs kiln;
- `kiln/src.pack`: 106 files, sorted by path.  They are kiln's `boot/kiln.lisp` and
  `repos.lock`, plus the `.asd` files, `LICENSE` and `src/` of cairn, seal, conch, cram
  and natrium.

SBCL (`sbcl --script`) and `modus-builder-linux-x64` (`--script`) make the same bytes.

Workspace (each a clone of the commit named):

```
kiln 05d75719cdf0f92493c6726915334ad70ab483f0
cairn 2d276514cedc117a4c93e46b96b31ee2cc3b8064
seal 17403a5bab34e68b57ddd71fc6a8319b87e0ad6d
conch 1463a607e504a5b3067615ad9c4239b7e7939eaf
cram 3b2ebfbd1881a2a815092e2ad60d1837ed8f6e42
natrium b468a30dcb55ca4d01372ce2b246828e3b20d73f
modus 48372f38bd76dc7a58fdc4cd1d35d891289887a5   (scripts/ape-segments.lisp only)
```

Tested under Wine, starting from an empty directory:

| step | result |
|---|---|
| `--kiln help` | unpacks the pack into `%LOCALAPPDATA%\modus\kiln\`, loads cairn, prints the usage |
| `--kiln sync` | 51 repos cloned with cairn in 29 min, none failed; every checkout clean against real git (apart from the submodule entries noted below) |
| `--kiln windows --no-sync` | stage 1 (a builder from the workspace's modus, `fc79f7c9`, built by this exe) and stage 2 (`modus.exe` from that builder): 46 min.  `vessel.exe` installed; Hello 3D, Storybook and chirp in the Start menu |

Known: cairn leaves submodule entries out of the index, so in cl-consensus and scribe real
git reports `deps/...` as staged deletions.  Building from modus needs `fc79f7c9` or later:
earlier main spelled a layout offset that this builder's compiler rejects.
