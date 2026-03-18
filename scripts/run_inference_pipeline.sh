set -euo pipefail

# "${1}": path to the context file.
# "${2}": path to the testing file.
# "${3}": path to the output predictions.

python ./scripts/convert_dataset_to_dict.py "${2}" ./temp/test.json

python ./src/context_selection/run_multiple_choice.py \
  --do_predict \
  --model_name_or_path ./roberta-wwm-ext/multiple-choice \
  --output_dir ./predict/roberta-wwm-ext/multiple-choice \
  --test_file ./temp/test.json \
  --context_file "${1}" \
  --output_file ./predict/roberta-wwm-ext/multiple-choice/multiple_choice_predict.json \
  --cache_dir ./cache/ \
  --pad_to_max_length \
  --max_seq_length 512 \

python ./src/question_answering/run_qa.py \
  --do_predict \
  --model_name_or_path ./roberta-wwm-ext/qa \
  --output_dir ./predict/roberta-wwm-ext/qa \
  --test_file ./predict/roberta-wwm-ext/multiple-choice/multiple_choice_predict.json \
  --context_file "${1}" \
  --cache_dir ./cache/ \
  --pad_to_max_length \
  --max_seq_length 512 \

python ./scripts/export_predictions_csv.py ./predict/roberta-wwm-ext/qa/test_predictions.json "${3}"
