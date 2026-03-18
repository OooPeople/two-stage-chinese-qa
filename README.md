# Two-Stage Chinese Question Answering Pipeline

This repository is a portfolio-ready version of an Applied Deep Learning homework project. It implements a two-stage question answering pipeline: first selecting the most relevant context paragraph, then extracting the final answer span from that paragraph.

## Overview

The original coursework repository focused on competition-style prediction scripts and training commands. This public version keeps the core implementation, reorganizes the project structure, and adds documentation so the pipeline is easier to review and run.

## Key Features

- Two-stage inference pipeline combining context selection and extractive question answering
- Training and prediction scripts adapted from Hugging Face example workflows
- Helper scripts for dataset format conversion and CSV submission export
- Clear separation between source code, runnable scripts, and authoring-only files

## Tech Stack

- Python
- PyTorch
- Hugging Face Transformers
- Hugging Face Datasets
- NumPy
- spaCy

## Repository Structure

```text
two-stage-chinese-qa/
|-- src/
|   |-- context_selection/
|   |   `-- run_multiple_choice.py
|   `-- question_answering/
|       |-- eval.py
|       |-- run_qa.py
|       |-- trainer_qa.py
|       `-- utils_qa.py
|-- scripts/
|   |-- convert_dataset_to_dict.py
|   |-- download_checkpoints.sh
|   |-- export_predictions_csv.py
|   `-- run_inference_pipeline.sh
|-- sample_data/
|   |-- README.md
|   |-- context_sample.json
|   |-- test_sample.json
|   |-- train_sample.json
|   |-- valid_sample.json
|   `-- sample_submission.csv
|-- README.md
|-- requirements.txt
|-- THIRD_PARTY_NOTICES.md
`-- .gitignore
```

## Setup

### Prerequisites

- Python 3.8 or later
- A working PyTorch installation compatible with your hardware
- Git Bash, WSL, or another shell environment if you want to run the `.sh` scripts on Windows
- `wget` and `unzip` are required if you want to use `scripts/download_checkpoints.sh`

### Installation

```bash
pip install -r requirements.txt
python -m spacy download zh_core_web_md
```

Note: the exact coursework environment was not preserved, so `requirements.txt` is a best-effort dependency list rather than a fully pinned reproduction environment.

## Usage

### Explore sample data

The `sample_data/` directory contains tiny format examples derived from the coursework data. These files are for schema illustration only and are not meant to represent the full dataset.

### Run the inference pipeline

1. Download the fine-tuned checkpoints:

```bash
bash scripts/download_checkpoints.sh
```

The downloaded `roberta-wwm-ext.zip` archive should extract into:

```text
roberta-wwm-ext/
|-- multiple-choice/
`-- qa/
```

2. Run prediction:

```bash
bash scripts/run_inference_pipeline.sh /path/to/context.json /path/to/test.json /path/to/prediction.csv
```

Note: this repository does not include the checkpoint files directly. Full inference depends on the external download link remaining available.
If the link becomes unavailable, place compatible checkpoint files manually under `./roberta-wwm-ext/multiple-choice/` and `./roberta-wwm-ext/qa/`.

### Main helper scripts

- `scripts/convert_dataset_to_dict.py`: wraps the original list-style JSON into the dict format expected by the training scripts
- `scripts/download_checkpoints.sh`: downloads the fine-tuned `roberta-wwm-ext` checkpoints required for full inference
- `scripts/export_predictions_csv.py`: converts predicted JSON answers into submission CSV format

### Training entry points

```bash
python src/context_selection/run_multiple_choice.py --help
python src/question_answering/run_qa.py --help
```

## Method

The pipeline is organized as two sequential stages:

1. Context selection: a multiple-choice model scores candidate paragraphs and predicts the most relevant context for each question.
2. Answer extraction: an extractive question answering model receives the selected paragraph and predicts the final answer span.

This design reduces the search space for answer extraction and matches the structure of the course dataset used in the original assignment.

## Results

- The original coursework included a written report, but verified final metrics have not yet been extracted into this portfolio version.
- TODO: add validated evaluation metrics or leaderboard results after checking the original report and experiment records.

## Dataset

- This project expects the course-provided QA dataset format, including question records and a separate context file.
- The full dataset is not included in this public repository.
- A very small set of format examples is included under `sample_data/`.
- The paragraph indices in `sample_data/train_sample.json`, `valid_sample.json`, and `test_sample.json` are remapped to `sample_data/context_sample.json` so the examples are self-contained.
- The fine-tuned model weights are also not committed to this repository; they are fetched separately by `scripts/download_checkpoints.sh`.
- The helper script `convert_dataset_to_dict.py` indicates that some raw data files were originally stored as a JSON list and then wrapped into a `{"data": ...}` structure for training and inference.

## Limitations

- Exact package versions from the coursework environment are not fully documented.
- The fine-tuned checkpoints are not included in version control and depend on an external download link.
- Only tiny format samples are bundled; no demo predictions or visual outputs are included yet.
- Several core training files are adapted from official Hugging Face example scripts rather than built from scratch.

## Course Context

This repository was adapted from a homework submission for the course `Applied Deep Learning`. The public version keeps the implemented pipeline and helper utilities, removes the course-report-oriented layout, and adds documentation for recruiter-facing review.

## Author

Student coursework adapted into a portfolio repository by the original project author.
