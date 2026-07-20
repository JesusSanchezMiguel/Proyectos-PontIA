# 🚀 Proyectos PontIA

Repositorio con los proyectos desarrollados durante el Máster de Inteligencia Artificial de PontIA. Cada proyecto aborda un área diferente del ecosistema de la IA, desde el desarrollo de aplicaciones con LLMs y agentes inteligentes hasta el procesamiento de lenguaje natural y el análisis de datos.

## 📂 Estructura del repositorio

```
Proyectos-PontIA/
│
├── Proyecto-LLMs/
├── Proyecto-Prompts/
└── Proyecto-Jupiter/
```

---

# 1️⃣ Proyecto LLMs

## 📖 Descripción

Este proyecto desarrolla un asistente conversacional basado en un modelo de OpenAI gobernado mediante un **agente**, capaz de utilizar herramientas externas para responder preguntas de forma más precisa.

El agente dispone de dos herramientas principales:

- 📚 **RAG (Retrieval-Augmented Generation)** para consultar información contenida en un documento proporcionado.
- 🌤️ **Consulta a una API meteorológica** para obtener información del tiempo en tiempo real.

De esta forma, el agente decide cuándo utilizar cada herramienta antes de generar la respuesta final.

## Tecnologías utilizadas

- Python
- OpenAI API
- LangChain
- Agentes
- RAG
- APIs REST

## Funcionalidades

- Chat con un LLM de OpenAI.
- Uso de agentes para decidir qué herramienta utilizar.
- Consulta documental mediante RAG.
- Consulta meteorológica mediante API externa.
- Respuestas enriquecidas combinando conocimiento del modelo y datos externos.

---

# 2️⃣ Proyecto Prompts

## 📖 Descripción

Este proyecto implementa un pipeline de procesamiento de lenguaje natural utilizando modelos de Hugging Face.

El flujo completo consta de tres etapas:

### 1. Filtrado de reseñas

Se analizan reseñas de videojuegos para seleccionar únicamente aquellas que contienen información relevante.

### 2. Análisis mediante LLM

Las reseñas seleccionadas son procesadas por un primer modelo de lenguaje que realiza un análisis del contenido.

### 3. Extracción estructurada

Un segundo modelo transforma la información obtenida en un **JSON estructurado**, facilitando su posterior explotación.

## Tecnologías utilizadas

- Python
- Hugging Face Transformers
- Pipeline NLP
- JSON
- Prompt Engineering

## Flujo del proyecto

```
Reseñas
      │
      ▼
Filtrado
      │
      ▼
LLM Análisis
      │
      ▼
LLM → JSON estructurado
```

---

# 3️⃣ Proyecto Júpiter

## 📖 Descripción

Proyecto final del Máster de Inteligencia Artificial.

El objetivo consiste en transformar y analizar datos de emociones obtenidos de un parque de atracciones para generar indicadores de negocio (KPIs).

El proyecto incluye todo el ciclo de análisis de datos:

1. Lectura de archivos JSON.
2. Conversión a DataFrames de Pandas.
3. Limpieza y transformación de datos.
4. Análisis Exploratorio de Datos (EDA).
5. Creación de un DataFrame consolidado.
6. Diseño de una base de datos.
7. Carga de los datos.
8. Obtención de KPIs.

## Tecnologías utilizadas

- Python
- Pandas
- NumPy
- Matplotlib
- Seaborn
- SQL
- Bases de datos
- Jupyter Notebook

## Flujo del proyecto

```
JSON
 │
 ▼
DataFrames
 │
 ▼
Limpieza
 │
 ▼
EDA
 │
 ▼
DataFrame General
 │
 ▼
Base de Datos
 │
 ▼
KPIs
```

---

# 🛠 Tecnologías utilizadas

- Python
- OpenAI API
- LangChain
- Hugging Face Transformers
- Pandas
- NumPy
- SQL
- APIs REST
- Jupyter Notebook
- Prompt Engineering
- Retrieval-Augmented Generation (RAG)

---

# 🎯 Objetivos del repositorio

Este repositorio reúne distintos proyectos prácticos desarrollados durante el Máster de IA de PontIA, mostrando competencias en:

- Desarrollo de aplicaciones con LLMs.
- Construcción de agentes inteligentes.
- Implementación de sistemas RAG.
- Integración con APIs externas.
- Prompt Engineering.
- Procesamiento del Lenguaje Natural (NLP).
- Análisis y limpieza de datos.
- Análisis exploratorio (EDA).
- Modelado y explotación de bases de datos.
- Obtención de indicadores de negocio (KPIs).

---

# 👨‍💻 Autor

**[Jesus Sanchez Miguel]**

Repositorio desarrollado como parte del **Máster de Inteligencia Artificial de PontIA**.
