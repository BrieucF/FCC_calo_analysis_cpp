#!/bin/sh -u
source /cvmfs/fcc.cern.ch/sw/0.8/init_fcc_stack.sh $1
#source /cvmfs/fcc.cern.ch/sw/0.8.3/init_fcc_stack.sh
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$PWD/install/lib/
#eos
export EOS_MGM_URL="root://eospublic.cern.ch"
