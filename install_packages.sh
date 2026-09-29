#!/bin/bash
# Install Ultimate Vocal Remover's dependencies for Python 3.14.
#
# Requires python3-devel (the CPython headers) so that C-extension packages
# such as diffq and samplerate can be built:
#   sudo dnf install python3-devel      # Fedora / RHEL
#
# Usage:  ./install_packages.sh
set -euo pipefail

PY="${PYTHON:-python3}"

echo "==> Using $("$PY" --version)"
"$PY" -c 'import sys; assert sys.version_info[:2] >= (3,10), "Python 3.10+ required"' \
    || { echo "ERROR: Python 3.10+ is required." >&2; exit 1; }

echo "==> Installing PyTorch"
# CPU build by default; pass GPU=1 to use the CUDA wheel index instead.
if [ "${GPU:-0}" = "1" ]; then
    TORCH_INDEX="https://download.pytorch.org/whl/cu124"
else
    TORCH_INDEX="https://download.pytorch.org/whl/cpu"
fi
"$PY" -m pip install --upgrade pip
"$PY" -m pip install torch torchvision --index-url "$TORCH_INDEX"

echo "==> Installing remaining requirements"
"$PY" -m pip install -r requirements.txt

echo "==> Done. Start the app with:  $PY UVR.py"
