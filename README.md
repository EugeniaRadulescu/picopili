# picopili

### Purpose

* Provide a pipeline for GWAS of family data with arbitrary pedigrees, from sib-pairs to extended pedigrees, to work in parallel to [ricopili](https://github.com/Nealelab/ricopili) for case/control and trio data

### Primary Functions

* `qc_rel.py`: runs QC for family GWAS data. Designed to be consistent with ricopili trio QC, with minor adjustments to mendelian error handling and streamlined output.
* `pca_rel.py`: main driver script to run PCA on family GWAS data. Includes strict QC (with LD pruning, etc), extraction of a set of unrelated individuals to compute PCs, and projection of PCA to full dataset. Jobs are submitted via UGER, and ricopili-like success/failure emails are sent on completion. See tasks `strict_qc.py` and `imus_pca.py`.
* `admix_rel.py`: estimates relatedness for admixed samples. Relatedness is estimated by starting with a subset of individuals who are unrelated, running an Admixture analysis, selecting "exemplar" individuals for each ancestry component, using those individuals to anchor a supervised Admixture analysis fo the full data, and using those Admixture results as the basis for ancestry-adjusted relatedness estimation using REAP.
* `filter_ped.py`: uses genetic relatedness information to flag (a) cryptic relatedness across FIDs, (b) unrelated individuals within FIDs, (c) possible parent/offspring pair not identified in .fam file, and (d) parent/offspring pairs indicated by pedigree that aren't supported by genetic relatedness. Provides a suggested sample exclusion list based on weighted preferences for phenotype, pedigree, and genotyping rate.
* `ped_confirm.py`: confirms that reported pedigrees in .fam file are consistent with genetic relatedness. Works as a wrapper to `find_expected_pedigree.pl` from PRIMUS.
* `gwas_rel.py`: Genome-wide association analysis (in parallelized chunks) with either `plink --dfam` or a GEE model.
* `impute_rel.py`: Imputation pipeline for related samples using SHAPEIT's `--duohmm` and IMPUTE2. Includes build check (with liftOver if needed), alignement to reference, phasing, imputation, and best-guess genotype calls with MAF/info score/mendelian error filtering.


### Installation at Broad

##### 1. The following assumes:

* You're working on the Broad UGER cluster (though can probably be adapted)
* You've already installed [ricopili](https://github.com/Nealelab/ricopili).
* You have git configured with a github account.

Note additional dependencies may exist for some modules (e.g. Admixture, REAP, PRIMUS).

##### 2. Download picopili from github

```
mkdir ~/github
cd ~/github
git clone https://github.com/Nealelab/picopili.git
```

##### 3. Add picopili to search path

In `~/.my.bashrc` (or equivalent for your shell) add the line:

```
PATH=$HOME/github/picopili/rp_bin:$PATH
```

##### 4. Logout and log back in.

Applies the changes in `~/.my.bashrc`.


### Installation on other platforms

For other platforms, please see the `portable` branch (https://github.com/Nealelab/picopili/tree/portable), with patch notes in pull #56.

Briefly, you will want to clone from github and switch to the portable branch:
```
mkdir ~/github
cd ~/github
git clone https://github.com/Nealelab/picopili.git
git checkout portable
```

Then run `./picopili/CONFIG` and `./picopili/GET_REFS` to setup the installation. 

You will also need to define a cluster configuration with a `.conf` configuation file and a `.sub.sh` sumbission script template. See `./picopili/cluster_templates/` for examples for a SGE/UGE job system (`broad_uger.*`) and for a TORQUE/Maui job system with tasks parallelized within node as well as across nodes (`lisa.*`).
