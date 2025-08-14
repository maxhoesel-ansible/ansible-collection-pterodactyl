#!/usr/bin/env bash
pip-compile -U requirements.in
python3 -m piptools sync --pip-args "--quiet"
