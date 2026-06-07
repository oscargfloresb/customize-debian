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
