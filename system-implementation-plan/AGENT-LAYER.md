# MBP Agent Layer

**AI Agent Definitions & Orchestration**

---

## 1. Agent Architecture Overview

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                           AGENT ORCHESTRATION                                │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│   ┌─────────────┐                                                            │
│   │  ORCHESTRATOR│─── Manages state, routes tasks, coordinates agents        │
│   └──────┬──────┘                                                            │
│          │                                                                   │
│    ┌─────┴─────┬────────────┬────────────┬────────────┬────────────┐        │
│    ▼           ▼            ▼            ▼            ▼            ▼        │
│ ┌──────┐  ┌──────┐    ┌──────┐    ┌──────┐    ┌──────┐    ┌──────┐       │
│ │ANALYZ│  │HYPMAK│    │HYPRFN│    │QMAKER│    │ASSESS│    │SYNTHS│       │
│ │  ER  │  │  ER  │    │  ER  │    │      │    │  OR  │    │  IZER│       │
│ └──┬───┘  └──┬───┘    └──┬───┘    └──┬───┘    └──┬───┘    └──┬───┘       │
│    │         │           │           │           │           │            │
│    └─────────┴───────────┴───────────┴───────────┴───────────┘            │
│                              │                                             │
│                              ▼                                             │
│                        ┌──────────┐                                        │
│                        │  SHARED  │                                        │
│                        │ CONTEXT  │                                        │
│                        │  STORE   │                                        │
│                        └──────────┘                                        │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## 2. Agent Specifications

### 2.1 Analyzer Agent

**Purpose:** Extract structured signals from raw input data

**Input:**
```json
{
  "transcript": "[{\"speaker\": \"subject\", \"text\": \"...\", \"timestamp\": \"...\"}]",
  "metadata": {
    "response_times": [],
    "engagement_cues": [],
    "pause_patterns": []
  },
  "current_phase": "phase_1_core"
}
```

**Output:**
```json
{
  "signals": [
    {
      "signal_id": "sig_001",
      "type": "emotional_marker",
      "subtype": "vulnerability_display",
      "confidence": 0.82,
      "transcript_ref": "line_12",
      "raw_evidence": "...",
      "target_fields": ["attachment_pattern", "vulnerability_bandwidth"]
    }
  ],
  "contradictions_detected": [
    {
      "contradiction_id": "con_001",
      "line_a": 5,
      "line_b": 18,
      "type": "temporal_variance",
      "description": "..."
    }
  ],
  "engagement_quality": 0.75
}
```

**Core Capabilities:**
- Natural language understanding for psychological content
- Behavioral cue recognition (hesitation, deflection, emotional shift)
- Pattern extraction from narrative structure
- Contradiction detection within single session

**Model Requirements:**
- Base: GPT-4 or Claude 3 Opus
- Context window: 128k tokens minimum
- Fine-tuning: Optional, on annotated psychological interviews

---

### 2.2 HypothesisMaker Agent

**Purpose:** Generate competing structural hypotheses per field

**Input:**
```json
{
  "field": "attachment_pattern",
  "signals": [...],
  "existing_hypotheses": [],
  "session_context": {
    "cultural_context": "ID",
    "demographics": {...}
  }
}
```

**Output:**
```json
{
  "field": "attachment_pattern",
  "hypotheses": [
    {
      "id": "hyp_001",
      "code": "H1",
      "description": "Dismissive-avoidant with anxious core—defensive independence masking fear of rejection",
      "prior_weight": 0.40,
      "supporting_signals": ["sig_001", "sig_003"],
      "expected_further_evidence": ["emotional_distance_when_pressed", "minimizing_relationship_importance"]
    },
    {
      "id": "hyp_002",
      "code": "H2",
      "description": "Anxious-preoccupied with learned suppression—desire for closeness paired with fear of burdening",
      "prior_weight": 0.35,
      "supporting_signals": ["sig_002", "sig_004"],
      "expected_further_evidence": ["indirect_bids_for_reassurance", "overexplaining_in_relationships"]
    },
    {
      "id": "hyp_003",
      "code": "H3",
      "description": "Disorganized attachment with caregiving role reversal—parentified childhood leading to boundary confusion",
      "prior_weight": 0.25,
      "supporting_signals": ["sig_005"],
      "expected_further_evidence": ["caretaking_compulsion", "resentment_under_caregiving"]
    }
  ],
  "generation_notes": "Based on early-phase signals; high uncertainty expected"
}
```

**Core Capabilities:**
- Generate diverse, competing interpretations
- Weight hypotheses by initial evidence fit
- Identify what evidence would confirm/reject each hypothesis
- Maintain epistemic humility (no premature convergence)

**Constraints:**
- Minimum 3 hypotheses per field
- Maximum 5 hypotheses per field
- Prior weights must sum to 1.0
- Each hypothesis must be falsifiable

---

### 2.3 HypothesisRefiner Agent

**Purpose:** Update hypothesis weights based on new evidence using Bayesian logic

**Input:**
```json
{
  "field": "attachment_pattern",
  "current_hypotheses": [...],
  "new_evidence": {
    "evidence_id": "ev_015",
    "type": "probe_response",
    "content": "...",
    "target_hypotheses": ["hyp_001", "hyp_002"]
  },
  "likelihood_estimates": {
    "hyp_001": 0.7,
    "hyp_002": 0.3,
    "hyp_003": 0.1
  }
}
```

**Output:**
```json
{
  "field": "attachment_pattern",
  "updated_hypotheses": [
    {
      "id": "hyp_001",
      "previous_weight": 0.40,
      "current_weight": 0.52,
      "weight_change": 0.12,
      "supporting_evidence": ["ev_001", "ev_007", "ev_015"],
      "status": "leading"
    },
    {
      "id": "hyp_002",
      "previous_weight": 0.35,
      "current_weight": 0.28,
      "weight_change": -0.07,
      "status": "competing"
    }
  ],
  "refinement_action": "none",
  "confidence_delta": 0.15
}
```

**Refinement Trigger Conditions:**
```python
if hypothesis.current_weight > 0.6 and hypothesis.specificity < 3:
    trigger_refinement(hypothesis)
    # Generate more specific version of leading hypothesis
```

**Refinement Output:**
```json
{
  "refinement_action": "generated_child_hypothesis",
  "parent_hypothesis_id": "hyp_001",
  "child_hypothesis": {
    "id": "hyp_001_v2",
    "code": "H1.2",
    "description": "Dismissive-avoidant with specific abandonment fear around maternal figures—father absence led to compensatory self-reliance",
    "specificity": 4,
    "prior_weight": 0.60
  }
}
```

---

### 2.4 QuestionMaker Agent

**Purpose:** Generate strategic probes based on confidence deficits

**Input:**
```json
{
  "session_state": {
    "current_phase": "phase_2_probing",
    "completed_phases": ["phase_0", "phase_1"]
  },
  "field_confidences": {
    "attachment_pattern": 0.45,
    "cognitive_structure": 0.72,
    "power_dynamics": 0.38
  },
  "priority_fields": ["power_dynamics", "attachment_pattern"],
  "recent_contradictions": [...],
  "session_history": [...]
}
```

**Output:**
```json
{
  "probes": [
    {
      "probe_id": "prb_007",
      "target_field": "power_dynamics",
      "probe_type": "devils_advocate",
      "question": "You've described yourself as easygoing, but I'm curious—tell me about a time you felt someone was trying to control you and you pushed back hard.",
      "rationale": "Testing dominance hypothesis vs. submissive self-presentation; H1 predicts resistance narrative, H2 predicts avoidance",
      "expected_signals": {
        "H1_dominance": ["pride_in_resistance", "detailed_account", "emotional_elevation"],
        "H2_submission": ["vague_response", "minimizing", "topic_shift"]
      },
      "fallback_probes": ["prb_007b", "prb_007c"]
    },
    {
      "probe_id": "prb_008",
      "target_field": "attachment_pattern",
      "probe_type": "forced_choice",
      "question": "If you had to choose: being alone and completely self-sufficient, or deeply connected but occasionally disappointing someone you care about?",
      "rationale": "Direct confrontation of avoidant vs. anxious core; reveals defense priorities",
      "expected_response_patterns": {
        "avoidant": "emphasizes_sufficiency_downplays_cost",
        "anxious": "emphasizes_connection_downplays_burden",
        "secure": "acknowledges_tradeoff_explores_nuance"
      }
    }
  ],
  "strategy_notes": "Targeting two lowest-confidence fields with complementary probe types"
}
```

**Probe Type Library:**

| Type | Purpose | Example |
|------|---------|---------|
| **Devil's Advocate** | Test hypothesis strength by seeking disconfirming evidence | "Tell me about a time you didn't feel that way" |
| **Forced Choice** | Reveal prioritization under constraint | Trade-off scenarios |
| **Surprise Probe** | Bypass rehearsed narrative | "What do people most often misunderstand about you?" |
| **Inconsistency Probe** | Explore detected contradictions | "I noticed X and Y seem different—help me understand" |
| **Temporal Probe** | Track developmental change | "Compare yourself 5 years ago to now" |
| **Somatic Probe** | Access pre-cognitive responses | "When did your body react before your mind caught up?" |

---

### 2.5 Assessor Agent

**Purpose:** Quantify 12-dimensional matrix with confidence intervals

**Input:**
```json
{
  "session_id": "uuid",
  "all_field_profiles": {
    "attachment_pattern": {...},
    "cognitive_structure": {...},
    "power_dynamics": {...}
  },
  "evidence_registry": [...],
  "contradiction_log": [...],
  "convergence_analysis": {
    "cross_field_consistency": 0.78,
    "evidence_density": "medium"
  }
}
```

**Output:**
```json
{
  "matrix_12d": {
    "cognitive": {
      "ab": { "score": 7.5, "ci_low": 0.65, "ci_high": 0.85, "evidence_count": 12 },
      "cdi": { "score": 6.0, "ci_low": 0.50, "ci_high": 0.70, "evidence_count": 8 },
      "crf": { "score": 5.5, "ci_low": 0.45, "ci_high": 0.65, "evidence_count": 10 },
      "processing_style": "analytical"
    },
    "emotional": {
      "eg": { "score": 6.5, "ci_low": 0.55, "ci_high": 0.75, "evidence_count": 9 },
      "rsi": { "primary": "suppression", "secondary": "reappraisal" },
      "vb": { "score": 4.0, "ci_low": 0.30, "ci_high": 0.50, "evidence_count": 11 },
      "stress_response": "freeze"
    },
    "relational": {
      "arp": "strategic_compliance",
      "rs": { "score": 8.0, "ci_low": 0.70, "ci_high": 0.90, "evidence_count": 14 },
      "coi": { "score": 7.0, "ci_low": 0.60, "ci_high": 0.80, "evidence_count": 10 }
    },
    "adaptive": {
      "cfv": { "primary": "irrelevance", "secondary": "rejection" },
      "dmc": { "primary": "intellectualization", "secondary": "withdrawal" },
      "asc": ["strategic_foresight", "emotional_reading"]
    }
  },
  "assessment_quality": "use_with_caution",
  "overall_confidence": 0.72,
  "quality_flags": [
    "low_evidence_for_crf",
    "contradiction_unexplored_in_vb"
  ]
}
```

**Scoring Algorithm:**
```python
def calculate_dimension_score(evidence_list, field_weights):
    """
    Aggregate evidence into dimension score with confidence interval
    """
    weighted_sum = sum(e.signal_strength * e.confidence for e in evidence_list)
    total_weight = sum(e.confidence for e in evidence_list)
    
    point_estimate = weighted_sum / total_weight
    
    # Confidence interval based on evidence consistency and quantity
    variance = calculate_evidence_variance(evidence_list)
    ci_width = base_ci_width / sqrt(len(evidence_list)) * (1 + variance)
    
    return {
        'score': point_estimate,
        'ci_low': max(0, point_estimate - ci_width),
        'ci_high': min(1, point_estimate + ci_width)
    }
```

---

### 2.6 Synthesizer Agent

**Purpose:** Integrate all field data into coherent structural profile

**Input:**
```json
{
  "session_id": "uuid",
  "matrix_12d": {...},
  "field_profiles": [...],
  "contradictions": [...],
  "adaptation_chains": [...],
  "persona_observations": [...],
  "core_observations": [...]
}
```

**Output:**
```json
{
  "final_profile": {
    "core_structure": {
      "core_fear": {
        "primary": { "type": "irrelevance", "confidence": 0.85 },
        "secondary": { "type": "rejection", "confidence": 0.62 },
        "hierarchy": "primary_dominant"
      },
      "core_drive": {
        "primary": { "type": "mastery", "confidence": 0.78 },
        "secondary": { "type": "recognition", "confidence": 0.55 }
      },
      "defense_mechanism": {
        "primary": "intellectualization",
        "secondary": "controlled_vulnerability",
        "automation_level": 4
      }
    },
    
    "persona_core_gap": {
      "persona_description": "Competent, self-sufficient, intellectually confident—appears as the capable one others can rely on",
      "core_description": "Deep fear of being irrelevant or replaceable; uses competence to secure connection; exhausted by constant performance",
      "gap_consequences": [
        "Relational distance despite capability",
        "Burnout from sustained performance",
        "Difficulty receiving help",
        "Intimacy limited to functional domains"
      ],
      "exhaustion_markers": [
        "Increased withdrawal after high-visibility events",
        "Cynicism about others' competence",
        "Physical symptoms during downtime"
      ]
    },
    
    "adaptation_potensi_chain": [
      {
        "adaptation": "Hyper-independence",
        "origin": "Early disappointment in caregivers' reliability",
        "latent_strength": "Self-sufficiency under pressure",
        "growth_vector": "Selective interdependence"
      },
      {
        "adaptation": "Intellectual processing of emotions",
        "origin": "Invalidation of emotional expression",
        "latent_strength": "Pattern recognition and analysis",
        "growth_vector": "Integrated emotional-cognitive experience"
      }
    ],
    
    "cross_interaction_patterns": [
      {
        "pattern_name": "Prestige-Driven Analytical Identity",
        "components": ["High AB", "High CFV(Irrelevance)", "Intellectualization DMC"],
        "description": "Uses abstract thinking and analysis as route to recognition; competence becomes identity proxy for connection"
      },
      {
        "pattern_name": "Strategic Compliance with Hidden Rebellion",
        "components": ["Strategic ARP", "High RS", "Moderate CRF"],
        "description": "Surface adaptation to authority while maintaining internal resistance; recognition-seeking through perceived independence"
      }
    ],
    
    "growth_vectors": [
      {
        "dimension": "vulnerability_bandwidth",
        "current": 4.0,
        "target": 6.5,
        "pathway": "Gradual disclosure in low-stakes relationships; somatic grounding before emotional expression"
      }
    ],
    
    "assessment_metadata": {
      "overall_confidence": 0.78,
      "quality_rating": "use_as_is",
      "key_uncertainties": ["Secondary core drive", "Recovery pattern under chronic stress"],
      "recommended_reassessment": "12_months"
    }
  }
}
```

---

## 3. Agent Orchestration

### 3.1 Task Routing

```python
class Orchestrator:
    def route_task(self, session_state, event):
        """
        Route events to appropriate agents based on session phase
        """
        if event.type == "new_transcript":
            return self.analyzer.process(event.data)
        
        elif event.type == "signals_extracted":
            # Check which fields need hypothesis generation
            for field in event.target_fields:
                if not field.has_hypotheses():
                    return self.hypothesis_maker.generate(field)
            return self.hypothesis_refiner.update_all_fields()
        
        elif event.type == "confidence_check":
            low_confidence_fields = self.get_fields_below_threshold(0.7)
            if low_confidence_fields:
                return self.question_maker.generate_probes(low_confidence_fields)
        
        elif event.type == "phase_complete" and event.phase == 4:
            return self.assessor.calculate_matrix()
        
        elif event.type == "matrix_calculated":
            return self.synthesizer.generate_profile()
```

### 3.2 Shared Context Store

```python
@dataclass
class SharedContext:
    """
    Shared memory accessible to all agents
    """
    session_id: str
    current_phase: Phase
    
    # Layer 1: Raw
    transcript: List[Turn]
    metadata: SessionMetadata
    
    # Layer 2: Signals
    signal_registry: List[Signal]
    contradiction_log: List[Contradiction]
    
    # Layer 3: Hypotheses
    field_registry: Dict[str, FieldState]
    
    # Layer 4: Matrix
    matrix_12d: Optional[Matrix12D]
    
    # Working memory
    recent_insights: List[Insight]
    active_probes: List[Probe]
```

### 3.3 Agent Communication Protocol

```json
{
  "message_type": "agent_communication",
  "from_agent": "analyzer",
  "to_agent": "hypothesis_maker",
  "session_id": "uuid",
  "payload": {
    "event": "signals_ready",
    "data": {...},
    "priority": "normal",
    "deadline": "ISO8601"
  }
}
```

---

## 4. Agent Configuration

### 4.1 Model Selection per Agent

| Agent | Primary Model | Fallback | Context Window |
|-------|---------------|----------|----------------|
| Analyzer | GPT-4 | Claude 3 Opus | 128k |
| HypothesisMaker | Claude 3 Opus | GPT-4 | 200k |
| HypothesisRefiner | GPT-4 | Claude 3 Sonnet | 128k |
| QuestionMaker | GPT-4 | Claude 3 Opus | 128k |
| Assessor | Claude 3 Opus | GPT-4 | 200k |
| Synthesizer | Claude 3 Opus | GPT-4 | 200k |

### 4.2 Temperature Settings

| Agent | Temperature | Reasoning |
|-------|-------------|-----------|
| Analyzer | 0.2 | Consistent signal extraction |
| HypothesisMaker | 0.7 | Creative diversity in hypotheses |
| HypothesisRefiner | 0.3 | Precise Bayesian updating |
| QuestionMaker | 0.5 | Balanced creativity and relevance |
| Assessor | 0.1 | Consistent scoring |
| Synthesizer | 0.4 | Coherent integration with nuance |

---

*Agent Layer v1.0 — Dr. Zemetia Research × Dr. Zemetia Psychology × Architect-Zero*
*MirrorBreak Protocol: System Implementation Plan*
