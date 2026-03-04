# MBP Agent Architecture v2.0 - Modular Collaborative System

## Overview

Sistem baru dengan **14+ specialized agents** yang bekerja kolaboratif, bukan sequential overload. Setiap agent punya 1-2 tugas spesifik dan berkomunikasi via shared state.

## Core Philosophy

```
Old: 6 Agents → Each does everything → Bottleneck
New: 14+ Agents → Each does one thing well → Parallel + Collaborative
```

---

## Agent Network Diagram

```mermaid
graph TB
    subgraph InputLayer["📥 Input Layer"]
        INT[IntakeAgent<br/>Safety & Context]
    end

    subgraph ExtractionLayer["🔍 Extraction Layer - Parallel"]
        LSE[LinguisticExtractor<br/>Patterns & Markers]
        ESE[EmotionalExtractor<br/>Affect & Granularity]
        CSE[CognitiveExtractor<br/>Processing Style]
        BSE[BehavioralExtractor<br/>Engagement Cues]
    end

    subgraph SynthesisLayer["🧩 Synthesis Layer"]
        PSG[PatternSynthesizer<br/>Cross-Signal Integration]
        CTX[Contextualizer<br/>Cultural & Temporal Context]
    end

    subgraph HypothesisLayer["💡 Hypothesis Layer - Per Field"]
        HGA[HGen-Attachment]
        HGC[HGen-Cognitive]
        HGE[HGen-Emotional]
        HGR[HGen-Relational]
        HGD[HGen-Defense]
    end

    subgraph ValidationLayer["⚖️ Validation Layer"]
        EVE[EvidenceEvaluator<br/>Bayesian Update]
        CND[ContradictionDetector<br/>Inconsistency Logger]
        GAP[GapAnalyzer<br/>Confidence Deficits]
    end

    subgraph ProbeLayer["❓ Probe Layer"]
        PDS[ProbeDesigner<br/>Question Generation]
        PSS[ProbeSelector<br/>Strategy Optimization]
    end

    subgraph AssessmentLayer["📊 Assessment Layer"]
        TNM[TensionMapper<br/>Cross-Dimension Tensions]
        M12[MatrixPositioner<br/>12D Scoring]
        VAL[Validator<br/>Quality Check]
    end

    subgraph OutputLayer["📤 Output Layer"]
        PCO[ProfileComposer<br/>Final Integration]
        EXP[Explainer<br/>User-Friendly Report]
    end

    %% Flow Connections
    INT --> LSE & ESE & CSE & BSE
    
    LSE & ESE & CSE & BSE --> PSG
    PSG --> CTX
    CTX --> HGA & HGC & HGE & HGR & HGD
    
    HGA & HGC & HGE & HGR & HGD --> EVE
    EVE --> CND
    CND --> GAP
    
    GAP --> PDS
    PDS --> PSS
    PSS -.->|New Data| INT
    
    EVE --> TNM
    TNM --> M12
    M12 --> VAL
    VAL --> PCO
    PCO --> EXP
```

---

## State Flow Architecture

```mermaid
stateDiagram-v2
    [*] --> Intake : User Input
    
    Intake --> ParallelExtraction : Safety Clear
    Intake --> [*] : Crisis Detected
    
    ParallelExtraction --> SignalSynthesis : All Extractors Complete
    
    SignalSynthesis --> HypothesisGeneration : Patterns Detected
    
    HypothesisGeneration --> EvidenceValidation : Hypotheses Ready
    
    EvidenceValidation --> GapAnalysis : Validation Complete
    
    GapAnalysis --> ProbeDesign : Low Confidence Fields
    GapAnalysis --> TensionMapping : Confidence Threshold Met
    
    ProbeDesign --> [*] : Return Question
    
    TensionMapping --> MatrixPositioning : Tensions Mapped
    
    MatrixPositioning --> QualityValidation : Matrix Complete
    
    QualityValidation --> ProfileComposition : Quality Pass
    QualityValidation --> GapAnalysis : Quality Fail
    
    ProfileComposition --> [*] : Final Profile
```

---

## Agent Specifications

### Layer 1: Input

#### 1. IntakeAgent
```yaml
Responsibility: Initial safety screening & session setup
Input:
  - user_message: string
  - session_context: object
Output:
  - safety_cleared: boolean
  - crisis_flags: array
  - initial_context: object
  - routing_decision: "proceed" | "halt" | "escalate"
Model: gpt-4 / kimi-k2.5
Temperature: 0.1
```

### Layer 2: Extraction (Parallel)

#### 2. LinguisticExtractor
```yaml
Responsibility: Extract linguistic patterns only
Input:
  - transcript: array
Output:
  - absolutes: array
  - qualifiers: array
  - evasion_markers: array
  - temporal_references: array
  - meta_talk: array
Model: gpt-4
Temperature: 0.2
```

#### 3. EmotionalExtractor
```yaml
Responsibility: Extract emotional markers only
Input:
  - transcript: array
Output:
  - explicit_affects: array
  - implicit_emotions: array
  - granularity_indicators: array
  - regulation_attempts: array
Model: gpt-4
Temperature: 0.2
```

#### 4. CognitiveExtractor
```yaml
Responsibility: Extract cognitive processing patterns
Input:
  - transcript: array
Output:
  - abstraction_level: score
  - causal_complexity: score
  - processing_speed_indicators: array
  - bias_patterns: array
Model: gpt-4
Temperature: 0.2
```

#### 5. BehavioralExtractor
```yaml
Responsibility: Extract behavioral/engagement cues
Input:
  - transcript: array
  - metadata: object (response times, etc)
Output:
  - engagement_patterns: array
  - avoidance_indicators: array
  - pause_patterns: array
  - topic_shift_frequency: number
Model: gpt-4
Temperature: 0.2
```

### Layer 3: Synthesis

#### 6. PatternSynthesizer
```yaml
Responsibility: Merge signals from all extractors into unified patterns
Input:
  - linguistic_signals: array
  - emotional_signals: array
  - cognitive_signals: array
  - behavioral_signals: array
Output:
  - unified_patterns: array
  - pattern_confidences: object
  - cross_domain_correlations: array
Model: gpt-4
Temperature: 0.3
```

#### 7. Contextualizer
```yaml
Responsibility: Add cultural and temporal context to patterns
Input:
  - patterns: array
  - user_context: object
Output:
  - contextualized_patterns: array
  - cultural_adjustments: array
Model: gpt-4
Temperature: 0.3
```

### Layer 4: Hypothesis Generation (Per Field)

#### 8. HGen-Attachment
```yaml
Responsibility: Generate attachment-related hypotheses only
Input:
  - contextualized_patterns: array
Output:
  - attachment_hypotheses: array (3-5)
Model: gpt-4
Temperature: 0.7
```

#### 9. HGen-Cognitive
```yaml
Responsibility: Generate cognitive structure hypotheses only
Input:
  - contextualized_patterns: array
Output:
  - cognitive_hypotheses: array (3-5)
Model: gpt-4
Temperature: 0.7
```

#### 10. HGen-Emotional
```yaml
Responsibility: Generate emotional architecture hypotheses only
Input:
  - contextualized_patterns: array
Output:
  - emotional_hypotheses: array (3-5)
Model: gpt-4
Temperature: 0.7
```

#### 11. HGen-Relational
```yaml
Responsibility: Generate power dynamics & relational hypotheses
Input:
  - contextualized_patterns: array
Output:
  - relational_hypotheses: array (3-5)
Model: gpt-4
Temperature: 0.7
```

#### 12. HGen-Defense
```yaml
Responsibility: Generate defense mechanism hypotheses
Input:
  - contextualized_patterns: array
Output:
  - defense_hypotheses: array (3-5)
Model: gpt-4
Temperature: 0.7
```

### Layer 5: Validation

#### 13. EvidenceEvaluator
```yaml
Responsibility: Bayesian update of all hypotheses
Input:
  - all_hypotheses: object (by field)
  - new_evidence: array
Output:
  - updated_hypotheses: object
  - confidence_changes: object
  - evidence_registry: array
Model: gpt-4
Temperature: 0.3
```

#### 14. ContradictionDetector
```yaml
Responsibility: Find and log inconsistencies
Input:
  - updated_hypotheses: object
  - evidence_registry: array
Output:
  - contradictions: array
  - tension_pairs: array
  - unexplained_variance: array
Model: gpt-4
Temperature: 0.2
```

#### 15. GapAnalyzer
```yaml
Responsibility: Identify confidence deficits per field
Input:
  - updated_hypotheses: object
  - contradictions: array
Output:
  - low_confidence_fields: array
  - information_gaps: array
  - probe_priorities: array
Model: gpt-4
Temperature: 0.2
```

### Layer 6: Probe Design

#### 16. ProbeDesigner
```yaml
Responsibility: Create questions for specific gaps
Input:
  - information_gaps: array
  - target_hypotheses: array
Output:
  - candidate_probes: array
  - probe_rationales: array
Model: gpt-4
Temperature: 0.5
```

#### 17. ProbeSelector
```yaml
Responsibility: Select optimal probe strategy
Input:
  - candidate_probes: array
  - session_history: array
Output:
  - selected_probe: object
  - fallback_probes: array
  - strategy_notes: string
Model: gpt-4
Temperature: 0.4
```

### Layer 7: Assessment

#### 18. TensionMapper
```yaml
Responsibility: Map cross-dimension tensions
Input:
  - updated_hypotheses: object
  - contradictions: array
Output:
  - tension_network: array
  - persona_core_gaps: array
Model: gpt-4
Temperature: 0.3
```

#### 19. MatrixPositioner
```yaml
Responsibility: Generate 12D matrix positions
Input:
  - updated_hypotheses: object
  - tension_network: array
Output:
  - matrix_12d: object
  - position_confidences: object
  - supporting_evidence: object
Model: gpt-4
Temperature: 0.2
```

#### 20. Validator
```yaml
Responsibility: Quality check final assessment
Input:
  - matrix_12d: object
  - supporting_evidence: object
Output:
  - quality_score: number
  - validation_notes: array
  - needs_reassessment: boolean
Model: gpt-4
Temperature: 0.1
```

### Layer 8: Output

#### 21. ProfileComposer
```yaml
Responsibility: Integrate all data into final profile
Input:
  - matrix_12d: object
  - tension_network: array
  - evidence_registry: array
Output:
  - final_profile: object
  - core_structure: object
  - adaptation_chains: array
Model: gpt-4
Temperature: 0.4
```

#### 22. Explainer
```yaml
Responsibility: Generate user-friendly explanation
Input:
  - final_profile: object
Output:
  - executive_summary: string
  - user_report: object
  - recommendations: array
Model: gpt-4
Temperature: 0.5
```

---

## Collaboration Patterns

### Pattern 1: Parallel Extraction
```mermaid
sequenceDiagram
    participant O as Orchestrator
    participant L as LinguisticExtractor
    participant E as EmotionalExtractor
    participant C as CognitiveExtractor
    participant B as BehavioralExtractor
    participant P as PatternSynthesizer

    O->>L: Extract(transcript)
    O->>E: Extract(transcript)
    O->>C: Extract(transcript)
    O->>B: Extract(transcript)
    
    par Parallel Processing
        L-->>O: linguistic_signals
        E-->>O: emotional_signals
        C-->>O: cognitive_signals
        B-->>O: behavioral_signals
    end
    
    O->>P: Synthesize(all_signals)
    P-->>O: unified_patterns
```

### Pattern 2: Per-Field Hypothesis Race
```mermaid
sequenceDiagram
    participant O as Orchestrator
    participant HA as HGen-Attachment
    participant HC as HGen-Cognitive
    participant HE as HGen-Emotional
    participant HR as HGen-Relational
    participant HD as HGen-Defense

    O->>HA: Generate(patterns)
    O->>HC: Generate(patterns)
    O->>HE: Generate(patterns)
    O->>HR: Generate(patterns)
    O->>HD: Generate(patterns)

    par Hypothesis Generation
        HA-->>O: attachment_hypotheses
        HC-->>O: cognitive_hypotheses
        HE-->>O: emotional_hypotheses
        HR-->>O: relational_hypotheses
        HD-->>O: defense_hypotheses
    end
```

### Pattern 3: Validation Loop
```mermaid
sequenceDiagram
    participant O as Orchestrator
    participant EV as EvidenceEvaluator
    participant CD as ContradictionDetector
    participant GA as GapAnalyzer
    participant PD as ProbeDesigner
    participant PS as ProbeSelector

    O->>EV: Evaluate(all_hypotheses)
    EV-->>O: updated_hypotheses
    
    O->>CD: DetectContradictions(updated)
    CD-->>O: contradictions
    
    O->>GA: AnalyzeGaps(updated, contradictions)
    GA-->>O: low_confidence_fields
    
    alt Confidence < Threshold
        O->>PD: DesignProbes(gaps)
        PD-->>O: candidate_probes
        O->>PS: SelectProbe(candidates)
        PS-->>O: selected_probe
    else Confidence >= Threshold
        O->>O: Proceed to Assessment
    end
```

---

## Implementation Benefits

### Performance
- **Parallel Extraction**: 4 extractors run simultaneously → ~4x speedup
- **Per-Field Hypothesis**: 5 generators in parallel → ~5x speedup
- **Focused Agents**: Smaller prompts → faster inference

### Quality
- **Specialization**: Each agent optimized for specific task
- **Collaboration**: Cross-validation between agents
- **Debugging**: Easy to isolate issues per agent

### Maintainability
- **Modularity**: Add/remove agents without breaking flow
- **Testing**: Unit test each agent independently
- **Scaling**: Scale individual agents based on load

---

## Migration from v1 to v2

### Phase 1: Extractor Layer
- Split Analyzer into 4 extractors
- Add PatternSynthesizer
- Keep v1 agents as fallback

### Phase 2: Hypothesis Layer
- Split HypothesisMaker into per-field agents
- Add EvidenceEvaluator
- Add ContradictionDetector

### Phase 3: Assessment Layer
- Add TensionMapper
- Split Assessor into MatrixPositioner + Validator

### Phase 4: Output Layer
- Add Explainer
- Refine ProfileComposer

---

*MBP Agent Architecture v2.0 - Modular Collaborative Design*
*Dr. Zemetia Research Division*
