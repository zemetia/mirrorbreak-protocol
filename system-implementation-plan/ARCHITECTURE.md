# MBP System Architecture

**MirrorBreak Protocol — Technical System Blueprint**  
*Collaboration: Dr. Zemetia Research + Dr. Zemetia Psychology + Architect-Zero*

---

## 1. System Overview

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                        MBP SYSTEM ARCHITECTURE                               │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│   ┌─────────────┐                                                            │
│   │   CLIENT    │  User interface (web/chat/voice)                           │
│   │  INTERFACE  │                                                            │
│   └──────┬──────┘                                                            │
│          │                                                                   │
│          ▼                                                                   │
│   ┌─────────────────────────────────────────────────────────────────┐       │
│   │                     ORCHESTRATION LAYER                          │       │
│   │  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌─────────┐ │       │
│   │  │  Phase   │ │  Phase   │ │  Phase   │ │  Phase   │ │  Phase  │ │       │
│   │  │    0     │ │   1-2    │ │    3     │ │    4     │ │   5-6   │ │       │
│   │  │  Safety  │ │   Core   │ │  Mining  │ │  Validate│ │ Synthesize│       │
│   │  └──────────┘ └──────────┘ └──────────┘ └──────────┘ └─────────┘ │       │
│   └─────────────────────────────────────────────────────────────────┘       │
│          │                                                                   │
│          ▼                                                                   │
│   ┌─────────────────────────────────────────────────────────────────┐       │
│   │                      AI AGENT LAYER                              │       │
│   │                                                                  │       │
│   │  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐         │       │
│   │  │Analyzer  │  │Hypothesis│  │Hypothesis│  │ Question │         │       │
│   │  │  Agent   │──│  Maker   │──│ Refiner  │──│  Maker   │         │       │
│   │  └──────────┘  └──────────┘  └──────────┘  └──────────┘         │       │
│   │       │                                              │          │       │
│   │       ▼                                              ▼          │       │
│   │  ┌──────────┐                                 ┌──────────┐      │       │
│   │  │Assessor  │◄────────────────────────────────│Synthesizer│      │       │
│   │  │  Agent   │                                 │  Agent   │      │       │
│   │  └──────────┘                                 └──────────┘      │       │
│   └─────────────────────────────────────────────────────────────────┘       │
│          │                                                                   │
│          ▼                                                                   │
│   ┌─────────────────────────────────────────────────────────────────┐       │
│   │                      DATA LAYER                                  │       │
│   │  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐         │       │
│   │  │ Session  │  │  Field   │  │Evidence  │  │   12D    │         │       │
│   │  │  Store   │  │Hypotheses│  │ Registry │  │  Matrix  │         │       │
│   │  └──────────┘  └──────────┘  └──────────┘  └──────────┘         │       │
│   │  ┌──────────┐  ┌──────────┐  ┌──────────┐                       │       │
│   │  │Contradict│  │  Final   │  │  Audit   │                       │       │
│   │  │   Log    │  │ Profile  │  │   Trail  │                       │       │
│   │  └──────────┘  └──────────┘  └──────────┘                       │       │
│   └─────────────────────────────────────────────────────────────────┘       │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## 2. Core Design Principles

### 2.1 Multi-Field Hypothesis Tracking

Unlike single-hypothesis systems, MBP maintains **parallel hypothesis fields**:

```
FIELD_REGISTRY
├── field_id: "family_dynamics"
│   ├── hypotheses: [H1, H2, H3]
│   ├── confidence_threshold: 0.7
│   ├── iteration_count: 3
│   └── status: "refining"
├── field_id: "cognitive_structure"
│   ├── hypotheses: [H1, H2]
│   ├── confidence_threshold: 0.7
│   ├── iteration_count: 2
│   └── status: "stable"
└── field_id: "power_dynamics"
    ├── hypotheses: [H1, H2, H3, H4]
    ├── confidence_threshold: 0.7
    ├── iteration_count: 1
    └── status: "early"
```

### 2.2 Bayesian Confidence Propagation

Each hypothesis maintains:
- `prior_weight`: Initial probability (0.0-1.0)
- `likelihood_score`: P(Evidence|Hypothesis)
- `posterior_weight`: Updated after each evidence
- `confidence_interval`: [lower, upper] bounds

### 2.3 Contradiction Preservation

Contradictions are **not resolved** — they are logged and explored:

```json
{
  "contradiction_id": "C-042",
  "field_a": "attachment_pattern",
  "field_b": "vulnerability_bandwidth",
  "description": "High attachment anxiety but low disclosure",
  "resolution_strategy": "explore_parts",
  "status": "active",
  "exploration_questions": [...]
}
```

### 2.4 Safety Checkpointing

Mandatory safety gates at Phase 0 and Phase 6:
- Phase 0: Readiness assessment must pass
- Mid-session: Continuous dysregulation detection
- Phase 6: Grounding protocol mandatory

---

## 3. Component Specifications

### 3.1 Analyzer Agent

**Purpose**: Signal extraction from raw input

**Input**:
- Raw transcript (text)
- Behavioral cues (metadata)
- Session context (phase, field focus)

**Output**:
- Tagged signals (categorized observations)
- Field detection (which fields are relevant)
- Engagement quality score

**Key Functions**:
- `extract_signals(transcript)` → Signal[]
- `detect_fields(signals)` → Field[]
- `assess_engagement(session)` → QualityScore

### 3.2 HypothesisMaker Agent

**Purpose**: Generate initial competing hypotheses per field

**Input**:
- Analyzed signals
- Field registry (which fields need hypotheses)

**Output**:
- 3+ hypotheses per field
- Prior weights (based on base rates + signals)
- Testable predictions per hypothesis

**Key Functions**:
- `generate_hypotheses(field, signals)` → Hypothesis[]
- `assign_priors(hypotheses, base_rates)` → WeightedHypothesis[]
- `generate_predictions(hypothesis)` → Predictions[]

### 3.3 HypothesisRefiner Agent

**Purpose**: Bayesian update and hypothesis refinement

**Input**:
- Current hypotheses with weights
- New evidence
- Contradictions (if any)

**Output**:
- Updated posterior weights
- Refined hypothesis descriptions
- Confidence interval adjustments

**Key Functions**:
- `bayesian_update(hypothesis, evidence)` → UpdatedHypothesis
- `refine_description(hypothesis, evidence)` → RefinedHypothesis
- `check_convergence(field)` → ConvergenceStatus

### 3.4 QuestionMaker Agent

**Purpose**: Generate contextual probes based on confidence gaps

**Input**:
- Field confidence scores
- Current phase
- Hypothesis predictions

**Output**:
- Contextual questions
- Probe type (Devil's Advocate, Forced Choice, Surprise, Somatic)

**Trigger Logic**:
```
IF confidence[field] < 0.7:
  → Generate targeted probe
IF contradiction detected:
  → Generate exploration probe
IF phase == 3 (Mining):
  → Generate adaptation pattern probe
```

**Key Functions**:
- `generate_probe(field, confidence, type)` → Question
- `select_probe_strategy(hypotheses)` → Strategy
- `calibrate_difficulty(subject_state)` → DifficultyLevel

### 3.5 Assessor Agent

**Purpose**: Score 12D Matrix dimensions

**Input**:
- All field data
- Evidence registry
- Contradiction log

**Output**:
- 12D scores (1-10) per dimension
- Confidence intervals per score
- Cross-interaction patterns

**Key Functions**:
- `score_dimension(dimension, evidence)` → ScoreWithCI
- `detect_interactions(scores)` → Pattern[]
- `validate_consistency(scores, contradictions)` → ValidationReport

### 3.6 Synthesizer Agent

**Purpose**: Generate final structural profile

**Input**:
- 12D Matrix scores
- Field profiles
- Core Fear/Drive/Defense extraction
- Persona-Core Gap analysis

**Output**:
- Final Structural Profile
- Growth vectors
- Assessment quality rating

**Key Functions**:
- `extract_core_structure(fields)` → CoreStructure
- `calculate_persona_core_gap(profile)` → GapAnalysis
- `identify_adaptation_potensi(profile)` → ConversionChain[]
- `generate_growth_vectors(profile)` → Vector[]

---

## 4. Data Flow Architecture

```
PHASE 0: SAFETY
┌────────────────────────────────────────┐
│ Input: Subject intake data             │
│ Process: Safety screening algorithm    │
│ Output: Go/No-Go decision              │
│ Store: Safety assessment in Session    │
└────────────────────────────────────────┘
            ↓
PHASE 1: CORE DATA COLLECTION
┌────────────────────────────────────────┐
│ Input: Core question responses         │
│ Process: Analyzer → Signal extraction  │
│ Output: Tagged signals, field detection│
│ Store: Layer 1 (Raw) + Layer 2 (Signals)│
└────────────────────────────────────────┘
            ↓
PHASE 2: HYPOTHESIS GENERATION
┌────────────────────────────────────────┐
│ Input: Signals                         │
│ Process: HypothesisMaker → 3+ per field│
│ Output: Field registry with hypotheses │
│ Store: Field registry                  │
└────────────────────────────────────────┘
            ↓
ITERATIVE LOOP (Phases 2-3-4)
┌────────────────────────────────────────┐
│ QuestionMaker → Subject response       │
│ Analyzer → Signal extraction           │
│ HypothesisRefiner → Bayesian update    │
│ Check: Confidence ≥ 0.7 per field?     │
│ Check: Contradictions to explore?      │
│ Repeat until convergence or max iter   │
└────────────────────────────────────────┘
            ↓
PHASE 5: ASSESSMENT
┌────────────────────────────────────────┐
│ Input: Final field states              │
│ Process: Assessor → 12D scoring        │
│ Output: Matrix scores with CI          │
│ Store: 12D Matrix + Contradiction log  │
└────────────────────────────────────────┘
            ↓
PHASE 6: SYNTHESIS & CLOSURE
┌────────────────────────────────────────┐
│ Input: 12D Matrix, all field data      │
│ Process: Synthesizer → Final profile   │
│ Output: Structural Profile             │
│ Store: Final Profile (Layer 3)         │
│ Process: Grounding protocol            │
│ Output: Closure confirmation           │
└────────────────────────────────────────┘
```

---

## 5. Integration Points

### 5.1 Inter-Agent Communication

Agents communicate via standardized message format:

```json
{
  "message_type": "signal" | "hypothesis" | "question" | "assessment" | "synthesis",
  "source_agent": "analyzer" | "hypothesis_maker" | ...,
  "target_agent": "...",
  "payload": { ... },
  "timestamp": "ISO8601",
  "session_id": "uuid",
  "trace_id": "uuid"
}
```

### 5.2 Human-in-the-Loop

- **Safety override**: Human can pause/stop at any time
- **Contradiction exploration**: Human judgment for complex contradictions
- **Final review**: Synthesized profile can be human-validated

### 5.3 Audit Trail

All decisions logged:
- Hypothesis weight changes
- Question generation rationale
- Score justifications
- Confidence interval calculations

---

## 6. Scalability Considerations

### 6.1 Horizontal Scaling

- Each agent can be deployed as independent service
- Message queue for inter-agent communication
- Database sharding by session

### 6.2 Latency Optimization

- Cache hypothesis libraries per field type
- Pre-computed probe templates
- Incremental assessment updates

### 6.3 Resource Management

- Token budget per agent call
- Session timeout handling
- Graceful degradation on overload

---

## 7. Security & Privacy

### 7.1 Data Classification

| Data Type | Sensitivity | Retention |
|-----------|-------------|-----------|
| Raw transcripts | High | 90 days |
| Field hypotheses | High | Session only |
| Final profile | Medium | Indefinite (encrypted) |
| Audit logs | Low | 1 year |

### 7.2 Access Controls

- Analyst authentication
- Subject consent verification
- Role-based access (read-only vs. full)

---

## 8. Next Steps

1. **Implement Data Schema** → See `DATA-SCHEMA.md`
2. **Develop Agent Prompts** → See `PROMPTS/` directory
3. **API Specification** → See `API-SPEC.md`
4. **Tech Stack Selection** → See `TECH-STACK.md`

---

*Architecture v1.0 — System Implementation Plan*  
*MBP Technical Blueprint*
