#!/usr/bin/env bats

setup() {
  load "${BATS_PLUGIN_PATH}/load.bash"

  # Uncomment to enable stub debugging
  # export CURL_STUB_DEBUG=/dev/tty
  # export JQ_STUB_DEBUG=/dev/tty
}

@test "Missing urls parameter fails" {
  export BUILDKITE_PLUGIN_JSON_WATCHER_FIELD=".version"
  export BUILDKITE_PLUGIN_JSON_WATCHER_EXPECTED_VALUE="1.0.0"

  run "$PWD"/hooks/command

  assert_failure 1
  assert_output --partial "'urls' parameter is required"
}

@test "Missing field parameter fails" {
  export BUILDKITE_PLUGIN_JSON_WATCHER_URLS="https://example.com/test.json"
  export BUILDKITE_PLUGIN_JSON_WATCHER_EXPECTED_VALUE="1.0.0"

  run "$PWD"/hooks/command

  assert_failure 1
  assert_output --partial "'field' parameter is required"
}

@test "Missing expected_value parameter fails" {
  export BUILDKITE_PLUGIN_JSON_WATCHER_URLS="https://example.com/test.json"
  export BUILDKITE_PLUGIN_JSON_WATCHER_FIELD=".version"
  export BUILDKITE_PLUGIN_JSON_WATCHER_POLLING_INTERVAL=60

  run "$PWD"/hooks/command

  assert_failure 1
  assert_output --partial "'expected_value' parameter is required"
}
