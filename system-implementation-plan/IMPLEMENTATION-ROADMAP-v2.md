# MBP v2 Implementation Roadmap

## Phase 1: Foundation (Week 1-2)

### 1.1 Core Infrastructure
- [ ] Set up new project structure in `/backend-v2/`
- [ ] Create base agent class with standardized I/O
- [ ] Implement shared state management (Redis/SQLite)
- [ ] Set up agent registry and orchestrator

### 1.2 Base Agent Implementation
```python
# Base class for all agents
class MBPAgent(ABC):
    def __init__(self, name: str, model: str, temperature: float):
        self.name = name
        self.llm = get_llm(model, temperature)
    
    @abstractmethod
    async def process(self, state: AgentState) -> AgentOutput:
        pass
    
    async def execute(self, state: AgentState) -> AgentOutput:
        # Add timing, logging, error handling
        with NodeTimer(self.name):
            return await self.process(state)
```

---

## Phase 2: Extraction Layer (Week 3)

### 2.1 Parallel Extractors
Implement 4 extractors that run in parallel:

```python
async def run_extraction_layer(state: MBPState):
    # Run all extractors in parallel
    results = await asyncio.gather(
        linguistic_extractor.process(state),
        emotional_extractor.process(state),
        cognitive_extractor.process(state),
        behavioral_extractor.process(state)
    )
    
    # Merge results
    return {
        "linguistic": results[0],
        "emotional": results[1],
        "cognitive": results[2],
        "behavioral": results[3]
    }
```

### 2.2 Prompt Templates
Create focused prompts for each extractor:
- `prompts/extractors/linguistic.md`
- `prompts/extractors/emotional.md`
- `prompts/extractors/cognitive.md`
- `prompts/extractors/behavioral.md`

---

## Phase 3: Hypothesis Layer (Week 4)

### 3.1 Per-Field Hypothesis Generators
Implement 5 parallel hypothesis generators:

```python
HYPOTHESIS_FIELDS = [
    "attachment",
    "cognitive", 
    "emotional",
    "relational",
    "defense"
]

async def run_hypothesis_layer(patterns: dict):
    generators = [HGenAgent(field) for field in HYPOTHESIS_FIELDS]
    
    # Run all generators in parallel
    results = await asyncio.gather(
        *[gen.process(patterns) for gen in generators]
    )
    
    return {field: result for field, result in zip(HYPOTHESIS_FIELDS, results)}
```

### 3.2 Evidence Evaluator
Bayesian update system for hypothesis refinement.

---

## Phase 4: Validation & Probe Layers (Week 5)

### 4.1 Validation Agents
- ContradictionDetector
- GapAnalyzer
- EvidenceEvaluator

### 4.2 Probe Design System
- ProbeDesigner (creates questions)
- ProbeSelector (chooses optimal)
- ProbeStrategy (manages question types)

---

## Phase 5: Assessment Layer (Week 6)

### 5.1 12D Matrix System
- TensionMapper (cross-dimension analysis)
- MatrixPositioner (scoring)
- Validator (quality check)

### 5.2 Profile Generation
- ProfileComposer (structural integration)
- Explainer (user-friendly output)

---

## Phase 6: Integration & Testing (Week 7-8)

### 6.1 LangGraph Integration
```python
from langgraph.graph import StateGraph

builder = StateGraph(MBPState)

# Add nodes
builder.add_node("intake", intake_agent)
builder.add_node("extract_parallel", run_extraction_layer)
builder.add_node("synthesize", pattern_synthesizer)
builder.add_node("hypothesize_parallel", run_hypothesis_layer)
builder.add_node("validate", validation_layer)
builder.add_node("probe", probe_layer)
builder.add_node("assess", assessment_layer)
builder.add_node("compose", profile_composer)

# Add edges
builder.add_edge(START, "intake")
builder.add_conditional_edges("intake", route_safety)
builder.add_edge("extract_parallel", "synthesize")
builder.add_edge("synthesize", "hypothesize_parallel")
builder.add_conditional_edges("validate", route_confidence)
```

### 6.2 Testing Strategy
- Unit tests per agent
- Integration tests per layer
- End-to-end flow tests
- Performance benchmarks

---

## File Structure

```
backend-v2/
├── agents/
│   ├── base.py              # Base agent class
│   ├── intake.py            # IntakeAgent
│   ├── extractors/          # 4 extractors
│   │   ├── linguistic.py
│   │   ├── emotional.py
│   │   ├── cognitive.py
│   │   └── behavioral.py
│   ├── synthesis.py         # PatternSynthesizer, Contextualizer
│   ├── hypothesis/          # 5 HGen agents
│   │   ├── attachment.py
│   │   ├── cognitive.py
│   │   ├── emotional.py
│   │   ├── relational.py
│   │   └── defense.py
│   ├── validation.py        # EvidenceEvaluator, ContradictionDetector, GapAnalyzer
│   ├── probes.py            # ProbeDesigner, ProbeSelector
│   ├── assessment.py        # TensionMapper, MatrixPositioner, Validator
│   └── output.py            # ProfileComposer, Explainer
├── graph/
│   ├── state.py             # MBPState definition
│   ├── nodes.py             # Node wrappers
│   └── edges.py             # Routing logic
├── prompts/
│   ├── extractors/          # Extractor prompts
│   ├── hypothesis/          # HGen prompts
│   ├── validation/          # Validation prompts
│   ├── probes/              # Probe prompts
│   └── assessment/          # Assessment prompts
├── core/
│   ├── config.py            # Configuration
│   ├── llm.py               # LLM setup
│   ├── state_manager.py     # State persistence
│   └── orchestrator.py      # Agent orchestration
├── tests/
│   ├── unit/                # Unit tests
│   ├── integration/         # Integration tests
│   └── e2e/                 # End-to-end tests
└── api/
    └── main.py              # FastAPI app
```

---

## Performance Targets

| Metric | v1 (Current) | v2 (Target) |
|--------|--------------|-------------|
| Single Turn Time | 2-3 minutes | 30-45 seconds |
| Parallel Agents | 0 | 9+ |
| Total Agents | 6 | 14+ |
| Avg Prompt Size | ~2000 tokens | ~800 tokens |

---

## Key Decisions

1. **Parallel over Sequential**: Run extractors & hypothesis generators in parallel
2. **Small over Large**: Smaller, focused prompts vs large monolithic ones
3. **Specialized over Generalized**: One agent = one task
4. **Collaborative over Independent**: Agents share state and build on each other

---

*Implementation Roadmap v1.0 - Modular MBP System*
