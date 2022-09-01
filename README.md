# PFNano

This is a [NanoAOD](https://twiki.cern.ch/twiki/bin/view/CMSPublic/WorkBookNanoAOD) framework to enable the use of various jet substructure tools atop the functionality provided by nanoAOD. In the PFNanoAOD's as per the current version, PFcandidates can be saved for AK4 only, AK8 only, or all the PF candidates. More below.
This format can be used with [fastjet](http://fastjet.fr) directly.

## Recipe

**THIS IS A DEVELOPMENT BRANCH**

Taken from official repo-> For **UL** 2016, 2017 and 2018 data and MC **NanoAODv8** according to the [XPOG](https://gitlab.cern.ch/cms-nanoAOD/nanoaod-doc/-/wikis/Releases/NanoAODv8) and [PPD](https://twiki.cern.ch/twiki/bin/view/CMS/PdmVRun2LegacyAnalysisSummaryTable) recommendations. 

Currently, the RunIISummer20_production branch on this fork from the [official cms repo](https://github.com/cms-jet/PFNano), is updated for nanoAODv9 production on MiniAODv2 for RunII UL using the latest global tags as recommended by [PPD for UL production](https://twiki.cern.ch/twiki/bin/viewauth/CMS/PdmVRun2LegacyAnalysis) and as per [instructions for nanoAODv9 production](https://gitlab.cern.ch/cms-nanoAOD/nanoaod-doc/-/wikis/Releases/NanoAODv9).

To get started:
```
cmsrel  CMSSW_10_6_29
cd  CMSSW_10_6_29/src
cmsenv
git cms-addpkg PhysicsTools/NanoAOD
git cms-rebase-topic andrzejnovak:614nosort #not sure why this is necessary, but following the official repo
git clone https://github.com/kaustuvdatta/PFNano.git PhysicsTools/PFNano
scram b -j 10
cd PhysicsTools/PFNano/
git checkout origin RunIISummer20_production
cd PhysicsTools/PFNano/test
```
## Local Usage and setup: 
(Outdated/parts not relevant; this is taken from the official repo which was built up to work with nanoAODv8 not 9, but everything below generally applies for nanoAODv9 production and this branch has been otherwise updated for compatibility with v9 as stated before)

There are python config files ready to run in `PhysicsTools/PFNano/test/` for the UL campaign of nanoAODv9, named `nano_{mc,data}_{2016,2017,2018}_UL*_NANO.py`. 

<details>
  <summary>Details on how the config files are modified</summary>
  
    (comments below are for nanoAODv8 production, which this was last updated for officially, but are generally applicable to the nanoAODv9 (on MiniAODv2) production this branch is intended for)
    
    Notice that the current version can create 4 types of files depending on the PF candidate contents. 
    In these files, for simplicity, 4 options are included but only one is commented out for use. For instance:
    ```
    process = PFnano_customizeMC(process)
    #process = PFnano_customizeMC_allPF(process)            ##### PFcands will content ALL the PF Cands
    #process = PFnano_customizeMC_AK4JetsOnly(process)      ##### PFcands will content only the AK4 jets PF cands
    #process = PFnano_customizeMC_AK8JetsOnly(process)      ##### PFcands will content only the AK8 jets PF cands
    #process = PFnano_customizeMC_noInputs(process)         ##### No PFcands but all the other content is available.
    ```

    New since Pull Request [#39](https://github.com/cms-jet/PFNano/pull/39): Examples to include or exclude the input features for the DeepJet tagger are given in `nano106Xv8_on_mini106X_2017_mc_NANO.py`. Now the list of options that are currently implemented inside `pfnano_cff.py` (e.g. for MC) looks like that:
    ```
    process = PFnano_customizeMC(process)
    #process = PFnano_customizeMC_add_DeepJet(process)                  ##### DeepJet inputs are added to the Jet collection
    #process = PFnano_customizeMC_allPF(process)                        ##### PFcands will content ALL the PF Cands
    #process = PFnano_customizeMC_allPF_add_DeepJet(process)            ##### PFcands will content ALL the PF Cands; + DeepJet inputs for Jets
    #process = PFnano_customizeMC_AK4JetsOnly(process)                  ##### PFcands will content only the AK4 jets PF cands
    #process = PFnano_customizeMC_AK4JetsOnly_add_DeepJet(process)      ##### PFcands will content only the AK4 jets PF cands; + DeepJet inputs for Jets
    #process = PFnano_customizeMC_AK8JetsOnly(process)                  ##### PFcands will content only the AK8 jets PF cands
    #process = PFnano_customizeMC_noInputs(process)                     ##### No PFcands but all the other content is available.
    ```
    In general, whenever `_add_DeepJet` is specified (does not apply to `AK8JetsOnly` and `noInputs`), the DeepJet inputs are added to the Jet collection. For all other cases that involve adding tagger inputs, only DeepCSV and / or DDX are taken into account as default (= the old behaviour when `keepInputs=True`). Internally, this is handled by selecting a list of taggers, namely choosing from `DeepCSV`, `DeepJet`, and `DDX` (or an empty list for the `noInputs`-case, formerly done by setting `keepInputs=False`, now set `keepInputs=[]`). This refers to a change of the logic inside `pfnano_cff.py` and `addBTV.py`. If one wants to use this new flexibility, one can also define new customization functions with other combinations of taggers. Currently, there are all configurations to reproduce the ones that were available previously, and all configuations that extend the old ones by adding DeepJet inputs. DeepJet outputs, on top of the discriminators already present in NanoAOD, are added in any case where AK4Jets are added, i.e. there is no need to require the full set of inputs to get the individual output nodes / probabilities. The updated description using `PFnano_customizeMC_add_DeepJet` can be viewed here: [here](https://annika-stein.web.cern.ch/PFNano/AddDeepJetTagInfo_desc.html) and the size [here](https://annika-stein.web.cern.ch/PFNano/AddDeepJetTagInfo_size.html).

</details>

### How to create python files using cmsDriver

All python config files were produced with `cmsDriver.py`.

Two imporant parameters that one needs to verify in the central nanoAOD documentation are `--conditions` and `--era`. 
- `--era` options from [WorkBookNanoAOD](https://twiki.cern.ch/twiki/bin/view/CMSPublic/WorkBookNanoAOD) or [XPOG](https://gitlab.cern.ch/cms-nanoAOD/nanoaod-doc/-/wikis/Releases/NanoAODv9)
- `--conditions` can be found here [PdMV](https://twiki.cern.ch/twiki/bin/view/CMS/PdmV)


**UL `cmsRun` python config files are generated by running `make_configs_UL.sh`**

```
chmod u+x make_configs_UL.sh 
bash make_configs_UL.sh  # run to only produce configs
bash make_configs_UL.sh  -e # run to actually execute configs on 1000 events
```

## Submission to CRAB
<details>
  <summary>Submission via yaml card and crabby.py.</summary>

  For crab submission a handler script `crabby.py`, a crab baseline template `template_crab.py` and an example 
  submission yaml card `card_example.yml` are provided.

  - A single campaign (data/mc, year, config, output path) should be configured statically in a copy of `card_example.yml`.
  - To submit:
    ```
    source crab.sh
    python crabby.py -c card.yml --make --submit
    ```
  - `--make` and `--submit` calls are independent, allowing manual inspection of submit configs
  - Add `--test` to disable publication on otherwise publishable config and produce a single file per dataset
</details>

**Old-school interactive submission**
    Samples can be submitted to crab using the `submit_all.py` script. Run with `-h` option to see usage. 
    
    Forthe production of UL samples for SMP-22-003 everything (including configs, datasets, etc.) is already set up on this branch, so just running (any of) the following lines will work out of the box. Comomenting out UL2017/2018 productions here, please uncomment if necessary.

    For UL 2016-2018 MC:
    
    ```
    python submit_all.py -c nano_mc_2016_ULPreVFP_NANO.py  -f datasets/UL2016_MC_preVFP.txt  -d NANOv9_UL16preVFP_MC

    python submit_all.py -c nano_mc_2016_ULPostVFP_NANO.py  -f datasets/UL2016_MC_postVFP.txt  -d NANOv9_UL16postVFP_MC

    #python submit_all.py -c nnano_mc_2017_UL_NANO.py  -f datasets/UL2017_MC.txt   -d NANOv9_UL17_MC

    #python submit_all.py -c nano_mc_2018_UL_NANO.py  -f datasets/UL2018_MC.txt  -d NANOv9_UL18_MC
    ```
    
    For UL 2016-2018 data:
    
    ```
    python submit_all.py -c nano_data_2016_ULPreVFP_NANO.py  -f datasets/JetHT_UL2016_preVFP.txt -d NANOv9_UL16preVFP_Data -l jsons/Cert_271036-284044_13TeV_Legacy2016_Collisions16_JSON.txt 

    python submit_all.py -c nano_data_2016_ULPostVFP_NANO.py  -f datasets/JetHT_UL2016_postVFP.txt -d NANOv9_UL16postVFP_Data -l jsons/Cert_271036-284044_13TeV_Legacy2016_Collisions16_JSON.txt 
    
    python submit_all.py -c nano_data_2016_ULPreVFP_NANO.py  -f datasets/SingleMuon_UL2016_preVFP.txt -d NANOv9_UL16preVFP_Data -l jsons/Cert_271036-284044_13TeV_Legacy2016_Collisions16_JSON.txt 

    python submit_all.py -c nano_data_2016_ULPostVFP_NANO.py  -f datasets/SingleMuon_UL2016_postVFP.txt -d NANOv9_UL16postVFP_Data -l jsons/Cert_271036-284044_13TeV_Legacy2016_Collisions16_JSON.txt 

    python submit_all.py -c nano_data_2017_UL_NANO.py -f datasets/JetHT_UL2017.txt -d NANOv9_UL17_Data -l jsons/Cert_294927-306462_13TeV_UL2017_Collisions17_GoldenJSON.txt  
    
    python submit_all.py -c nano_data_2017_UL_NANO.py -f datasets/SingleMuon_UL2017.txt -d NANOv9_UL17_Data -l jsons/Cert_294927-306462_13TeV_UL2017_Collisions17_GoldenJSON.txt  

    python submit_all.py -c nano_data_2018_UL_NANO.py -f datasets/JetHT_UL2018.txt -d NANOv9_UL18_Data -l jsons/Cert_314472-325175_13TeV_Legacy2018_Collisions18_JSON.txt 
    
    python submit_all.py -c nano_data_2018_UL_NANO.py -f datasets/SingleMuon_UL2018.txt -d NANOv9_UL18_Data -l jsons/Cert_314472-325175_13TeV_Legacy2018_Collisions18_JSON.txt
    ```


## Processing data

When processing data, a lumi mask should be applied. The so called golden JSON should be applicable in most cases. Should also be checked here https://twiki.cern.ch/twiki/bin/view/CMS/PdmV; they are stored in the jsons directory in PFNano/test for convenience, and are copied from the official source: 

```
# 2016: /afs/cern.ch/cms/CAF/CMSCOMM/COMM_DQM/certification/Collisions16/13TeV/Legacy_2016/Cert_271036-284044_13TeV_Legacy2016_Collisions16_JSON.txt
# 2017: /afs/cern.ch/cms/CAF/CMSCOMM/COMM_DQM/certification/Collisions17/13TeV/Legacy_2017/Cert_294927-306462_13TeV_UL2017_Collisions17_GoldenJSON.txt
# 2018: /afs/cern.ch/cms/CAF/CMSCOMM/COMM_DQM/certification/Collisions18/13TeV/Legacy_2018/Cert_314472-325175_13TeV_Legacy2018_Collisions18_JSON.txt

```

In interactive submission add `--lumiMask jsons/...txt`. And for `crabby.py` submissions include in `card.yml`. 


## How to create a website with (PF)NanoAOD content

To create nice websites like [this one] (http://algomez.web.cern.ch/algomez/testWeb/JMECustomNano102x_mc_v01.html#Jet) with the content of your nanoAODs, use the `inspectNanoFile.py` file from the `PhysicsTools/nanoAOD` package. To see how this looks, one can run, for example, on a dummy file provided in PFNano/test as follows:
```
python ../../NanoAOD/test/inspectNanoFile.py nano_mc2018.root -s website_with_collectionsize.html -d website_with_collectiondescription.html
```

## Documenting the Extended NanoAOD Samples

For the MC samples, the number of events can be found by looking up the output dataset in DAS. For the data, you will need to run brilcalc to get the total luminosity of the dataset. See the instructions below. 


## Running brilcalc
These are condensed instructions from the lumi POG TWiki (https://twiki.cern.ch/twiki/bin/view/CMS/TWikiLUM). Also see the brilcalc quickstart guide: https://twiki.cern.ch/twiki/bin/viewauth/CMS/BrilcalcQuickStart.

Note: brilcalc should be run on lxplus. It does not work on the lpc.

Instructions:

1.) Add the following lines to your .bashrc file (or equivalent for your shell). Don't forget to source this file afterwards!

    export PATH=$HOME/.local/bin:/cvmfs/cms-bril.cern.ch/brilconda/bin:$PATH
    export PATH=/afs/cern.ch/cms/lumi/brilconda-1.1.7/bin:$HOME/.local/bin:$PATH
    
2.) Install brilws:

    pip install --install-option="--prefix=$HOME/.local" brilws
    
3.) Get the json file for your output dataset. In the area in which you submitted your jobs:

    crab report -d [your crab directory]
    
The processedLumis.json file will tell you which lumi sections you successfully ran over. The lumi sections for incomplete, failed, or unpublished jobs are listed in notFinishedLumis.json, failedLumis.json, and notPublishedLumis.json. More info can be found at https://twiki.cern.ch/twiki/bin/view/CMSPublic/CRAB3Commands#crab_report.
    
4.) Run brilcalc on lxplus:

    brilcalc lumi -i processedLumis.json -u /fb --normtag /cvmfs/cms-bril.cern.ch/cms-lumi-pog/Normtags/normtag_PHYSICS.json -b "STABLE BEAMS"
    
The luminosity of interest will be listed under "totrecorded(/fb)." You can also run this over the other previously mentioned json files.
    
Note: '-b "STABLE BEAMS"' is optional if you've already run over the golden json. 
        Using the normtag is NOT OPTIONAL, as it defines the final calibrations and detectors that are used for a given run.
