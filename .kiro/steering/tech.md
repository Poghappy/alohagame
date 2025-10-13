# Technology Stack

## Build System & Package Management

- **Monorepo**: npm workspaces with 5 main packages
- **Package Manager**: npm (Node.js 18+ required)
- **Build Tool**: TypeScript compilation with NestJS CLI and Next.js
- **Development**: Concurrent development servers with hot reload

## Core Technologies

### Frontend (bytebot-ui)
- **Framework**: Next.js 15 with App Router
- **Runtime**: React 19
- **Language**: TypeScript 5
- **Styling**: Tailwind CSS 4 with Radix UI components
- **Performance**: Turbopack support for faster development
- **Real-time**: Socket.io client for live updates
- **VNC**: react-vnc for desktop viewing

### Backend Services

#### Agent API (bytebot-agent)
- **Framework**: NestJS 11 with TypeScript
- **Database**: SQLite with Prisma ORM
- **Real-time**: Socket.io WebSocket server
- **AI Integration**: Anthropic SDK, OpenAI SDK, Google GenAI
- **Authentication**: Better Auth integration
- **Scheduling**: NestJS Schedule module

#### Desktop Service (bytebotd)
- **Framework**: NestJS 11 with TypeScript
- **Desktop Control**: @nut-tree-fork/nut-js for automation
- **Input Tracking**: uiohook-napi for global input monitoring
- **Image Processing**: Sharp for screenshots
- **MCP Protocol**: @rekog/mcp-nest for Model Context Protocol

#### Shared Package (@bytebot/shared)
- **Purpose**: Common types, utilities, and interfaces
- **Build**: TypeScript compilation with dual exports (ESM/CommonJS)

### Infrastructure & Deployment

#### Docker & Containers
- **Base Images**: Node.js 18 Alpine for services, Ubuntu 22.04 for desktop
- **Desktop Environment**: XFCE with VNC server
- **Orchestration**: Docker Compose for development and production
- **Registry**: GitHub Container Registry (ghcr.io)

#### Kubernetes & Helm
- **Charts**: Complete Helm charts for all services
- **Database**: PostgreSQL with persistent volumes
- **Ingress**: Nginx ingress controller support
- **Secrets**: Kubernetes secrets for API keys
- **Scaling**: Horizontal pod autoscaling support

#### LiteLLM Proxy (Optional)
- **Purpose**: Unified API for 100+ AI providers
- **Configuration**: YAML-based model routing
- **Features**: Load balancing, rate limiting, cost tracking

## Development Tools

### Code Quality
- **Linting**: ESLint 9 with TypeScript rules
- **Formatting**: Prettier 3 with consistent configuration
- **Type Checking**: TypeScript 5 with strict mode
- **Testing**: Jest for unit tests, Supertest for API tests

### Database
- **ORM**: Prisma with SQLite (development) / PostgreSQL (production)
- **Migrations**: Prisma migrate for schema changes
- **Studio**: Prisma Studio for database visualization
- **Seeding**: Custom seed scripts for test data

## Common Commands

### Development Setup
```bash
# Install all dependencies
npm run install:all

# Setup development environment (includes Prisma setup)
npm run setup

# Start all services in development mode
npm run dev

# Start with Turbopack (faster)
npm run dev:turbo
```

### Building & Testing
```bash
# Build all packages
npm run build

# Run tests
npm run test

# Lint code
npm run lint

# Format code
npm run format
```

### Database Operations
```bash
# Run database migrations (development)
npm run prisma:dev

# Deploy migrations (production)
npm run prisma:deploy

# Open Prisma Studio
cd packages/bytebot-agent && npx prisma studio
```

### Docker Operations
```bash
# Start development environment
npm run docker:dev

# Start production environment
npm run docker:prod

# Stop all containers
npm run docker:down
```

### Individual Service Commands
```bash
# Agent service
cd packages/bytebot-agent
npm run start:dev    # Development with watch
npm run start:prod   # Production build

# UI service
cd packages/bytebot-ui
npm run dev          # Development server
npm run dev:turbo    # With Turbopack
npm run build        # Production build

# Desktop service
cd packages/bytebotd
npm run start:dev    # Development with watch
npm run start:prod   # Production build
```

## Environment Configuration

### Required Environment Variables
```bash
# AI Provider API Keys (choose one or more)
ANTHROPIC_API_KEY=sk-ant-...
OPENAI_API_KEY=sk-...
GEMINI_API_KEY=...

# Database (production)
DATABASE_URL=postgresql://user:pass@host:5432/db

# Service URLs (for inter-service communication)
BYTEBOT_DESKTOP_URL=http://localhost:9990
AGENT_BASE_URL=http://localhost:9991
```

### Port Configuration
- **9990**: Desktop service (bytebotd) - VNC and computer control
- **9991**: Agent API (bytebot-agent) - Task management and AI coordination
- **9992**: UI service (bytebot-ui) - Web interface

## Performance Considerations

### Development Performance
- Use `npm run dev:turbo` for faster Next.js builds with Turbopack
- Shared package builds automatically before dependent services
- Concurrent service startup with proper dependency management

### Production Optimization
- Multi-stage Docker builds for smaller images
- Prisma query optimization with proper indexing
- Socket.io connection pooling for real-time features
- Sharp image processing for efficient screenshots

## Security Features

### API Security
- Input validation with class-validator
- Zod schema validation for runtime type checking
- CORS configuration for cross-origin requests
- Rate limiting and request size limits

### Desktop Security
- Sandboxed desktop environment in containers
- Controlled application access
- Secure VNC connections
- Input sanitization for automation commands