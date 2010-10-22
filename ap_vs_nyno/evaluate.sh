#!/bin/bash

if [ "$#" -ne 1 ]; then echo "Usage: sh evaluate.sh DATE"; exit 1; fi

DATE="$1"
NNNBDIR=/l/n # path to apertium-nn-nb

echo "Translating without unknown word marks, for wdiff-html"
cat nb | apertium -u -d $NNNBDIR nb-nn    > u.$DATE-apertium-nb-nn
cat nb | apertium -u -d $NNNBDIR nb-nn-cp > u.$DATE-apertium-nb-nn-cp

../wdiff-to-html.sh u.$DATE-apertium-nb-nn u.$DATE-apertium-nb-nn-cp > results/$DATE-wdiff.html

echo "Translating with unknown word marks, for WER"
cat nb | apertium    -d $NNNBDIR nb-nn    >   $DATE-apertium-nb-nn
cat nb | apertium    -d $NNNBDIR nb-nn-cp >   $DATE-apertium-nb-nn-cp

echo 'WER testing [1/4]'
apertium-eval-translator -t $DATE-apertium-nb-nn    -r nn.ref0 > results/$DATE-ap_vs_ref0.WER
echo 'WER testing [2/4]'
apertium-eval-translator -t $DATE-apertium-nb-nn    -r nn.ref1 > results/$DATE-ap_vs_ref1.WER
echo 'WER testing [3/4]'
apertium-eval-translator -t $DATE-apertium-nb-nn-cp -r nn.ref0 > results/$DATE-ap-cp_vs_ref0.WER
echo 'WER testing [4/4]'
apertium-eval-translator -t $DATE-apertium-nb-nn-cp -r nn.ref1 > results/$DATE-ap-cp_vs_ref1.WER


