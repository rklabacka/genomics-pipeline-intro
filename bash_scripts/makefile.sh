#!/bin/bash
set -e
dir=$(cd -P -- "$(dirname -- "$0")" && pwd -P)
mkdir bin
mkdir bash_scripts
mv genomics-pipeline-intro.sh SARS-CoV-2-*.sh SnpEff_processing.sh pi-tajima.sh ./bash_scripts/
git clone https://github.com/cfarkas/shc.git
cd shc/
./autogen.sh
./configure
make
cd ..
echo ""
echo "make done. Continue with install"
# Install
./shc/src/shc -f ./bash_scripts/SARS-CoV-2-merge-variants.sh -o ./SARS-CoV-2-merge-variants
./shc/src/shc -f ./bash_scripts/genomics-pipeline-intro.sh -o ./genomics-pipeline-intro
./shc/src/shc -f ./bash_scripts/SnpEff_processing.sh -o ./SnpEff_processing
./shc/src/shc -f ./bash_scripts/pi-tajima.sh -o ./pi-tajima
mv genomics-pipeline-intro SARS-CoV-2-merge-variants pi-tajima SnpEff_processing ./bin/
echo ""
echo "All done. Binaries are located in ./bin/ folder"
#
