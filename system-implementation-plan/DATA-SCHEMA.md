# MBP Data Schema

**Database Design & Entity Relationships**

---

## 1. Entity Relationship Diagram

```
┌──────────────────┐     ┌──────────────────┐     ┌──────────────────┐
│     SESSION      │────▶│  PHASE_CHECKPOINT│     │   ANALYST_USER   │
├──────────────────┤     ├──────────────────┤     ├──────────────────┤
│ id (PK)          │     │ id (PK)          │     │ id (PK)          │
│ subject_id (FK)  │     │ session_id (FK)  │     │ email            │
│ analyst_id (FK)  │     │ phase_number     │     │ role             │
│ status           │     │ state_snapshot   │     │ calibration_level│
│ started_at       │     │ confidence_map   │     └──────────────────┘
│ completed_at     │     │ timestamp        │            │
│ safety_cleared   │     └──────────────────┘            │
└────────┬─────────┘                                     │
         │                                              │
         │    ┌──────────────────┐                      │
         └───▶│  SUBJECT_PROFILE │──────────────────────┘
            ├──────────────────┤
            │ id (PK)          │
            │ pseudonym        │
            │ demographics     │
            │ consent_record   │
            └──────────────────┘

┌──────────────────┐     ┌──────────────────┐     ┌──────────────────┐
│   FIELD_REGISTRY │────▶│   HYPOTHESIS     │────▶│    EVIDENCE      │
├──────────────────┤     ├──────────────────┤     ├──────────────────┤
│ id (PK)          │     │ id (PK)          │     │ id (PK)          │
│ session_id (FK)  │     │ field_id (FK)    │     │ hypothesis_id(FK)│
│ field_name       │     │ description      │     │ signal_type      │
│ field_type       │     │ prior_weight     │     │ content          │
│ current_confidence│    │ current_weight   │     │ weight           │
│ status           │     │ refinement_count │     │ timestamp        │
└──────────────────┘     │ generation       │     │ source_agent     │
                         └──────────────────┘     └──────────────────┘

┌──────────────────┐     ┌──────────────────┐     ┌──────────────────┐
│ CONTRADICTION_LOG│     │ MATRIX_12D       │     │  FINAL_PROFILE   │
├──────────────────┤     ├──────────────────┤     ├──────────────────┤
│ id (PK)          │     │ id (PK)          │     │ id (PK)          │
│ session_id (FK)  │     │ session_id (FK)  │     │ session_id (FK)  │
│ field_a          │     │ dimension_code   │     │ core_fear        │
│ field_b          │     │ score (1-10)     │     │ core_drive       │
│ contradiction_type│    │ confidence_low   │     │ defense_primary  │
│ resolution_status│     │ confidence_high  │     │ defense_secondary│
│ exploration_notes│     │ evidence_count   │     │ matrix_12d (FK)  │
└──────────────────┘     └──────────────────┘     │ persona_gap      │
                                                  │ adaptation_chain │
                                                  └──────────────────┘
```

---

## 2. Core Tables

### 2.1 Session Management

```sql
CREATE TABLE sessions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    subject_id UUID REFERENCES subjects(id),
    analyst_id UUID REFERENCES analysts(id),
    
    -- Status tracking
    status VARCHAR(20) CHECK (status IN (
        'initialized', 'phase_0_safety', 'phase_1_core',
        'phase_2_probing', 'phase_3_mining', 'phase_4_validation',
        'phase_5_synthesis', 'phase_6_closure', 'completed', 'aborted'
    )),
    
    -- Safety tracking
    safety_clearance BOOLEAN DEFAULT FALSE,
    safety_checkpoint JSONB, -- Full Phase 0 results
    abort_reason VARCHAR(100),
    
    -- Timing
    started_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    completed_at TIMESTAMP WITH TIME ZONE,
    last_activity_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    
    -- Metadata
    cultural_context VARCHAR(10), -- 'ID', 'US', 'JP', etc.
    session_language VARCHAR(10) DEFAULT 'id',
    
    -- Quality metrics
    engagement_score DECIMAL(3,2), -- 0.00 - 1.00
    completeness_score DECIMAL(3,2),
    
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_sessions_status ON sessions(status);
CREATE INDEX idx_sessions_analyst ON sessions(analyst_id);
CREATE INDEX idx_sessions_subject ON sessions(subject_id);
```

### 2.2 Multi-Field Hypothesis System

```sql
CREATE TABLE field_registry (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    session_id UUID REFERENCES sessions(id) ON DELETE CASCADE,
    
    -- Field definition
    field_name VARCHAR(50) CHECK (field_name IN (
        'family_relations', 'cognitive_structure', 'attachment_pattern',
        'power_dynamics', 'emotional_architecture', 'defense_system',
        'core_conflict', 'adaptation_history'
    )),
    
    field_description TEXT,
    
    -- Confidence tracking
    current_confidence DECIMAL(3,2) CHECK (current_confidence >= 0 AND current_confidence <= 1),
    confidence_history JSONB, -- Array of {timestamp, value, trigger}
    
    -- Status
    status VARCHAR(20) CHECK (status IN ('active', 'saturated', 'contradictory', 'finalized')),
    
    -- Iteration tracking
    refinement_iterations INTEGER DEFAULT 0,
    
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    
    UNIQUE(session_id, field_name)
);

CREATE TABLE hypotheses (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    field_id UUID REFERENCES field_registry(id) ON DELETE CASCADE,
    
    -- Hypothesis content
    hypothesis_code VARCHAR(10), -- H1, H2, H3...
    description TEXT NOT NULL,
    
    -- Bayesian weights
    prior_weight DECIMAL(3,2) CHECK (prior_weight >= 0 AND prior_weight <= 1),
    current_weight DECIMAL(3,2) CHECK (current_weight >= 0 AND current_weight <= 1),
    weight_history JSONB, -- Array of {timestamp, old_val, new_val, evidence_id}
    
    -- Specificity (refinement level)
    specificity_score INTEGER CHECK (specificity_score >= 0 AND specificity_score <= 5),
    -- 0: Generic, 1: Category, 2: Pattern, 3: Personal, 4: Specific, 5: Precise
    
    -- Status
    status VARCHAR(20) CHECK (status IN ('competing', 'leading', 'confirmed', 'rejected')),
    
    -- Evidence links
    supporting_evidence_ids UUID[],
    contradicting_evidence_ids UUID[],
    
    generation INTEGER DEFAULT 1, -- Refinement generation
    parent_hypothesis_id UUID REFERENCES hypotheses(id), -- For tracking refinement lineage
    
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_hypotheses_field ON hypotheses(field_id);
CREATE INDEX idx_hypotheses_status ON hypotheses(status);
```

### 2.3 Evidence Registry

```sql
CREATE TABLE evidence (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    session_id UUID REFERENCES sessions(id) ON DELETE CASCADE,
    
    -- Source
    source_phase INTEGER CHECK (source_phase >= 0 AND source_phase <= 6),
    source_agent VARCHAR(50), -- 'analyzer', 'question_maker', etc.
    
    -- Content
    evidence_type VARCHAR(50) CHECK (evidence_type IN (
        'behavioral_cue', 'verbal_content', 'emotional_marker',
        'cognitive_marker', 'contradiction', 'probe_response',
        'stress_reaction', 'narrative_pattern'
    )),
    
    raw_content TEXT,
    processed_content TEXT,
    
    -- Signal extraction
    signal_tags VARCHAR(50)[], -- Array of tags
    
    -- Impact
    target_fields VARCHAR(50)[], -- Which fields this evidence affects
    
    -- Metadata
    timestamp TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    transcript_position INTEGER, -- Line/turn number
    
    -- Quality
    reliability_score DECIMAL(3,2), -- Analyst-assigned or auto-calculated
    ambiguity_flag BOOLEAN DEFAULT FALSE
);

CREATE INDEX idx_evidence_session ON evidence(session_id);
CREATE INDEX idx_evidence_type ON evidence(evidence_type);
CREATE INDEX idx_evidence_fields ON evidence USING GIN(target_fields);
```

### 2.4 12-Dimensional Matrix

```sql
CREATE TABLE matrix_12d (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    session_id UUID REFERENCES sessions(id) ON DELETE CASCADE,
    
    -- COGNITIVE DOMAIN
    ab_score DECIMAL(3,1) CHECK (ab_score >= 1 AND ab_score <= 10),
    ab_confidence_low DECIMAL(3,2),
    ab_confidence_high DECIMAL(3,2),
    ab_evidence_count INTEGER,
    
    cdi_score DECIMAL(3,1) CHECK (cdi_score >= 1 AND cdi_score <= 10),
    cdi_confidence_low DECIMAL(3,2),
    cdi_confidence_high DECIMAL(3,2),
    cdi_evidence_count INTEGER,
    
    crf_score DECIMAL(3,1) CHECK (crf_score >= 1 AND crf_score <= 10),
    crf_confidence_low DECIMAL(3,2),
    crf_confidence_high DECIMAL(3,2),
    crf_evidence_count INTEGER,
    
    processing_style VARCHAR(20) CHECK (processing_style IN ('intuitive', 'analytical', 'balanced')),
    
    -- EMOTIONAL DOMAIN
    eg_score DECIMAL(3,1) CHECK (eg_score >= 1 AND eg_score <= 10),
    eg_confidence_low DECIMAL(3,2),
    eg_confidence_high DECIMAL(3,2),
    eg_evidence_count INTEGER,
    
    rsi_primary VARCHAR(30) CHECK (rsi_primary IN (
        'suppression', 'expression', 'reappraisal', 'avoidance', 'explosive'
    )),
    rsi_secondary VARCHAR(30),
    
    vb_score DECIMAL(3,1) CHECK (vb_score >= 1 AND vb_score <= 10),
    vb_confidence_low DECIMAL(3,2),
    vb_confidence_high DECIMAL(3,2),
    vb_evidence_count INTEGER,
    
    stress_response VARCHAR(20) CHECK (stress_response IN (
        'freeze', 'flight', 'fight', 'tend_befriend', 'adaptive'
    )),
    
    -- RELATIONAL DOMAIN
    arp_pattern VARCHAR(30) CHECK (arp_pattern IN (
        'rebellious', 'compliant', 'strategic_compliance', 'detached', 'dominant_counter'
    )),
    
    rs_score DECIMAL(3,1) CHECK (rs_score >= 1 AND rs_score <= 10),
    rs_confidence_low DECIMAL(3,2),
    rs_confidence_high DECIMAL(3,2),
    rs_evidence_count INTEGER,
    
    coi_score DECIMAL(3,1) CHECK (coi_score >= 1 AND coi_score <= 10),
    coi_confidence_low DECIMAL(3,2),
    coi_confidence_high DECIMAL(3,2),
    coi_evidence_count INTEGER,
    
    -- ADAPTIVE DOMAIN
    cfv_primary VARCHAR(30) CHECK (cfv_primary IN (
        'rejection', 'irrelevance', 'loss_of_control', 'abandonment',
        'incompetence', 'powerlessness'
    )),
    cfv_secondary VARCHAR(30),
    cfv_confidence DECIMAL(3,2),
    
    dmc_primary VARCHAR(30) CHECK (dmc_primary IN (
        'intellectualization', 'humor', 'dominance', 'people_pleasing',
        'withdrawal', 'perfectionism', 'hyper_independence'
    )),
    dmc_secondary VARCHAR(30),
    dmc_confidence DECIMAL(3,2),
    
    asc_strengths VARCHAR(50)[], -- Array of converted strengths
    
    -- Metadata
    calculated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    assessor_agent_version VARCHAR(20),
    
    -- Cross-validation
    contradiction_flags JSONB,
    cross_pattern_detected VARCHAR(50)[]
);

CREATE INDEX idx_matrix_session ON matrix_12d(session_id);
```

### 2.5 Contradiction Log

```sql
CREATE TABLE contradiction_log (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    session_id UUID REFERENCES sessions(id) ON DELETE CASCADE,
    
    -- Location
    field_a VARCHAR(50),
    field_b VARCHAR(50),
    hypothesis_a_id UUID REFERENCES hypotheses(id),
    hypothesis_b_id UUID REFERENCES hypotheses(id),
    
    -- Nature
    contradiction_type VARCHAR(50) CHECK (contradiction_type IN (
        'direct_opposition', 'temporal_variance', 'context_dependency',
        'ego_state_differentiation', 'developmental_shift'
    )),
    
    -- Assessment
    severity_score INTEGER CHECK (severity_score >= 1 AND severity_score <= 5),
    -- 1: Minor tension, 5: Fundamental incompatibility
    
    -- Resolution approach
    resolution_status VARCHAR(30) CHECK (resolution_status IN (
        'unexplored', 'explored', 'explained_as_multiplicity',
        'developmental_accounted', 'remains_contradictory'
    )),
    
    exploration_notes TEXT,
    exploration_timestamp TIMESTAMP WITH TIME ZONE,
    
    -- MBP principle: Contradictions are data, not errors
    treated_as_data BOOLEAN DEFAULT TRUE
);

CREATE INDEX idx_contradictions_session ON contradiction_log(session_id);
CREATE INDEX idx_contradictions_type ON contradiction_log(contradiction_type);
```

### 2.6 Final Profile

```sql
CREATE TABLE final_profiles (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    session_id UUID REFERENCES sessions(id) ON DELETE CASCADE,
    matrix_id UUID REFERENCES matrix_12d(id),
    
    -- CORE STRUCTURE
    core_fear_primary VARCHAR(50),
    core_fear_secondary VARCHAR(50),
    core_fear_hierarchy JSONB, -- Ordered list with weights
    core_fear_confidence DECIMAL(3,2),
    
    core_drive_primary VARCHAR(50),
    core_drive_secondary VARCHAR(50),
    core_drive_confidence DECIMAL(3,2),
    
    defense_primary VARCHAR(50),
    defense_secondary VARCHAR(50),
    defense_automation_level INTEGER CHECK (defense_automation_level >= 1 AND defense_automation_level <= 5),
    defense_confidence DECIMAL(3,2),
    
    -- PERSONA-CORE GAP
    persona_description TEXT,
    core_description TEXT,
    gap_delta TEXT,
    gap_consequences TEXT[],
    gap_exhaustion_markers TEXT[],
    
    -- ADAPTATION-POTENSI CHAIN
    adaptation_potensi_chain JSONB, -- Array of {adaptation, origin, strength, confidence}
    
    -- CROSS-INTERACTION PATTERNS
    detected_patterns VARCHAR(50)[],
    pattern_descriptions JSONB,
    
    -- GROWTH VECTORS
    growth_vectors JSONB, -- Array of {dimension, current, target, pathway}
    
    -- OVERALL QUALITY
    overall_confidence DECIMAL(3,2),
    assessment_quality VARCHAR(20) CHECK (assessment_quality IN (
        'use_as_is', 'use_with_caution', 'requires_reassessment', 'insufficient_data'
    )),
    
    -- Metadata
    generated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    synthesizer_version VARCHAR(20),
    
    -- Review
    reviewed_by UUID REFERENCES analysts(id),
    review_notes TEXT,
    review_status VARCHAR(20) CHECK (review_status IN ('pending', 'approved', 'flagged'))
);

CREATE INDEX idx_profiles_session ON final_profiles(session_id);
```

---

## 3. JSON Schema Definitions

### 3.1 API Request: Create Session

```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "type": "object",
  "required": ["subject_pseudonym", "analyst_id"],
  "properties": {
    "subject_pseudonym": {
      "type": "string",
      "minLength": 3,
      "maxLength": 50
    },
    "analyst_id": {
      "type": "string",
      "format": "uuid"
    },
    "cultural_context": {
      "type": "string",
      "enum": ["ID", "US", "JP", "KR", "SG", "OTHER"],
      "default": "ID"
    },
    "session_language": {
      "type": "string",
      "default": "id"
    },
    "consent_record": {
      "type": "object",
      "properties": {
        "informed_consent_given": { "type": "boolean" },
        "stress_testing_acknowledged": { "type": "boolean" },
        "data_usage_agreed": { "type": "boolean" },
        "consent_timestamp": { "type": "string", "format": "date-time" }
      },
      "required": ["informed_consent_given", "stress_testing_acknowledged"]
    }
  }
}
```

### 3.2 API Response: Phase 2 Probing

```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "type": "object",
  "required": ["session_id", "phase", "probes"],
  "properties": {
    "session_id": { "type": "string", "format": "uuid" },
    "phase": { "type": "string", "enum": ["phase_2_probing"] },
    "field_confidences": {
      "type": "object",
      "properties": {
        "family_relations": { "type": "number", "minimum": 0, "maximum": 1 },
        "cognitive_structure": { "type": "number", "minimum": 0, "maximum": 1 },
        "attachment_pattern": { "type": "number", "minimum": 0, "maximum": 1 }
      }
    },
    "probes": {
      "type": "array",
      "items": {
        "type": "object",
        "properties": {
          "probe_id": { "type": "string" },
          "target_field": { "type": "string" },
          "probe_type": { "type": "string", "enum": ["devils_advocate", "forced_choice", "surprise", "inconsistency", "temporal"] },
          "question_text": { "type": "string" },
          "rationale": { "type": "string" },
          "expected_signals": { "type": "array", "items": { "type": "string" } }
        }
      }
    }
  }
}
```

### 3.3 Final Profile Output

```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "type": "object",
  "required": ["session_id", "core_structure", "matrix_12d", "overall_confidence"],
  "properties": {
    "session_id": { "type": "string", "format": "uuid" },
    "core_structure": {
      "type": "object",
      "properties": {
        "core_fear": {
          "type": "object",
          "properties": {
            "primary": { "type": "string" },
            "secondary": { "type": "string" },
            "confidence": { "type": "number" }
          }
        },
        "core_drive": {
          "type": "object",
          "properties": {
            "primary": { "type": "string" },
            "secondary": { "type": "string" },
            "confidence": { "type": "number" }
          }
        },
        "defense_mechanism": {
          "type": "object",
          "properties": {
            "primary": { "type": "string" },
            "secondary": { "type": "string" },
            "confidence": { "type": "number" }
          }
        }
      }
    },
    "matrix_12d": {
      "type": "object",
      "properties": {
        "cognitive": {
          "type": "object",
          "properties": {
            "ab": { "type": "object", "properties": { "score": { "type": "number" }, "ci_low": { "type": "number" }, "ci_high": { "type": "number" } } },
            "cdi": { "type": "object", "properties": { "score": { "type": "number" }, "ci_low": { "type": "number" }, "ci_high": { "type": "number" } } },
            "crf": { "type": "object", "properties": { "score": { "type": "number" }, "ci_low": { "type": "number" }, "ci_high": { "type": "number" } } }
          }
        }
      }
    },
    "persona_core_gap": {
      "type": "object",
      "properties": {
        "persona_description": { "type": "string" },
        "core_description": { "type": "string" },
        "gap_consequences": { "type": "array", "items": { "type": "string" } }
      }
    },
    "overall_confidence": { "type": "number", "minimum": 0, "maximum": 1 },
    "assessment_quality": { "type": "string", "enum": ["use_as_is", "use_with_caution", "requires_reassessment"] }
  }
}
```

---

## 4. Vector Store Schema (for Evidence Retrieval)

```python
# Pinecone / Weaviate / Chroma schema

class EvidenceEmbedding:
    id: str  # UUID
    session_id: str
    
    # Embedding
    text: str  # Raw or processed content
    embedding: List[float]  # 1536-dim (OpenAI) or 768-dim (local)
    
    # Metadata
    phase: int
    evidence_type: str
    field_tags: List[str]
    timestamp: datetime
    
    # For retrieval
    hypothesis_links: List[str]  # Connected hypothesis IDs
    contradiction_flag: bool
```

---

*Data Schema v1.0 — Dr. Zemetia Research × Architect-Zero*
*MirrorBreak Protocol: System Implementation Plan*
