# modus release 2026-11-26

Source: `modus-lisp/modus` commit `057780f88ed6d68cd10d43c193ebf7693f709872`.  Build ID `5732367` (`$((16#057780f))`).

New since `20261125`:

- **`modus.com` carries the whole organisation's source**: every modus-lisp repository but
  dist (67, 6033 files), so `modus.com sources` unpacks all of modus-lisp and the desk can
  load what it ships.  85.6 MB.
- **The desk**: Files (warren) is in its menu, and Terminal is not.  Browser (loom) is not
  yet: weft still depends on chipz.
- **macOS**: `modus.com desk` serves frames (LISTEN on a socket asks ppoll on every AArch64
  image, compiled in, because a boot-time redefinition cannot reach compiled callers in
  macOS's signed code), and `modus.com repl` starts the REPL on every platform.
- **Merged**: the PowerPC Mac port (ppc-mac), the hosted-Windows work (modus win64-hosted,
  seal windows-trust, cairn windows-worktree, kiln modus-kiln, vessel windows-host).
- **Mutual tail calls are off for now** (`*TAIL-CALLS*` NIL): SBCL and a modus builder
  marked different calls, so their images differed.  Self tail calls are unaffected.

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
| `modus-darwin-arm64.elf` (inside `modus-macos-arm64`) | `6f5864559dc946cee8d4b10867924123d6ce533008f4666d862d1b67b5a46963` | `MODUS_DARWIN=1 MODUS_CODE_BASE=7000010000 MODUS_CONV_DELTA=7040000000 MODUS_HEAP_BASE=7080000000 MODUS_JIT_ARENA_BASE=7100000000 mvm/build-aarch64-cli.lisp` |
| `modus-ape-stub.exe` (`modus.com`'s PE) | `7d2c00da3aa878fcb9ee7b1998bb67e8b01407fc8a8764bd01fc7ee555361410` | `mvm/build-ape-stub.lisp` |

Every compiled file, these two included, was built three times, on three different hosts,
and the three are byte-identical:

1. SBCL (`sbcl --dynamic-space-size 16384 --script SCRIPT`);
2. `modus-builder-linux-x64` from step 1, on Linux;
3. `modus-builder-windows-x64.exe` from step 1, under Wine.

Each with

```sh
MODUS_SOURCE_COMMIT=057780f88ed6d68cd10d43c193ebf7693f709872 MODUS_BUILD_ID=5732367 MODUS_FASL=0
MODUS_NATRIUM=<natrium at the commit below>      # the Mach-O's code signature (SHA-256)
```

and no vessel checkout (the hosted CLIs need none).

`modus.com` (`MODUS_APE_PE`, `MODUS_APE_ELF`, `MODUS_APE_MACHO`, `MODUS_APE_STUB`,
`MODUS_APE_CRAM`, `MODUS_APE_SEGMENTS`) is the same bytes made by SBCL and by
`modus-linux-x64`.  Besides the three CLIs it holds three segments:

- `main.lisp`: modus's `scripts/ape-main.lisp` (the menu: `desk`, `repl`, `sources`);
- `cram.lisp`: cram's `src/` files in `cram.asd`'s order (also `MODUS_APE_CRAM`, the gzip);
- `src.tar.z`: `MODUS_SRC_REPOS=all scripts/make-source-tar.lisp` over the repositories
  below (every modus-lisp repository but dist: 67, 6033 files), the same bytes made by SBCL
  and by `modus-linux-x64` (`36520ab1184b18de2ce670f517849f7acb9fdb37df1501da516beab809f52cdc`).

What `modus.com` runs is a release file's exact bytes: compare the copy it caches
(`~/.cache/modus/` on Linux and macOS, `%LOCALAPPDATA%\modus\` on Windows) with
`SHA256SUMS`.

Source tree for `src.tar.z` (each a `git archive` of the commit named):

```
.github 34afe002f398bde954fd5fbba9ad30e3698127a3
beacon 8f101a222aade0f9b70ae8427a5e1ad6dd668797
brotli-pure e7ba1fc305ca2b735dddfeecd02b7ad6de79de1b
cabinet 8064e5c9f7489ece3675c104af912dbedb789d13
cairn 2d276514cedc117a4c93e46b96b31ee2cc3b8064
cassette 249c6751166b729de1414cca763ed62d745056ad
chirp 1278a491a95bd3cd0029280e80b2acceceef14dc
chord 04134a5dc9fb49329e4925a15c4a79eba372c30f
cl-consensus b2962dcd09b23e280b9725be9318c1594bb1708c
cl-deposits 654b98dfe28391e29d598555340a82f1e8d90222
cl-fips aea8d6720c42a7670381c088b2344154ff16acbf
cl-frpc 5b29c27497282f1c65bf011add0bbdf49bf872ba
cl-marmot 5d1cbe18e372aefe834cf425bcb1730427594d85
cl-nostr d891b03a3ad0e8e28f8d1b9141f7a9a48622758e
cl-payments 7c663a06ce92064023994f6a7734231498507762
cl-sev-snp dfa76291c00f13f68c46e14cc59e542ec28b0619
cl-smb fce9a074a2af49925f9008f08c11c5c01e211c84
cl-tor 1ffbfe8b8e4ec17dbb315e458ea09597427b6cfd
cl-transport e8767dad3dc958e5800d01cb047a8737526a4ce2
conch 1463a607e504a5b3067615ad9c4239b7e7939eaf
cram 3b2ebfbd1881a2a815092e2ad60d1837ed8f6e42
emissary 2a1be7555b07a168836e3979a68a16251717aa9c
ex-nihilo a6f6907d8be05a909ce3f04ba48975b0abe28e3b
folio c6db791463c022364d1a443f15cebd40a81051ed
fs-apple 2afde9bec56bd762cbc5bf99fec0c4506b73fcfc
fs-fat 7f8f7e38c298909c94d9d946752f7d196c2b9dd8
gesso 3db03a9d33c0ba4507482145f9b0c893359cf99e
glass 4c1b9ab3f43d4c93bd9af3b55ec2b2ba6ee77e8f
glass-mcclim e9c4a06efd7e2e94365b40af6ebb86a38a5c8a01
glass-sdl 5a5e0e10cbe49a853d1758576f0cb6af6f86eb61
glass-webrtc d7825edfe3fa4154d9110fc810d4b0599baa1383
illatio 1a8229d5f670fccc2beeb31f0749a46210fe9034
json-simple a562e5a4251df5010477ba879bd7ceb8ed522588
kiln adba4311b780163d989a638b64a726c55b48ea2e
loom 5a179149d27db46a9ea77ada05efdde42aa59ff2
mill 2553ba57bb5c9345ed299e26d930ee88267ba457
modus 057780f88ed6d68cd10d43c193ebf7693f709872
modus-lisp.github.io 270551423f5799d3cd21073fbffde7b302d81e9c
natrium 8c494a3c2c92b47a4bc5f2568da4083eed9f4962
operandi fb2ebccbc3221053958f0ed6bd148900c571bbc4
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
shuttle 4406e01cf306efc175a2cdaae98e87a41824d143
skep 1fa33347da2f6fec4180307e10713c6d233dde14
spool 26124c2b291c504d5042f0c74704723cf4b3159f
sqlite-pure c125a6fe8c439e66ae6d38bc385146d29a1d3a8c
stave 12940fb63fa2cc80c58e528c6c8bff0c5965770c
stencil 0a7da387844c889d3a1319037c29a68777685e49
trellis 881011eb026b0d6b1ed2faecfa9633c4ce3dd1a7
vessel 8b6e5cf85d94534b23e28bc8a2e2a225b4c7a91f
warp 627f4ee8ad7becab1d51b50bf4b307c2ffd1f7a2
warren 1a85384aeb84c9e4ae8f80bb612c973b14784b7f
wax 0b48716cfce52be990e0ef43fcecb2c5fa899b44
webp-pure ff5c1e93331ebd7f318464700bebddbc3392d4c4
webrtc-data cec39e8cab9b0702e4cc57c60e6aadaf83b50564
webrtc-media 318513223559c109be1cd5fdcf01df80e096750c
weft 8375ff817744ecf477da8f6dcd00456b87ca1c0c
witness 8b5267740d02147d79ef81ae39a3d34da09d023c
zstd-pure ebbd28eab4401caf3ad6fba34d5d5353602cc8ff
```

To rebuild and check: `docs/building.md` in modus.
