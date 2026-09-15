# CMMODE

Materials for Multiobjective Differential Evolution with Speciation for Constrained Multimodal Multiobjective Optimization.

## Files

| File | Description |
|---|---|
| [CMMODE.zip](CMMODE.zip) | CMMODE archive |
| [CMMF.zip](CMMF.zip) | CMMF archive |
| [Multiobjective Differential Evolution with Speciation for Constrained Multimodal Multiovjective Optimization.pdf](Multiobjective%20Differential%20Evolution%20with%20Speciation%20for%20Constrained%20Multimodal%20Multiovjective%20Optimization.pdf) | Paper PDF |

## Reading the materials

This page indexes the files currently stored in the repository. The archive inventory and selected entry points are described below; runtime dependencies remain unverified. GitHub file search does not search inside ZIP archives; consult the archive contents and accompanying documents before running code.

The original packages and documents remain the source materials. If browsable source files are added later, identify the archive version they came from.

## Archive layout inspected on 2026-09-15

The archive directories and selected entry-point text were inspected without executing MATLAB:

| Archive | Internal files | Entry points / contents |
|---|---:|---|
| `CMMODE.zip` | 19 | `main_CMMODE.m` calls `CMMODE.m`; 15 MATLAB source files and 4 MAT files |
| `CMMF.zip` | 34 | `CMMF1.m` and related functions; 17 MATLAB source files and 17 reference MAT files |

`main_CMMODE.m` adds `CMMF/` and `Indicator_calculation/` to the MATLAB path. The uploaded algorithm archive instead contains `Indicator/`, while the CMMF functions are in the separate CMMF archive. Resolve this directory layout before running the entry point; this index does not certify the runtime setup or results.

The original archives and reference data are retained. Paths above are inside the archives, not loose files at the repository root.
