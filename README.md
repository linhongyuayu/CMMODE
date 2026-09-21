# CMMODE

<!-- solver-policy-20260922 -->
> **2026-09-22 求解器决定：** 今后不再使用 Gurobi，也不再要求许可证或续期。采用当前项目已验证的替代器；尚未迁移的旧入口保持停用。历史结果及求解器标注保留。本段即本仓当前求解器约束；不改写历史实验记录。
<!-- /solver-policy-20260922 -->

**[逐文件路径与分类](FILEMAP.md) · [机器可读清单](FILEMAP.csv)**

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

## Directory roles and preparation limits (2026-09-21)

| Location | Role |
|---|---|
| [source/CMMODE/](source/CMMODE/) | Algorithm, selection operators and [main_CMMODE.m](source/CMMODE/main_CMMODE.m) browsing copies |
| [source/CMMODE/Indicator/](source/CMMODE/Indicator/) | Metric functions and historical result aggregation scripts |
| [source/CMMODE/Location_Selection_problem/](source/CMMODE/Location_Selection_problem/) | Separate location-selection example and its helper functions |
| [source/CMMF/](source/CMMF/) | 17 benchmark functions; their 17 reference MAT files remain in `CMMF.zip/Reference_PSPF_data/` |
| ZIP files / paper PDF | Frozen source/data releases and publication material |

For a future run, prepare a separate working copy from both ZIPs. The benchmark script needs the actual `CMMF` function directory, its `Reference_PSPF_data` directory, and the algorithm archive's `Indicator` directory on the MATLAB path. The script's `Indicator_calculation/` name does not match the uploaded `Indicator/` directory (`main_CMMODE.m:2–3`); reference data is loaded by bare filename at lines 135–136. The `source/` browsing tree omits MAT data, so adding only its source directories is insufficient.

The location-selection script is a separate example: `Location_Selection_problem/main_CMMFtest3_CMMODE.m:4–6,74` retains machine-specific input/output paths that need explicit adaptation in a working copy. Do not treat its configuration as the benchmark setup.

All 53 ZIP members passed CRC/path/index-hash checks; the 32 committed source copies match their original member bytes. MATLAB execution, toolbox compatibility and scientific results were not tested. The repository is a frozen research release, not a live experiment log.
