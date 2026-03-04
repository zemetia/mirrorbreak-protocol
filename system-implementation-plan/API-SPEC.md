# MBP API Specification

**RESTful API for MirrorBreak Protocol System**

---

## 1. Base Information

```
Base URL: https://api.mirrorbreak.io/v1
Content-Type: application/json
Authentication: Bearer {JWT_TOKEN}
```

---

## 2. Session Management

### 2.1 Create Session

```http
POST /sessions
```

**Request:**
```json
{
  "subject_pseudonym": "Subject-A47",
  "analyst_id": "analyst_001",
  "cultural_context": "ID",
  "session_language": "id",
  "consent_record": {
    "informed_consent_given": true,
    "stress_testing_acknowledged": true,
    "data_usage_agreed": true,
    "consent_timestamp": "2026-03-04T10:00:00Z"
  }
}
```

**Response (201):**
```json
{
  "session_id": "550e8400-e29b-41d4-a716-446655440000",
  "status": "initialized",
  "created_at": "2026-03-04T10:00:00Z",
  "next_phase": "phase_0_safety",
  "phase_url": "/sessions/550e8400-e29b-41d4-a716-446655440000/phase/0"
}
```

### 2.2 Get Session Status

```http
GET /sessions/{session_id}
```

**Response (200):**
```json
{
  "session_id": "550e8400-e29b-41d4-a716-446655440000",
  "status": "phase_2_probing",
  "subject_pseudonym": "Subject-A47",
  "analyst_id": "analyst_001",
  "current_phase": {
    "phase_number": 2,
    "phase_name": "adaptive_probing",
    "started_at": "2026-03-04T10:25:00Z"
  },
  "phases_completed": ["phase_0", "phase_1"],
  "field_confidences": {
    "attachment_pattern": 0.45,
    "cognitive_structure": 0.72,
    "power_dynamics": 0.38
  },
  "overall_progress": 0.35,
  "estimated_completion": "2026-03-04T11:30:00Z"
}
```

### 2.3 List Sessions

```http
GET /sessions?analyst_id={id}&status={status}&limit=20&offset=0
```

---

## 3. Phase Operations

### 3.1 Execute Phase

```http
POST /sessions/{session_id}/phase/{phase_number}/execute
```

**Phase 0: Safety Check**

**Request:**
```json
{
  "readiness_check": {
    "current_stress_level": 3,
    "support_system_available": true,
    "sleep_quality_last_week": "adequate",
    "recent_crisis": false
  },
  "informed_consent_verified": true
}
```

**Response (200):**
```json
{
  "phase": 0,
  "status": "completed",
  "safety_clearance": true,
  "readiness_score": 8,
  "next_phase": "phase_1_core",
  "safety_notes": "Subject stable, adequate support, proceeding"
}
```

### 3.2 Submit Phase Data

```http
POST /sessions/{session_id}/phase/{phase_number}/data
```

**Phase 1: Core Questions**

**Request:**
```json
{
  "transcript": [
    {
      "turn_id": 1,
      "speaker": "analyst",
      "text": "Tell me about your childhood...",
      "timestamp": "2026-03-04T10:15:00Z"
    },
    {
      "turn_id": 2,
      "speaker": "subject",
      "text": "It was fine. Normal, I guess...",
      "timestamp": "2026-03-04T10:15:05Z",
      "metadata": {
        "response_delay_ms": 3200,
        "hesitation_markers": true
      }
    }
  ],
  "metadata": {
    "engagement_score": 0.75,
    "emotional_range_observed": ["neutral", "guarded"]
  }
}
```

**Response (202):**
```json
{
  "data_id": "data_001",
  "processing_status": "queued",
  "estimated_processing_time": "30s",
  "callback_url": "/sessions/{id}/phase/1/data/{data_id}/status"
}
```

### 3.3 Get Phase Results

```http
GET /sessions/{session_id}/phase/{phase_number}/results
```

**Response (200):**
```json
{
  "phase": 1,
  "status": "completed",
  "signals_extracted": 12,
  "fields_populated": ["attachment_pattern", "cognitive_structure", "defense_system"],
  "field_confidences": {
    "attachment_pattern": 0.35,
    "cognitive_structure": 0.55,
    "defense_system": 0.48
  },
  "hypotheses_generated": {
    "attachment_pattern": 3,
    "cognitive_structure": 3,
    "defense_system": 3
  },
  "completion_timestamp": "2026-03-04T10:25:00Z"
}
```

---

## 4. Field & Hypothesis Operations

### 4.1 Get Field Status

```http
GET /sessions/{session_id}/fields/{field_name}
```

**Response (200):**
```json
{
  "field": "attachment_pattern",
  "status": "active",
  "current_confidence": 0.68,
  "confidence_history": [
    {"timestamp": "2026-03-04T10:20:00Z", "value": 0.35},
    {"timestamp": "2026-03-04T10:35:00Z", "value": 0.52},
    {"timestamp": "2026-03-04T10:50:00Z", "value": 0.68}
  ],
  "hypotheses": [
    {
      "id": "hyp_001",
      "code": "H1",
      "description": "Dismissive-avoidant with anxious core",
      "current_weight": 0.68,
      "status": "leading",
      "specificity": 3
    },
    {
      "id": "hyp_002",
      "code": "H2",
      "description": "True avoidant, authentic low need",
      "current_weight": 0.18,
      "status": "competing"
    }
  ],
  "evidence_count": 14,
  "refinement_count": 2
}
```

### 4.2 Trigger Hypothesis Refinement

```http
POST /sessions/{session_id}/fields/{field_name}/refine
```

**Request:**
```json
{
  "new_evidence": [
    {
      "evidence_id": "ev_025",
      "type": "probe_response",
      "content": "Subject described specific instance of needing mother...",
      "likelihood_by_hypothesis": {
        "hyp_001": 0.85,
        "hyp_002": 0.20,
        "hyp_003": 0.60
      }
    }
  ]
}
```

**Response (200):**
```json
{
  "field": "attachment_pattern",
  "refinement_completed": true,
  "hypothesis_updates": [
    {
      "hypothesis_id": "hyp_001",
      "previous_weight": 0.52,
      "current_weight": 0.68,
      "change": 0.16
    }
  ],
  "new_confidence": 0.68,
  "refinement_triggered": false
}
```

---

## 5. Probe Generation

### 5.1 Generate Probes

```http
POST /sessions/{session_id}/probes/generate
```

**Request:**
```json
{
  "target_fields": ["attachment_pattern", "power_dynamics"],
  "probe_types": ["devils_advocate", "forced_choice"],
  "count": 3
}
```

**Response (200):**
```json
{
  "probes": [
    {
      "probe_id": "prb_003",
      "target_field": "attachment_pattern",
      "probe_type": "devils_advocate",
      "question": "You describe yourself as not needing much from others...",
      "rationale": "Tests defended vs authentic independence",
      "expected_signals": {
        "h1_support": ["hesitation", "affective_charge"],
        "h2_support": ["genuine_confusion"]
      },
      "safety_check": "passed"
    }
  ],
  "priority_field": "attachment_pattern",
  "generation_timestamp": "2026-03-04T10:45:00Z"
}
```

---

## 6. Matrix & Profile Operations

### 6.1 Calculate Matrix

```http
POST /sessions/{session_id}/matrix/calculate
```

**Response (200):**
```json
{
  "matrix_id": "mat_001",
  "status": "calculated",
  "matrix_12d": {
    "cognitive": {
      "ab": {"score": 7.5, "ci_low": 0.65, "ci_high": 0.85},
      "cdi": {"score": 6.0, "ci_low": 0.50, "ci_high": 0.70},
      "crf": {"score": 5.5, "ci_low": 0.45, "ci_high": 0.65}
    },
    "emotional": {...},
    "relational": {...},
    "adaptive": {...}
  },
  "overall_confidence": 0.72,
  "assessment_quality": "use_with_caution",
  "calculation_timestamp": "2026-03-04T11:15:00Z"
}
```

### 6.2 Generate Final Profile

```http
POST /sessions/{session_id}/profile/generate
```

**Response (200):**
```json
{
  "profile_id": "prof_001",
  "status": "generated",
  "profile_url": "/sessions/{id}/profile/prof_001",
  "core_structure": {...},
  "persona_core_gap": {...},
  "adaptation_potensi_chain": [...],
  "overall_confidence": 0.78,
  "generation_timestamp": "2026-03-04T11:30:00Z"
}
```

### 6.3 Get Final Profile

```http
GET /sessions/{session_id}/profile
```

**Response (200):** Full profile JSON (see AGENT-LAYER.md for structure)

---

## 7. Real-time Operations (WebSocket)

### 7.1 Connect to Session Stream

```
WebSocket: wss://api.mirrorbreak.io/v1/sessions/{session_id}/stream
```

**Events:**

```json
// Phase transition
{
  "event": "phase_transition",
  "timestamp": "2026-03-04T10:25:00Z",
  "data": {
    "from_phase": 1,
    "to_phase": 2,
    "trigger": "core_questions_completed"
  }
}

// Signal detected
{
  "event": "signal_detected",
  "timestamp": "2026-03-04T10:30:00Z",
  "data": {
    "signal_id": "sig_015",
    "type": "emotional_marker",
    "target_fields": ["attachment_pattern"]
  }
}

// Hypothesis update
{
  "event": "hypothesis_update",
  "timestamp": "2026-03-04T10:35:00Z",
  "data": {
    "field": "attachment_pattern",
    "hypothesis_id": "hyp_001",
    "previous_weight": 0.52,
    "current_weight": 0.68
  }
}

// Probe recommendation
{
  "event": "probe_recommendation",
  "timestamp": "2026-03-04T10:45:00Z",
  "data": {
    "probe_id": "prb_003",
    "target_field": "attachment_pattern",
    "question": "...",
    "rationale": "..."
  }
}
```

---

## 8. Error Handling

### Standard Error Format

```json
{
  "error": {
    "code": "SAFETY_CHECK_FAILED",
    "message": "Session aborted: Subject readiness score below threshold",
    "details": {
      "readiness_score": 4,
      "threshold": 5,
      "abort_reason": "insufficient_stability"
    },
    "timestamp": "2026-03-04T10:05:00Z"
  }
}
```

### Error Codes

| Code | HTTP Status | Description |
|------|-------------|-------------|
| `SESSION_NOT_FOUND` | 404 | Session ID does not exist |
| `INVALID_PHASE` | 400 | Phase number invalid for current state |
| `SAFETY_CHECK_FAILED` | 403 | Phase 0 did not pass |
| `PROCESSING_IN_PROGRESS` | 409 | Previous operation still processing |
| `INSUFFICIENT_DATA` | 422 | Not enough evidence for requested operation |
| `RATE_LIMIT_EXCEEDED` | 429 | Too many requests |
| `INTERNAL_ERROR` | 500 | Server error |

---

## 9. Rate Limits

| Endpoint | Limit |
|----------|-------|
| `POST /sessions` | 10/minute |
| `POST /sessions/{id}/phase/*/execute` | 30/minute |
| `POST /sessions/{id}/probes/generate` | 60/minute |
| `GET /sessions/{id}` | 120/minute |
| WebSocket | 1 connection/session |

---

*API Specification v1.0 — Dr. Zemetia Research × Architect-Zero*
*MirrorBreak Protocol: System Implementation Plan*
