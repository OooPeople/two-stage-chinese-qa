set -euo pipefail

# Downloads the fine-tuned checkpoints required by the full inference pipeline.
# The archive is expected to extract into:
# ./roberta-wwm-ext/multiple-choice
# ./roberta-wwm-ext/qa

wget https://www.dropbox.com/s/ayg1w4yb9ib8u00/roberta-wwm-ext.zip?dl=1 -O roberta-wwm-ext.zip
unzip roberta-wwm-ext.zip 
