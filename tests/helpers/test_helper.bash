# shellcheck shell=bash

UMBROSIO="$(cd "${BATS_TEST_DIRNAME}/../src" && pwd)/umbrosio"
HELPERS="$(cd "${BATS_TEST_DIRNAME}/helpers" && pwd)"

umbrosio_setup() {
  export HOME="${BATS_TEST_TMPDIR}/home"
  mkdir -p "${HOME}"

  export CURL_LOG="${BATS_TEST_TMPDIR}/curl.log"
  : > "${CURL_LOG}"
  rm -f "${CURL_LOG}.body"

  # El mock se invoca como "curl": el fichero debe llamarse exactamente así.
  local mock_bin="${BATS_TEST_TMPDIR}/bin"
  mkdir -p "${mock_bin}"
  ln -sf "${HELPERS}/mock_curl" "${mock_bin}/curl"
  export PATH="${mock_bin}:${PATH}"

  unset LLM_PROVIDER LLM_URL LLM_MODEL LLM_API_KEY
  unset MISTRAL_API_KEY MISTRAL_URL MISTRAL_MODEL
  unset LEMONADE_API_KEY LEMONADE_URL LEMONADE_MODEL
  unset CURL_FAIL CURL_RESPONSE
}

curl_log_url() {
  grep -E '^url=' "${CURL_LOG}" | tail -n 1 | cut -d= -f2-
}

request_body() {
  cat "${CURL_LOG}.body"
}

request_json_field() {
  jq -r "$1" "${CURL_LOG}.body"
}
