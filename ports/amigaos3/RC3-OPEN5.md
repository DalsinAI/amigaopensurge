# OpenSurge 0.6.1.3 for AmigaOS 3, RC3: rebuilt on GFOpenAmigaGCC open5

3 November 2026, Team 5 (Dale: "rebuild everything on open5").

RC1 and RC2 (2 Nov, 03:18 and 04:31 UTC) were built on the os32-gcc16 stove as it was switched from
GFOpenAmigaGCC 16.2.0-open3 to open4 (about 03:07); no build record names which one. open3 has GCC 15/16's
late-combine store bug: a copy compiled to `move (An)+,(d,An,Xn)` stores each element one place late (GCC PR
123853), fixed since open4 (gfopengcc patches/gcc/0013). RC3 is RC2's source rebuilt, dependencies and all, on
daletop's os32-gcc16 stove, **m68k-amigaos-gcc (GFOpenAmigaGCC 16.2.0-open5) 16.2.0b**, with this repository's
own scripts: build-dependencies.sh, build-first-pass.sh, package.sh. The only change is the version, amigaos3-rc3.

| file | bytes | sha256 |
|---|---|---|
| opensurge-0.6.1.3-amigaos3-68040-rc3.tar.gz | 38007584 | 61b569557e8d83a17ac794d0229d3bf0792cc58d4304c54e3ca1745ceae3f4c8 |
| dist/opensurge (stripped, in the archive) | 4241628 | f2ed2503a012b062fb933df1e97bfccccbdef86809e2214b3f502685280f6511 |
| opensurge (unstripped, not shipped) | 4573280 | cd8006c8e5d7c2c9ac3f240a1e4b514fc28c01855757cfe119fc9933a7ceb4d7 |

Autoinc scanner (amicradle-guest tools/scan_autoinc_overlap.py, 68040): the unstripped RC3 has no store of the bug's
shape (WRONG 0, BOTH 0; 668 findings that look like data). The stripped RC1, RC2 and RC3 all report about 41 WRONG,
which are data in the code hunk (sp-relative "moves" in tables). RC3's unstripped build shows the same addresses as
data, so RC1 and RC2 were probably clean too; this rebuild settles it.

Not run in a lab: Codex's lab work owns the runtime check. The archive is on a draft release,
v0.6.1.3-amigaos3-rc3, for the owners to test and publish.
