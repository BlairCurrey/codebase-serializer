#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MAIN_SCRIPT="$SCRIPT_DIR/../main.sh"
TEST_CASES_DIR="$SCRIPT_DIR/cases"
EXPECTED_OUTPUT_DIR="$SCRIPT_DIR/expected_output"
OUTPUT_DIR="$SCRIPT_DIR/test_outputs"
TEST_FAILED=false

cleanup() {
  echo "Cleaning up..."
  rm -rf "$OUTPUT_DIR"
}

serialize_codebase() {
  local codebase_dir="$1"
  local output_file="$2"
  bash "$MAIN_SCRIPT" "$codebase_dir" "$output_file"
}

do_cleanup=true
while getopts "n" opt; do
  case $opt in
  n)
    do_cleanup=false
    ;;
  \?)
    echo "Invalid option: -$OPTARG"
    ;;
  esac
done

# Run tests
for test_case_dir in "$TEST_CASES_DIR"/*/; do
  test_case_name=$(basename "$test_case_dir")

  # Check if the directory contains an expected .md file
  expected_file="$EXPECTED_OUTPUT_DIR/$test_case_name.md"
  if [ ! -f "$expected_file" ]; then
    echo "Skipping test: $test_case_name (no expected output file found)"
    continue
  fi

  echo "Running test: $test_case_name"

  # temp output dir
  mkdir -p "$OUTPUT_DIR/$test_case_name"

  serialize_codebase "$test_case_dir" "$OUTPUT_DIR/$test_case_name/$test_case_name.md"
  actual_file="$OUTPUT_DIR/$test_case_name/$test_case_name.md"

  if diff -q "$expected_file" "$actual_file"; then
    echo "Test $test_case_name passed!"
  else
    echo "Test $test_case_name failed!"
    TEST_FAILED=true
    # TODO: maybe `diff -rupP` is easier to read?
    echo "--- Diff for $test_case_name ---"
    diff "$expected_file" "$actual_file"
    echo "------------------------------"
  fi
done

if $do_cleanup; then
  cleanup
fi

if $TEST_FAILED; then
  echo "Tests failed"
  exit 1
else
  echo "All tests completed successfully."
  exit 0
fi
