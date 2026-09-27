# modus-lisp Quicklisp distribution

A self-hosted [Quicklisp](https://www.quicklisp.org/) dist for the pure-Common-Lisp
`modus-lisp` libraries: 44 projects, 125 systems. Nearly all are pure Common Lisp with no
FFI; the exceptions are marked.

### Crypto, networking and protocols

| system | what it is |
|---|---|
| `natrium` | dependency-free, constant-time crypto: SHA-2/HMAC/HKDF, ChaCha20-Poly1305, X25519, Ed25519 |
| `secp256k1-fast` | secp256k1 ECDSA + BIP340 Schnorr with SBCL VOPs (not constant-time) |
| `seal` | TLS 1.3/1.2 client and HTTP |
| `conch` | SSH-2 client and server: exec, scp, SFTP |
| `cl-tor` / `cl-tor-transport` | a from-scratch Tor client, v3 onion services |
| `cl-transport` | uniform outbound transport: direct / SOCKS5 / Tor / pluggable |
| `cl-frpc` | frp reverse-proxy client (yamux + TLS) |
| `webrtc-data` | WebRTC data channels: ICE/STUN/TURN/DTLS/SCTP |
| `webrtc-media` | WebRTC media plane: SRTP/RTP, G.711, VP8 encoder |
| `cl-nostr` | Nostr client: NIP-01/19/44/59, relay pool, double-ratchet DMs |
| `cl-consensus` | a Bitcoin full node |
| `cl-payments` | Lightning Network, tested against Core Lightning and LND |

### Storage and data

| system | what it is |
|---|---|
| `pagetree` | crash-safe copy-on-write B+tree key/value store |
| `cabinet` | a POSIX-ish filesystem on pagetree |
| `sqlite-pure` | SQLite: the file format, locking and SQL, no libsqlite3 |
| `cairn` | git: client and server over smart-HTTP and SSH |
| `cram` | DEFLATE/zlib with Z_SYNC_FLUSH |
| `zstd-pure` | Zstandard codec |
| `brotli-pure` | Brotli codec |

### Graphics, text and documents

| system | what it is |
|---|---|
| `gesso` | 2D vector graphics: paths, fill, stroke |
| `scribe` | fonts and text: sfnt/WOFF2/CFF, OpenType shaping, rasterizer |
| `pigment` | image codecs: PNG/GIF/JPEG/WebP/SVG |
| `webp-pure` | WebP (VP8) decoder |
| `stencil` | SVG parser and renderer |
| `folio` | PDF renderer |

### Audio, video and speech

| system | what it is |
|---|---|
| `reed` | audio decoders: MP3, AAC-LC, Opus, G.711 |
| `reel` | VP8 and H.264 video codecs |
| `cassette` | WebM and MP4 containers and a player |
| `mill` | tensor engine / ONNX interpreter |
| `chord` | text to speech |
| `stave` | streaming speech recognition |

### Web engine

| system | what it is |
|---|---|
| `shuttle` | a JavaScript engine (88% test262) |
| `weft` | HTML/CSS layout and rendering (Acid2, Acid3 100/100) |
| `loom` | the browser shell for weft |

### Desktop and apps

| system | what it is |
|---|---|
| `glass` | framebuffer + VNC server, and a McCLIM backend |
| `glass-webrtc` | glass over WebRTC |
| `glass-sdl` | a glass desktop in a native window (uses SDL) |
| `warp` | presentation-based UI kit (+ warp-dom, warp-glass, warp-files, warp-media, ...) |
| `warren` | Miller-column file browser |
| `spool` | podcast client |

### Agents and tools

| system | what it is |
|---|---|
| `operandi` | a ReAct agent loop with live Lisp eval |
| `operandi-gui` | operandi as a chat app, with voice |
| `quill` | terminal line editor |

### modus itself

| system | what it is |
|---|---|
| `modus` | the MVM compiler and cross-compiler, loaded into a host Lisp |

## Use

`github.io` is HTTPS-only and Quicklisp's built-in fetcher speaks only HTTP, so first
teach it HTTPS. The snippet below shells out to `curl` (already on most systems) and
needs **no extra Lisp dependencies**:

```lisp
;; 1. one-time per session: an HTTPS fetcher for Quicklisp (needs `curl` on PATH)
(push (cons "https"
            (lambda (url file &rest _)
              (declare (ignore _))
              (let ((out (merge-pathnames file)))
                (uiop:run-program (list "curl" "-fsSL" "-o" (namestring out) url))
                (values out out))))
      ql-http:*fetch-scheme-functions*)

;; 2. install this dist, then load anything from it
(ql-dist:install-dist "https://modus-lisp.github.io/dist/modus.txt" :prompt nil)
(ql:quickload "operandi")            ; or any system below
```

(If your Quicklisp already fetches HTTPS — e.g. via `dexador` — skip step 1.)

Third-party dependencies (`bordeaux-threads`, `com.inuoe.jzon`, `cl-ppcre`, `babel`, ...)
resolve from the main Quicklisp dist as usual.

**Name clashes:** `folio`, `glass` and `weft` are also the names of unrelated projects in
the main Quicklisp dist. With this dist installed, those names resolve here.

---

Generated with [quickdist](https://github.com/orivej/quickdist) from each repo's default
branch, served via GitHub Pages. Every public modus-lisp repo with an `.asd` is included
(glass-mcclim, kiln and skep have none yet). Verified: the main system of every project
installs and quickloads from this dist into a clean Quicklisp, with no local source on
the path. To rebuild: `./build.sh`, then commit and push.
