# Tutorial de GitHub Spec-Kit

> Conversión limpia a Markdown del PDF original (24 páginas).

## Tabla de Contenidos
- Introducción
- Fundamentos de Spec-Driven Development
- Instalación y Configuración
- Flujo de Trabajo y Comandos
- Ejemplo Práctico
- Mejores Prácticas
- Errores Comunes
- Integración con Git y CI/CD
- Checklist de Calidad
- Conclusión

---

# Introducción

## ¿Qué es Spec-Kit?

Spec-Kit es una herramienta que invierte el paradigma tradicional de desarrollo de software. En lugar de escribir código primero y documentar después, Spec-Kit permite que las especificaciones se conviertan en implementaciones ejecutables.

## ¿Por qué usar Spec-Kit?

- Claridad desde el inicio: Define el “qué” antes del “cómo”.
- Reducción de errores: Especificaciones claras reducen malentendidos.
- Documentación viva: Las especificaciones están siempre actualizadas.
- Integración con AI: Funciona con Claude Code, Copilot y otros agentes.

## Contenido del Tutorial

### Módulo 1: Fundamentos
- Introducción a Spec-Driven Development
- Qué problema resuelve
- Diferencia con desarrollo tradicional
- Cuándo usarlo
- Instalación y Configuración
- Requisitos del sistema
- Instalación con uv
- Configuración con agentes AI

### Módulo 2: Flujo de Trabajo
- Comandos y Flujo de Trabajo
- /speckit.constitution
- /speckit.specify
- /speckit.plan
- /speckit.tasks
- /speckit.implement

### Módulo 3: Práctica
- Ejemplo práctico
- Proyecto de principio a fin
- Cada comando en acción

### Mejores Prácticas
- Tips para buenas especificaciones
- Errores comunes a evitar

---

# Prerrequisitos

- Python 3.11+
- uv
- Git
- Claude Code, Copilot o Cursor

# Instalación Rápida

```bash
curl -LsSf https://astral.sh/uv/install.sh | sh

uv tool install specify-cli --from git+https://github.com/github/spec-kit.git

specify check

specify init mi-proyecto --ai claude
```

# Spec-Driven Development

## Problemas que resuelve

- Requisitos ambiguos
- Código primero, documentación después
- Pérdida de contexto
- Ciclos de feedback largos

## Principios Fundamentales

| Tradicional | Spec-Driven |
|------------|------------|
| Código es rey | Especificaciones son rey |
| Documentación temporal | Especificaciones permanentes |
| Ambigüedad tolerada | Claridad requerida |
| AI genera código | AI genera desde specs |

## Flujo

Constitution → Specify → Plan → Tasks → Implement

1. Constitution
2. Specify
3. Plan
4. Tasks
5. Implement

## Beneficios

- Trazabilidad
- Refinamiento iterativo
- AI-friendly
- Independencia tecnológica

# Instalación y Configuración

## Requisitos

| Requisito | Versión |
|-----------|----------|
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

## Inicialización

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

# Flujo de Trabajo y Comandos

## /speckit.constitution

Define:
- Stack tecnológico
- Arquitectura
- Estándares
- Restricciones

### Ejemplo

```md
# Constitution

## Stack Tecnológico
- Runtime: Node.js 20+
- Framework: Hono
- Base de datos: PostgreSQL
- Testing: Vitest

## Principios Arquitectónicos
- Arquitectura hexagonal
- Inyección de dependencias
- Separación de capas

## Restricciones
- NO usar ORMs
- NO lógica en controladores
```

## /speckit.specify

Describe requisitos funcionales.

```md
# Spec: Autenticación de Usuario

## Descripción
El sistema debe permitir a usuarios registrarse
e iniciar sesión de forma segura.

## Criterios de Aceptación
- Usuario puede registrarse
- Password hasheado con bcrypt
- JWT generado al login
- Token expira en 24h
```

## /speckit.plan

Define arquitectura técnica, interfaces y testing.

## /speckit.tasks

Desglosa trabajo en tareas atómicas.

## /speckit.implement

Genera código desde constitution, spec, plan y tasks.

# Ejemplo Práctico

## CRUD de Tareas

### Entidad Todo

```text
id: UUID
title: string
description?: string
status: pending | completed
createdAt
updatedAt
```

### Endpoints

- POST /todos
- GET /todos
- GET /todos/:id
- PATCH /todos/:id
- DELETE /todos/:id

### Arquitectura

#### Domain
- Todo Entity
- TodoRepository

#### Application
- CreateTodoUseCase
- ListTodosUseCase
- GetTodoUseCase
- UpdateTodoUseCase
- DeleteTodoUseCase

#### Infrastructure
- SQLiteTodoRepository
- Hono Routes
- Zod Schemas

### Contrato TodoRepository

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
El usuario puede crear tareas fácilmente.

Bueno:
El usuario puede crear tareas mediante POST /todos con título validado y descripción opcional.

## Define criterios claros

- Título vacío retorna 400
- Título > 100 caracteres retorna 400
- Creación exitosa retorna 201
- UUID generado

## Casos Edge

- Título con espacios
- null vs undefined
- ID inexistente

# Errores Comunes

1. Saltarse la Constitution
2. Specs demasiado técnicas
3. Tasks no atómicas
4. Ignorar refinamiento

# Integración

## Git

```bash
git checkout -b spec/user-auth

git add .specify/constitution.md
git commit -m "spec: add project constitution"

git add .specify/specs/
git commit -m "spec: user authentication requirements"

git add src/
git commit -m "feat: implement user authentication"
```

## CI/CD

```yaml
name: Validate Specs

on: [push]
```

# Checklist

## Antes de implementar

- Constitution documenta stack completo
- Spec tiene criterios de aceptación
- Spec cubre casos de error
- Plan define interfaces claras
- Tasks son atómicas y verificables

## Después de implementar

- Código sigue constitution
- Todos los criterios de aceptación pasan
- Tests cubren casos documentados
- Specs actualizadas si hubo cambios

# Conclusión

Spec-Kit transforma el desarrollo haciendo que las especificaciones sean ciudadanos de primera clase. Con práctica, el flujo:

spec → plan → tasks → implement

se vuelve natural y produce código de mayor calidad.
