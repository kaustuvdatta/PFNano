#!/bin/bash

# Super overblown parser
PARAMS=""
# Set defaults
NO_EXEC="--no_exec "
# Parser
while (( "$#" )); do
  # Parse
  case "$1" in
    -e|--exec)
      NO_EXEC=""
      shift
      ;;
    -p|--parallel)
      PARALLEL=" &"
      shift
      ;;
    --noInputs)
      NOINPUTS="_noInputs"
      shift
      ;;
    -b|--my-flag-with-argument)
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        MY_FLAG_ARG=$2
        shift 2
      else
        echo "Error: Argument for $1 is missing" >&2
        exit 1
      fi
      ;;
    -*|--*=) # unsupported flags
      echo "Error: Unsupported flag $1" >&2
      exit 1
      ;;
    *) # preserve positional arguments
      PARAMS="$PARAMS $1"
      shift
      ;;
  esac
done
# set positional arguments in their proper place
eval set -- "$PARAMS"


# MC (2016, preVFP):
#cmsDriver.py nano_mc_2016_ULPreVFP --mc --eventcontent NANOAODSIM --datatier NANOAODSIM --step NANO \
#--conditions 106X_mcRun2_asymptotic_preVFP_v11  --era Run2_2016_HIPM,run2_nanoAOD_106Xv2 \
#--customise_commands="process.add_(cms.Service('InitRootHandlers', EnableIMT = cms.untracked.bool(False)))" --nThreads 4 \
#-n 100 --filein /store/mc/RunIISummer20UL16MiniAODAPVv2/QCD_Pt_1000to1400_TuneCP5_13TeV_pythia8/MINIAODSIM/106X_mcRun2_asymptotic_preVFP_v11-v1/120000/013ECA87-B948-6B41-A491-3681E6051D0C.root --fileout file:nano_mc2016preVFP.root \
#--customise PhysicsTools/PFNano/pfnano_cff.PFnano_customizeMC_AK8JetsOnly$NOINPUTS  $NO_EXEC $PARALLEL

# Data (2016, preVFP):
cmsDriver.py nano_data_2016_ULPreVFP --data --eventcontent NANOAODSIM --datatier NANOAODSIM --step NANO \
--conditions 106X_dataRun2_v35   --era Run2_2016_HIPM,run2_nanoAOD_106Xv2 \
--customise_commands="process.add_(cms.Service('InitRootHandlers', EnableIMT = cms.untracked.bool(False)))" --nThreads 4 \
-n 100 --filein /store/data/Run2016C/SingleMuon/MINIAOD/HIPM_UL2016_MiniAODv2-v2/130000/0294890E-E9C3-5340-8061-E6FB0E5E79B3.root --fileout file:nano_data2016preVFP.root \
--customise PhysicsTools/PFNano/pfnano_cff.PFnano_customizeData_AK8JetsOnly$NOINPUTS  $NO_EXEC $PARALLEL

# MC (2016, postVFP):
#cmsDriver.py nano_mc_2016_ULPostVFP --mc --eventcontent NANOAODSIM --datatier NANOAODSIM --step NANO \
#--conditions 106X_mcRun2_asymptotic_v17  --era Run2_2016,run2_nanoAOD_106Xv2 \
#--customise_commands="process.add_(cms.Service('InitRootHandlers', EnableIMT = cms.untracked.bool(False)))" --nThreads 4 \
#-n 100 --filein /store/mc/RunIISummer20UL16MiniAODv2/QCD_Pt_1000to1400_TuneCP5_13TeV_pythia8/MINIAODSIM/106X_mcRun2_asymptotic_v17-v1/120000/100E7694-DCCD-3F47-8FE4-B2B83A5A7B34.root --fileout file:nano_mc2016postVFP.root \
#--customise PhysicsTools/PFNano/pfnano_cff.PFnano_customizeMC_AK8JetsOnly$NOINPUTS  $NO_EXEC $PARALLEL

# Data (2016, postVFP):
cmsDriver.py nano_data_2016_ULPostVFP --data --eventcontent NANOAODSIM --datatier NANOAODSIM --step NANO \
--conditions 106X_dataRun2_v35   --era Run2_2016,run2_nanoAOD_106Xv2 \
--customise_commands="process.add_(cms.Service('InitRootHandlers', EnableIMT = cms.untracked.bool(False)))" --nThreads 4 \
-n 100 --filein /store/data/Run2016F/SingleMuon/MINIAOD/UL2016_MiniAODv2-v2/70000/060F0B51-FCEF-F343-890C-3043A4B268C2.root --fileout file:nano_data2016postVFP.root \
--customise PhysicsTools/PFNano/pfnano_cff.PFnano_customizeData_AK8JetsOnly$NOINPUTS  $NO_EXEC $PARALLEL

# MC (2017):
#cmsDriver.py nano_mc_2017_UL --mc --eventcontent NANOAODSIM --datatier NANOAODSIM --step NANO \
#--conditions 106X_mc2017_realistic_v9   --era Run2_2017,run2_nanoAOD_106Xv2  \
#--customise_commands="process.add_(cms.Service('InitRootHandlers', EnableIMT = cms.untracked.bool(False)))" --nThreads 4 \
#-n 100 --filein /store/mc/RunIISummer20UL17MiniAODv2/TTToSemiLeptonic_TuneCP5_13TeV-powheg-pythia8/MINIAODSIM/106X_mc2017_realistic_v9-v1/00000/005708B7-331C-904E-88B9-189011E6C9DD.root --fileout file:nano_mc2017.root \
#--customise PhysicsTools/PFNano/pfnano_cff.PFnano_customizeMC_AK8JetsOnly$NOINPUTS  $NO_EXEC $PARALLEL

# Data (2017):
cmsDriver.py nano_data_2017_UL --data --eventcontent NANOAODSIM --datatier NANOAODSIM --step NANO \
--conditions 106X_dataRun2_v36    --era Run2_2017,run2_nanoAOD_106Xv2 \
--customise_commands="process.add_(cms.Service('InitRootHandlers', EnableIMT = cms.untracked.bool(False)))" --nThreads 4 \
-n 100 --filein /store/data/Run2017B/SingleMuon/MINIAOD/UL2017_MiniAODv2-v1/260000/9032A966-8ED0-B645-97B6-A8EBC1D8D3B9.root --fileout file:nano_data2017.root \
--customise PhysicsTools/PFNano/pfnano_cff.PFnano_customizeData_AK8JetsOnly$NOINPUTS  $NO_EXEC $PARALLEL

# MC (2018):
#cmsDriver.py nano_mc_2018_UL --mc --eventcontent NANOAODSIM --datatier NANOAODSIM --step NANO \
#--conditions 106X_upgrade2018_realistic_v16_L1v1   --era Run2_2018,run2_nanoAOD_106Xv2 \
#--customise_commands="process.add_(cms.Service('InitRootHandlers', EnableIMT = cms.untracked.bool(False)))" --nThreads 4 \
#-n 100 --filein /store/mc/RunIISummer20UL18MiniAODv2/TTToSemiLeptonic_TuneCP5_13TeV-powheg-pythia8/MINIAODSIM/106X_upgrade2018_realistic_v16_L1v1-v2/120000/006455CD-9CDB-B843-B50D-5721C39F30CE.root --fileout file:nano_mc2018.root \
#--customise PhysicsTools/PFNano/pfnano_cff.PFnano_customizeMC_AK8JetsOnly$NOINPUTS  $NO_EXEC $PARALLEL

# Data (2018):
cmsDriver.py nano_data_2018_UL --data --eventcontent NANOAODSIM --datatier NANOAODSIM --step NANO \
--conditions 106X_dataRun2_v36    --era Run2_2018,run2_nanoAOD_106Xv2 \
--customise_commands="process.add_(cms.Service('InitRootHandlers', EnableIMT = cms.untracked.bool(False)))" --nThreads 4 \
-n 100 --filein /store/data/Run2018C/SingleMuon/MINIAOD/UL2018_MiniAODv2_GT36-v2/2530000/003EFE78-9748-DC43-BB97-14236C25C5FA.root --fileout file:nano_data2018.root \
--customise PhysicsTools/PFNano/pfnano_cff.PFnano_customizeData_AK8JetsOnly$NOINPUTS  $NO_EXEC $PARALLEL
