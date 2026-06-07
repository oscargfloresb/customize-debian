# Página 1

# Tutorial de GitHub Spec-Kit

Bienvenido al tutorial completo de Spec-Kit, el toolkit de GitHub para desarrollo dirigido por especificaciones (Spec-Driven Development).

## ¿Qué es Spec-Kit?

Spec-Kit es una herramienta que invierte el paradigma tradicional de desarrollo de software. En lugar de escribir código primero y documentar después, Spec-Kit permite que las especificaciones se conviertan en implementaciones ejecutables.

## ¿Por qué usar Spec-Kit?

- Claridad desde el inicio: Define el “qué” antes del “cómo”
- Reducción de errores: Especificaciones claras reducen malentendidos
- Documentación viva: Las especificaciones están siempre actualizadas
- Integración con AI: Funciona con Claude Code, Copilot y otros agentes

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

---

# Página 2

### Módulo 3: Práctica

- Ejemplo Práctico
- Proyecto de principio a fin
- Cada comando en acción

### Mejores Prácticas

- Tips para buenas especificaciones
- Errores comunes a evitar

## Prerrequisitos

Para seguir este tutorial necesitas:

- Python 3.11+ instalado
- uv (gestor de paquetes Python)
- Git configurado
- Un agente AI compatible (Claude Code, Copilot, Cursor)

## Instalación Rápida

```bash
# Instalar uv si no lo tienes
curl -LsSf https://astral.sh/uv/install.sh | sh

# Instalar spec-kit
uv tool install specify-cli --from git+https://github.com/github/spec-kit.git

# Verificar instalación
specify check

# Inicializar proyecto con tu agente AI
specify init mi-proyecto --ai claude
```

## Recursos

Repositorio:

github.com/github/spec-kit

Licencia: MIT

---

# Página 3

# Introducción a Spec-Driven Development

## ¿Qué Problema Resuelve?

El desarrollo de software tradicional sufre de varios problemas:

- **Requisitos ambiguos:** Las especificaciones se escriben apresuradamente y quedan obsoletas
- **Código primero, documentación después:** La documentación se convierte en una tarea secundaria
- **Pérdida de contexto:** El “por qué” se pierde en el código
- **Ciclos de feedback largos:** Errores de especificación se detectan tarde

## Spec-Driven Development (SDD)

SDD invierte este paradigma. Las especificaciones son el artefacto principal y el código es el derivado.

## Principios Fundamentales

| Tradicional | Spec-Driven |
|------------|------------|
| Código es rey | Especificaciones son rey |
| Documentación temporal | Especificaciones permanentes |
| Ambigüedad tolerada | Claridad requerida |
| AI genera código | AI genera desde specs |

## Flujo de Trabajo SDD

```text
Constitution → Specify → Plan → Tasks → Implement
     ↓            ↓         ↓       ↓         ↓
 Principios  Requisitos  Diseño  Tareas  Código
```

### 1. Constitution (Constitución)

Define los principios fundamentales del proyecto:

- Restricciones tecnológicas
- Patrones arquitectónicos
- Estándares de calidad

### 2. Specify (Especificar)

---

# Página 4

Describe qué debe hacer el sistema:

- Funcionalidades esperadas
- Comportamientos del usuario
- Criterios de aceptación

### 3. Plan (Planificar)

Diseña cómo se implementará:

- Arquitectura técnica
- Decisiones de diseño
- Dependencias

### 4. Tasks (Tareas)

Descompone en unidades ejecutables:

- Tareas atómicas
- Orden de implementación
- Dependencias entre tareas

### 5. Implement (Implementar)

Genera el código automáticamente desde las especificaciones.

## ¿Cuándo Usar SDD?

### Ideal Para

- Proyectos nuevos donde la claridad inicial es crucial
- Equipos con AI que quieren maximizar la productividad
- Sistemas complejos donde la documentación es esencial
- Refactorizaciones grandes que necesitan planificación

### No Recomendado Para

- Prototipos rápidos de exploración
- Scripts simples de una sola ejecución
- Código desechable

## Beneficios de SDD con Spec-Kit

---

# Página 5

- Trazabilidad: Cada línea de código se rastrea a una especificación
- Refinamiento iterativo: Las especificaciones se mejoran antes de codificar
- AI-friendly: Los agentes AI trabajan mejor con especificaciones claras
- Independencia tecnológica: Las specs no están atadas a un lenguaje

---

# Página 6

# Instalación y Configuración

## Requisitos del Sistema

Antes de instalar Spec-Kit, asegúrate de tener:

| Requisito | Versión Mínima | Verificar |
|------------|------------|------------|
| Python | 3.11+ | python --version |
| Git | 2.0+ | git --version |
| uv | Última | uv --version |

## Instalación de uv

uv es un gestor de paquetes Python ultrarrápido escrito en Rust.

### macOS / Linux

```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

### Windows (PowerShell)

```powershell
irm https://astral.sh/uv/install.ps1 | iex
```

## Verificar Instalación

```bash
uv --version
```

## Instalación de Spec-Kit

### Instalación Persistente (Recomendada)

```bash
uv tool install specify-cli \
--from git+https://github.com/github/spec-kit.git
```

Esto instala `specify` como comando global disponible en tu terminal.

### Instalación en Proyecto

```bash
# Crear entorno virtual
uv venv
```

---

# Página 7

```bash
# Activar entorno
source .venv/bin/activate    # Linux/macOS
.venv\Scripts\activate       # Windows

# Instalar dependencia
uv pip install \
git+https://github.com/github/spec-kit.git
```

## Verificar Instalación

```bash
specify --help
```

## Inicializar Proyecto

Después de instalar, inicializa Spec-Kit en tu proyecto especificando el agente AI:

```bash
# Crear proyecto nuevo con Claude Code
specify init mi-proyecto --ai claude

# Inicializar en directorio actual
specify init . --ai claude

# o con flag --here
specify init --here --ai claude

# Forzar en directorio no vacío
specify init . --force --ai claude
```

## Agentes AI soportados

| Flag --ai | Agente |
|------------|---------|
| claude | Claude Code |
| copilot | GitHub Copilot |
| cursor-agent | Cursor |
| gemini | Gemini |
| codex | OpenAI Codex |
| windsurf | Windsurf |
| amp | Amp |

## Flags adicionales de init

---

# Página 8

| Flag | Función |
|--------|----------|
| --script ps | Genera scripts PowerShell (por defecto detecta OS) |
| --no-git | Omite inicialización de Git |
| --ignore-agent-tools | Omite verificación de herramientas del agente |
| --debug | Habilita output de depuración |

## Verificar herramientas

```bash
specify check
specify version
```

## Estructura de Carpetas

```text
proyecto/
├── .specify/
│   ├── constitution.md    # Principios del proyecto
│   ├── specs/             # Especificaciones funcionales
│   │   └── *.md
│   ├── plans/             # Planes técnicos
│   │   └── *.md
│   ├── tasks/             # Tareas desglosadas
│   │   └── *.md
│   └── extensions/        # Extensiones instaladas
└── src/                   # Código generado
```

## Sistema de Extensiones

```bash
# Listar extensiones disponibles
specify extension list --available

# Buscar extensiones
specify extension search jira

# Instalar una extensión
specify extension add jira

# Habilitar/deshabilitar
specify extension enable jira
specify extension disable jira
```


# Página 9

```bash
# Actualizar extensiones
specify extension update
```

Las extensiones se instalan en `.specify/extensions/` y agregan comandos slash adicionales.

Ejemplo:

```text
/speckit.jira.specstoissues
```

## Configuración Opcional

### .speckit.yaml

Puedes crear un archivo de configuración:

```yaml
version: "1.0"

constitution:
  path: ".specify/constitution.md"

specs:
  directory: ".specify/specs"

plans:
  directory: ".specify/plans"

tasks:
  directory: ".specify/tasks"

output:
  directory: "src"
```

## Solución de Problemas

### Error: Python no encontrado

```bash
# Instalar Python con pyenv
curl https://pyenv.run | bash

pyenv install 3.12

pyenv global 3.12
```

### Error: uv no reconocido

Añade uv al PATH:

```bash
export PATH="$HOME/.cargo/bin:$PATH"
```

### Error: specify no encontrado

Reinstala con:

---

# Página 10

> Nota: El PDF original contiene un problema de OCR en esta página y el texto aparece fragmentado carácter por carácter. Reconstruido según el contenido visible.

```bash
uv tool install --force specify-cli \
  --from git+https://github.com/github/spec-kit.git
```

---

# Página 11

# Flujo de Trabajo y Comandos

Spec-Kit proporciona cinco comandos slash que forman un flujo de trabajo completo.

## Resumen de Comandos

| Comando | Propósito | Output |
|----------|-----------|---------|
| /speckit.constitution | Definir principios | constitution.md |
| /speckit.specify | Describir requisitos | specs/*.md |
| /speckit.plan | Crear plan técnico | plans/*.md |
| /speckit.tasks | Desglosar tareas | tasks/*.md |
| /speckit.implement | Generar código | src/* |

## 1. /speckit.constitution

Define los principios fundamentales e inmutables del proyecto.

### Uso

```text
/speckit.constitution
```

### Qué Incluir

- Stack tecnológico: Lenguajes, frameworks, herramientas
- Patrones arquitectónicos: Hexagonal, Clean, etc.
- Estándares de código: Linting, formateo, testing
- Restricciones: Lo que NO se debe hacer

### Ejemplo de Output

```markdown
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
```

---

# Página 12

```markdown
- NO usar ORMs
- NO lógica en controladores
```

## 2. /speckit.specify

Describe qué debe hacer el sistema en términos funcionales.

### Uso

```text
/speckit.specify [descripción del requisito]
```

### Qué Incluir

- Comportamiento esperado del usuario
- Criterios de aceptación claros
- Casos edge y errores
- Dependencias con otras features

### Ejemplo de Output

```markdown
# Spec: Autenticación de Usuario

## Descripción

El sistema debe permitir a usuarios registrarse
e iniciar sesión de forma segura.

## Criterios de Aceptación

- [ ] Usuario puede registrarse con email/password
- [ ] Password hasheado con bcrypt
- [ ] JWT generado al login exitoso
- [ ] Token expira en 24h

## Casos de Error

- Email duplicado: Error 409
- Credenciales inválidas: Error 401
```

## 3. /speckit.plan

Crea un plan técnico detallado de cómo implementar.

### Uso

```text
/speckit.plan [referencia a spec]
```

### Qué Incluir

---

# Página 13

- Arquitectura técnica
- Decisiones de diseño y justificación
- Interfaces y contratos
- Estrategia de testing

### Ejemplo de Output

```markdown
# Plan: Autenticación

## Arquitectura

### Capas

1. Domain: User entity, AuthService interface
2. Application: RegisterUseCase, LoginUseCase
3. Infrastructure: BcryptHasher, JwtGenerator

## Interfaces

### AuthService

- register(email, password): User
- login(email, password): Token
- verify(token): User | null

## Decisiones

- JWT sobre sesiones: stateless, escalable
- Bcrypt cost 12: balance seguridad/performance
```

## 4. /speckit.tasks

Desglosa el plan en tareas ejecutables atómicas.

### Uso

```text
/speckit.tasks [referencia a plan]
```

### Características de Buenas Tareas

- Atómicas: Una sola responsabilidad
- Verificables: Criterio claro de completitud
- Ordenadas: Dependencias explícitas
- Estimables: Scope definido

### Ejemplo de Output

---

# Página 14

```markdown
# Tasks: Autenticación

## Fase 1: Domain

- [ ] 1.1 Crear User entity
- [ ] 1.2 Definir AuthService interface
- [ ] 1.3 Definir Password value object

## Fase 2: Application

- [ ] 2.1 Implementar RegisterUseCase
- [ ] 2.2 Implementar LoginUseCase
- [ ] 2.3 Tests de casos de uso

## Fase 3: Infrastructure

- [ ] 3.1 Implementar BcryptHasher
- [ ] 3.2 Implementar JwtGenerator
- [ ] 3.3 Implementar UserRepository
```

## 5. /speckit.implement

Genera código automáticamente desde las especificaciones.

### Uso

```text
/speckit.implement [referencia a tasks]
```

### Proceso

1. Lee constitution para contexto
2. Lee spec para requisitos
3. Lee plan para arquitectura
4. Ejecuta tasks secuencialmente
5. Genera código según convenciones

### Resultado

Código generado que:

- Sigue la constitution
- Cumple la spec
- Implementa el plan
- Completa las tasks

## Flujo Completo

---

# Página 15

```text
Usuario describe feature
        ↓
/speckit.constitution (si no existe)
        ↓
/speckit.specify "feature X"
        ↓
/speckit.plan "spec de feature X"
        ↓
/speckit.tasks "plan de feature X"
        ↓
/speckit.implement "tasks de feature X"
        ↓
Código listo
```

---

# Página 16

# Ejemplo Práctico

Vamos a crear una API de gestión de tareas usando Spec-Kit de principio a fin.

## Paso 1: Crear Constitution

Iniciamos el agente AI y ejecutamos:

```text
/speckit.constitution
```

Resultado: `constitution.md`

```markdown
# Constitution: Todo API

## Stack Tecnológico

- Runtime: Bun
- Framework: Hono
- Database: SQLite
- Testing: Vitest

## Principios

- API REST
- Validación con Zod
- Responses JSON
- Códigos HTTP estándar

## Estructura

src/
├── domain/
├── application/
├── infrastructure/
└── index.ts

## Restricciones

- NO frameworks ORM pesados
- NO lógica en rutas
- Máximo 150 líneas por archivo
```

## Paso 2: Especificar Feature

```text
/speckit.specify "CRUD de tareas con título, descripción y estado"
```

Resultado: `specs/todo-crud.md`

```markdown
# Spec: CRUD de Tareas

## Descripción

API REST para gestionar tareas personales.
```



# Página 17

## Entidades

### Todo

- id: string (UUID)
- title: string (1-100 chars)
- description: string (opcional, max 500)
- status: "pending" | "completed"
- createdAt: ISO date
- updatedAt: ISO date

## Endpoints

### POST /todos

Crear tarea nueva.

- Body: `{ title, description? }`
- Response: `201 + Todo`

### GET /todos

Listar todas las tareas.

- Query: `?status=pending|completed`
- Response: `200 + Todo[]`

### GET /todos/:id

Obtener tarea por ID.

- Response: `200 + Todo | 404`

### PATCH /todos/:id

Actualizar tarea.

- Body: `{ title?, description?, status? }`
- Response: `200 + Todo | 404`

### DELETE /todos/:id

Eliminar tarea.

- Response: `204 | 404`

## Paso 3: Crear Plan Técnico

```text
/speckit.plan "specs/todo-crud.md"
```

Resultado: `plans/todo-crud-plan.md`

```markdown
# Plan: CRUD de Tareas

## Arquitectura

### Domain Layer

- Todo entity con factory method
- TodoRepository interface
- Validaciones en entity

### Application Layer

- CreateTodoUseCase
- ListTodosUseCase
- GetTodoUseCase
```

---

# Página 18

```markdown
- UpdateTodoUseCase
- DeleteTodoUseCase

### Infrastructure Layer

- SQLiteTodoRepository
- Hono routes
- Zod schemas
```

## Contratos

### TodoRepository

```typescript
create(todo: Todo): Promise<Todo>
findAll(filter?): Promise<Todo[]>
findById(id): Promise<Todo | null>
update(todo: Todo): Promise<Todo>
delete(id): Promise<void>
```

## Testing

- Unit: entities y use cases
- Integration: repository + sqlite
- E2E: endpoints completos

## Paso 4: Desglosar Tasks

```text
/speckit.tasks "plans/todo-crud-plan.md"
```

Resultado: `tasks/todo-crud-tasks.md`

```markdown
# Tasks: CRUD de Tareas

## 1. Setup

- [x] Inicializar proyecto Bun
- [x] Instalar dependencias
- [x] Configurar estructura carpetas

## 2. Domain

- [ ] Crear Todo entity
- [ ] Crear TodoRepository interface
- [ ] Tests unitarios entity

## 3. Application

- [ ] CreateTodoUseCase
- [ ] ListTodosUseCase
- [ ] GetTodoUseCase
- [ ] UpdateTodoUseCase
- [ ] DeleteTodoUseCase
- [ ] Tests use cases

## 4. Infrastructure

- [ ] SQLiteTodoRepository
- [ ] Zod validation schemas
- [ ] Hono routes
- [ ] Tests integración
```

---

# Página 19

```markdown
## 5. Finalización

- [ ] Tests E2E
- [ ] Documentación API
```

## Paso 5: Implementar

```text
/speckit.implement "tasks/todo-crud-tasks.md"
```

El agente AI genera automáticamente:

### src/domain/todo.ts

```typescript
export interface Todo {
  id: string
  title: string
  description?: string
  status: 'pending' | 'completed'
  createdAt: Date
  updatedAt: Date
}

export function createTodo(
  title: string,
  description?: string
): Todo {
  return {
    id: crypto.randomUUID(),
    title,
    description,
    status: 'pending',
    createdAt: new Date(),
    updatedAt: new Date()
  }
}
```

### src/application/create-todo.ts

```typescript
import type { Todo } from '../domain/todo'
import type { TodoRepository } from '../domain/repository'
import { createTodo } from '../domain/todo'

export class CreateTodoUseCase {
  constructor(private repo: TodoRepository) {}

  async execute(
    title: string,
    description?: string
  ): Promise<Todo> {

    const todo = createTodo(title, description)

    return this.repo.create(todo)
```

---

# Página 20

```typescript
  }
}
```

## Resultado Final

Estructura generada:

```text
src/
├── domain/
│   ├── todo.ts
│   └── repository.ts
├── application/
│   ├── create-todo.ts
│   ├── list-todos.ts
│   ├── get-todo.ts
│   ├── update-todo.ts
│   └── delete-todo.ts
├── infrastructure/
│   ├── sqlite-repository.ts
│   ├── schemas.ts
│   └── routes.ts
└── index.ts
```

---

# Página 21

# Mejores Prácticas

## Escribiendo Buenas Especificaciones

### 1. Sé Específico, No Ambiguo

#### Malo

```text
El usuario puede crear tareas fácilmente.
```

#### Bueno

```text
El usuario puede crear tareas mediante POST /todos
con título (requerido, 1-100 chars) y descripción
(opcional, max 500 chars).
```

### 2. Define Criterios de Aceptación Claros

Usa checkboxes verificables:

```markdown
## Criterios de Aceptación

- [ ] Título vacío retorna 400
- [ ] Título > 100 chars retorna 400
- [ ] Creación exitosa retorna 201 + Todo
- [ ] Todo incluye id generado UUID
```

### 3. Documenta Casos Edge

```markdown
## Casos Edge

- Título con solo espacios: Trim y validar vacío
- Descripción null vs undefined: Tratados igual
- ID inexistente: 404 con mensaje claro
```

### 4. Mantén Especificaciones Atómicas

Una spec por feature. Evita specs monolíticas.

### Constitution Efectiva

#### Principios sobre Tecnologías

##### Malo

```text
Usar React 18.2.0
```

---

# Página 22

##### Bueno

```text
UI declarativa con estado predecible.
Framework: React (versión estable actual).
```

## Restricciones Explícitas

Las restricciones previenen errores:

```markdown
## Restricciones

- NO mutación directa de estado
- NO any en TypeScript
- NO console.log en producción
- NO dependencias sin tipos
```

# Errores Comunes

## 1. Saltarse la Constitution

**Problema:** Sin constitution, cada spec puede contradecir a otras.

**Solución:** Siempre crear constitution primero.

## 2. Specs Demasiado Técnicas

**Problema:** Mezclar “qué” con “cómo”.

### Malo

```text
Usar bcrypt con cost 12 para hashear.
```

### Bueno en Spec

```text
Passwords almacenados de forma segura e irreversible.
```

### Bueno en Plan

```text
Implementar con bcrypt, cost 12.
```

## 3. Tasks No Atómicas

**Problema:** Tasks que toman días o son ambiguas.

### Malo

---

# Página 23

```markdown
- [ ] Implementar autenticación
```

### Bueno

```markdown
- [ ] Crear User entity
- [ ] Crear AuthService interface
- [ ] Implementar RegisterUseCase
- [ ] Tests RegisterUseCase
```

## 4. Ignorar Refinamiento

**Problema:** Implementar specs incompletas.

**Solución:** Iterar specs hasta que estén claras.

```text
specify → revisar → ajustar → specify → ...
```

# Patrones de Integración

## Con Git

```bash
# Branch por spec
git checkout -b spec/user-auth

# Commit constitution
git add .specify/constitution.md
git commit -m "spec: add project constitution"

# Commit spec
git add .specify/specs/
git commit -m "spec: user authentication requirements"

# Commit implementation
git add src/
git commit -m "feat: implement user authentication"
```

## Con CI/CD

```yaml
# .github/workflows/specs.yml

name: Validate Specs

on: [push]

jobs:
  validate:
    runs-on: ubuntu-latest

    steps:
```

---

# Página 24

```yaml
- uses: actions/checkout@v4

- name: Check spec completeness
  run: |
    # Verificar que cada spec tiene plan
    # Verificar que cada plan tiene tasks
```

## Con Code Review

- PR de Spec: Revisar requisitos antes de codificar
- PR de Plan: Revisar arquitectura antes de implementar
- PR de Code: Verificar que código cumple spec

# Checklist de Calidad

## Antes de Implementar

- Constitution documenta stack completo
- Spec tiene criterios de aceptación
- Spec cubre casos de error
- Plan define interfaces claras
- Tasks son atómicas y verificables

## Después de Implementar

- Código sigue constitution
- Todos los criterios de aceptación pasan
- Tests cubren casos documentados
- Specs actualizadas si hubo cambios

## Recursos Adicionales

# Conclusión

Spec-Kit transforma el desarrollo haciendo que las especificaciones sean ciudadanos de primera clase.

Con práctica, el flujo:

```text
spec → plan → tasks → implement
```

se vuelve natural y produce código de mayor calidad.

## Recursos

- Repositorio Spec-Kit
- Ejemplos de Specs
