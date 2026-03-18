# Two-Stage Chinese Question Answering Pipeline
# 雙階段中文問答系統

This repository is a cleaned-up public version of an Applied Deep Learning homework project. It implements a two-stage question answering pipeline: first selecting the most relevant context paragraph, then extracting the final answer span from that paragraph.

<!-- bilingual split -->

本專案是將 Applied Deep Learning 課程作業整理成可公開閱讀的整理版本。系統採用雙階段問答流程：先從候選段落中找出最相關的 context，再從該段落中抽取最終答案。

## Overview / 專案概述

The original coursework repository focused on competition-style prediction scripts and training commands. This public version keeps the core implementation, reorganizes the project structure, and adds documentation so the pipeline is easier to review and run.

<!-- bilingual split -->

原始作業版本以競賽提交與訓練指令為主。這份公開版本保留核心實作，重新整理專案結構，並補上文件說明，讓整體流程與執行方式更容易理解。

## Key Features / 主要特色

- Two-stage inference pipeline combining context selection and extractive question answering
- Training and prediction scripts adapted from Hugging Face example workflows
- Helper scripts for dataset format conversion and CSV submission export
- Clear separation between source code, runnable scripts, and authoring-only files

<!-- bilingual split -->

- 採用雙階段推論流程，結合 context selection 與 extractive QA
- 訓練與推論腳本改寫自 Hugging Face 官方範例流程
- 提供資料格式轉換與 CSV 輸出等輔助腳本
- 將核心程式、可執行腳本與整理用檔案明確分開

## Tech Stack / 技術棧

- Python
- PyTorch
- Hugging Face Transformers
- Hugging Face Datasets
- NumPy
- spaCy

## Repository Structure / 專案結構

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

## Setup / 環境設定

### Prerequisites / 事前需求

- Python 3.8 or later
- A working PyTorch installation compatible with your hardware
- Git Bash, WSL, or another shell environment if you want to run the `.sh` scripts on Windows
- `wget` and `unzip` are required if you want to use `scripts/download_checkpoints.sh`

<!-- bilingual split -->

- Python 3.8 以上版本
- 可正常運作且與硬體相容的 PyTorch 環境
- 若你在 Windows 上執行 `.sh` 腳本，建議使用 Git Bash、WSL 或其他 shell 環境
- 若要使用 `scripts/download_checkpoints.sh`，需要系統具備 `wget` 與 `unzip`

### Installation / 安裝方式

```bash
pip install -r requirements.txt
python -m spacy download zh_core_web_md
```

Note: the exact coursework environment was not preserved, so `requirements.txt` is a best-effort dependency list rather than a fully pinned reproduction environment.

<!-- bilingual split -->

註：原始作業的完整環境版本資訊沒有完整保留下來，因此 `requirements.txt` 目前是最小依賴清單，而不是完全可重現的鎖版本環境。

## Usage / 使用方式

### Explore Sample Data / 查看示範資料

The `sample_data/` directory contains tiny format examples derived from the coursework data. These files are for schema illustration only and are not meant to represent the full dataset.

<!-- bilingual split -->

`sample_data/` 內提供少量從原始課程資料切出的示範檔案，主要用途是說明資料格式，並不代表完整資料集規模。

### Run the Inference Pipeline / 執行推論流程

1. Download the fine-tuned checkpoints:

```bash
bash scripts/download_checkpoints.sh
```

2. The downloaded `roberta-wwm-ext.zip` archive should extract into:

```text
roberta-wwm-ext/
|-- multiple-choice/
`-- qa/
```

3. Run prediction:

```bash
bash scripts/run_inference_pipeline.sh /path/to/context.json /path/to/test.json /path/to/prediction.csv
```

<!-- bilingual split -->

1. 先下載已微調完成的 checkpoint：

```bash
bash scripts/download_checkpoints.sh
```

2. 解壓後應產生以下結構：

```text
roberta-wwm-ext/
|-- multiple-choice/
`-- qa/
```

3. 再執行推論：

```bash
bash scripts/run_inference_pipeline.sh /path/to/context.json /path/to/test.json /path/to/prediction.csv
```

Note: this repository does not include the checkpoint files directly. Full inference depends on the external download link remaining available. If the link becomes unavailable, place compatible checkpoint files manually under `./roberta-wwm-ext/multiple-choice/` and `./roberta-wwm-ext/qa/`.

<!-- bilingual split -->

註：本 repo 不直接附上 checkpoint 檔案。若要完整執行推論流程，仍需依賴外部下載連結；若連結失效，請手動將相容的 checkpoint 放到 `./roberta-wwm-ext/multiple-choice/` 與 `./roberta-wwm-ext/qa/`。

### Main Helper Scripts / 主要輔助腳本

- `scripts/convert_dataset_to_dict.py`: wraps the original list-style JSON into the dict format expected by the training scripts
- `scripts/download_checkpoints.sh`: downloads the fine-tuned `roberta-wwm-ext` checkpoints required for full inference
- `scripts/export_predictions_csv.py`: converts predicted JSON answers into submission CSV format

<!-- bilingual split -->

- `scripts/convert_dataset_to_dict.py`：將原始 list 形式的 JSON 包裝成訓練腳本需要的 dict 結構
- `scripts/download_checkpoints.sh`：下載完整推論流程所需的 `roberta-wwm-ext` 微調模型
- `scripts/export_predictions_csv.py`：將模型輸出的 JSON 答案轉成提交用 CSV 格式

### Training Entry Points / 訓練入口

```bash
python src/context_selection/run_multiple_choice.py --help
python src/question_answering/run_qa.py --help
```

以上兩支腳本分別對應 context selection 與 extractive QA 的訓練 / 推論入口。

## Method / 方法說明

The pipeline is organized as two sequential stages:

1. Context selection: a multiple-choice model scores candidate paragraphs and predicts the most relevant context for each question.
2. Answer extraction: an extractive question answering model receives the selected paragraph and predicts the final answer span.

This design reduces the search space for answer extraction and matches the structure of the course dataset used in the original assignment.

<!-- bilingual split -->

整體流程分為兩個階段：

1. Context selection：以 multiple-choice 模型對候選段落進行評分，選出與問題最相關的段落。
2. Answer extraction：將選出的段落送入 extractive QA 模型，預測答案所在的文字區間。

這種設計可以先縮小回答範圍，再進行答案抽取，也符合原始課程資料集的題目設計方式。

## Results / 結果

- The original coursework included a written report, but verified final metrics have not yet been extracted into this public version.
- TODO: add validated evaluation metrics or leaderboard results after checking the original report and experiment records.

<!-- bilingual split -->

- 原始作業有書面報告，但目前還沒有把確認過的最終指標整理進這個公開整理版本。
- TODO：待重新檢查原始報告與實驗紀錄後，再補上驗證過的評估指標或排名結果。

## Dataset / 資料集

- This project expects the course-provided QA dataset format, including question records and a separate context file.
- The full dataset is not included in this public repository.
- A very small set of format examples is included under `sample_data/`.
- The paragraph indices in `sample_data/train_sample.json`, `valid_sample.json`, and `test_sample.json` are remapped to `sample_data/context_sample.json` so the examples are self-contained.
- The fine-tuned model weights are also not committed to this repository; they are fetched separately by `scripts/download_checkpoints.sh`.
- The helper script `convert_dataset_to_dict.py` indicates that some raw data files were originally stored as a JSON list and then wrapped into a `{"data": ...}` structure for training and inference.

<!-- bilingual split -->

- 本專案使用課程提供的 QA 資料格式，包含題目資料與獨立的 context 檔案。
- 完整資料集並未放入這個公開 repo。
- `sample_data/` 中只保留少量示範資料供格式說明使用。
- `sample_data/train_sample.json`、`valid_sample.json`、`test_sample.json` 內的段落索引已重新對應到 `sample_data/context_sample.json`，因此這組 sample 可獨立理解。
- 微調後的模型權重也沒有直接提交到 repo，而是透過 `scripts/download_checkpoints.sh` 另外取得。
- `convert_dataset_to_dict.py` 顯示原始資料曾以 JSON list 儲存，之後再包成 `{"data": ...}` 結構供訓練與推論使用。

## Limitations / 限制

- Exact package versions from the coursework environment are not fully documented.
- The fine-tuned checkpoints are not included in version control and depend on an external download link.
- Only tiny format samples are bundled; no demo predictions or visual outputs are included yet.
- Several core training files are adapted from official Hugging Face example scripts rather than built from scratch.

<!-- bilingual split -->

- 原始作業環境的精確套件版本沒有完整保存。
- 微調後的 checkpoint 沒有納入版本控制，且仍依賴外部下載連結。
- 目前只附上少量格式示範資料，尚未加入 demo 預測結果或視覺化輸出。
- 多個核心訓練檔案是基於 Hugging Face 官方範例修改而來，並非完全從零實作。

## Course Context / 課程背景

This repository was adapted from a homework submission for the course `Applied Deep Learning`. The public version keeps the implemented pipeline and helper utilities, removes the course-report-oriented layout, and adds supporting documentation for clearer public reference.

<!-- bilingual split -->

本 repo 由 `Applied Deep Learning` 課程作業整理而成。公開版本保留了核心 pipeline 與輔助工具，移除較偏作業提交導向的內容，並補上更適合公開閱讀的文件說明。

## Author / 作者

Student coursework adapted into a public project repository by the original project author.

<!-- bilingual split -->

由原始作者將學生作業整理為公開整理版本。
