# LLM Ask - Integración de Mistral AI con Bash

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)

**LLM Ask** es un script de Bash que permite interactuar con la API de Mistral AI directamente desde la terminal. Facilita la integración de modelos de lenguaje grande (LLM) en flujos de trabajo de línea de comandos, automatización de scripts y generación de código.

## 📋 Características

- ✅ Realizar consultas genéricas a Mistral AI
- ✅ Explicar comandos de Linux
- ✅ Generar scripts de Bash automáticamente
- ✅ Instalar alias para uso como pipe
- ✅ Integración nativa con la terminal
- ✅ Configuración personalizable

## 🚀 Requisitos Previos

Antes de usar LLM Ask, asegúrate de tener instalados los siguientes paquetes:

- **curl** - Para hacer peticiones HTTP a la API
- **jq** - Para procesar respuestas JSON
- **API Key de Mistral** - Clave de autenticación para la API

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

### 1. Configurar la API Key

Crea una variable de entorno con tu clave de API de Mistral:

```bash
# Añade esto a tu ~/.bashrc o ~/.zshrc
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

Para instalar el alias `mistral` que permite usar el script como pipe:

```bash
llm_ask.sh --install
# o
llm_ask.sh -i
```

Esto añadirá el alias a tu `~/.bash_aliases`. Necesitarás recargar tu terminal:

```bash
source ~/.bash_aliases
```

## 📖 Uso

### Comandos disponibles

```
llm_ask [OPCIONES]

Opciones:
  -a, --ask TEXT          Realiza una pregunta genérica
  -e, --explain COMMAND   Explica un comando de Linux
  -s, --create-script DESC  Genera un script de Bash
  -i, --install           Instala el alias para pipe
  -h, --help              Muestra esta ayuda
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

#### 🔗 Usar como pipe (requiere alias instalado)

```bash
# Instalar alias primero
llm_ask.sh --install

# Luego recargar
echo "¿Cuál es la capital de Francia?" | mistral

# Procesar salida de un comando
df -h | mistral "Analiza el uso de disco"

# Encadenar comandos
cat config.json | mistral "Convierte este JSON a YAML"
```

## ⚙️ Configuración

### Variables de entorno

Puedes personalizar el comportamiento del script modificando las siguientes variables:

```bash
# URL de la API (por defecto: https://api.mistral.ai/v1/chat/completions)
export LLM_URL='https://api.mistral.ai/v1/chat/completions'

# Modelo a usar (por defecto: mistral-tiny)
export LLM_MODEL='mistral-small'

# Clave API (requerida)
export MISTRAL_API_KEY='tu_api_key'
```

### Modelos disponibles

- `mistral-tiny` - Modelo más rápido y económico (por defecto)
- `mistral-small` - Modelo equilibrado
- `mistral-medium` - Modelo más potente

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

**Nota:** Este script está probado en Linux Mint pero debería funcionar en cualquier distribución de Linux con Bash instalado.

*Made with ❤️ for the CLI community*

