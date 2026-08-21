# LLM Ask - Integración de Mistral AI y Lemonade AI con Bash

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)

**LLM Ask** es un script de Bash que permite interactuar con la API de Mistral AI o con un servidor de [Lemonade AI](https://lemonade-server.ai/) directamente desde la terminal. Facilita la integración de modelos de lenguaje grande (LLM) en flujos de trabajo de línea de comandos, automatización de scripts y generación de código.

## 📋 Características

- ✅ Realizar consultas genéricas a Mistral AI o a un servidor Lemonade
- ✅ Explicar comandos de Linux
- ✅ Generar scripts de Bash automáticamente
- ✅ Instalar alias para uso como pipe
- ✅ Integración nativa con la terminal
- ✅ Configuración personalizable

## 🚀 Requisitos Previos

Antes de usar LLM Ask, asegúrate de tener instalados los siguientes paquetes:

- **curl** - Para hacer peticiones HTTP a la API
- **jq** - Para procesar respuestas JSON
- **API Key de Mistral** - Clave de autenticación para la API (si usas Mistral)
- **Servidor Lemonade** - Un servidor [Lemonade](https://lemonade-server.ai/) accesible y su API key (si usas Lemonade)

### Instalación de dependencias en Ubuntu/Debian:

```bash
sudo apt update && sudo apt install -y curl jq
```

### Instalación de dependencias en Fedora/RHEL:

```bash
sudo dnf install -y curl jq
```

### Instalación de dependencias en Arch Linux:

```bash
sudo pacman -S curl jq
```

## 🔧 Instalación

### 1. Configurar el proveedor y la API Key

Por defecto se usa Mistral. Crea una variable de entorno con tu clave de API:

```bash
# Añade esto a tu ~/.bashrc o ~/.zshrc
export MISTRAL_API_KEY="tu_api_key_aqui"

# Recarga la configuración
source ~/.bashrc
```

Si quieres usar una LLM hosteada en un servidor Lemonade, indica el proveedor,
la dirección del servidor y la API key de Lemonade:

```bash
# Añade esto a tu ~/.bashrc o ~/.zshrc
export LLM_PROVIDER="lemonade"
export LEMONADE_URL="http://mi-servidor:8000"
export LEMONADE_API_KEY="tu_api_key_de_lemonade"
export LEMONADE_MODEL="Llama-3.2-1B-Instruct-Hybrid"

# Recarga la configuración
source ~/.bashrc
```

### 2. Instalar el script

#### Opción A: Instalación manual

1. Clona este repositorio:
   ```bash
   git clone https://github.com/GabrielReusRodriguez/LLM_ask.git
   cd LLM_ask
   ```

2. Haz el script ejecutable:
   ```bash
   chmod +x src/llm_ask.sh
   ```

3. Ejecuta directamente:
   ```bash
   ./src/llm_ask.sh -h
   ```

#### Opción B: Instalación sistema (recomendado)

Ejecuta el script de instalación:

```bash
./install/install.sh
```

Esto copiará el script a `/usr/local/bin/llm` para que esté disponible globalmente.

### 3. Instalar alias (opcional)

Para instalar el alias `umbrosio` que permite usar el script como pipe:

```bash
llm_ask.sh --install
# o
llm_ask.sh -i
```

Esto añadirá el alias a tu `~/.bash_aliases`. Necesitarás recargar tu terminal:

```bash
source ~/.bash_aliases
```

> **Nota:** en versiones anteriores este alias se llamaba `mistral`. Si ya lo tenías
> instalado, el script te avisará para que borres a mano la función `mistral()` de
> tu `~/.bash_aliases`.

## 📖 Uso

### Comandos disponibles

```
llm_ask [OPCIONES]

Opciones:
  -a, --ask TEXT             Realiza una pregunta genérica
  -e, --explain COMMAND      Explica un comando de Linux
  -s, --create-script DESC   Genera un script de Bash
  -P, --pipe [TEXT]          Lee la entrada estándar y la envía al LLM
  -i, --install              Instala el alias para pipe
  -p, --provider PROVIDER    Proveedor a usar: mistral (por defecto) o lemonade
  -m, --model MODEL          Modelo a usar
  -k, --api-key KEY          API key del proveedor
  -u, --url URL              URL del servidor del LLM
  -h, --help                 Muestra esta ayuda
```

### Ejemplos prácticos

#### 🔍 Realizar una pregunta genérica

```bash
# Pregunta directa
llm_ask.sh --ask "¿Cómo funciona git rebase?"

# o
llm_ask.sh -a "Explica el concepto de virtualización"
```

#### 📚 Explicar un comando de Linux

```bash
# Explicar comando ls
llm_ask.sh --explain "ls -la"

# o
llm_ask.sh -e "grep -r pattern ."
```

#### 💻 Generar un script de Bash

```bash
# Generar un script de backup
llm_ask.sh --create-script "crear un script de backup de bases de datos MySQL"

# o
llm_ask.sh -s "generar un script que monitoree el uso de CPU"
```

#### 🍋 Usar una LLM hosteada en un servidor Lemonade

```bash
# Con las variables de entorno de Lemonade ya exportadas
llm_ask.sh --provider lemonade --ask "¿Qué es una NPU?"

# Informando el servidor, la api key y el modelo por parámetro
llm_ask.sh -p lemonade \
    -u "http://mi-servidor:8000" \
    -k "tu_api_key_de_lemonade" \
    -m "Qwen3-0.6B-GGUF" \
    -a "Resume qué es Lemonade Server"
```

En `--url` puedes indicar tanto la dirección base del servidor
(`http://mi-servidor:8000`) como el endpoint completo
(`http://mi-servidor:8000/api/v1/chat/completions`); el script completa la ruta
por ti.

#### 🔗 Usar como pipe (requiere alias instalado)

```bash
# Instalar alias primero
llm_ask.sh --install

# Luego recargar
echo "¿Cuál es la capital de Francia?" | umbrosio

# Procesar salida de un comando
df -h | umbrosio "Analiza el uso de disco"

# Encadenar comandos
cat config.json | umbrosio "Convierte este JSON a YAML"

# El alias respeta el proveedor configurado
LLM_PROVIDER=lemonade dmesg | umbrosio "Busca errores de hardware"
```

También puedes usar el modo pipe sin instalar el alias:

```bash
df -h | llm_ask.sh --pipe "Analiza el uso de disco"
```

## ⚙️ Configuración

### Variables de entorno

Puedes personalizar el comportamiento del script modificando las siguientes variables:

| Variable | Descripción |
| --- | --- |
| `LLM_PROVIDER` | Proveedor a usar: `mistral` (por defecto) o `lemonade` |
| `LLM_URL` | URL del endpoint, tiene prioridad sobre la del proveedor |
| `LLM_MODEL` | Modelo a usar, tiene prioridad sobre el del proveedor |
| `LLM_API_KEY` | API key, tiene prioridad sobre la del proveedor |
| `MISTRAL_API_KEY` | API key de Mistral (requerida con el proveedor `mistral`) |
| `MISTRAL_URL` | URL de la API de Mistral |
| `MISTRAL_MODEL` | Modelo de Mistral |
| `LEMONADE_API_KEY` | API key de Lemonade |
| `LEMONADE_URL` | Dirección del servidor Lemonade o endpoint completo |
| `LEMONADE_MODEL` | Modelo cargado en el servidor Lemonade |

```bash
# Ejemplo con Mistral
export MISTRAL_API_KEY='tu_api_key'
export MISTRAL_MODEL='mistral-small'

# Ejemplo con Lemonade
export LLM_PROVIDER='lemonade'
export LEMONADE_URL='http://mi-servidor:8000'
export LEMONADE_API_KEY='tu_api_key_de_lemonade'
export LEMONADE_MODEL='Qwen3-0.6B-GGUF'
```

### Proveedores y valores por defecto

| Proveedor | URL por defecto | Modelo por defecto | API key |
| --- | --- | --- | --- |
| `mistral` | `https://api.mistral.ai/v1/chat/completions` | `mistral-tiny` | Obligatoria |
| `lemonade` | `http://localhost:8000/api/v1/chat/completions` | `Llama-3.2-1B-Instruct-Hybrid` | Opcional |

La API key de Lemonade es opcional porque un servidor local no la valida, pero si
la informas se envía en la cabecera `Authorization: Bearer`.

### Modelos disponibles

Mistral:

- `mistral-tiny` - Modelo más rápido y económico (por defecto)
- `mistral-small` - Modelo equilibrado
- `mistral-medium` - Modelo más potente

Lemonade: los modelos que tengas descargados en tu servidor, por ejemplo
`Llama-3.2-1B-Instruct-Hybrid` o `Qwen3-0.6B-GGUF`. Puedes consultarlos con:

```bash
curl -s http://mi-servidor:8000/api/v1/models | jq -r '.data[].id'
```

## 📁 Estructura del proyecto

```
LLM_ask/
├── README.md           # Documentación
├── LICENSE             # Licencia GPLv3
├── install/
│   └── install.sh      # Script de instalación
└── src/
    └── llm_ask.sh      # Script principal
```

## 🤝 Contribuir

Las contribuciones son bienvenidas. Para contribuir:

1. Haz un fork del proyecto
2. Crea una nueva rama (`git checkout -b feature/nueva-funcionalidad`)
3. Realiza tus cambios
4. Haz commit de los cambios (`git commit -m "Añade nueva funcionalidad"`)
5. Haz push a la rama (`git push origin feature/nueva-funcionalidad`)
6. Abre un Pull Request

## 🐛 Reportar problemas

Si encuentras algún problema o tienes sugerencias, por favor abre un issue en el repositorio.

## 📜 Licencia

Este proyecto está licenciado bajo la **GNU General Public License v3.0** - ver el archivo [LICENSE](LICENSE) para más detalles.

## 📞 Contacto

- **Autor:** Gabriel Reus
- **GitHub:** [https://github.com/GabrielReusRodriguez/](https://github.com/GabrielReusRodriguez/)

---

**Nota:** Este script está probado en Linux Mint con Mistral y Lemonade, pero debería funcionar en cualquier distribución de Linux con Bash instalado.

*Made with ❤️ for the CLI community*

