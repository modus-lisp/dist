# modus-lisp Quicklisp distribution

A self-hosted [Quicklisp](https://www.quicklisp.org/) dist for the pure-Common-Lisp
`modus-lisp` libraries (no FFI, no OpenSSL):

| system | what it is |
|---|---|
| `cl-consensus` / `cl-consensus/tor` | a Bitcoin full node (+ onion transport) |
| `cl-tor` / `cl-tor-transport` | a from-scratch Tor client |
| `seal` | a TLS 1.3/1.2 client |
| `natrium` | dependency-free hashes/HMAC/HKDF/ChaCha20/DRBG |
| `secp256k1-fast` | secp256k1 (ECDSA + Schnorr) with SBCL VOPs |
| `pagetree` | crash-safe copy-on-write B+tree store |
| `zstd-pure` | a Zstandard codec |
| `cl-transport` | uniform outbound transport (direct / SOCKS5 / Tor) |

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
(ql:quickload "cl-consensus")        ; or cl-consensus/tor, cl-tor, seal, zstd-pure, ...
```

(If your Quicklisp already fetches HTTPS — e.g. via `dexador` — skip step 1.)

Third-party dependencies (`ironclad`, `usocket`, `hunchentoot`, `com.inuoe.jzon`,
`chipz`, `bordeaux-threads`) resolve from the main Quicklisp dist as usual.

---

Generated with [quickdist](https://github.com/blytkerchan/quickdist) from each repo's
`master`, served via GitHub Pages. Verified: the full closure
(`cl-consensus` + `cl-consensus/tor` + every dependency) installs and quickloads from
this dist in an isolated SBCL with no local source on the path.
