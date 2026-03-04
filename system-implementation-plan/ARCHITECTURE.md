# MBP System Architecture

**MirrorBreak Protocol — Technical System Blueprint**

---

## 1. System Overview

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                         MBP SYSTEM ARCHITECTURE                              │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  ┌──────────────┐    ┌──────────────┐    ┌──────────────┐    ┌───────────┐  │
│  │   CLIENT     │───▶│   API GATEWAY │───▶│   ORCHESTRATOR│───▶│  AGENTS   │  │
│  │  (Web/App)   │◀───│   (Auth/Rate) │◀───│   (State Mgr) │◀───│  (6 Layer)│  │
│  └──────────────┘    └──────────────┘    └──────────────┘    └───────────┘  │
│         │                                            │                       │
│         ▼                                            ▼                       │
│  ┌──────────────┐                         ┌──────────────────────┐          │
│  │  DATABASE    │                         │   EVIDENCE STORE     │          │
│  │  (PostgreSQL)│                         │   (Vector + Graph)   │          │
│  └──────────────┘                         └──────────────────────┘          │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## 2. Component Architecture

### 2.1 Agent Layer (6 Specialized Agents)

```
                    ┌─────────────────┐
                    │   SESSION INIT  │
                    └────────┬────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────────────┐
│                         AGENT PIPELINE                               │
├─────────────────────────────────────────────────────────────────────┤
│                                                                      │
│  Phase 0          Phase 1         Phase 2         Phase 3           │
│  ┌──────┐        ┌──────┐        ┌──────┐        ┌──────┐           │
│  │SAFETY│───────▶│ANALYZ│───────▶│HYPMAK│───────▶│HYPRFN│           │
│  │CHECK │        │  ER  │        │  ER  │        │  ER  │           │
│  └──────┘        └──────┘        └──────┘        └──────┘           │
│     │               │               │               │                │
│     ▼               ▼               ▼               ▼                │
│  ┌──────┐        ┌──────┐        ┌──────┐        ┌──────┐           │
│  │Safety│        │Signal│        │Field │        │Bayes │           │
│  │Result│        │Tags  │        │Hypoth│        │Update│           │
│  └──────┘        └──────┘        └──────┘        └──────┘           │
│                                                       │               │
│  Phase 4          Phase 5         Phase 6             │               │
│  ┌──────┐        ┌──────┐        ┌──────┐            │               │
│  │ASSESS│◀───────│SYNTHS│◀───────│CLOSUR│◀───────────┘               │
│  │  OR  │        │  IZER│        │  E   │                              │
│  └──────┘        └──────┘        └──────┘                              │
│     │               │               │                                 │
│     ▼               ▼               ▼                                 │
│  ┌──────┐        ┌──────┐        ┌──────┐                             │
│  │12D   │        │Final │        │Ground│                             │
│  │Matrix│        │Profil│        │ing   │                             │
│  └──────┘        └──────┘        └──────┘                             │
│                                                                      │
└─────────────────────────────────────────────────────────────────────┘
```

### 2.2 Agent Responsibilities

| Agent | Input | Output | Core Function |
|-------|-------|--------|---------------|
| **Analyzer** | Raw transcript, audio cues, metadata | Tagged signals (emotional, cognitive, behavioral) | Pattern recognition, feature extraction |
| **HypothesisMaker** | Signals per field | 3+ competing hypotheses with priors | Generate diverse structural interpretations |
| **HypothesisRefiner** | Hypotheses + new evidence | Updated weights, refined descriptions | Bayesian updating, specificity enhancement |
| **QuestionMaker** | Confidence deficits per field | Contextual probes | Strategic information acquisition |
| **Assessor** | All field data, contradictions | 12D Matrix scores + CI | Quantified structural mapping |
| **Synthesizer** | Complete field profiles | Final Structural Profile | Cross-field integration, gap analysis |

---

## 3. Data Flow Architecture

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                           DATA FLOW LAYERS                                   │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│ LAYER 1: RAW CAPTURE                    LAYER 2: SIGNAL EXTRACTION          │
│ ┌─────────────────────┐                 ┌─────────────────────┐              │
│ │ • Transcript text   │───────────────▶│ • Emotional tags    │              │
│ │ • Audio features    │                 │ • Cognitive markers │              │
│ │ • Response times    │                 │ • Behavioral cues   │              │
│ │ • Engagement score  │                 │ • Contradictions    │              │
│ └─────────────────────┘                 └─────────────────────┘              │
│           │                                        │                         │
│           ▼                                        ▼                         │
│ LAYER 3: HYPOTHESIS REGISTRY            LAYER 4: MATRIX SYNTHESIS           │
│ ┌─────────────────────┐                 ┌─────────────────────┐              │
│ │ • Field definitions │───────────────▶│ • 12D scores        │              │
│ │ • Hypothesis states │                 │ • Confidence intervals│            │
│ │ • Evidence links    │                 │ • Cross-patterns    │              │
│ │ • Confidence history│                 │ • Gap mapping       │              │
│ └─────────────────────┘                 └─────────────────────┘              │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## 4. State Management

### 4.1 Session State Machine

```
                    ┌─────────────┐
         ┌─────────▶│   INITIAL   │
         │          └──────┬──────┘
         │                 │ Init
         │                 ▼
         │          ┌─────────────┐     Safety fail
         │    ┌────│  PHASE_0    │────────────────▶┌─────────┐
         │    │    │   SAFETY    │                 │  ABORT  │
         │    │    └──────┬──────┘                 └─────────┘
         │    │           │ Pass
         │    │           ▼
         │    │    ┌─────────────┐
         │    │    │  PHASE_1    │◀────────────────────────┐
         │    │    │    CORE     │                         │
         │    │    └──────┬──────┘                         │
         │    │           │                                 │
         │    │           ▼                                 │
         │    │    ┌─────────────┐     Confidence ▀ 0.7   │
         │    └───▶│  PHASE_2    │─────────────────────────┤
         │         │   PROBING   │                         │
         │         └──────┬──────┘                         │
         │                │ Confidence ≥ 0.7              │
         │                ▼                                 │
         │         ┌─────────────┐                         │
         │         │  PHASE_3    │                         │
         │         │   MINING    │                         │
         │         └──────┬──────┘                         │
         │                │                                 │
         │                ▼                                 │
         │         ┌─────────────┐                         │
         │         │  PHASE_4    │                         │
         │         │ VALIDATION  │                         │
         │         └──────┬──────┘                         │
         │                │                                 │
         │                ▼                                 │
         │         ┌─────────────┐                         │
         │         │  PHASE_5    │                         │
         └─────────│  SYNTHESIS  │                         │
                   └──────┬──────┘                         │
                          │                                 │
                          ▼                                 │
                   ┌─────────────┐                         │
                   │  PHASE_6    │─────────────────────────┘
                   │   CLOSURE   │     (Complete loop)
                   └─────────────┘
```

### 4.2 Checkpoint Strategy

Every phase completion creates immutable checkpoint:
```json
{
  "checkpoint_id": "uuid",
  "session_id": "uuid",
  "phase": "PHASE_2",
  "timestamp": "ISO8601",
  "state_hash": "sha256",
  "rollback_available": true
}
```

---

## 5. Security & Safety Architecture

### 5.1 Safety Gates

```
PHASE 0 (SAFETY CHECK)
│
├─▶ Readiness Score < 5 ──────▶ ABORT (refer to support)
├─▶ Acute distress detected ──▶ ABORT (immediate grounding)
├─▶ Dissociation signs ───────▶ PAUSE (stabilization protocol)
└─▶ Pass ─────────────────────▶ PROCEED
```

### 5.2 Data Protection

- End-to-end encryption for session data
- No raw audio storage (transient processing only)
- PII pseudonymization
- Audit logging for all assessments

---

## 6. Scalability Considerations

| Component | Scaling Strategy |
|-----------|------------------|
| API Gateway | Horizontal + Load balancer |
| Agents | Queue-based (Redis/RabbitMQ) |
| Database | Read replicas + Connection pooling |
| Vector Store | Sharding by session ID |

---

## 7. Integration Points

```
┌─────────────────────────────────────────────────────────────┐
│                     EXTERNAL INTEGRATIONS                    │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐       │
│  │   OpenAI     │  │  Anthropic   │  │   Local LLM  │       │
│  │   (GPT-4)    │  │  (Claude)    │  │   (Llama)    │       │
│  └──────────────┘  └──────────────┘  └──────────────┘       │
│         │                │                │                 │
│         └────────────────┼────────────────┘                 │
│                          ▼                                  │
│                  ┌──────────────┐                           │
│                  │  LLM Router  │                           │
│                  │ (Failover)   │                           │
│                  └──────────────┘                           │
│                          │                                  │
│                          ▼                                  │
│                  ┌──────────────┐                           │
│                  │    AGENTS    │                           │
│                  └──────────────┘                           │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

*Architecture v1.0 — Dr. Zemetia Research × Architect-Zero*
*MirrorBreak Protocol: System Implementation Plan*
