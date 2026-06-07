# Tutorial de GitHub Spec-Kit

> Transcripción en Markdown del contenido extraído del PDF de 24 páginas.

## ¿Qué es Spec-Kit?
Spec-Kit es una herramienta que invierte el paradigma tradicional de desarrollo de software. En lugar de escribir código primero y documentar después, las especificaciones se convierten en implementaciones ejecutables.

## ¿Por qué usar Spec-Kit?
- Claridad desde el inicio
- Reducción de errores
- Documentación viva
- Integración con AI

# Módulo 1: Fundamentos

## Introducción a Spec-Driven Development

### ¿Qué problema resuelve?
- Requisitos ambiguos
- Código primero, documentación después
- Pérdida de contexto
- Ciclos de feedback largos

### Principios fundamentales

| Tradicional | Spec-Driven |
|------------|------------|
| Código es rey | Especificaciones son rey |
| Documentación temporal | Especificaciones permanentes |
| Ambigüedad tolerada | Claridad requerida |
| AI genera código | AI genera desde specs |

### Flujo SDD

Constitution → Specify → Plan → Tasks → Implement

1. Constitution
2. Specify
3. Plan
4. Tasks
5. Implement

## Cuándo usar SDD

### Ideal para
- Proyectos nuevos
- Equipos con IA
- Sistemas complejos
- Grandes refactorizaciones

### No recomendado para
- Prototipos rápidos
- Scripts simples
- Código desechable

# Instalación y Configuración

## Requisitos

| Requisito | Versión |
|------------|---------|
| Python | 3.11+ |
| Git | 2.0+ |
| uv | Última |

## Instalar uv

```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

## Instalar Spec-Kit

```bash
uv tool install specify-cli --from git+https://github.com/github/spec-kit.git
```

## Verificar

```bash
specify check
specify version
```

## Inicializar proyecto

```bash
specify init mi-proyecto --ai claude
specify init . --ai claude
specify init --here --ai claude
specify init . --force --ai claude
```

## Agentes soportados

- claude
- copilot
- cursor-agent
- gemini
- codex
- windsurf
- amp

## Estructura

```text
proyecto/
├── .specify/
│   ├── constitution.md
│   ├── specs/
│   ├── plans/
│   ├── tasks/
│   └── extensions/
└── src/
```

## Extensiones

```bash
specify extension list --available
specify extension search jira
specify extension add jira
specify extension enable jira
specify extension disable jira
specify extension update
```

# Flujo de Trabajo y Comandos

## /speckit.constitution

Define:
- Stack tecnológico
- Arquitectura
- Estándares
- Restricciones

## /speckit.specify

Describe:
- Requisitos
- Criterios de aceptación
- Casos de error
- Dependencias

## /speckit.plan

Incluye:
- Arquitectura técnica
- Interfaces
- Contratos
- Estrategia de testing

## /speckit.tasks

Genera:
- Tareas atómicas
- Dependencias
- Orden de ejecución

## /speckit.implement

Genera código a partir de:
- Constitution
- Spec
- Plan
- Tasks

# Ejemplo práctico: CRUD de Tareas

## Entidad Todo

```text
id: UUID
title: string
description: string
status: pending | completed
createdAt
updatedAt
```

## Endpoints

- POST /todos
- GET /todos
- GET /todos/:id
- PATCH /todos/:id
- DELETE /todos/:id

## Arquitectura

### Domain
- Todo Entity
- TodoRepository

### Application
- CreateTodoUseCase
- ListTodosUseCase
- GetTodoUseCase
- UpdateTodoUseCase
- DeleteTodoUseCase

### Infrastructure
- SQLiteTodoRepository
- Hono Routes
- Zod Schemas

## Contrato TodoRepository

```ts
create(todo: Todo): Promise<Todo>
findAll(filter?): Promise<Todo[]>
findById(id): Promise<Todo | null>
update(todo: Todo): Promise<Todo>
delete(id): Promise<void>
```

# Mejores Prácticas

## Sé específico

Malo:
```text
El usuario puede crear tareas fácilmente.
```

Bueno:
```text
El usuario puede crear tareas mediante POST /todos con validaciones definidas.
```

## Define criterios claros

- Título vacío retorna 400
- Título > 100 retorna 400
- Creación exitosa retorna 201
- UUID generado

## Documenta casos edge

- Espacios en blanco
- null vs undefined
- ID inexistente

## Mantén specs atómicas

Una feature por spec.

# Errores comunes

1. Saltarse la Constitution
2. Specs demasiado técnicas
3. Tasks no atómicas
4. Ignorar refinamiento

# Integración con Git

```bash
git checkout -b spec/user-auth
git add .specify/constitution.md
git commit -m "spec: add project constitution"
```

# Checklist

## Antes de implementar

- Constitution completa
- Criterios de aceptación
- Casos de error
- Interfaces claras
- Tasks verificables

## Después de implementar

- Código sigue constitution
- Tests completos
- Specs actualizadas

# Conclusión

Spec-Kit transforma el desarrollo mediante el flujo:

spec → plan → tasks → implement

y permite que las especificaciones sean el artefacto principal del proceso de desarrollo.
