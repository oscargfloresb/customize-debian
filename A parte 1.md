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
