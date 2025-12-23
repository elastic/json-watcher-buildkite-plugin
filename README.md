# JSON Watcher Buildkite Plugin

A Buildkite plugin that polls JSON endpoints and waits until a specific field matches an expected value.

## Requirements

- `curl` - for fetching JSON
- `jq` - for parsing JSON

## Features

- **Poll multiple JSON endpoints**
- **Wait for specific field values** using jq path syntax
- **Configurable polling interval** (default: 60 seconds)

## Example

**Usage:**

```yaml
steps:
  - label: "Wait for JSON file"
    plugins:
      - elastic/json-watcher#v1.0.0:
          urls: "https://example.com/myfile_version.json"
          field: ".version"
          expected_value: "9.2.4"
          polling_interval: 30 # optional, defaults to 60
```

**Output:**

```bash
~~~ :package: JSON Watcher
Monitoring 1 URL(s)
Field: .version
Expected value: 9.2.4
Polling every 30s
✓ https://example.com/myfile_version.json: 9.2.4 (matches!)
```

### Required input

- #### `urls` (string)

  One or more URLs to poll for JSON data. Multiple URLs should be comma-separated.

  **Example:**

  ```
  urls: "https://api.example.com/status.json"
  ```

  **Multiple URLs:**

  ```
  urls: "https://api1.example.com/v1.json,https://api2.example.com/v2.json"
  ```

- #### `field` (string)

  The `jq` path to the JSON field you want to check. Supports nested fields.

  **Examples:**

  ```
  field: ".version"             # Top-level field
  field: ".app.release.version" # Nested field
  field: ".[0].status"          # Array access
  ```

- #### `expected_value` (string)

  The value you're waiting for. The plugin will exit successfully once all URLs return this value for the specified field.

  **Example:**
  `expected_value: "1.2.3"`

### Optional input

- #### `polling_interval` (integer)

  How often (in seconds) to poll the URLs. Defaults to `60`.

  **Example:**
  Check every 30 seconds.
  `polling_interval: 30`

## Use Cases

- ### 1. Wait for JSON metadata

```yaml
steps:
  - label: "Wait for JSON file"
    plugins:
      - elastic/json-watcher#v1.0.0:
          urls: "${URLS}"
          field: "${FIELD}"
          expected_value: "${EXPECTED_VALUE}"
```

- ### 2. Wait for deployment status

```yaml
steps:
  - label: "Wait for expected value in JSON metadata file"
    plugins:
      - elastic/json-watcher#v1.0.0:
          urls: "https://api.k8s.example.com/deployments/my-app/status.json"
          field: ".status"
          expected_value: "ready"
          polling_interval: 15
```

- ### 3. Check multiple URLs

```yaml
steps:
  - label: "Wait for multiple JSON files"
    plugins:
      - elastic/json-watcher#v1.0.0:
          urls: "https://us-east.api.example.com/status.json,https://eu-west.api.example.com/status.json"
          field: ".version"
          expected_value: "some-version-here"
```

## Development

This repository is using `pre-commit` to automate commit hooks.

It also uses `hermit` to automate provisioning of the tools required to interact with the repo. Run `. bin/activate-hermit` to activate it in your shell. This includes all the tools in the `bin`.

Before your first commit, please run `pre-commit install` inside the repository directory to set up the git hook scripts.

### Running tests locally

You will need `docker` installed.

```bash
docker run -it --rm -v "$PWD:/plugin:ro" buildkite/plugin-linter --id elastic/json-watcher
```
