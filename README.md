# stack-samba4-dc

Terraform + Ansible stack for Samba4 DCs.

- Terraform root: `terraform/envs/home` (MinIO/S3 backend)
- Ansible playbooks: `ansible/playbooks/base.yml`, `ansible/playbooks/samba_dc.yml`
- Shared base role/module are pinned to `infra-platform` v0.1.0 (see `terraform/envs/home/main.tf` and `.gitea/workflows/dc-apply.yml`).
