# Graph Report - TRIAL-DLE  (2026-10-21)

## Corpus Check
- 44 files · ~1,594,478 words
- Verdict: corpus is large enough that graph structure adds value.
- Unclassified: 15 file(s) not represented in the graph (top: .csv 4, .tex 3, .safetensors 3)

## Summary
- 402 nodes · 653 edges · 17 communities (11 shown, 6 thin omitted)
- Extraction: 93% EXTRACTED · 7% INFERRED · 0% AMBIGUOUS · INFERRED: 45 edges (avg confidence: 0.88)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `3385c60c`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- LegalEvaluator
- BaseSummarizer
- api/app.py
- ModelMetadata
- QwenSummarizer
- Model Card for Model ID
- Model Card for Model ID
- LedSummarizer
- test_api.py
- dashboard/app.py
- startup.ps1
- Model Card for Model ID
- Project Setup and Operations
- IEEE-conference-template-062824/IEEEtran.cls
- IEEEtran.cls

## God Nodes (most connected - your core abstractions)
1. `BaseSummarizer` - 25 edges
2. `SummarizationResult` - 23 edges
3. `ModelMetadata` - 21 edges
4. `QwenSummarizer` - 19 edges
5. `LedSummarizer` - 17 edges
6. `Model Card for Model ID` - 15 edges
7. `Model Card for Model ID` - 15 edges
8. `Model Card for Model ID` - 15 edges
9. `LegalEvaluator` - 14 edges
10. `LegalEntityExtractor` - 13 edges

## Surprising Connections (you probably didn't know these)
- `extractor()` --uses--> `LegalEntityExtractor`  [INFERRED]
  tests/test_legal_entity_regex.py → src/metrics/entity_extractor.py
- `test_full_evaluation_pipeline()` --uses--> `LegalEvaluationResult`  [INFERRED]
  tests/test_evaluator.py → src/metrics/evaluator.py
- `evaluator()` --uses--> `LegalEvaluator`  [INFERRED]
  tests/test_evaluator.py → src/metrics/evaluator.py
- `test_bart_summarize_dry_run()` --uses--> `SummarizationResult`  [INFERRED]
  tests/test_base_summarizer.py → src/models/base.py
- `test_model_factory_and_metadata()` --uses--> `BaseSummarizer`  [INFERRED]
  tests/test_base_summarizer.py → src/models/base.py

## Import Cycles
- None detected.

## Communities (17 total, 6 thin omitted)

### Community 0 - "LegalEvaluator"
Cohesion: 0.06
Nodes (15): ExtractedEntities, LegalEntityExtractor, LegalEvaluationResult, LegalEvaluator, evaluator(), test_full_evaluation_pipeline(), test_rouge_calculation(), test_rouge_partial_overlap() (+7 more)

### Community 1 - "BaseSummarizer"
Cohesion: 0.10
Nodes (9): BartSummarizer, BaseSummarizer, SummarizationResult, get_all_model_metadata(), get_summarizer(), resolve_model_key(), test_bart_summarize_dry_run(), test_model_factory_and_metadata() (+1 more)

### Community 2 - "api/app.py"
Cohesion: 0.11
Nodes (16): evaluate_summary(), extract_legal_entities(), get_benchmarks(), get_models(), health(), root(), summarize_text(), EvaluateRequest (+8 more)

### Community 3 - "ModelMetadata"
Cohesion: 0.06
Nodes (3): BartSummarizer, ModelMetadata, LedSummarizer

### Community 4 - "QwenSummarizer"
Cohesion: 0.16
Nodes (5): QwenSummarizer, test_qwen_metadata(), test_qwen_prompt_formatting(), test_qwen_slice_prompt_tokens_guardrail(), test_qwen_summarize_dry_run()

### Community 5 - "Model Card for Model ID"
Cohesion: 0.05
Nodes (37): Bias, Risks, and Limitations, Citation [optional], Compute Infrastructure, Direct Use, Downstream Use [optional], Environmental Impact, Evaluation, Factors (+29 more)

### Community 6 - "Model Card for Model ID"
Cohesion: 0.05
Nodes (37): Bias, Risks, and Limitations, Citation [optional], Compute Infrastructure, Direct Use, Downstream Use [optional], Environmental Impact, Evaluation, Factors (+29 more)

### Community 7 - "LedSummarizer"
Cohesion: 0.17
Nodes (4): LedSummarizer, test_led_global_attention_mask_guardrail(), test_led_metadata(), test_led_summarize_dry_run()

### Community 10 - "startup.ps1"
Cohesion: 0.47
Nodes (3): Invoke-GraphifyUpdate(), Write-Err(), Write-Info()

### Community 13 - "Model Card for Model ID"
Cohesion: 0.05
Nodes (37): Bias, Risks, and Limitations, Citation [optional], Compute Infrastructure, Direct Use, Downstream Use [optional], Environmental Impact, Evaluation, Factors (+29 more)

### Community 14 - "Project Setup and Operations"
Cohesion: 0.07
Nodes (25): 1. LED Global Attention Mask Guardrail (`src/models/led_summarizer.py`), 1. One-Click Automated Startup (Recommended), 2. Manual Environment Setup & Tests, 2. Qwen Left-Padding & Prompt Slicing Guardrail (`src/models/qwen_summarizer.py`), 3. Start the FastAPI Inference & Evaluation Backend, 4. Launch the Interactive Streamlit Dashboard, 🏛️ Critical Architectural Guardrails, Cross-Architecture Legal Bill Summarization Engine (+17 more)

## Knowledge Gaps
- **4 isolated node(s):** `insert`, `update`, `insert`, `update`
  These have ≤1 connection - possible missing edges or undocumented components. (Counts symbols only; 213 node(s) total have ≤1 connection when file, concept and rationale nodes are included.)
- **6 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `BaseSummarizer` connect `BaseSummarizer` to `ModelMetadata`, `QwenSummarizer`, `LedSummarizer`?**
  _High betweenness centrality (0.055) - this node is a cross-community bridge._
- **Are the 2 inferred relationships involving `BaseSummarizer` (e.g. with `get_summarizer()` and `test_model_factory_and_metadata()`) actually correct?**
  _`BaseSummarizer` has 2 INFERRED edges - model-reasoned connections that need verification._
- **What connects `insert`, `update`, `insert` to the rest of the system?**
  _4 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `LegalEvaluator` be split into smaller, more focused modules?**
  _Cohesion score 0.06079664570230608 - nodes in this community are weakly interconnected._
- **Why does `LegalEvaluator` connect `LegalEvaluator` to `dashboard/app.py`, `api/app.py`?**
  _High betweenness centrality (0.041) - this node is a cross-community bridge._
- **Are the 6 inferred relationships involving `SummarizationResult` (e.g. with `BartSummarizer` and `BartSummarizer`) actually correct?**
  _`SummarizationResult` has 6 INFERRED edges - model-reasoned connections that need verification._
- **Should `BaseSummarizer` be split into smaller, more focused modules?**
  _Cohesion score 0.0988235294117647 - nodes in this community are weakly interconnected._