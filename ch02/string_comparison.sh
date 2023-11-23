#!/bin/bash
VARIABLE_ONE="nostarch"
VARIABLE_TWO="nostarch"

# Test that the two variables are equal
if [[ "${VARIABLE_ONE}" == "${VARIABLE_TWO}" ]]; then
  echo "They are equal!"
else
  echo "They are not equal!"
fi
