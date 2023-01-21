# https://github.com/ml-tooling/ml-workspace
# https://github.com/LukasMasuch

# --- versions ---

# https://github.com/krallin/tini/releases/
TINI_VERSION="0.19.0"

# --- end of versions ---

# Add tini
wget --no-verbose https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini -O /tini
chmod +x /tini

# Cleanup
clean-layer.sh

# Layer size: 0.1 MB 
# Total size: 850 MB
