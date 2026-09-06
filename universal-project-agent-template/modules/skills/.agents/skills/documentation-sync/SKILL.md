---
name: documentation-sync
description: Update only documentation affected by changed behavior, contracts, terminology or delivery rules; preserve source and generated-view boundaries.
---

# Documentation Sync

Start with the task and current diff; reuse its approved contract. Read exact
affected docs, not a fixed list of all architecture/product files.
Decide whether meaning, customer wording or only a generated representation
changes. Update the authoritative source first, then mirrors/exports.
Unknown customer facts remain explicit gaps, never inferred from passing mocks.

For this template repository edit installable sources and run the mirror checker.
Keep historical guides visibly non-authoritative; avoid copying policy text into
multiple new registries. Report which documents changed and which didn't need
changes. Select docs/contract checks, not an unrelated full application replay.
Default to read-only if assigned as reviewer; write only with explicit ownership.
