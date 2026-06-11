# Forcepoint User ID Service + Cisco ISE pxGrid Integration

Integrates Cisco Platform Exchange Grid (pxGrid) with Forcepoint User Identity Service (FUID),
enabling identity-based access control in Forcepoint NGFW based on Cisco ISE session events.

## How it works

When a user authenticates or disconnects on the network, Cisco ISE fires a session event.
This service picks it up and adds or removes the user's IP address in FUID automatically.

    Cisco ISE -> pxGrid events -> this service -> FUID API -> Forcepoint NGFW

## Requirements

- Forcepoint User ID Service v2+
- Cisco Identity Services Engine v2.7+
- Docker + Docker Compose v2, or Ubuntu 22.04/24.04 (traditional install)

## Quick Start - Docker

1. Create pxGrid client account:

    docker compose run pxgrid-service fuid-ise pxgrid create-client -i --server ISE-HOST --username USERNAME

2. Approve the account in Cisco ISE under Administration -> pxGrid Services.

3. Copy and edit the environment file:

    cp .env.example .env
    nano .env

4. Start the service:

    docker compose up -d

5. Check logs:

    docker compose logs -f

## Quick Start - Traditional (Ubuntu 22.04/24.04)

1. Download and extract the release:

    tar -zxvf fp-fuid-cisco-pxgrid-tr.tar.gz
    cd fp-fuid-cisco-pxgrid-tr

2. Create pxGrid client account:

    ./fuid-ise pxgrid create-client -i --server ISE-HOST --username USERNAME

3. Approve the account in Cisco ISE under Administration -> pxGrid Services.

4. Edit configuration:

    nano fuid-ise.yml

5. Run installer:

    sudo ./fp-fuid-pxgrid-installer.sh

6. Start and verify:

    sudo systemctl start fuid-ise
    sudo systemctl status fuid-ise
    journalctl -u fuid-ise -f

## Configuration

| Variable | Description | Default |
|---|---|---|
| PXGRID_CLIENT_ACCOUNT_NAME | pxGrid API client username | required |
| PXGRID_CLIENT_ACCOUNT_PASSWORD | pxGrid API client password | required |
| PXGRID_HOST_ADDRESS | Cisco ISE hostname or IP | required |
| FUID_API_USERNAME | FUID API username | required |
| FUID_API_PASSWORD | FUID API password | required |
| FUID_IP_ADDRESS | FUID server hostname or IP | required |
| AD_LDAP_HOST | Active Directory hostname or IP | required |
| AD_LDAP_USER_DN | LDAP bind user DN | required |
| AD_LDAP_PASSWORD | LDAP bind user password | required |
| AD_DOMAIN_NAME | Active Directory domain name | required |
| SESSION_LISTENER_INTERVAL_TIME | Polling interval in seconds | 3 |
| SAVE_LOGS | Save logs to file | false |
| DISPLAY_INFO | Show process info in logs | true |
| IGNORE_UNKNOWN_SESSIONS | Ignore non-AD users | true |
| ISE_PORT | Cisco ISE pxGrid port | 8910 |
| FUID_PORT | FUID API port | 5000 |
| AD_PORT | LDAP port | 636 |

## Troubleshooting

Check service is running:

    systemctl status fuid-ise
    journalctl -u fuid-ise -f

Check network connectivity:

    ping -c 2 <ISE-HOST>
    ping -c 2 <FUID-HOST>

## Changes from original

- Go updated from 1.15 to 1.26
- Deprecated ioutil package replaced with io and os
- Docker Compose updated to v2 syntax
- Dockerfile updated to alpine 3.21 with proper entrypoint
- Installer modernized with error handling and Ubuntu support
- systemd service hardened with security settings and dedicated user

## License

Apache License 2.0 - see LICENSE file

Original project: https://github.com/Forcepoint/fp-bd-fuid-cisco-pxgrid
