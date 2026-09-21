# CMMODE

Materials for Multiobjective Differential Evolution with Speciation for Constrained Multimodal Multiobjective Optimization.

## Files

| File | Description |
|---|---|
| [CMMODE.zip](CMMODE.zip) | CMMODE archive |
| [CMMF.zip](CMMF.zip) | CMMF archive |
| [Multiobjective Differential Evolution with Speciation for Constrained Multimodal Multiovjective Optimization.pdf](Multiobjective%20Differential%20Evolution%20with%20Speciation%20for%20Constrained%20Multimodal%20Multiovjective%20Optimization.pdf) | Paper PDF |

## Browsable source and complete member index

- [source/](source/): source browsing copies under `source/<archive-stem>/<original-member-path>`.
- [Complete member index](ARCHIVE_INDEX.md) / [JSON index](ARCHIVE_INDEX.json): all 53 archive members, their sizes and SHA256 hashes, including links to 32 source copies.

The original ZIPs are frozen artifacts; `source/` copies preserve the exact member bytes. Running the code still requires the matching archive data, working directory and dependencies; standalone execution has not been verified.

## Archive layout inspected on 2026-09-15

The archive directories and selected entry-point text were inspected without executing MATLAB:

| Archive | Internal files | Entry points / contents |
|---|---:|---|
| `CMMODE.zip` | 19 | `main_CMMODE.m` calls `CMMODE.m`; 15 MATLAB source files and 4 MAT files |
| `CMMF.zip` | 34 | `CMMF1.m` and related functions; 17 MATLAB source files and 17 reference MAT files |

`main_CMMODE.m` adds `CMMF/` and `Indicator_calculation/` to the MATLAB path. The uploaded algorithm archive instead contains `Indicator/`, while the CMMF functions are in the separate CMMF archive. Resolve this directory layout before running the entry point; this index does not certify the runtime setup or results.

The table uses archive-relative paths; source copies are under `source/<archive-stem>/`.
