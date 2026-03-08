# MirrorBreak Protocol v3.1 — AI Agent Question Generation Framework

**Empirical Pattern Deconstruction Model (EPDM)**

Dokumen ini adalah **framework untuk AI agent** generate pertanyaan. Bukan template pertanyaan fixed, tapi **instruction set** untuk AI membuat pertanyaan berdasarkan hipotesis dan konteks.

---

## AI Agent Architecture

```
Input Layer:
├── Current Hypothesis Registry (per 12D field)
├── Response History (transcript + tagged signals)
├── Confidence Scores (per dimension)
└── Contradiction Log

Processing Layer:
├── Hypothesis Prioritizer (which field needs probing?)
├── Question Generator (this document)
└── Safety Monitor (trauma/crisis detection)

Output Layer:
├── Generated Question
├── Target Dimension(s)
└── Expected Response Type
```

---

## Phase 0: Context Gathering (FIXED QUESTIONS)

**Rasio: Fixed 100% | AI Generation 0%**

> **Tujuan:** 7 pertanyaan FIXED untuk semua user. Diberikan berurutan tanpa modifikasi AI. Fungsinya: konteks formasi + rapport baseline.

### Q0.1 — The Atmosphere Probe
> *"Kalau rumah tempat kamu dibesarkan punya 'suara' atau 'vibe', kira-kira suaranya kayak gimana? Bukan kata sifat umum—tapi kayak musik apa, cuaca apa, atau suasana apa?"*

**[12D]:** Family emotional climate, Safety baseline, Unspoken rules

---

### Q0.2 — The Handler Pattern
> *"Waktu ada masalah di keluarga—bukan yang gede-gede, yang sehari-hari aja—siapa yang biasanya 'nyadar duluan' dan nanganin? Bukan yang paling keras, tapi yang paling... duluan bergerak?"*

**[12D]:** Parental modeling, Role assignment genesis, Emotional leadership

---

### Q0.3 — The Unwritten Curriculum
> *"Ada nggak satu 'aturan' yang kamu ikutin sekarang—cara ngomong, cara diam, cara reaksi—yang kamu sadar ternyata nggak diajarin explicitly, tapi kebawa dari kecil? Kayak kebiasaan yang nggak pernah ditulis?"*

**[12D]:** Survival rules, Implicit learning, Pre-conscious patterns

---

### Q0.4 — The Contrast Moment
> *"Ada nggak sesuatu dari keluarga/latar belakang kamu yang waktu kecil kamu anggap 'normal semua orang begini', tapi pas kenal lingkungan lain kamu kayak 'oh, ternyata nggak semua orang punya ini'?"*

**[12D]:** Cultural backdrop, Normalization of patterns, Belief system genesis

---

### Q0.5 — The Support Topology
> *"Kalau ada teman dekat yang lagi collapse dan cerita sama kamu—yang beneran collapse, bukan curhat biasa—kamu biasanya arahin ke orang lain, handle sendiri, atau cara lain?"*

**[12D]:** Support system structure, Help-seeking patterns, Reciprocity style

---

### Q0.6 — The Reflex Archeology
> *"Cara kamu respon ketika kaget, atau ketika ada yang tiba-tiba—itu cara yang sama dari kecil, atau ada masa kamu sadar 'oh, gue sekarang beda'? Kapan bedanya?"*

**[12D]:** Stress response origin, Adaptation timeline, Core stability

---

### Q0.7 — The Permission Slip
> *"Kita bisa pause kapan aja, bisa muter arah, bisa skip yang nggak nyaman. Nggak ada yang harus dijawab—yang penting obrolannya nyaman buat kamu. Oke?"*

**[12D]:** Safety container, Consent embedding, Autonomy validation

---

## Phase 1: Core Pattern Exposure

**AI Objective:** Extract multi-layered data through indirect storytelling.

### Generation Framework

**Step 1: Read Hypothesis Registry**
```
FOR each 12D dimension:
  IF confidence < 0.6 → Mark for probing
  IF contradiction detected → Mark for validation
  IF gap identified → Mark for mining
```

**Step 2: Select Probe Strategy**

| Gap Type | Strategy | Question Arc |
|----------|----------|--------------|
| Identity ambiguity | Alien Reaction Probe | "Kapan kamu bereaksi dengan cara yang bikin heran 'ini dari mana?'" |
| Compartmentalization | Exception Self Probe | "Kapan orang kenal kamu bilang 'ini nggak kayak kamu biasanya'?" |
| Projection resistance | Mislabel Friction Probe | "Label apa yang paling sering salah tempel ke kamu?" |
| Somatic split | Body Betrayal Probe | "Kapan tubuhmu bereaksi duluan tanpa kamu tahu kenapa?" |
| Emotional unprocessed | Relatable Wound Probe | "Film/lagu apa yang relate-nya ngeselin?" |
| Vulnerability block | Swallowed Truth Probe | "Kapan terakhir ujung-ujungnya ditelen sendiri?" |
| Conflict style | Unwinnable Exit Probe | "Kapan walk away bukan karena selesai tapi unwinnable?" |
| Authority pattern | Power Silence Probe | "Kapan diam padahal nggak setuju dengan yang berkuasa?" |
| Recognition need | Invisible Labor Probe | "Kapan sungguh-sungguh tapi nggak ada yang notice?" |
| Decision regret | Haunting Decision Probe | "Keputusan apa yang masih 'ngantri' di kepala?" |
| Control pattern | Plan's Humor Probe | "Kapan rencana 'waterproof' ketawa oleh realitas?" |
| Emergency mode | Emergency Self Probe | "Krisis mendadak—kamu jadi tipe yang tenang atau panik produktif?" |

**Step 3: Generate Specific Question**

```python
# AI Generation Template
def generate_phase1_question(target_dimension, context_history):
    
    # Select base probe type
    probe_type = select_probe(target_dimension)
    
    # Add context anchor from previous response
    anchor = extract_anchor(context_history)
    
    # Frame as specific moment (not general trait)
    question = f"Kapan terakhir kali {probe_type}... {anchor}?"
    
    # Add follow-up trigger for elaboration
    follow_up = "Bukan jawabannya yang penting—tapi ceritanya. Situasinya kayak gimana?"
    
    return {
        "question": question,
        "target": target_dimension,
        "expected": "narrative_with_somatic_detail"
    }
```

---

## Phase 2: Adaptive Probing (Hypothesis Testing)

**AI Objective:** Test hypotheses without revealing them.

### Input for AI
```
Hypothesis Registry:
├── Field: Relational
│   ├── H1: Suppression pattern (weight: 0.7)
│   ├── H2: People-pleasing origin (weight: 0.5)
│   └── H3: Attachment avoidance (weight: 0.3)
├── Field: Cognitive
│   ├── H1: Binary thinking under stress (weight: 0.6)
│   └── H2: Control illusion (weight: 0.4)
└── [Other fields...]
```

### Generation Rules by Hypothesis Type

**Rule 2.1 — Testing Suppression Pattern**
```
HYPOTHESIS: Subject suppresses emotional expression as adaptation
DIRECT (FORBIDDEN): "Do you suppress your feelings?"
AI GENERATE: "Kapan terakhir kali 'I'm fine' keluar dari mulut padahal sebenarnya nggak?"
FOLLOW-UP: "Apa yang stop kamu untuk bilang 'sebenarnya...'?"
TARGET: RSI, VB, suppression trigger
```

**Rule 2.2 — Testing People-Pleasing**
```
HYPOTHESIS: Subject has people-pleasing as survival strategy
DIRECT (FORBIDDEN): "Are you a people-pleaser?"
AI GENERATE: "Kapan terakhir ngelakuin sesuatu bukan karena mau tapi 'lebih enak kalau begini'?"
FOLLOW-UP: "Apa yang kamu bayangkan kalau nggak begini?"
TARGET: ARP, RS, fear of rejection
```

**Rule 2.3 — Testing Control Need**
```
HYPOTHESIS: Subject uses control as anxiety management
DIRECT (FORBIDDEN): "Do you need control?"
AI GENERATE: "Situasi paling nggak nyaman—yang bikin pengen 'ambil alih' atau freeze?"
FOLLOW-UP: "Apa yang terjadi di tubuh saat itu?"
TARGET: COI, Stress Response
```

**Rule 2.4 — Testing Validation Seeking**
```
HYPOTHESIS: Subject seeks external validation due to unstable self-worth
DIRECT (FORBIDDEN): "Do you need validation?"
AI GENERATE: "Kapan terakhir share sesuatu kecil terus... nunggu? Apa yang kamu tunggu?"
FOLLOW-UP: "Berapa lama 'tunggu'-nya, dan apa yang bikin berhenti nunggu?"
TARGET: RS, ASC (glorified vs genuine)
```

**Rule 2.5 — Testing Perfectionism**
```
HYPOTHESIS: Subject has perfectionism as defense against criticism
DIRECT (FORBIDDEN): "Are you a perfectionist?"
AI GENERATE: "Ada nggak yang ditunda bukan karena males tapi 'belum sempurna'? Berapa lama?"
FOLLOW-UP: "Apa yang harus terjadi biar 'sempurna'?"
TARGET: COI, CRF, fear of failure
```

**Rule 2.6 — Testing Hyper-Independence**
```
HYPOTHESIS: Subject avoids dependency due to past relational hurt
DIRECT (FORBIDDEN): "Do you have trouble asking for help?"
AI GENERATE: "Kapan terakhir beneran minta tolong personal—dan rasanya gimana?"
FOLLOW-UP: "Apa yang lebih berat: hasilnya atau proses minta tolongnya?"
TARGET: VB, ARP, trust structure
```

### Stress Test Generation

**Rule 2.7 — Temporal Contradiction Test**
```
TRIGGER: Subject claims [VALUE/IDENTITY] consistently
AI GENERATE: "Ada nggak advice dulu kamu kasih teman—yang kamu anggap wise—tapi sekarang sadar kamu sendiri nggak lakuin?"
TARGET: Consistency check, ASC legitimacy
```

**Rule 2.8 — Context Switch Test**
```
TRIGGER: Different behavior in different contexts detected
AI GENERATE: "Situasi A vs B—kamu kayak dua orang. Apa bedanya yang bikin respons beda?"
TARGET: Compartmentalization, contextual identity
```

**Rule 2.9 — Value-Behavior Gap Test**
```
TRIGGER: Stated values contradict observed behavior
AI GENERATE: "[VALUE] penting, tapi yang terakhir kamu [BEHAVIOR]. Apa yang lebih kuat dari [VALUE]?"
TARGET: COI, CFV, true priority
```

**Rule 2.10 — Somatic-Cognitive Split Test**
```
TRIGGER: High cognitive claim detected
AI GENERATE: "Pikiranmu bilang [X]—logis. Tapi tubuhmu...? Kalau tubuh bisa ngomong, apa yang dia bilang?"
TARGET: AB × Stress Response, pre-cognitive pattern
```

---

## Phase 3: Deep Trauma & Adaptation Mining

**AI Objective:** Extract survival patterns, trauma responses, and deepest psychological structures.

### Generation Rules by Target Layer

**Rule 3.1 — Pre-Verbal Trauma (Somatic Memory)**
```
LAYER: Pre-cognitive / somatic trauma (before language)
INDICATOR: Unexplained somatic responses
AI GENERATE: "Kapan tubuhmu bereaksi dengan cara yang nggak masuk akal? Takut padahal aman, atau tenang padahal harusnya panik?"
FOLLOW-UP: "Apa yang tubuhmu 'tahu' yang pikiranmu belum kejar?"
TARGET: Pre-verbal trauma, somatic memory, implicit memory
```

**Rule 3.2 — Attachment Wound (Sudden Intimacy)**
```
LAYER: Attachment wound exposure
CONDITION: Rapport confidence > 0.8
AI GENERATE: "Kalau saya bilang—cuma hipotesis—cara kamu [PATTERN] itu proteksi dari [INFERRED_WOUND], reaksi tubuhmu apa?"
FOLLOW-UP: "Bukan jawabannya—tapi apa yang muncul di saat itu?"
TARGET: Attachment wound, defense activation, somatic response
WARNING: Only after strong rapport established
```

**Rule 3.3 — Repetition Compulsion**
```
LAYER: Unconscious pattern repetition
INDICATOR: Similar relationship/job patterns
AI GENERATE: "Ada nggak situasi yang berulang—bukan orangnya, tapi 'feel'-nya? Kayak 'kok familiar' meski beda konteks?"
FOLLOW-UP: "Apa yang sama dari feel-nya?"
TARGET: Trauma reenactment, unconscious pattern
```

**Rule 3.4 — Shame Core Extraction**
```
LAYER: Deepest identity-based shame
INDICATOR: High protection around specific identity aspect
AI GENERATE: "Apa yang paling kamu takutkan kalau orang tahu—bukan yang di-judge, tapi yang bikin kamu 'hilang'?"
FOLLOW-UP: "Hilangnya kayak gimana?"
TARGET: Shame core (I am bad), identity fear
```

**Rule 3.5 — Dissociation Check**
```
LAYER: Dissociative response (trauma severity)
INDICATOR: Memory gaps, numbing, detachment
AI GENERATE: "Pernah nggak 'hilang' dari situasi—bukan pingsan, tapi kayak nonton dari luar? Atau waktu berlalu tapi nggak ingat?"
FOLLOW-UP: "Kapan situasinya, dan apa yang terjadi sebelumnya?"
TARGET: Dissociation severity, trauma accessibility
```

**Rule 3.6 — Therapeutic Alliance Breach (Resistance)**
```
LAYER: Deep resistance exposure
CONDITION: Subject shows consistent avoidance/deflection
AI GENERATE: "Saya notice kamu cerita [X] dengan [Y]—tapi ada yang nggak nyambung. Bukan kamu yang salah—tapi saya nggak ngerti. Bisa bantu?"
FOLLOW-UP: "Apa yang saya lewatkan?"
TARGET: Resistance pattern, hidden material
```

### Standard Deep Mining Rules

**Rule 3.7 — The Forbidden Rules**
```
TARGET: Family system implicit rules
AI GENERATE: "Apa yang 'nggak boleh'—bukan dilarang explicitly, tapi diam-diam nggak dilakuin?"
FOLLOW-UP: "Siapa yang pertama kali 'ngasih tahu' hal ini?"
```

**Rule 3.8 — The Deferred Life**
```
TARGET: Deferred needs, postponed living
AI GENERATE: "Hal apa yang paling sering 'simpan untuk nanti' tapi 'nanti'-nya nggak datang?"
FOLLOW-UP: "Kenapa 'sekarang' bukan waktunya?"
```

**Rule 3.9 — The Protected Core**
```
TARGET: Core self protection
AI GENERATE: "Bagian dirimu apa yang paling di-proteksi—bukan dibanggakan, tapi yang paling 'raw'?"
FOLLOW-UP: "Raw-nya diapa?"
```

**Rule 3.10 — The Pattern Breakdown**
```
TARGET: Coping failure moment
AI GENERATE: "Kapan pola yang biasanya 'works' tiba-tiba nggak works? Apa yang terjadi?"
FOLLOW-UP: "Apa yang kamu sadari tentang diri sendiri di saat itu?"
```

**Rule 3.11 — The Safety Perimeter**
```
TARGET: Trust radius, intimacy capacity
AI GENERATE: "Seberapa dekat orang bisa mendekat sebelum alarm 'jaga-jaga'?"
FOLLOW-UP: "Situasi kayak apa yang pernah bikin alarmnya nggak bunyi?"
```

**Rule 3.12 — The Cost Accounting**
```
TARGET: Adaptation cost, long-term consequence
AI GENERATE: "Cara kamu survive sekarang—ada 'cicilannya' nggak? Apa yang harus dikorbankan?"
FOLLOW-UP: "Berapa lama sudah bayar cicilan ini?"
```

---

## Phase 4: Contradiction Exposure

**AI Objective:** Expose contradictions through innocent curiosity.

### Generation Rules

**Rule 4.1 — Contextual Shift Mirror**
```
INPUT: Contradiction detected between Context A and Context B
AI GENERATE: "Menarik... di [A] kamu [BEHAVIOR_A], tapi di [B] [BEHAVIOR_B]. Apa yang beda yang bikin respons beda?"
TONE: Innocent curiosity, not accusation
TARGET: Compartmentalization, contextual identity
```

**Rule 4.2 — Temporal Evolution Mirror**
```
INPUT: Change detected between past and present self
AI GENERATE: "Ada nggak hal yang dulu 'kamu banget' tapi sekarang sadar itu adaptasi?"
TONE: Reflection invitation
TARGET: ASC legitimacy, identity evolution
```

**Rule 4.3 — Value-Behavior Bridge**
```
INPUT: Stated value contradicts behavior
AI GENERATE: "[VALUE] penting, tapi yang terakhir [BEHAVIOR]. Apa yang lebih kuat dari [VALUE]?"
TONE: Genuine puzzle
TARGET: True priority, hidden value
```

### 12D Tension Pair Generation

**AI Input Format untuk Tension Pair:**
```
USER_DATA:
├── Claimed Identity: [e.g., "Saya orangnya analytical"]
├── Observed Behavior: [e.g., somatic freeze saat bahas konflik]
├── Contradiction Signal: [e.g., klaim logis tapi response emosional]
└── Context: [e.g., saat di-question tentang masalah personal]

AI TASK: Generate question yang expose gap antara klaim dan observasi
TONE: Innocent curiosity ("Menarik...") bukan accusation
```

---

**Rule 4.4 — AB × Stress Response (Cognitive vs Somatic Split)**
```
INPUT REQUIREMENTS:
- User claim: "Saya analytical/logical/mikir dulu" (high AB claim)
- Observed: Response somatic/emosional tanpa processing kognitif
- Evidence: "Saya langsung tau harus apa" + tanda tubuh (jantung berdebar, tegang)

AI GENERATE:
"Kamu bilang tipe yang analytical—mikir dulu baru act. Tapi pas cerita [CONTEXT] tadi,
saya notice kamu langsung [SOMATIC_SIGNAL]. Itu analytical-nya 'freeze' dulu, atau
ada yang lebih dulu dari pikiran?"

TARGET: Expose pre-cognitive response pattern
VARIABLES: [CONTEXT] = topik yang trigger response, [SOMATIC_SIGNAL] = observed body reaction
```

---

**Rule 4.5 — EG × VB (Awareness vs Expression Gap)**
```
INPUT REQUIREMENTS:
- User demonstrated: High emotional granularity (bisa bedain nuanced feelings)
- User demonstrated: Low vulnerability expression (nggak pernah share ke orang)
- Evidence: Bisa describe 5 jenis sedih, tapi bilang "saya nggak pernah cerita ini"

AI GENERATE:
"Kamu pintar banget identify perasaan—bisa bedain [SPECIFIC_EG_DEMO]. 
Tapi pas udah identify... diapain? Tetep di dalam, atau ada yang bisa keluar?"

FOLLOW-UP (if "tetep di dalam"):
"Apa yang harus terjadi biar yang di-identify itu bisa sampai ke luar?"

TARGET: Expose awareness-expression gap
VARIABLES: [SPECIFIC_EG_DEMO] = contoh konkret granularitas emosi yang user tunjukkan
```

---

**Rule 4.6 — RS × ARP (Recognition Need vs Authority Pattern)**
```
INPUT REQUIREMENTS:
- User claim/behavior: Butuh diakui/validasi (RS signal)
- User behavior: Dominan/rebellious dengan authority (ARP signal)
- Contradiction: Mau recognition tapi approach ke authority adalah confront/control

AI GENERATE:
"Saya notice kamu butuh [RECOGNITION_TYPE]—tapi cara kamu dapetinnya
di [AUTHORITY_CONTEXT] adalah [ARP_BEHAVIOR]. 
Itu cara yang bikin kamu dapet yang kamu butuh, atau cara yang 'aman' untuk nggak keliatan butuh?"

TARGET: Expose compensation pattern (dominance as defense against need)
VARIABLES: 
- [RECOGNITION_TYPE] = jenis recognition yang user cari (acknowledgment, praise, etc)
- [AUTHORITY_CONTEXT] = situasi authority yang terdeteksi
- [ARP_BEHAVIOR] = dominan/rebellious/withdraw pattern yang observed
```

---

**Rule 4.7 — ASC × Emotional Structure (Glorified Strength vs Cost)**
```
INPUT REQUIREMENTS:
- User claim: [BEHAVIOR] adalah strength/kekuatan/identitas inti
- User demonstrated: Ada cost emosional/psikologis (drained, empty, isolated)
- Contradiction: Klaim strength tapi ada suffering yang disembunyikan

AI GENERATE:
"Kamu bilang [BEHAVIOR_CLAIM] adalah kekuatan kamu—yang bikin kamu [POSITIVE_OUTCOME].
Tapi tadi juga cerita [COST_EVIDENCE]. 
Ini strength yang memang kuat, atau ini familiar karena sudah lama dilakukan?"

FOLLOW-UP (if defensive):
"Bukan yang benar-salah—tapi kalau ada 'tagihan' yang terus dibayar,
apa yang harus dikorbankan untuk maintain [BEHAVIOR_CLAIM]?"

TARGET: Test ASC legitimacy (genuine adaptation vs glorified survival)
VARIABLES:
- [BEHAVIOR_CLAIM] = klaim strength yang user banggakan
- [POSITIVE_OUTCOME] = hasil positif yang dikaitkan dengan behavior
- [COST_EVIDENCE] = bukti cost yang user ceritakan (exhaustion, no close friends, etc)
```

---

## Phase 6: Closure

**AI Objective:** Safe landing without validation-seeking.

### Generation Rules

**Rule 6.1 — Grounding**
```
AI GENERATE: "Sekarang, di ruangan ini—apa yang paling kamu sadari? Suara, cahaya, suhu?"
```

**Rule 6.2 — Subjective Capture**
```
AI GENERATE: "Dari semua yang kita obrolin—tanpa harus benar atau salah—apa yang muncul sekarang?"
```

**Rule 6.3 — Resource Anchor**
```
AI GENERATE: "Kalau ada yang nyangkut setelah ini—apa yang biasanya bikin grounded lagi?"
```

**Rule 6.4 — Next Step**
```
AI GENERATE: "Apa yang perlu kamu lakuin setelah ini—untuk kamu sendiri?"
```

**Rule 6.5 — Authority Return**
```
AI GENERATE: "Obrolan selesai. Ini eksplorasi—bukan diagnosis. Kamu punya otoritas penuh atas interpretasi dirimu."
```

---

## AI Decision Tree: Which Phase to Use?

```
IF session_start == true:
    → Phase 0 (Context Gathering)

ELIF confidence < 0.6 in any field:
    → Phase 1 (Core Pattern Exposure)

ELIF hypothesis_ready AND not_yet_tested:
    → Phase 2 (Adaptive Probing)

ELIF surface_patterns_extracted AND depth_required:
    → Phase 3 (Deep Trauma Mining)

ELIF contradiction_detected:
    → Phase 4 (Validation)

ELIF session_end == true:
    → Phase 6 (Closure)
```

---

## Question Quality Checklist (AI Self-Check)

Before generating question, AI must verify:

- [ ] **Indirect?** — Not asking directly about target dimension
- [ ] **Story-forcing?** — Cannot be answered with label/category
- [ ] **Specific moment?** — Uses "kapan" not "bagaimana"
- [ ] **No hypothesis reveal?** — Doesn't mention "I think" or "hypothesis"
- [ ] **No validation-seeking?** — Doesn't ask "does this resonate?"
- [ ] **Somatic potential?** — Allows body-based response
- [ ] **Safety-appropriate?** — Matches subject's readiness level

---

## Prohibited Phrases (AI Must Never Use)

| Forbidden | Why | Alternative Instruction |
|-----------|-----|------------------------|
| "I have a hypothesis" | Reveals assessment frame | Test without stating |
| "Does this resonate?" | Seeks confirmation | Let contradiction emerge |
| "You seem to..." | Sounds like labeling | "Saya notice..." + question |
| "Describe yourself" | Invites curated image | "Kapan kamu..." + moment |
| "How do you feel?" | Too direct | "Apa yang ikut muncul?" |
| "Why did you..." | Invites justification | "Apa yang..." or "Bagaimana..." |
| "Yourself 5 years ago" | Expected framing | "Dulu vs sekarang..." |
| "Are you [trait]?" | Binary, superficial | Behavioral probe |

---

*MirrorBreak Protocol v3.1 — AI Agent Question Generation Framework*
*"The best question is one the AI generates, not the one it memorizes."*
