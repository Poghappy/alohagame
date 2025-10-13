# Project Structure

## Repository Organization

AlohaGameBot follows a monorepo structure with npm workspaces, organized into distinct packages for different services and shared utilities.

## Root Directory Structure

```
alohagamebot/
├── packages/                    # Main service packages
├── docs/                       # Documentation and guides
├── helm/                       # Kubernetes Helm charts
├── scripts/                    # Development and deployment scripts
├── vibe-tools/                 # AI-powered development tools
├── 视觉资产/                    # Visual assets and branding
├── .cursor/                    # Cursor IDE configuration
├── .kiro/                      # Kiro AI assistant configuration
├── .github/                    # GitHub workflows and templates
└── docker/                     # Docker configurations (implied)
```

## Core Packages Structure

### packages/bytebot-agent (Port 9991)
**Purpose**: Main AI coordination service and API backend

```
packages/bytebot-agent/
├── src/
│   ├── agent/                  # AI agent logic and coordination
│   ├── anthropic/              # Anthropic Claude integration
│   ├── openai/                 # OpenAI GPT integration
│   ├── google/                 # Google Gemini integration
│   ├── tasks/                  # Task management and execution
│   ├── messages/               # Message handling and storage
│   ├── summaries/              # Task summary generation
│   ├── prisma/                 # Database service layer
│   ├── proxy/                  # LiteLLM proxy integration
│   ├── app.controller.ts       # Main API controller
│   ├── app.module.ts           # NestJS application module
│   └── main.ts                 # Application entry point
├── prisma/
│   ├── migrations/             # Database migration files
│   ├── schema.prisma           # Database schema definition
│   └── dev.db                  # SQLite development database
├── dist/                       # Compiled TypeScript output
├── package.json                # Dependencies and scripts
├── Dockerfile                  # Container build configuration
└── .env.example                # Environment variable template
```

### packages/bytebot-ui (Port 9992)
**Purpose**: Web interface for task management and desktop viewing

```
packages/bytebot-ui/
├── src/
│   ├── app/                    # Next.js App Router pages
│   ├── components/             # React UI components
│   ├── hooks/                  # Custom React hooks
│   ├── lib/                    # Utility libraries
│   ├── types/                  # TypeScript type definitions
│   └── utils/                  # Helper functions
├── public/                     # Static assets and logos
├── scripts/                    # Build and branding scripts
├── .next/                      # Next.js build output
├── server.ts                   # Custom Express server
├── next.config.ts              # Next.js configuration
├── tailwind.config.js          # Tailwind CSS configuration
├── package.json                # Dependencies and scripts
└── Dockerfile                  # Container build configuration
```

### packages/bytebotd (Port 9990)
**Purpose**: Desktop automation and computer control service

```
packages/bytebotd/
├── src/
│   ├── computer-use/           # Desktop automation logic
│   ├── input-tracking/         # Mouse/keyboard input monitoring
│   ├── mcp/                    # Model Context Protocol implementation
│   ├── nut/                    # Nut.js automation wrapper
│   ├── app.controller.ts       # Desktop control API
│   ├── app.module.ts           # NestJS application module
│   └── main.ts                 # Application entry point
├── root/                       # Desktop environment files
│   ├── etc/                    # System configuration
│   ├── home/                   # User home directory setup
│   └── usr/                    # User binaries and applications
├── dist/                       # Compiled TypeScript output
├── package.json                # Dependencies and scripts
└── Dockerfile                  # Container build configuration
```

### packages/bytebot-agent-cc
**Purpose**: Alternative agent implementation (Computer Control focused)

```
packages/bytebot-agent-cc/
├── src/
│   ├── agent/                  # Simplified agent logic
│   ├── tasks/                  # Task management
│   ├── messages/               # Message handling
│   └── prisma/                 # Database integration
├── prisma/                     # Database schema and migrations
└── package.json                # Dependencies and scripts
```

### packages/shared
**Purpose**: Common utilities and types shared across services

```
packages/shared/
├── src/
│   ├── types/                  # Shared TypeScript interfaces
│   ├── utils/                  # Common utility functions
│   └── index.ts                # Main export file
├── dist/                       # Compiled output (ESM + CommonJS)
└── package.json                # Build configuration
```

## Documentation Structure

### docs/
**Purpose**: Comprehensive project documentation

```
docs/
├── api-reference/              # API documentation
│   ├── agent/                  # Agent API endpoints
│   ├── computer-use/           # Desktop control API
│   ├── endpoint/               # General API endpoints
│   └── openapi.json            # OpenAPI specification
├── core-concepts/              # Architecture and concepts
├── deployment/                 # Deployment guides
├── guides/                     # User guides and tutorials
├── rest-api/                   # REST API documentation
├── images/                     # Documentation images
├── logo/                       # Brand assets
├── introduction.mdx            # Getting started guide
└── quickstart.mdx              # Quick setup guide
```

## Infrastructure Structure

### helm/
**Purpose**: Kubernetes deployment configurations

```
helm/
├── charts/                     # Individual service charts
│   ├── bytebot-agent/          # Agent service Helm chart
│   ├── bytebot-desktop/        # Desktop service Helm chart
│   ├── bytebot-ui/             # UI service Helm chart
│   ├── bytebot-llm-proxy/      # LiteLLM proxy chart
│   └── postgresql/             # Database chart
├── templates/                  # Main chart templates
├── values.yaml                 # Default configuration values
├── values-proxy.yaml           # LiteLLM proxy configuration
└── Chart.yaml                  # Main chart metadata
```

### vibe-tools/
**Purpose**: AI-powered development and automation tools

```
vibe-tools/
├── src/
│   ├── commands/               # CLI command implementations
│   │   ├── browser/            # Browser automation (Stagehand)
│   │   ├── github/             # GitHub integration
│   │   ├── linear/             # Linear project management
│   │   ├── mcp/                # Model Context Protocol
│   │   └── test/               # Testing utilities
│   ├── llms/                   # LLM provider integrations
│   ├── providers/              # Service provider abstractions
│   ├── types/                  # TypeScript definitions
│   └── utils/                  # Utility functions
├── tests/                      # Test suites and reports
├── infra/                      # Infrastructure code (Nuxt app)
└── package.json                # Dependencies and configuration
```

## Configuration Structure

### .cursor/
**Purpose**: Cursor IDE AI team configuration

```
.cursor/
├── config/                     # AI team configurations
├── rules/                      # Development and collaboration rules
├── templates/                  # Code and project templates
└── commands/                   # Custom AI commands
```

### .kiro/
**Purpose**: Kiro AI assistant configuration

```
.kiro/
├── steering/                   # AI guidance rules
│   ├── product.md              # Product overview
│   ├── tech.md                 # Technology stack
│   └── structure.md            # Project structure (this file)
└── settings/                   # Configuration files
```

## File Naming Conventions

### TypeScript Files
- **Controllers**: `*.controller.ts` - API endpoint handlers
- **Services**: `*.service.ts` - Business logic services
- **Modules**: `*.module.ts` - NestJS module definitions
- **Types**: `*.types.ts` - TypeScript type definitions
- **Utils**: `*.utils.ts` - Utility functions

### React Components
- **Components**: PascalCase (e.g., `TaskManager.tsx`)
- **Hooks**: camelCase starting with "use" (e.g., `useAuth.ts`)
- **Pages**: kebab-case for files, PascalCase for components

### Configuration Files
- **Environment**: `.env`, `.env.example`, `.env.local`
- **Docker**: `Dockerfile`, `docker-compose.yml`
- **Package**: `package.json`, `package-lock.json`
- **TypeScript**: `tsconfig.json`, `tsconfig.build.json`

## Import Path Conventions

### Relative Imports
- Same directory: `./filename`
- Parent directory: `../filename`
- Nested directories: `./subdirectory/filename`

### Absolute Imports
- Shared package: `@bytebot/shared`
- Internal modules: Use relative paths within packages
- External libraries: Standard npm package names

## Development Workflow Paths

### Local Development
1. **Root setup**: `npm run install:all && npm run setup`
2. **Start services**: `npm run dev` or `npm run dev:turbo`
3. **Individual services**: Navigate to package directory and use local scripts

### Docker Development
1. **Environment setup**: `npm run docker:dev`
2. **Service access**: Services available on standard ports (9990, 9991, 9992)
3. **Logs and debugging**: Use Docker Compose commands

### Production Deployment
1. **Kubernetes**: Use Helm charts in `helm/` directory
2. **Docker**: Use production Docker Compose configurations
3. **Railway**: One-click deployment via Railway button

This structure supports the monorepo architecture while maintaining clear separation of concerns between the AI coordination layer, desktop automation, web interface, and shared utilities.