# Umbrosio - Integración de Lemonade AI y Mistral AI con Bash

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)

**Umbrosio** es un script de Bash que permite interactuar con un servidor de [Lemonade AI](https://lemonade-server.ai/) o con la API de Mistral AI directamente desde la terminal. Facilita la integración de modelos de lenguaje grande (LLM) en flujos de trabajo de línea de comandos, automatización de scripts y generación de código. El comando de terminal es `umbrosio`.

## 📋 Características

- ✅ Realizar consultas genéricas a un servidor Lemonade o a Mistral AI
- ✅ Explicar comandos de Linux
- ✅ Generar scripts de Bash automáticamente
- ✅ Instalar el comando `umbrosio` para usarlo desde cualquier terminal
- ✅ Integración nativa con la terminal
- ✅ Configuración personalizable

## 🚀 Requisitos Previos

Antes de usar Umbrosio, asegúrate de tener instalados los siguientes paquetes:

- **curl** - Para hacer peticiones HTTP a la API
- **jq** - Para procesar respuestas JSON
- **Servidor Lemonade** - Un servidor [Lemonade](https://lemonade-server.ai/) accesible y su API key (proveedor por defecto)
- **API Key de Mistral** - Clave de autenticación para la API (si usas Mistral)

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

Por defecto se usa Lemonade. Indica la dirección del servidor, la API key de
Lemonade y el modelo que tengas cargado:

```bash
# Añade esto a tu ~/.bashrc o ~/.zshrc
export LEMONADE_URL="http://mi-servidor:8000"
export LEMONADE_API_KEY="tu_api_key_de_lemonade"
export LEMONADE_MODEL="Llama-3.2-1B-Instruct-Hybrid"

# Recarga la configuración
source ~/.bashrc
```

Si tu servidor Lemonade escucha en `http://localhost:8000` y no valida la API
key, no necesitas configurar nada.

Si quieres usar Mistral, indica el proveedor y tu clave de API:

```bash
# Añade esto a tu ~/.bashrc o ~/.zshrc
export LLM_PROVIDER="mistral"
export MISTRAL_API_KEY="tu_api_key_aqui"

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
   chmod +x src/umbrosio
   ```

3. Ejecuta directamente:
   ```bash
   ./src/umbrosio -h
   ```

#### Opción B: Instalación sistema (recomendado)

Instala el comando en `/usr/local/bin` desde el propio script:

```bash
./src/umbrosio --install
# o
./src/umbrosio -i
```

Esto copiará el script a `/usr/local/bin/umbrosio` y le dará permisos de ejecución para que esté disponible globalmente. Si no tienes permisos de escritura en `/usr/local/bin`, se usará `sudo`.

## 📖 Uso

### Comandos disponibles

```
umbrosio [OPCIONES]

Opciones:
  -a, --ask TEXT             Realiza una pregunta genérica
  -e, --explain COMMAND      Explica un comando de Linux
  -s, --create-script DESC   Genera un script de Bash
  -P, --pipe [TEXT]          Lee la entrada estándar y la envía al LLM
  -i, --install              Instala umbrosio en /usr/local/bin
  -p, --provider PROVIDER    Proveedor a usar: lemonade (por defecto) o mistral
  -m, --model MODEL          Modelo a usar
  -k, --api-key KEY          API key del proveedor
  -u, --url URL              URL del servidor del LLM
  -h, --help                 Muestra esta ayuda
```

### Ejemplos prácticos

#### 🔍 Realizar una pregunta genérica

```bash
# Pregunta directa
umbrosio --ask "¿Cómo funciona git rebase?"

# o
umbrosio -a "Explica el concepto de virtualización"
```

#### 📚 Explicar un comando de Linux

```bash
# Explicar comando ls
umbrosio --explain "ls -la"

# o
umbrosio -e "grep -r pattern ."
```

#### 💻 Generar un script de Bash

```bash
# Generar un script de backup
umbrosio --create-script "crear un script de backup de bases de datos MySQL"

# o
umbrosio -s "generar un script que monitoree el uso de CPU"
```

#### 🍋 Usar una LLM hosteada en un servidor Lemonade

Es el proveedor por defecto, así que basta con tener sus variables de entorno
exportadas:

```bash
umbrosio --ask "¿Qué es una NPU?"
```

También puedes informar el servidor, la api key y el modelo por parámetro:

```bash
umbrosio -u "http://mi-servidor:8000" \
    -k "tu_api_key_de_lemonade" \
    -m "Qwen3-0.6B-GGUF" \
    -a "Resume qué es Lemonade Server"
```

En `--url` puedes indicar tanto la dirección base del servidor
(`http://mi-servidor:8000`) como el endpoint completo
(`http://mi-servidor:8000/api/v1/chat/completions`); el script completa la ruta
por ti.

#### 🌩️ Usar Mistral AI

```bash
umbrosio --provider mistral --ask "¿Cómo funciona git rebase?"

# o con la api key y el modelo por parámetro
umbrosio -p mistral -k "tu_api_key" -m "mistral-small" -a "Explica el concepto de virtualización"
```

#### 🔗 Usar como pipe

Si llega texto por la entrada estándar, `umbrosio` lo envía al LLM. Con el comando
en PATH no hace falta nada más:

```bash
echo "¿Cuál es la capital de Francia?" | umbrosio

# Procesar salida de un comando
df -h | umbrosio "Analiza el uso de disco"

# Encadenar comandos
cat config.json | umbrosio "Convierte este JSON a YAML"

# El comando respeta el proveedor configurado
LLM_PROVIDER=mistral dmesg | umbrosio "Busca errores de hardware"
```

También puedes forzar el modo pipe con `--pipe`:

```bash
df -h | umbrosio --pipe "Analiza el uso de disco"
```

## ⚙️ Configuración

### Variables de entorno

Puedes personalizar el comportamiento del script modificando las siguientes variables:

| Variable | Descripción |
| --- | --- |
| `LLM_PROVIDER` | Proveedor a usar: `lemonade` (por defecto) o `mistral` |
| `LLM_URL` | URL del endpoint, tiene prioridad sobre la del proveedor |
| `LLM_MODEL` | Modelo a usar, tiene prioridad sobre el del proveedor |
| `LLM_API_KEY` | API key, tiene prioridad sobre la del proveedor |
| `LEMONADE_API_KEY` | API key de Lemonade |
| `LEMONADE_URL` | Dirección del servidor Lemonade o endpoint completo |
| `LEMONADE_MODEL` | Modelo cargado en el servidor Lemonade |
| `MISTRAL_API_KEY` | API key de Mistral (requerida con el proveedor `mistral`) |
| `MISTRAL_URL` | URL de la API de Mistral |
| `MISTRAL_MODEL` | Modelo de Mistral |

```bash
# Ejemplo con Lemonade
export LEMONADE_URL='http://mi-servidor:8000'
export LEMONADE_API_KEY='tu_api_key_de_lemonade'
export LEMONADE_MODEL='Qwen3-0.6B-GGUF'

# Ejemplo con Mistral
export LLM_PROVIDER='mistral'
export MISTRAL_API_KEY='tu_api_key'
export MISTRAL_MODEL='mistral-small'
```

### Proveedores y valores por defecto

| Proveedor | URL por defecto | Modelo por defecto | API key |
| --- | --- | --- | --- |
| `lemonade` (por defecto) | `http://localhost:8000/api/v1/chat/completions` | `Llama-3.2-1B-Instruct-Hybrid` | Opcional |
| `mistral` | `https://api.mistral.ai/v1/chat/completions` | `mistral-tiny` | Obligatoria |

La API key de Lemonade es opcional porque un servidor local no la valida, pero si
la informas se envía en la cabecera `Authorization: Bearer`.

### Modelos disponibles

Lemonade: los modelos que tengas descargados en tu servidor, por ejemplo
`Llama-3.2-1B-Instruct-Hybrid` (por defecto) o `Qwen3-0.6B-GGUF`. Puedes
consultarlos con:

```bash
curl -s http://mi-servidor:8000/api/v1/models | jq -r '.data[].id'
```

Mistral:

- `mistral-tiny` - Modelo más rápido y económico (por defecto)
- `mistral-small` - Modelo equilibrado
- `mistral-medium` - Modelo más potente

## 📁 Estructura del proyecto

```
LLM_ask/                # repositorio de Umbrosio
├── README.md           # Documentación
├── LICENSE             # Licencia GPLv3
└── src/
    └── umbrosio         # Comando principal
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

**Nota:** Este script está probado en Linux Mint con Lemonade y Mistral, pero debería funcionar en cualquier distribución de Linux con Bash instalado.

*Made with ❤️ for the CLI community*

