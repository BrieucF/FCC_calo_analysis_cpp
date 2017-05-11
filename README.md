FCC_calo_analysis
=====================

Analysis tools for calorimetry:
 - hits/cells/cluster read from EDM in c++
 - setup and results of analysis (drawing etc.) handled from python

# Initialization

Dependencies:
 - ROOT
 - PODIO
 - fcc-edm
taken from the FCC software stack:

~~~{.sh}
source init.sh
~~~

# Build

~~~{.sh}
mkdir build
cd build
cmake -DCMAKE_INSTALL_PREFIX=../install ..
make -j 8 install
cd ..
~~~

# Run analysis

## Common: configuration

To see the help message:

~~~{.sh}
python scripts/calo_init.py --help
~~~

The required argument is the input file name and the energy (vector):

~~~{.sh}
python scripts/calo_init.py <INPUT_FILE_NAME>.root [energy]
~~~

User may also specify any of the optional arguments.

In particular, if user wants to analyse multiple files:

~~~{.sh}
python scripts/calo_init.py <INPUT_FILE_NAME_CONTAINING_?_CHARACTER>.root ENERGY -r [LIST_OF_SUBSTITUTIONS]
~~~

where `-r` indicates that a regex should be used, substituting the `?` character in the input (or output) file name with the elements of the list of substitutions.

For instance,
~~~{.sh}
python scripts/calo_init.py 'output_10GeV_?.root' 10 -r firstPart secondPart
~~~

results in:
~~~{.sh}
Input file: output_10GeV_firstPart.root
Input file: output_10GeV_secondPart.root
Energy of initial particle: [10] GeV
~~~

If instead of of a list, "energy" is used after "-r" option, the '?' character gets substituted with the energy of the particles.

For instance,
~~~{.sh}
python scripts/calo_init.py 'output_?GeV.root' 10 50 100 -r energy
~~~

results in:
~~~{.sh}
Input file: output_10GeV.root
Input file: output_50GeV.root
Input file: output_100GeV.root
Energy of initial particle: [10, 50, 100] GeV
~~~


## Example: `SimpleAnalysis`

Required arguments:
 - input file name
 - energy
 - sampling factor

~~~{.sh}
python scripts/test_macro_simple.py <INPUT_FILE_NAME>.root ENERGY SF
~~~

## Shower profiles: `ShowerProfiles`

Required arguments:
 - input file name
 - energy
 - sampling factor

Analysis is done for one file.

~~~{.sh}
python scripts/test_macro_profiles.py <INPUT_FILE_NAME>.root ENERGY SF
~~~

## Cells: `CellAnalysis`

Required arguments:
 - input file name
 - energy
 - sf

Analysis is done for one file.

~~~{.sh}
python scripts/test_macro_cells.py <INPUT_FILE_NAME>.root ENERGY SF
~~~

## Reconstructed event preview: `ReconstructionExample`

Preview of the reconstructed cluster.
The first plot contains all towers, the second the centre of the cluster and the third one all the cells associated to the cluster.
Additionally the windows used in the reconstrucion are drawn.

Required arguments:
 - input file name
 - energy

Analysis is done for all the files (all energies), but for one event from each (default: first event).

~~~{.sh}
python scripts/plot_recoExample.py <INPUT_FILE_NAME>.root ENERGY
~~~

Input file name and the energy are required.

List of additional options:
~~~{.sh}
   -r REGEX [REGEX ...], --regex REGEX [REGEX ...]
                        String to insert in place of '?' character in file
                        names ("energy" inserts the values of energies)
  -o OUTPUT, --output OUTPUT
                        Output file name
  -v, --verbose         Verbose
    --clusterColl CLUSTERCOLL
                        Name of the clusters collection
                        (fcc::CaloClusterCollection)
  --positionColl POSITIONCOLL
                        Name of the positioned cells collection
                        (fcc::PositionedCaloHitCollection)
  --windowSeed WINDOWSEED WINDOWSEED
                        Size of the window used for seeding [eta,phi]
  --windowPos WINDOWPOS WINDOWPOS
                        Size of the window used for berycentre coalculation
                        [eta,phi]
  --windowDupl WINDOWDUPL WINDOWDUPL
                        Size of the window used for duplicate removal
                        [eta,phi]
  --dEta DETA DETA      Size of the tower in eta
  --maxEta MAXETA       Maximum eta
  --dPhi DPHI           Size of the tower in phi
  --numPhi NUMPHI       Number of the towers in phi
  --zoom ZOOM ZOOM      How many bins around centre should be visible
  --event EVENT         Number of an event to draw
~~~

## Reconstruction monitor: `SingleParticleRecoMonitors`

Monitor plots of the reconstruction procedure.
The plots are created based on the clusters and generated particles (for single particle events only).

~~~{.sh}
python scripts/plot_recoMonitor.py <INPUT_FILE_NAME>.root ENERGY <INPUT_FILE_WITH_MC_INFORMATION>.root
~~~

The plots are saved to root file and as a png. The first row includes the energy distribution, energy distribution as a function of phi, number of reconstructed clusters and the number of reconstructed clusters as a function of phi.
The second row contains information about any reconstructed duplicates (difference of energy, eta, phi and R=sqrt(eta^2+phi^2) with respect to the most energetic cluster).
The last row contains comparison to the MC particle: difference in eta distribution, difference in eta as a function of eta, difference in phi distribution and difference in phi as a function of phi.


## Reconstruction monitor with upstream energy correction

python scripts/plot_recoMonitor.py root://eospublic.cern.ch//eos/fcc/users/n/novaj/combCaloForBerlin/output_combCalo_reconstructionSW_e50GeV_part1.root 50 root://eospublic.cern.ch//eos/fcc/users/n/novaj/combCaloForBerlin/output_combCalo_e50GeV_part1_v3.root --clusterColl EcalClusters --correctionParams 0.1369 0.004587 0.1692 0.6769 --cellColl ECalCellsForSW --bitfield system:4,cryo:1,type:3,subtype:3,cell:6,eta:9,phi:10

--- Everything in reconstruction file (GenParticles, GenVertices, Cells, Clusters), simulations for Berlin
**** Upstream material 1.2 X0, B = 4 T
python scripts/plot_clusterAnalysis.py root://eospublic.cern.ch//eos/fcc/users/n/novaj/combCaloForBerlin/output_combCalo_reconstructionSW_e?GeV_bfield1_eta0_v2.root 20 50 100 500 1000 --clusterColl CombinedClusters --correctionParams 0.1037 0.0007507 0.1382 1.002 --cellColl ECalCellsForSW --bitfield system:4,cryo:1,type:3,subtype:3,cell:6,eta:9,phi:10 -o combCalo_?GeV_bfield1_eta0 -r energy
**** Upstream material 1.2 X0, B = 0 T
python scripts/plot_clusterAnalysis.py root://eospublic.cern.ch//eos/fcc/users/n/novaj/combCaloForBerlin/output_combCalo_reconstructionSW_e?GeV_bfield0_eta0_v2.root 20 50 100 500 1000 --clusterColl CombinedClusters --correctionParams 0.05774 0.000315 0.0621 0.8285 --cellColl ECalCellsForSW --bitfield system:4,cryo:1,type:3,subtype:3,cell:6,eta:9,phi:10 -o combCalo_?GeV_bfield0_eta0 -r energy


List of additional options:
~~~{.sh}
  -r REGEX [REGEX ...], --regex REGEX [REGEX ...]
                        String to insert in place of '?' character in file
                        names ("energy" inserts the values of energies)
  -o OUTPUT, --output OUTPUT
                        Output file name
  -v, --verbose         Verbose
  --particleColl PARTICLECOLL
                        Name of the MC particle collection
                        (fcc::MCParticleCollection)
  --clusterColl CLUSTERCOLL
                        Name of the clusters collection
                        (fcc::CaloClusterCollection)
  --dEta DETA DETA      Size of the tower in eta
  --maxEta MAXETA       Maximum eta
  --dPhi DPHI           Size of the tower in phi
  --numPhi NUMPHI       Number of the towers in phi
~~~


## Energy resolution

Input files: ROOT files with energy distribution saved with name "energy". Each ROOT file should contain distribution for one energy. Such input files may be obtained e.g. by `plot_recoMonitor.py` macro.
Energy distributions are fitted twice with Gaussian, and the energy resolution plot is fitted with p0+p1/sqrt(E) function.

~~~{.sh}
python scripts/plot_enResolution.py energy?GeV.root 20 50 100 200 500 1000 -r energy
~~~
python scripts/plot_enResolution.py combCalo_?GeV_bfield1_eta0.root 20 50 100 500 -n 'energyCorrected' -o resolution_bfield1 -r energy
-n: name of the histogram


## Compare resolutions
 python scripts/plot_compareResolutions_jana.py resolution_?_bfield1.root 0 -r corrected notCorrected -t 'Electrons SW, 1.2X_{0}, B= 4T' -l 'Upstream correction: 0.0047 #oplus 0.0764/#sqrt{E}' 'No upstream correction: 0.0047 #oplus 0.0848/#sqrt{E}' -m 0.04


# How to create own analysis

1. Create Class deriving from `BaseAnalysis` or `BaseTwoFileAnalysis`. Include:
  - histograms (push back to m_histograms)
  - processEvent method
  - finishLoop method
2. Add class to `include/LinkDef.h` and `CMakeLists.txt` so it can be accessed from ROOT.
3. Create analysis script:
  - add command line arguments
  - retrieve histograms after analysis is done
