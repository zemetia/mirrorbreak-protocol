# MBP Agent Layer Specification

**AI Agent Definitions & Responsibilities**

---

## 1. Agent Architecture Overview

```
┌─────────────────────────────────────────────────────────────┐
│                    AGENT ORCHESTRATION                       │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│   ┌─────────────┐    ┌─────────────┐    ┌─────────────┐    │
│   │  ANALYZER   │───▶│  HYPOTHESIS │───▶│   REFINER   │    │
│   │             │    │    MAKER    │    │             │    │
│   └─────────────┘    └─────────────┘    └─────────────┘    │
│          │                                    │             │
│          │         ┌─────────────┐            │             │
│          └────────▶│  QUESTION   │◀───────────┘             │
│                    │    MAKER    │                          │
│                    └─────────────┘                          │
│                           │                                 │
│                           ▼                                 │
│                    ┌─────────────┐    ┌─────────────┐      │
│                    │  ASSESSOR   │───▶│ SYNTHESIZER │      │
│                    │             │    │             │      │
│                    └─────────────┘    └─────────────┘      │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## 2. Agent Specifications

### 2.1 Analyzer Agent

**ID**: `analyzer-v1`  
**Purpose**: Extract structured signals from raw input  
**Input**: Raw transcripts, behavioral metadata  
**Output**: Tagged signals, field relevance scores

**Responsibilities**:
- Parse natural language for psychological signals
- Identify somatic markers and non-verbal cues
- Tag content with field relevance
- Assess engagement quality
- Detect emotional valence and intensity

**Output Schema**:
```json
{
  "signals": [
    {
      "signal_type": "boundary_enforcement",
      "category": "relational",
      "strength": 0.8,
      "confidence": 0.9,
      "evidence_quote": "...",
      "timestamp": "..."
    }
  ],
  "field_detection": {
    "family_dynamics": 0.85,
    "attachment_pattern": 0.72,
    "cognitive_structure": 0.45
  },
  "engagement_quality": 0.88
}
```

---

### 2.2 HypothesisMaker Agent

**ID**: `hypothesis-maker-v1`  
**Purpose**: Generate competing hypotheses per field  
**Input**: Analyzed signals, field definitions  
**Output**: 3+ weighted hypotheses per active field

**Responsibilities**:
- Generate diverse, competing explanations
- Assign prior weights based on signal patterns
- Ensure hypotheses are mutually exclusive where possible
- Generate testable predictions for each hypothesis

**Algorithm**:
```
FOR each field in active_fields:
    signals = filter_by_field(evidence, field)
    
    H1 = generate_primary_hypothesis(signals)
    H1.prior = base_rate(field) * signal_strength
    
    H2 = generate_alternative(signals, H1)
    H2.prior = base_rate(field) * 0.5
    
    H3 = generate_contrarian(signals, H1, H2)
    H3.prior = base_rate(field) * 0.3
    
    FOR each H in [H1, H2, H3]:
        H.predictions = generate_predictions(H)
        
    normalize_priors([H1, H2, H3])
```

---

### 2.3 HypothesisRefiner Agent

**ID**: `hypothesis-refiner-v1`  
**Purpose**: Bayesian update and hypothesis refinement  
**Input**: Current hypotheses, new evidence  
**Output**: Updated posterior weights, refined descriptions

**Responsibilities**:
- Calculate P(H|Evidence) using Bayes' theorem
- Update confidence intervals
- Refine hypothesis text for specificity
- Detect convergence (confidence > threshold)
- Flag hypotheses for rejection

**Bayesian Update**:
```
posterior = (likelihood * prior) / evidence_probability

where:
- likelihood = match between prediction and observed
- prior = current weight
- evidence_probability = sum over all hypotheses
```

**Refinement Strategy**:
- If evidence supports → Increase specificity
- If evidence contradicts → Adjust scope or reject
- If mixed → Maintain with wider confidence interval

---

### 2.4 QuestionMaker Agent

**ID**: `question-maker-v1`  
**Purpose**: Generate targeted probes based on confidence gaps  
**Input**: Field confidence scores, hypothesis predictions  
**Output**: Contextual questions

**Trigger Logic**:
```python
def should_probe(field):
    if field.confidence < 0.7:
        return True
    if field.contradictions.active:
        return True
    if field.iteration < MIN_ITERATIONS:
        return True
    return False
```

**Probe Types**:

| Type | Purpose | Example |
|------|---------|---------|
| **Devil's Advocate** | Test hypothesis robustness | "Tell me about a time when X was NOT true..." |
| **Forced Choice** | Reveal trade-off preferences | "Would you rather be ignored or criticized?" |
| **Surprise Probe** | Access unprepared responses | "What's most misunderstood about you?" |
| **Somatic Marker** | Access pre-cognitive data | "When did your body react before your mind?" |
| **Temporal Comparison** | Track stability/change | "How are you different from 5 years ago?" |
| **Inconsistency Probe** | Explore contradictions | "Part of you wants X, but another part..." |

**Selection Algorithm**:
```
IF confidence < 0.7:
    → Select probe targeting specific gap
    
IF contradiction detected:
    → Select inconsistency probe
    
IF phase == 3 (Mining):
    → Select somatic or rule-extraction probe
    
IF under stress test:
    → Select forced choice or devil's advocate
```

---

### 2.5 Assessor Agent

**ID**: `assessor-v1`  
**Purpose**: Score 12D Matrix dimensions  
**Input**: All field data, evidence registry  
**Output**: Dimension scores with confidence intervals

**Scoring Methodology**:
- Aggregate evidence per dimension
- Weight by evidence quality and confidence
- Calculate score (1-10) with confidence interval
- Identify cross-interaction patterns

**Evidence Weighting**:
```
dimension_score = weighted_average(
    evidence_signals,
    weights = confidence * relevance * recency
)

confidence_interval = calculate_ci(
    evidence_variance,
    evidence_count
)
```

**Cross-Interaction Detection**:
```
IF (AB > 7 AND CDI > 7 AND CRF > 6):
    → Pattern: "strategic_mind"
    
IF (RS > 7 AND ARP == "rebellious"):
    → Pattern: "recognition_wound"
    
IF (EG > 6 AND VB < 4 AND RSI == "suppression"):
    → Pattern: "emotional_trap"
```

---

### 2.6 Synthesizer Agent

**ID**: `synthesizer-v1`  
**Purpose**: Generate final structural profile  
**Input**: 12D Matrix, all field profiles  
**Output**: Complete Structural Profile

**Synthesis Pipeline**:
```
1. Extract Core Structure
   ├── Map CFV from field data
   ├── Map Core Drive from energy patterns
   └── Map DMC from defense patterns

2. Build Cognitive Map
   ├── AB → abstraction_level
   ├── CDI → causal_depth
   └── CRF → rigidity_profile

3. Build Emotional Architecture
   ├── EG → granularity
   ├── RSI → regulation_strategy
   └── VB → expression_capacity

4. Calculate Persona-Core Gap
   ├── Extract persona narrative
   ├── Extract core patterns
   └── Calculate delta magnitude

5. Identify Adaptation-Potensi Chain
   ├── Map adaptations to origins
   ├── Identify latent strengths
   └── Calculate activation potential

6. Generate Growth Vectors
   ├── Identify lowest confidence areas
   ├── Map high-impact improvements
   └── Prioritize by feasibility
```

---

## 3. Agent Communication Protocol

### 3.1 Message Format

```json
{
  "message_id": "uuid",
  "timestamp": "ISO8601",
  "session_id": "uuid",
  "trace_id": "uuid",
  
  "header": {
    "from_agent": "analyzer",
    "to_agent": "hypothesis_maker",
    "message_type": "signal_batch",
    "priority": 1
  },
  
  "payload": {
    "field_id": "uuid",
    "signals": [...],
    "context": {...}
  },
  
  "metadata": {
    "processing_time_ms": 450,
    "token_count": 1250
  }
}
```

### 3.2 Message Types

| Type | Sender | Receiver | Purpose |
|------|--------|----------|---------|
| `signal_batch` | Analyzer | HypothesisMaker | New signals for processing |
| `hypothesis_set` | HypothesisMaker | HypothesisRefiner | Initial hypotheses |
| `evidence_update` | HypothesisRefiner | QuestionMaker | New evidence for probing |
| `probe_request` | QuestionMaker | Orchestrator | Question for subject |
| `assessment_ready` | Assessor | Synthesizer | 12D scores complete |
| `profile_complete` | Synthesizer | Orchestrator | Final output ready |

---

## 4. Error Handling & Recovery

### 4.1 Agent Failure Modes

| Failure | Detection | Recovery |
|---------|-----------|----------|
| Timeout | >30s no response | Retry with simpler input |
| Low confidence | <0.5 output confidence | Request more evidence |
| Contradiction overload | >5 active contradictions | Prioritize and defer |
| Hallucination | Unsupported claims | Fact-check against evidence |

### 4.2 Fallback Strategies

- **Analyzer fails**: Use simpler regex-based extraction
- **HypothesisMaker fails**: Use template hypotheses
- **QuestionMaker fails**: Use standard probe library
- **Assessor fails**: Flag for human review

---

## 5. Performance Requirements

| Agent | Latency Target | Throughput | Accuracy Target |
|-------|---------------|------------|-----------------|
| Analyzer | <2s | 1 msg/s | 85% signal precision |
| HypothesisMaker | <3s | 1 batch/s | N/A (generative) |
| HypothesisRefiner | <2s | 1 update/s | 90% convergence |
| QuestionMaker | <1s | 1 question/s | 80% relevance |
| Assessor | <5s | 1 matrix/s | 75% inter-rater |
| Synthesizer | <5s | 1 profile/s | N/A (generative) |

---

*Agent Layer v1.0 — System Implementation Plan*
