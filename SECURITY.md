# Security Policy

## Supported Versions

Only the latest builds in the Antergos NeXT package repository receive security updates. There are no LTS releases.

| Version | Supported |
|---------|-----------|
| latest (rolling) | ✅ |

## Reporting a Vulnerability

Please **do not** report security vulnerabilities through public GitHub issues, discussions, or pull requests.

Instead, report via **GitHub Private Vulnerability Reporting** for this repository. If that's unavailable, email `ash8820@proton.me`.

When reporting, include:

- The affected package name and version
- A description of the issue and why it's security-sensitive
- Steps to reproduce or a proof of concept
- Any relevant logs, payloads, or screenshots
- The potential impact
- Suggested mitigations or fixes, if known

You can expect an acknowledgment within 3 business days. After assessment, I'll work on a fix and coordinate disclosure timing when appropriate.

## Scope

This covers the PKGBUILDs and supporting files in this repo (packaging logic, dependency handling, distribution of upstream software). Issues in upstream software itself should be reported to the respective upstream project.
