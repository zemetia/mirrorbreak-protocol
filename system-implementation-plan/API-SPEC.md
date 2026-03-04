# MBP API Specification

**RESTful API for MirrorBreak Protocol System**

---

## Base URL

```
Production: https://api.mirrorbreak.io/v1
Development: http://localhost:8000/v1
```

## Authentication

```http
Authorization: Bearer {api_key}
X-Client-Version: 1.0.0
```

---

## Endpoints

### Sessions

#### Create Session
```http
POST /sessions
```

**Request:**
```json
{
  "subject_id": "uuid",
  "analyst_id": "uuid",
  "metadata": {
    "cultural_context": "ID",
    "language": "id",
    "session_format": "text"
  }
}
```

**Response:**
```json
{
  "session_id": "uuid",
  "status": "pending",
  "created_at": "2026-03-04T08:30:00Z",
  "next_phase": 0
}
```

#### Get Session
```http
GET /sessions/{session_id}
```

**Response:**
```json
{
  "session_id": "uuid",
  "status": "active",
  "current_phase": 2,
  "safety_status": "cleared",
  "fields": [...],
  "checkpoint": {...},
  "created_at": "...",
  "updated_at": "..."
}
```

#### Update Session Status
```http
PATCH /sessions/{session_id}
```

**Request:**
```json
{
  "status": "paused",
  "checkpoint": {
    "last_phase": 2,
    "can_resume": true
  }
}
```

---

### Safety Checks

#### Submit Safety Check
```http
POST /sessions/{session_id}/safety
```

**Request:**
```json
{
  "readiness_score": 8,
  "stress_level": 3,
  "support_system": "strong",
  "screening_questions": [
    {"question_id": "SQ-001", "response": false, "flag": false}
  ],
  "decision": "proceed"
}
```

**Response:**
```json
{
  "safety_check_id": "uuid",
  "decision": "proceed",
  "next_phase": 1
}
```

---

### Evidence

#### Submit Evidence
```http
POST /sessions/{session_id}/evidence
```

**Request:**
```json
{
  "source": {
    "type": "transcript",
    "phase": 2,
    "timestamp": "2026-03-04T08:45:00Z"
  },
  "transcript": [
    {"speaker": "analyst", "text": "Tell me about..."},
    {"speaker": "subject", "text": "I..."}
  ],
  "metadata": {
    "response_time_ms": 4500,
    "word_count": 127
  }
}
```

**Response:**
```json
{
  "evidence_id": "uuid",
  "signals_extracted": 5,
  "fields_detected": ["family_dynamics", "attachment_pattern"],
  "processing_status": "completed"
}
```

#### Get Evidence
```http
GET /sessions/{session_id}/evidence?field_id={uuid}&limit=50
```

**Response:**
```json
{
  "evidence": [...],
  "total": 47,
  "page": 1
}
```

---

### Fields & Hypotheses

#### List Fields
```http
GET /sessions/{session_id}/fields
```

**Response:**
```json
{
  "fields": [
    {
      "field_id": "uuid",
      "field_name": "family_dynamics",
      "status": "converged",
      "current_confidence": 0.82,
      "hypothesis_count": 3
    }
  ]
}
```

#### Get Field Hypotheses
```http
GET /sessions/{session_id}/fields/{field_id}/hypotheses
```

**Response:**
```json
{
  "field_id": "uuid",
  "field_name": "family_dynamics",
  "hypotheses": [
    {
      "hypothesis_id": "uuid",
      "hypothesis_text": "...",
      "posterior_weight": 0.75,
      "confidence_interval": [0.68, 0.82],
      "status": "active"
    }
  ],
  "convergence_status": "converged"
}
```

#### Trigger Hypothesis Refinement
```http
POST /sessions/{session_id}/fields/{field_id}/refine
```

**Request:**
```json
{
  "evidence_ids": ["ev_001", "ev_002"]
}
```

**Response:**
```json
{
  "refinement_completed": true,
  "updated_hypotheses": [...],
  "convergence_status": {...}
}
```

---

### Questions

#### Generate Question
```http
POST /sessions/{session_id}/questions/generate
```

**Request:**
```json
{
  "target_field_ids": ["uuid"],
  "probe_type": "auto"
}
```

**Response:**
```json
{
  "question_id": "uuid",
  "question_text": "Tell me about a time...",
  "probe_type": "devils_advocate",
  "target_fields": ["family_dynamics"],
  "difficulty": "medium",
  "fallback_question": "Have you ever..."
}
```

#### Get Question
```http
GET /sessions/{session_id}/questions/{question_id}
```

---

### Assessment

#### Trigger 12D Assessment
```http
POST /sessions/{session_id}/assess
```

**Response:**
```json
{
  "assessment_id": "uuid",
  "status": "processing",
  "estimated_completion": "30s"
}
```

#### Get 12D Matrix
```http
GET /sessions/{session_id}/matrix
```

**Response:**
```json
{
  "matrix_id": "uuid",
  "dimensions": {
    "AB": {"score": 7.5, "confidence_interval": [6.8, 8.2]},
    "CDI": {"score": 6.8, "confidence_interval": [6.0, 7.6]},
    ...
  },
  "cross_interactions": [...],
  "overall_confidence": 0.79
}
```

---

### Synthesis

#### Generate Final Profile
```http
POST /sessions/{session_id}/synthesize
```

**Response:**
```json
{
  "profile_id": "uuid",
  "status": "processing",
  "estimated_completion": "60s"
}
```

#### Get Final Profile
```http
GET /sessions/{session_id}/profile
```

**Response:**
```json
{
  "profile_id": "uuid",
  "executive_summary": "...",
  "core_structure": {...},
  "cognitive_map": {...},
  "emotional_architecture": {...},
  "relational_dynamics": {...},
  "persona_core_gap": {...},
  "adaptation_potensi_chain": [...],
  "growth_vectors": [...],
  "assessment_quality": {...}
}
```

---

### WebSocket (Real-time)

#### Connect to Session Stream
```javascript
ws://api.mirrorbreak.io/v1/sessions/{session_id}/stream
```

**Messages:**
```json
// Server → Client
{
  "type": "phase_change",
  "data": {"from": 1, "to": 2}
}

{
  "type": "hypothesis_update",
  "data": {"field_id": "uuid", "confidence": 0.75}
}

{
  "type": "question_ready",
  "data": {"question_id": "uuid", "text": "..."}
}

{
  "type": "safety_flag",
  "data": {"level": "monitoring", "reason": "..."}
}
```

---

## Error Handling

### Status Codes

| Code | Meaning | Usage |
|------|---------|-------|
| 200 | OK | Success |
| 201 | Created | Resource created |
| 400 | Bad Request | Invalid input |
| 401 | Unauthorized | Missing/invalid API key |
| 403 | Forbidden | Insufficient permissions |
| 404 | Not Found | Resource doesn't exist |
| 409 | Conflict | State conflict (e.g., wrong phase) |
| 422 | Unprocessable | Validation failed |
| 429 | Rate Limited | Too many requests |
| 500 | Server Error | Internal error |

### Error Response

```json
{
  "error": {
    "code": "INVALID_PHASE_TRANSITION",
    "message": "Cannot transition from phase 0 to phase 2",
    "details": {
      "current_phase": 0,
      "requested_phase": 2,
      "allowed_transitions": [1]
    }
  }
}
```

---

## Rate Limits

| Endpoint | Limit |
|----------|-------|
| POST /sessions | 10/minute |
| POST /evidence | 60/minute |
| GET /matrix | 30/minute |
| WebSocket | 1 connection/session |

---

## Pagination

```http
GET /sessions/{id}/evidence?page=2&limit=25
```

**Response:**
```json
{
  "data": [...],
  "pagination": {
    "page": 2,
    "limit": 25,
    "total": 47,
    "has_more": true
  }
}
```

---

*API Specification v1.0 — System Implementation Plan*
