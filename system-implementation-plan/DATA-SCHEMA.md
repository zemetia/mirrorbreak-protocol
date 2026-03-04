# MBP Data Schema

**Database Design & Entity Relationships**

---

## 1. Entity Overview

```
┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐
│    SESSION      │────▶│     FIELD       │────▶│   HYPOTHESIS    │
│   (container)   │     │   (per-domain)  │     │  (competing)    │
└─────────────────┘     └─────────────────┘     └─────────────────┘
         │                       │                       │
         ▼                       ▼                       ▼
┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐
│  SAFETY_CHECK   │     │    EVIDENCE     │     │  PREDICTION     │
│                 │     │    (tagged)     │     │  (testable)     │
└─────────────────┘     └─────────────────┘     └─────────────────┘
         │
         ▼
┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐
│  CONTRADICTION  │────▶│   12D_MATRIX    │────▶│  FINAL_PROFILE  │
│     (log)       │     │   (scored)      │     │  (synthesized)  │
└─────────────────┘     └─────────────────┘     └─────────────────┘
```

See ARCHITECTURE.md for full JSON schema definitions.

---

## 2. Database Schema (PostgreSQL)

```sql
-- Core Session Table
CREATE TABLE sessions (
    session_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    subject_id UUID NOT NULL,
    analyst_id UUID NOT NULL,
    status VARCHAR(20) NOT NULL CHECK (status IN ('pending', 'active', 'paused', 'completed', 'aborted')),
    current_phase INTEGER CHECK (current_phase BETWEEN 0 AND 6),
    safety_status VARCHAR(20) CHECK (safety_status IN ('cleared', 'monitoring', 'flagged', 'stopped')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    completed_at TIMESTAMP WITH TIME ZONE,
    metadata JSONB,
    checkpoint JSONB
);

CREATE INDEX idx_sessions_status ON sessions(status);
CREATE INDEX idx_sessions_analyst ON sessions(analyst_id);

-- Safety Screening
CREATE TABLE safety_checks (
    safety_check_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    session_id UUID REFERENCES sessions(session_id) ON DELETE CASCADE,
    timestamp TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    readiness_score INTEGER CHECK (readiness_score BETWEEN 1 AND 10),
    stress_level INTEGER CHECK (stress_level BETWEEN 1 AND 10),
    decision VARCHAR(30) CHECK (decision IN ('proceed', 'proceed_with_caution', 'defer')),
    flags TEXT[],
    screening_data JSONB
);

-- Hypothesis Fields
CREATE TABLE fields (
    field_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    session_id UUID REFERENCES sessions(session_id) ON DELETE CASCADE,
    field_name VARCHAR(50) NOT NULL,
    field_category VARCHAR(20) CHECK (field_category IN ('relational', 'cognitive', 'emotional', 'adaptive')),
    status VARCHAR(20) CHECK (status IN ('pending', 'active', 'stable', 'converged', 'abandoned')),
    iteration_count INTEGER DEFAULT 0,
    confidence_threshold DECIMAL(3,2) DEFAULT 0.70,
    current_confidence DECIMAL(3,2),
    converged_at TIMESTAMP WITH TIME ZONE,
    linked_dimensions VARCHAR(10)[],
    metadata JSONB
);

CREATE INDEX idx_fields_session ON fields(session_id);

-- Hypotheses
CREATE TABLE hypotheses (
    hypothesis_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    field_id UUID REFERENCES fields(field_id) ON DELETE CASCADE,
    session_id UUID REFERENCES sessions(session_id) ON DELETE CASCADE,
    hypothesis_text TEXT NOT NULL,
    iteration INTEGER DEFAULT 0,
    version VARCHAR(20) DEFAULT 'initial',
    prior_weight DECIMAL(4,3),
    posterior_weight DECIMAL(4,3),
    confidence_lower DECIMAL(4,3),
    confidence_upper DECIMAL(4,3),
    status VARCHAR(20) CHECK (status IN ('active', 'rejected', 'merged')),
    rejection_reason TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_hypotheses_field ON hypotheses(field_id);

-- Evidence Registry
CREATE TABLE evidence (
    evidence_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    session_id UUID REFERENCES sessions(session_id) ON DELETE CASCADE,
    field_id UUID REFERENCES fields(field_id),
    hypothesis_id UUID REFERENCES hypotheses(hypothesis_id),
    source_type VARCHAR(30) CHECK (source_type IN ('transcript', 'behavioral_cue', 'probe_response')),
    phase INTEGER,
    timestamp TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    raw_content TEXT,
    signals JSONB,
    tags TEXT[],
    somatic_markers TEXT[],
    emotional_valence DECIMAL(3,2),
    processing_metadata JSONB
);

CREATE INDEX idx_evidence_session ON evidence(session_id);
CREATE INDEX idx_evidence_field ON evidence(field_id);

-- Contradictions
CREATE TABLE contradictions (
    contradiction_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    session_id UUID REFERENCES sessions(session_id) ON DELETE CASCADE,
    type VARCHAR(20) CHECK (type IN ('inter_field', 'intra_field', 'temporal')),
    field_a_id UUID REFERENCES fields(field_id),
    field_b_id UUID REFERENCES fields(field_id),
    description TEXT,
    evidence_a_ids UUID[],
    evidence_b_ids UUID[],
    resolution_strategy VARCHAR(30),
    resolution_attempts JSONB,
    status VARCHAR(20) CHECK (status IN ('active', 'explored', 'resolved', 'persistent')),
    exploration_value DECIMAL(3,2),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    resolved_at TIMESTAMP WITH TIME ZONE
);

-- 12D Matrix
CREATE TABLE matrix_12d (
    matrix_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    session_id UUID REFERENCES sessions(session_id) ON DELETE CASCADE,
    assessed_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    dimensions JSONB NOT NULL,
    cross_interactions JSONB,
    overall_confidence DECIMAL(3,2),
    assessment_quality VARCHAR(30)
);

-- Final Profile
CREATE TABLE final_profiles (
    profile_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    session_id UUID REFERENCES sessions(session_id) ON DELETE CASCADE,
    matrix_id UUID REFERENCES matrix_12d(matrix_id),
    synthesized_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    core_structure JSONB,
    cognitive_map JSONB,
    emotional_architecture JSONB,
    relational_dynamics JSONB,
    persona_core_gap JSONB,
    adaptation_potensi_chain JSONB,
    growth_vectors JSONB,
    assessment_quality JSONB,
    metadata JSONB
);

-- Audit Trail
CREATE TABLE audit_logs (
    log_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    session_id UUID REFERENCES sessions(session_id) ON DELETE CASCADE,
    agent_name VARCHAR(50),
    action VARCHAR(100),
    entity_type VARCHAR(50),
    entity_id UUID,
    previous_state JSONB,
    new_state JSONB,
    timestamp TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_audit_session ON audit_logs(session_id);
```

---

## 3. Key Relationships

```
sessions ||--o{ fields : contains
sessions ||--o{ safety_checks : has
sessions ||--o{ evidence : generates
sessions ||--o{ contradictions : tracks
sessions ||--o{ matrix_12d : produces
sessions ||--|| final_profiles : results_in

fields ||--o{ hypotheses : contains
fields ||--o{ evidence : supports

hypotheses ||--o{ evidence : supported_by

contradictions }o--|| fields : involves
```

---

## 4. Data Retention Policy

| Table | Retention | Archive Strategy |
|-------|-----------|------------------|
| sessions | 2 years | Encrypt and compress |
| safety_checks | 2 years | Keep for liability |
| fields | 2 years | Archive with session |
| hypotheses | 2 years | Archive with session |
| evidence | 90 days | Purge raw content, keep signals |
| contradictions | 2 years | Archive with session |
| matrix_12d | Indefinite | Keep encrypted |
| final_profiles | Indefinite | Keep encrypted |
| audit_logs | 1 year | Compress and archive |

---

## 5. Access Patterns

### 5.1 Read Heavy
- Fetch session by ID
- List fields for session
- Get active hypotheses for field
- Retrieve final profile

### 5.2 Write Heavy
- Create evidence entries (each response)
- Update hypothesis weights
- Log agent actions

### 5.3 Indexes Required
- `sessions.status`, `sessions.analyst_id`
- `fields.session_id`
- `evidence.session_id`, `evidence.field_id`
- `hypotheses.field_id`
- `audit_logs.session_id`

---

*Data Schema v1.0 — System Implementation Plan*
