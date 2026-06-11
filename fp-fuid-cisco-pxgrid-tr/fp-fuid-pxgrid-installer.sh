#!/bin/bash
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

info()    { echo -e "${GREEN}[INFO]${NC} $1"; }
warning() { echo -e "${YELLOW}[WARN]${NC} $1"; }
error()   { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    error "Please run as root (sudo ./fp-fuid-pxgrid-installer.sh)"
fi

# Check OS
if [ -f /etc/os-release ]; then
    . /etc/os-release
    info "Detected OS: $NAME $VERSION_ID"
else
    error "Cannot detect OS. /etc/os-release not found."
fi

# Check required files exist
for f in fuid-ise fuid-ise.yml fuid-ise.service; do
    if [ ! -f "$f" ]; then
        error "Required file '$f' not found. Please run this script from the extracted package directory."
    fi
done

# Create directories
info "Creating directories..."
mkdir -p /var/fuid-ise/logs
mkdir -p /var/fuid-ise/timestamp

# Install binary and config
info "Installing fuid-ise binary..."
chmod +x fuid-ise
cp fuid-ise /var/fuid-ise/fuid-ise

info "Installing configuration..."
cp fuid-ise.yml /var/fuid-ise/fuid-ise.yml

# Install systemd service
info "Installing systemd service..."
cp fuid-ise.service /etc/systemd/system/fuid-ise.service

# Reload and enable service
info "Enabling service..."
systemctl daemon-reload
systemctl enable fuid-ise.service

info "Installation complete!"
info "Next steps:"
echo "  1. Edit /var/fuid-ise/fuid-ise.yml with your configuration"
echo "  2. Start the service: systemctl start fuid-ise"
echo "  3. Check status:      systemctl status fuid-ise"
