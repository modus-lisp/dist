#!/usr/bin/env bash
# Rebuild the modus Quicklisp dist from every public modus-lisp repo's default branch.
#
#   ./build.sh [workdir]      then review, commit and push this repo
#
# Needs: gh (authenticated), git, tar, sha1sum, sbcl with Quicklisp (for quickdist).
# Builds from fresh GitHub clones, never local checkouts, so the dist is exactly what's
# published.  Replaces modus/ and modus.txt here; README.md and .nojekyll are kept.
set -euo pipefail

HERE="$(cd "$(dirname "$0")" && pwd)"
W="${1:-$(mktemp -d)}"
VER="$(date -u +%Y%m%d%H%M%S)"
SKIP=" dist .github modus-lisp.github.io "
mkdir -p "$W/src"
rm -rf "$W/projects" "$W/out"
mkdir -p "$W/projects"

for r in $(gh repo list modus-lisp --limit 200 --json name,isPrivate \
             -q '.[] | select(.isPrivate==false) | .name'); do
  case "$SKIP" in *" $r "*) continue;; esac
  rm -rf "$W/src/$r"
  git clone -q --depth 1 "https://github.com/modus-lisp/$r.git" "$W/src/$r"
  if ! git -C "$W/src/$r" ls-files | grep -q '\.asd$'; then
    echo "skip $r (no .asd)"; continue
  fi
  mkdir "$W/projects/$r"
  git -C "$W/src/$r" archive HEAD | tar -x -C "$W/projects/$r"
done

# modus vendors chipz for its own build; shipping that .asd would shadow Quicklisp's chipz
rm -f "$W/projects/modus/vendor/chipz/chipz.asd"

cat > "$W/gen.lisp" <<LISP
(load (merge-pathnames "quicklisp/setup.lisp" (user-homedir-pathname)))
(ql:quickload :quickdist :silent t)
;; quickdist (2019) collects tar output through babel-streams, which on SBCL 2.6.8 makes
;; an array of element type :DEFAULT and errors.  Same value, computed by the shell.
(defun quickdist::tar-content-sha1 (path)
  (subseq (uiop:run-program (format nil "tar -xOf '~a' | sha1sum" (sb-ext:native-namestring path))
                            :output :string)
          0 40))
;; ... and it only knows (:version name v); unwrap (:feature f dep) and (:require name) too.
(defun quickdist::asdf-dependency-name (form)
  (if (consp form)
      (case (first form)
        (:version (second form))
        (:feature (quickdist::asdf-dependency-name (third form)))
        (:require (second form))
        (t form))
      form))
(quickdist:quickdist :name "modus" :version "$VER"
                     :base-url "https://modus-lisp.github.io/dist/"
                     :projects-dir #p"$W/projects/" :dists-dir #p"$W/out/")
(format t "~&@@ GEN $VER~%")
LISP
sbcl --non-interactive --load "$W/gen.lisp" 2>&1 | grep -a '@@'

# Quicklisp finds a release's systems by .asd file name, so each file must define a
# system of its own name (warp's app/monitor.asd defining warp-monitor broke every warp install)
awk 'NR>1{f[$1" "$2]=1; if ($2==$3) ok[$1" "$2]=1}
     END {for (k in f) if (!(k in ok)) {print "ERROR: no system named after its .asd:", k; bad=1}
          exit bad}' "$W/out/modus/$VER/systems.txt"

cd "$HERE"
rm -rf modus modus.txt
cp -a "$W/out/." .
touch .nojekyll
echo "built $VER: $(($(wc -l < modus/$VER/releases.txt) - 1)) projects," \
     "$(($(wc -l < modus/$VER/systems.txt) - 1)) systems. Review, then commit and push."
