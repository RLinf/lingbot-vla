# LeRobot slim patches (`lingbotvla/lerobot_slim/patches/`)

These three files are the **load-bearing** slimming overrides applied on top of
the official `lerobot==0.4.2` wheel by the `apply-lerobot-slim` console script
(`lingbotvla.lerobot_slim:main`).

They are byte-identical to the previously-vendored `vendor/lerobot` sources,
which were themselves the official `0.4.2` wheel plus exactly these three edits.

The files ship as **package data** inside the `rlinf-lingbotvla` wheel
(declared via `[tool.setuptools.package-data]`), so the applier works from a
non-editable install with no dependency on a source checkout of `scripts/` or a
top-level `patches/` tree. It resolves them at runtime via
`importlib.resources.files("lingbotvla.lerobot_slim")`.

## Why slimming is required (not cosmetic)

The official `lerobot==0.4.2` `policies/__init__.py` eagerly imports every
policy backend. `deploy.lingbot_vla_policy` imports
`lerobot.policies.pi0.configuration_pi0`, which triggers that eager
`__init__`, which pulls:

```
lerobot.policies.__init__ (eager) -> groot.modeling_groot
  -> lerobot.policies.pretrained:33 (eager) -> lerobot.configs.train
  -> lerobot.envs -> lerobot.robots -> lerobot.motors.motors_bus -> import serial 💥
```

`pyserial` (and the further realsense/dynamixel/feetech hardware deps behind it)
are not in the RoboTwin VLA inference runtime, so the eager chain breaks the
import. The three overrides defer the imports:

| file | change | nature |
|------|--------|--------|
| `policies/__init__.py` | eager exports -> `_LAZY_EXPORTS` + `__getattr__` | load-bearing, behaviour-neutral |
| `policies/pretrained.py` | `TrainPipelineConfig` import guarded behind `TYPE_CHECKING` | load-bearing, behaviour-neutral |
| `processor/__init__.py` | eager -> lazy `__getattr__` | load-bearing, behaviour-neutral |

Only import *timing* changes (lazy vs eager); the exported symbols and their
semantics are unchanged. Verified bitwise-identical VLA inference output
(`max_abs_diff = 0.0`) against the vendored baseline.

## Application

```bash
uv pip install --no-deps "lerobot==0.4.2"
apply-lerobot-slim
```

`--no-deps` is required because of two resolver-verified structural version
conflicts (Round 2 / Phase 3):

* lerobot pins `datasets>=4.0.0,<4.2.0` — conflicts with the LingBot runtime
  pin `datasets==3.6.0` (datasets IS on the inference path; LingBot owns it).
* lerobot pins `gymnasium>=1.1.1,<2.0.0` — conflicts with the RoboTwin
  env-runtime pin `gymnasium==0.29.1` (gymnasium is NOT on the VLA-inference
  path; RoboTwin owns it).

The runtime deliberately stays on the older versions; lerobot's
dataset/training code (the only caller of `datasets>=4` / `gymnasium>=1.1`) is
not on the inference path. The slim files make the hardware deps unnecessary,
so `--no-deps` is safe for inference.

The applier is **fail-closed** and idempotent. For each target it takes a
three-way decision on the file's sha256 against two pinned hashes — the
official `0.4.2` wheel hash and the patched (slim) hash:

| target sha256 matches | action | status |
|-----------------------|--------|--------|
| patched hash | leave untouched (idempotent) | `already_patched` |
| official `0.4.2` hash | write the slim copy | `patched` |
| neither (or version ≠ 0.4.2) | **do not overwrite**; exit non-zero | `unexpected_hash` / `version_mismatch` |

The shipped slim source itself must also hash to the pinned patched value, else
the run fails as `patch_source_drift` (an accidental edit to
`lingbotvla/lerobot_slim/patches/` fails loudly instead of installing a
different patch).
