#!/usr/bin/env python3
import argparse
import json
import subprocess
import sys
from pathlib import Path


def run(cmd: list[str], cwd: Path | None = None) -> str:
    p = subprocess.run(cmd, cwd=str(cwd) if cwd else None, capture_output=True, text=True)
    if p.returncode != 0:
        raise RuntimeError(
            "Command failed.\n"
            f"Command: {' '.join(cmd)}\n"
            f"STDOUT:\n{p.stdout}\n"
            f"STDERR:\n{p.stderr}\n"
        )
    return p.stdout


def terraform_init(tf_dir: Path) -> None:
    # -upgrade optional; useful in CI to avoid stale provider locks if you bump versions
    cmd = ["terraform", f"-chdir={str(tf_dir)}", "init", "-input=false"]
    run(cmd)


def terraform_output_hosts(tf_dir: Path) -> dict:
    cmd = ["terraform", f"-chdir={str(tf_dir)}", "output", "-json", "hosts"]
    out = run(cmd)
    return json.loads(out)


def normalize_hosts(terraform_output: dict) -> dict:
    # terraform output -json returns either:
    #  - {"value": {...}, "type": ..., "sensitive": ...}
    #  - {...} (already the value) depending on how it's produced
    return terraform_output.get("value", terraform_output)


def render_inventory(hosts: dict) -> str:
    groups: dict[str, list[str]] = {}
    all_lines: list[str] = []

    for hostname, h in hosts.items():
        ip = h["ipv4"]
        user = h.get("ansible_user", "ubuntu")
        all_lines.append(f"{hostname} ansible_host={ip} ansible_user={user}")

        for g in h.get("groups", []):
            groups.setdefault(g, []).append(hostname)

    out: list[str] = []
    out.append("[all]")
    out.extend(sorted(all_lines))
    out.append("")

    for g in sorted(groups.keys()):
        out.append(f"[{g}]")
        out.extend(sorted(groups[g]))
        out.append("")

    return "\n".join(out).rstrip() + "\n"


def main() -> int:
    ap = argparse.ArgumentParser(
        description="Run terraform init, read output 'hosts', and generate an Ansible inventory.ini."
    )
    ap.add_argument(
        "--tf-dir",
        required=True,
        help="Terraform working directory (e.g., terraform/envs/home)",
    )
    ap.add_argument(
        "--out",
        required=True,
        help="Inventory output path (e.g., ansible/inventories/home/inventory.ini)",
    )
    ap.add_argument(
        "--init",
        action="store_true",
        help="Run 'terraform init -input=false' before reading outputs.",
    )
    args = ap.parse_args()

    tf_dir = Path(args.tf_dir).resolve()
    out_path = Path(args.out).resolve()

    if not tf_dir.exists():
        print(f"ERROR: tf-dir does not exist: {tf_dir}", file=sys.stderr)
        return 2

    if args.init:
        terraform_init(tf_dir)

    data = terraform_output_hosts(tf_dir)
    hosts = normalize_hosts(data)

    inv = render_inventory(hosts)

    out_path.parent.mkdir(parents=True, exist_ok=True)
    out_path.write_text(inv, encoding="utf-8")
    print(f"Wrote inventory: {out_path}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
