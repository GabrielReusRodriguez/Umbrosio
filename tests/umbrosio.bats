#!/usr/bin/env bats

load helpers/test_helper

setup() {
  umbrosio_setup
}

@test "muestra la ayuda con --help" {
  run "${UMBROSIO}" --help
  [ "$status" -eq 0 ]
  [[ "$output" == *"umbrosio"* ]]
  [[ "$output" == *"--ask"* ]]
  [[ "$output" == *"--provider"* ]]
}

@test "muestra la ayuda con -h" {
  run "${UMBROSIO}" -h
  [ "$status" -eq 0 ]
  [[ "$output" == *"Usage: umbrosio"* ]]
}

@test "falla con una opcion no soportada" {
  run "${UMBROSIO}" --no-existe
  [ "$status" -ne 0 ]
}

@test "sin accion en un TTY muestra error" {
  run script -qefc "${UMBROSIO}" /dev/null
  [ "$status" -eq 1 ]
  [[ "$output" == *"Error, executed without action"* ]]
}

@test "mistral sin api key falla" {
  run "${UMBROSIO}" --provider mistral --ask "hola"
  [ "$status" -eq 1 ]
  [[ "$output" == *"api key de Mistral"* ]]
}

@test "proveedor desconocido falla" {
  run "${UMBROSIO}" --provider openai --ask "hola"
  [ "$status" -eq 1 ]
  [[ "$output" == *"proveedor no soportado"* ]]
}

@test "ask con lemonade usa el endpoint por defecto y devuelve la respuesta" {
  run "${UMBROSIO}" --ask "hola"
  [ "$status" -eq 0 ]
  [ "$output" = "respuesta-mock" ]
  [ "$(curl_log_url)" = "http://localhost:8000/api/v1/chat/completions" ]
  [ "$(request_json_field '.model')" = "Llama-3.2-1B-Instruct-Hybrid" ]
  [ "$(request_json_field '.messages[0].content')" = "hola" ]
  [ "$(request_json_field '.stream')" = "false" ]
}

@test "normaliza la url base de lemonade" {
  run "${UMBROSIO}" -u "http://mi-servidor:8000" --ask "ping"
  [ "$status" -eq 0 ]
  [ "$(curl_log_url)" = "http://mi-servidor:8000/api/v1/chat/completions" ]
}

@test "normaliza la url de lemonade que termina en /api/v1" {
  run "${UMBROSIO}" -u "http://mi-servidor:8000/api/v1" --ask "ping"
  [ "$status" -eq 0 ]
  [ "$(curl_log_url)" = "http://mi-servidor:8000/api/v1/chat/completions" ]
}

@test "respeta el endpoint completo de lemonade" {
  run "${UMBROSIO}" -u "http://mi-servidor:8000/api/v1/chat/completions" --ask "ping"
  [ "$status" -eq 0 ]
  [ "$(curl_log_url)" = "http://mi-servidor:8000/api/v1/chat/completions" ]
}

@test "mistral con api key llama al endpoint oficial" {
  run "${UMBROSIO}" --provider mistral --api-key "secreto" --ask "hola"
  [ "$status" -eq 0 ]
  [ "$output" = "respuesta-mock" ]
  [ "$(curl_log_url)" = "https://api.mistral.ai/v1/chat/completions" ]
  [ "$(request_json_field '.model')" = "mistral-tiny" ]
  grep -qx 'arg=Authorization: Bearer secreto' "${CURL_LOG}"
}

@test "lemonade sin api key no envia Authorization" {
  run "${UMBROSIO}" --ask "hola"
  [ "$status" -eq 0 ]
  ! grep -q '^arg=Authorization:' "${CURL_LOG}"
}

@test "lemonade con api key envia Authorization" {
  run "${UMBROSIO}" -k "lemon-key" --ask "hola"
  [ "$status" -eq 0 ]
  grep -qx 'arg=Authorization: Bearer lemon-key' "${CURL_LOG}"
}

@test "el modelo por parametro tiene prioridad" {
  run "${UMBROSIO}" -m "Qwen3-0.6B-GGUF" --ask "hola"
  [ "$status" -eq 0 ]
  [ "$(request_json_field '.model')" = "Qwen3-0.6B-GGUF" ]
}

@test "explain envia el prompt de explicacion" {
  run "${UMBROSIO}" --explain "ls -la"
  [ "$status" -eq 0 ]
  [ "$(request_json_field '.messages[0].content')" = "Explica el comando ls -la en Linux" ]
}

@test "create-script envia el prompt de generacion" {
  run "${UMBROSIO}" --create-script "hacer un backup"
  [ "$status" -eq 0 ]
  [ "$(request_json_field '.messages[0].content')" = "Genera un script de Bash que hacer un backup" ]
}

@test "modo pipe concatena prompt y stdin" {
  run bash -c "printf 'salida-df\n' | '${UMBROSIO}' 'Analiza el disco'"
  [ "$status" -eq 0 ]
  [ "$output" = "respuesta-mock" ]
  [ "$(request_json_field '.messages[0].content')" = $'Analiza el disco\nsalida-df' ]
}

@test "la opcion --pipe fuerza el modo pipe" {
  run bash -c "printf 'texto\n' | '${UMBROSIO}' --pipe 'Resume'"
  [ "$status" -eq 0 ]
  [ "$(request_json_field '.messages[0].content')" = $'Resume\ntexto' ]
}

@test "LLM_PROVIDER=mistral exige api key" {
  LLM_PROVIDER=mistral run "${UMBROSIO}" --ask "hola"
  [ "$status" -eq 1 ]
  [[ "$output" == *"api key de Mistral"* ]]
}

@test "install crea el alias en HOME temporal" {
  run "${UMBROSIO}" --install
  [ "$status" -eq 0 ]
  [[ "$output" == *"Se ha instalado el alias umbrosio"* ]]
  [ -f "${HOME}/.bash_aliases" ]
  grep -q "umbrosio() { # Alias installed" "${HOME}/.bash_aliases"
  grep -q "${UMBROSIO}" "${HOME}/.bash_aliases"
}

@test "install sustituye un alias umbrosio previo" {
  cat > "${HOME}/.bash_aliases" <<'EOF'
umbrosio() { # Alias installed
    echo antiguo
}
EOF
  run "${UMBROSIO}" --install
  [ "$status" -eq 0 ]
  [[ "$output" == *"Se ha actualizado el alias umbrosio"* ]]
  [ "$(grep -c 'umbrosio() { # Alias installed' "${HOME}/.bash_aliases")" -eq 1 ]
  grep -q "${UMBROSIO}" "${HOME}/.bash_aliases"
  ! grep -q "echo antiguo" "${HOME}/.bash_aliases"
}
