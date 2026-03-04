# MBP Technology Stack

**Recommended Technology Stack for Implementation**

---

## Architecture Overview

```
┌─────────────────────────────────────────────────────────────┐
│                        CLIENT LAYER                          │
│         (Web App / Mobile / CLI)                             │
├─────────────────────────────────────────────────────────────┤
│                        API GATEWAY                           │
│         (Kong / AWS API Gateway / Nginx)                     │
├─────────────────────────────────────────────────────────────┤
│                      APPLICATION LAYER                       │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐         │
│  │   Session   │  │   Agent     │  │  Assessment │         │
│  │   Service   │  │   Service   │  │   Service   │         │
│  └─────────────┘  └─────────────┘  └─────────────┘         │
├─────────────────────────────────────────────────────────────┤
│                        AI LAYER                              │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐         │
│  │  Analyzer   │  │ Hypothesis  │  │  Question   │         │
│  │    Agent    │  │   Agents    │  │    Agent    │         │
│  └─────────────┘  └─────────────┘  └─────────────┘         │
│  ┌─────────────┐  ┌─────────────┐                          │
│  │  Assessor   │  │ Synthesizer │                          │
│  │    Agent    │  │    Agent    │                          │
│  └─────────────┘  └─────────────┘                          │
├─────────────────────────────────────────────────────────────┤
│                      MESSAGE QUEUE                           │
│         (Redis / RabbitMQ / AWS SQS)                         │
├─────────────────────────────────────────────────────────────┤
│                       DATA LAYER                             │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐         │
│  │ PostgreSQL  │  │    Redis    │  │  S3/MinIO   │         │
│  │  (Primary)  │  │   (Cache)   │  │  (Storage)  │         │
│  └─────────────┘  └─────────────┘  └─────────────┘         │
└─────────────────────────────────────────────────────────────┘
```

---

## Core Technologies

### Backend Framework

| Component | Recommendation | Alternatives |
|-----------|---------------|--------------|
| **Language** | Python 3.11+ | Node.js, Go |
| **Framework** | FastAPI | Django, Flask |
| **Rationale** | Async support, type hints, OpenAPI auto-gen | |

**Why FastAPI:**
- Native async/await for concurrent agent processing
- Automatic OpenAPI documentation
- Type validation with Pydantic
- High performance (Starlette + Uvicorn)

### Database

| Component | Recommendation | Alternatives |
|-----------|---------------|--------------|
| **Primary DB** | PostgreSQL 15+ | MySQL, CockroachDB |
| **JSON Support** | Native JSONB | MongoDB (if heavy JSON) |
| **Migration** | Alembic | Django migrations |

**Schema Design:**
- Relational core (sessions, fields, hypotheses)
- JSONB for flexible evidence metadata
- Array types for tags and dimensions

### Caching

| Component | Recommendation | Use Case |
|-----------|---------------|----------|
| **Cache** | Redis 7+ | Session state, hypothesis cache |
| **Rate Limiting** | Redis | API throttling |
| **Pub/Sub** | Redis | Real-time updates |

### Message Queue

| Component | Recommendation | Use Case |
|-----------|---------------|----------|
| **Queue** | Celery + Redis | Async agent tasks |
| **Alternative** | AWS SQS | Cloud-native |
| **Alternative** | RabbitMQ | Complex routing |

### AI/ML Infrastructure

| Component | Recommendation | Purpose |
|-----------|---------------|---------|
| **LLM API** | OpenAI GPT-4 | Agent reasoning |
| **Alternative** | Anthropic Claude | Longer context |
| **Alternative** | Local LLM (Llama 3) | Privacy, cost |
| **Embeddings** | OpenAI text-embedding-3 | Semantic search |
| **Vector DB** | pgvector | Evidence retrieval |

### Storage

| Component | Recommendation | Use Case |
|-----------|---------------|----------|
| **Object Storage** | AWS S3 / MinIO | Raw transcripts, audio |
| **CDN** | CloudFront / Cloudflare | Static assets |
| **Backup** | pg_dump + S3 | Database backups |

---

## Agent Implementation

### Agent Architecture

```python
# Base Agent Class
class MBPAgent(ABC):
    def __init__(self, llm_client: LLMClient):
        self.llm = llm_client
        self.prompt = self.load_prompt()
    
    @abstractmethod
    async def process(self, input_data: dict) -> AgentOutput:
        pass
    
    async def call_llm(self, context: dict) -> LLMResponse:
        return await self.llm.generate(
            prompt=self.prompt.format(**context),
            temperature=0.3,
            response_format="json"
        )
```

### Agent-Specific LLM Configs

| Agent | Model | Temperature | Max Tokens |
|-------|-------|-------------|------------|
| Analyzer | GPT-4 | 0.1 | 2000 |
| HypothesisMaker | GPT-4 | 0.4 | 3000 |
| HypothesisRefiner | GPT-4 | 0.2 | 2500 |
| QuestionMaker | GPT-4 | 0.5 | 1500 |
| Assessor | GPT-4 | 0.1 | 3000 |
| Synthesizer | GPT-4 | 0.3 | 4000 |

### Prompt Management

```
prompts/
├── base/
│   └── system_context.md
├── agents/
│   ├── analyzer.md
│   ├── hypothesis_maker.md
│   ├── hypothesis_refiner.md
│   ├── question_maker.md
│   ├── assessor.md
│   └── synthesizer.md
└── version_control/
    └── v1.0/  # Snapshots for reproducibility
```

---

## Infrastructure

### Deployment Options

| Environment | Recommendation | Specs |
|-------------|---------------|-------|
| **Development** | Docker Compose | Local stack |
| **Staging** | AWS ECS / k8s | 2 vCPU, 4GB RAM |
| **Production** | AWS EKS / GCP GKE | 4+ vCPU, 8GB+ RAM |

### Containerization

```dockerfile
# Dockerfile
FROM python:3.11-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
```

### Docker Compose (Development)

```yaml
version: '3.8'
services:
  api:
    build: .
    ports:
      - "8000:8000"
    environment:
      - DATABASE_URL=postgresql://user:pass@db:5432/mbp
      - REDIS_URL=redis://redis:6379
    depends_on:
      - db
      - redis
  
  db:
    image: postgres:15
    environment:
      POSTGRES_DB: mbp
      POSTGRES_USER: user
      POSTGRES_PASSWORD: pass
    volumes:
      - postgres_data:/var/lib/postgresql/data
  
  redis:
    image: redis:7-alpine
  
  celery:
    build: .
    command: celery -A tasks worker --loglevel=info
    environment:
      - DATABASE_URL=postgresql://user:pass@db:5432/mbp
    depends_on:
      - db
      - redis

volumes:
  postgres_data:
```

---

## Monitoring & Observability

### Logging

| Component | Tool | Purpose |
|-----------|------|---------|
| **Structured Logs** | JSON + ELK / Loki | Queryable logs |
| **Audit Trail** | Database table | Compliance |
| **Agent Logs** | Structured | Debugging |

### Metrics

| Component | Tool | Metrics |
|-----------|------|---------|
| **Application** | Prometheus | Request latency, errors |
| **Infrastructure** | Grafana + Prometheus | CPU, memory, DB |
| **LLM Usage** | Custom | Token count, cost |
| **Agent Performance** | Custom | Confidence progression |

### Alerting

| Condition | Severity | Channel |
|-----------|----------|---------|
| Error rate >5% | Critical | PagerDuty |
| Latency >2s | Warning | Slack |
| LLM rate limit | Warning | Slack |
| Safety flag triggered | Critical | Immediate |

---

## Security

### Data Protection

| Layer | Implementation |
|-------|---------------|
| **Transit** | TLS 1.3 |
| **At Rest** | AES-256 (DB), S3 SSE |
| **PII** | Tokenization |
| **Backup** | Encrypted, access controlled |

### Access Control

```
Roles:
- admin: Full access
- analyst: Create/run sessions
- viewer: Read-only profiles
- system: Service-to-service
```

### Compliance

- **GDPR**: Right to deletion, data export
- **HIPAA**: If clinical context (not default)
- **Audit**: All access logged

---

## Cost Estimates (Monthly)

### Small Deployment (~100 sessions/month)

| Component | Cost |
|-----------|------|
| Compute (ECS Fargate) | $100 |
| RDS PostgreSQL | $50 |
| Redis (ElastiCache) | $30 |
| OpenAI API | $200 |
| S3 Storage | $10 |
| **Total** | **~$390** |

### Medium Deployment (~1000 sessions/month)

| Component | Cost |
|-----------|------|
| Compute (EKS) | $400 |
| RDS PostgreSQL | $150 |
| Redis | $80 |
| OpenAI API | $1,500 |
| S3 + CDN | $50 |
| **Total** | **~$2,180** |

---

## Development Workflow

### Local Setup

```bash
# 1. Clone repo
git clone https://github.com/zemetia/mirrorbreak-protocol.git
cd mirrorbreak-protocol/system-implementation

# 2. Start infrastructure
docker-compose up -d

# 3. Run migrations
alembic upgrade head

# 4. Seed prompts
python scripts/load_prompts.py

# 5. Start API
uvicorn main:app --reload
```

### Testing

```bash
# Unit tests
pytest tests/unit

# Integration tests
pytest tests/integration

# Agent tests
pytest tests/agents

# Load tests
locust -f tests/load/locustfile.py
```

---

*Technology Stack v1.0 — System Implementation Plan*
