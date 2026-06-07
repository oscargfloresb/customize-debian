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
