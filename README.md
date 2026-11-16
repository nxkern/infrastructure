# homelab-infrastructure

terraform configuration for managing homelab docker services and cloudflare tunnel routing.

## prerequisites

- docker daemon running on target host
- terraform >= 1.5
- nix with flakes (optional, provides dev environment)

## services

- **adguardhome**: dns sinkhole and ad blocker
- **caddy**: reverse proxy routing internal traffic
- **cloudflared**: cloudflare tunnel daemon
- **homepage**: homelab dashboard
- **kopia**: backup server with rclone support
- **library**: calibre web book server
- **memos**: markdown note-taking platform
- **vikunja**: task management service
- **website**: custom nuxt frontend
- **yourspotify**: self-hosted spotify metrics (client, api, mongodb)

## setup

1. copy example configuration files:

```sh
cp backend.hcl.example backend.hcl
cp variables.tfvars.example variables.tfvars
```

2. configure `backend.hcl` with your s3/r2 credentials and update `variables.tfvars` with target host details and service tokens.

## workflow

if using nix:

```sh
nix develop
```

commands:

- `make init`: initialize terraform with backend configuration
- `make plan`: create execution plan saved to `plan.out`
- `make apply`: apply the generated plan
- `make fmt`: format all `.tf` files recursively
- `make validate`: check syntax and configuration validity
