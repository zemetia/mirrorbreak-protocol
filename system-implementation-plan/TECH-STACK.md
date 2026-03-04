# MBP Technology Stack

**Recommended Technology Stack for MirrorBreak Protocol Implementation**

---

## 1. Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                        TECH STACK OVERVIEW                       │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  FRONTEND          BACKEND           AI/ML           DATA        │
│  ─────────         ───────           ─────           ────        │
│  Next.js 14        FastAPI           OpenAI          PostgreSQL  │
│  TypeScript        Python 3.11       Anthropic       Redis       │
│  Tailwind          Pydantic          Local LLM       Pinecone    │
│  React Query       SQLAlchemy 2.0    Instructor      MinIO      │
│                                                                  │
│  INFRASTRUCTURE                                                  │
│  ─────────────                                                   │
│  Docker │ K8s │ GitHub Actions │ AWS/GCP │ Terraform            │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

---

## 2. Backend Stack

### 2.1 Core Framework

| Component | Technology | Version | Rationale |
|-----------|------------|---------|-----------|
| **Framework** | FastAPI | ^0.104 | Async native, auto OpenAPI, Pydantic integration |
| **Language** | Python | 3.11+ | ML/AI ecosystem, agent orchestration |
| **Validation** | Pydantic v2 | ^2.5 | Type-safe models, JSON Schema gen |
| **ORM** | SQLAlchemy 2.0 | ^2.0 | Async support, PostgreSQL optimized |
| **Migrations** | Alembic | ^1.12 | Database versioning |

### 2.2 Agent Orchestration

| Component | Technology | Purpose |
|-----------|------------|---------|
| **Workflow Engine** | Prefect 2.x / Temporal | Phase management, checkpointing |
| **Task Queue** | Celery + Redis | Async agent tasks |
| **State Machine** | Python transitions | Phase state management |
| **Event Bus** | Redis Pub/Sub | Real-time updates |

### 2.3 Key Dependencies

```python
# requirements.txt
fastapi==0.104.1
uvicorn[standard]==0.24.0
pydantic==2.5.0
sqlalchemy[asyncio]==2.0.23
asyncpg==0.29.0
alembic==1.12.1
redis==5.0.1
celery==5.3.4
prefect==2.14.0
httpx==0.25.2
python-jose[cryptography]==3.3.0
passlib[bcrypt]==1.7.4
python-multipart==0.0.6
structlog==23.2.0
sentry-sdk==1.38.0
```

---

## 3. AI/ML Stack

### 3.1 LLM Infrastructure

| Component | Technology | Purpose |
|-----------|------------|---------|
| **Primary LLM** | OpenAI GPT-4 / Claude 3 Opus | Agent reasoning |
| **Fallback LLM** | Claude 3 Sonnet / GPT-3.5 | Cost optimization |
| **Local Option** | Llama 2 70B (vLLM) | Privacy-sensitive deployments |
| **Structured Output** | Instructor / Outlines | Typed LLM responses |
| **Prompt Management** | Langfuse / Helicone | Versioning, observability |

### 3.2 Agent Prompt Engineering

```python
# Agent configuration structure
AGENT_CONFIG = {
    "analyzer": {
        "model": "gpt-4-1106-preview",
        "temperature": 0.2,
        "max_tokens": 4000,
        "structured_output": SignalExtraction
    },
    "hypothesis_maker": {
        "model": "claude-3-opus-20240229",
        "temperature": 0.7,
        "max_tokens": 4000,
        "structured_output": HypothesisSet
    },
    "hypothesis_refiner": {
        "model": "gpt-4-1106-preview",
        "temperature": 0.3,
        "max_tokens": 4000,
        "structured_output": HypothesisUpdate
    },
    "question_maker": {
        "model": "gpt-4-1106-preview",
        "temperature": 0.5,
        "max_tokens": 2000,
        "structured_output": ProbeSet
    },
    "assessor": {
        "model": "claude-3-opus-20240229",
        "temperature": 0.1,
        "max_tokens": 4000,
        "structured_output": Matrix12D
    },
    "synthesizer": {
        "model": "claude-3-opus-20240229",
        "temperature": 0.4,
        "max_tokens": 8000,
        "structured_output": FinalProfile
    }
}
```

### 3.3 Vector Store (Evidence Retrieval)

| Component | Technology | Purpose |
|-----------|------------|---------|
| **Vector DB** | Pinecone / Weaviate / Chroma | Evidence embedding storage |
| **Embeddings** | OpenAI text-embedding-3-large | 3072-dim vectors |
| **Retrieval** | Hybrid (semantic + metadata) | Context-aware evidence fetch |

---

## 4. Data Layer

### 4.1 Primary Database

| Component | Technology | Purpose |
|-----------|------------|---------|
| **Database** | PostgreSQL 15+ | Primary data store |
| **Extensions** | pgvector, uuid-ossp | Vector ops, UUID gen |
| **Connection Pool** | PgBouncer | Connection management |

### 4.2 Caching & Queue

| Component | Technology | Purpose |
|-----------|------------|---------|
| **Cache** | Redis 7+ | Session state, rate limiting |
| **Queue** | Redis Streams / RabbitMQ | Agent task queue |
| **Pub/Sub** | Redis | Real-time WebSocket events |

### 4.3 Object Storage

| Component | Technology | Purpose |
|-----------|------------|---------|
| **Files** | MinIO / S3 | Audio files, exports |
| **Backups** | pgBackRest | PostgreSQL backups |

---

## 5. Frontend Stack

### 5.1 Core Framework

| Component | Technology | Version | Purpose |
|-----------|------------|---------|---------|
| **Framework** | Next.js | 14+ | React framework, API routes |
| **Language** | TypeScript | 5.3+ | Type safety |
| **Styling** | Tailwind CSS | 3.4+ | Utility-first CSS |
| **Components** | Radix UI / shadcn/ui | latest | Accessible primitives |
| **State** | Zustand | 4.4+ | Global state |
| **Data Fetch** | TanStack Query | 5.0+ | Server state |
| **Forms** | React Hook Form + Zod | latest | Form handling |

### 5.2 Real-time Features

| Component | Technology | Purpose |
|-----------|------------|---------|
| **WebSocket** | Socket.io | Real-time session updates |
| **Streaming** | Vercel AI SDK | LLM streaming responses |

---

## 6. Infrastructure

### 6.1 Containerization

```dockerfile
# Backend Dockerfile
FROM python:3.11-slim

WORKDIR /app

# Install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application
COPY . .

# Run
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
```

### 6.2 Orchestration

| Component | Technology | Purpose |
|-----------|------------|---------|
| **Container** | Docker | Application packaging |
| **Orchestration** | Kubernetes / Docker Compose | Deployment |
| **Ingress** | Nginx / Traefik | Load balancing |
| **SSL** | cert-manager | TLS certificates |

### 6.3 Cloud Infrastructure

**Option A: AWS**
- EKS (Kubernetes)
- RDS PostgreSQL
- ElastiCache Redis
- S3 (object storage)
- Application Load Balancer

**Option B: GCP**
- GKE (Kubernetes)
- Cloud SQL PostgreSQL
- Memorystore Redis
- Cloud Storage
- Cloud Load Balancing

**Option C: Self-hosted**
- Hetzner / DigitalOcean droplets
- Docker Compose
- PostgreSQL on VPS
- MinIO for storage

### 6.4 CI/CD

| Component | Technology | Purpose |
|-----------|------------|---------|
| **Repository** | GitHub | Code hosting |
| **CI/CD** | GitHub Actions | Build, test, deploy |
| **IaC** | Terraform / Pulumi | Infrastructure |
| **Monitoring** | Datadog / Grafana | Observability |

---

## 7. Development Environment

### 7.1 Local Development

```yaml
# docker-compose.dev.yml
version: '3.8'
services:
  api:
    build: ./backend
    volumes:
      - ./backend:/app
    ports:
      - "8000:8000"
    environment:
      - DATABASE_URL=postgresql+asyncpg://user:pass@db:5432/mbp
      - REDIS_URL=redis://redis:6379
    depends_on:
      - db
      - redis

  db:
    image: postgres:15
    environment:
      POSTGRES_USER: user
      POSTGRES_PASSWORD: pass
      POSTGRES_DB: mbp
    volumes:
      - postgres_data:/var/lib/postgresql/data

  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"

  web:
    build: ./frontend
    volumes:
      - ./frontend:/app
    ports:
      - "3000:3000"
    environment:
      - NEXT_PUBLIC_API_URL=http://localhost:8000
```

### 7.2 Environment Variables

```bash
# .env.example
# Database
DATABASE_URL=postgresql+asyncpg://user:pass@localhost:5432/mbp
DATABASE_POOL_SIZE=20

# Redis
REDIS_URL=redis://localhost:6379
REDIS_POOL_SIZE=50

# LLM
OPENAI_API_KEY=sk-...
ANTHROPIC_API_KEY=sk-ant-...
LLM_DEFAULT_MODEL=gpt-4-1106-preview
LLM_FALLBACK_MODEL=claude-3-opus-20240229

# Vector Store
PINECONE_API_KEY=...
PINECONE_ENVIRONMENT=...
PINECONE_INDEX=mbp-evidence

# Security
JWT_SECRET=...
JWT_ALGORITHM=HS256
JWT_EXPIRATION_HOURS=24

# Application
LOG_LEVEL=INFO
ENVIRONMENT=development
SENTRY_DSN=...
```

---

## 8. Monitoring & Observability

### 8.1 Logging

| Component | Technology | Purpose |
|-----------|------------|---------|
| **Structured Logs** | Structlog | JSON logging |
| **Aggregation** | ELK / Loki | Log collection |
| **Tracing** | OpenTelemetry | Distributed tracing |

### 8.2 Metrics

| Component | Technology | Purpose |
|-----------|------------|---------|
| **Metrics** | Prometheus | Metric collection |
| **Dashboard** | Grafana | Visualization |
| **Alerts** | PagerDuty / Opsgenie | Incident response |

### 8.3 Key Metrics

```python
# Custom metrics
MBP_SESSIONS_CREATED = Counter('mbp_sessions_created_total')
MBP_PHASE_DURATION = Histogram('mbp_phase_duration_seconds')
MBP_AGENT_LATENCY = Histogram('mbp_agent_request_duration_seconds', ['agent'])
MBP_HYPOTHESIS_CONFIDENCE = Gauge('mbp_hypothesis_confidence', ['field'])
MBP_LLM_TOKENS = Counter('mbp_llm_tokens_total', ['model', 'agent'])
```

---

## 9. Security Considerations

### 9.1 Data Protection

| Layer | Implementation |
|-------|----------------|
| **Transport** | TLS 1.3 |
| **Storage** | AES-256 at rest |
| **PII** | Pseudonymization |
| **Audit** | Immutable audit logs |

### 9.2 Access Control

```python
# RBAC structure
ROLES = {
    "admin": ["*"],
    "analyst": ["sessions:*", "profiles:read"],
    "reviewer": ["profiles:read", "profiles:review"],
    "subject": ["sessions:own", "profiles:own"]
}
```

---

## 10. Cost Estimates

### 10.1 Development (Monthly)

| Component | Provider | Cost |
|-----------|----------|------|
| VPS (2x) | Hetzner | $20 |
| PostgreSQL | Self-hosted | $0 |
| Redis | Self-hosted | $0 |
| LLM API | OpenAI | $100-200 |
| **Total** | | **$120-220** |

### 10.2 Production (Monthly)

| Component | Provider | Cost |
|-----------|----------|------|
| EKS Cluster | AWS | $150 |
| RDS PostgreSQL | AWS | $100 |
| ElastiCache | AWS | $50 |
| S3 Storage | AWS | $20 |
| Load Balancer | AWS | $25 |
| LLM API | OpenAI/Anthropic | $500-1000 |
| Monitoring | Datadog | $100 |
| **Total** | | **$945-1445** |

---

*Technology Stack v1.0 — Dr. Zemetia Research × Architect-Zero*
*MirrorBreak Protocol: System Implementation Plan*
