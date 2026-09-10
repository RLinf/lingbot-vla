# LingBot-VLA Runtime for RLinf / RPent

[LingBot-VLA](https://github.com/Robbyant/lingbot-vla) is a
Vision-Language-Action model for general-purpose robot manipulation.

`rlinf-lingbotvla` is the RLinf-maintained **inference runtime distribution**
used by [RPent](https://github.com/RLinf/RPent), including the LingBot-VLA
model and deployment code required by the RoboTwin integration.

This distribution is focused on inference. It is not a replacement for the
full upstream LingBot-VLA training environment.

## Installation

### Standalone inference runtime

```bash
pip install rlinf-lingbotvla==0.1.1
```

### RPent

RPent users should normally install LingBot-VLA as part of the RoboTwin stack:

```bash
uv pip install -e ".[robotwin]"
```

RPent currently composes:

```text
RPent
├── rlinf-robotwin-runtime
├── rlinf-lingbotvla
└── NVIDIA cuRobo
```

## Runtime Contract

The `0.1.x` inference runtime is validated with:

| Component    | Version        |
| ------------ | -------------- |
| Python       | `>=3.10,<3.12` |
| PyTorch      | `2.7.1`        |
| torchvision  | `0.22.1`       |
| Transformers | `4.57.6`       |
| Diffusers    | `0.35.1`       |
| NumPy        | `1.26.4`       |

These versions describe the validated **RLinf / RPent inference runtime**.

They intentionally differ from the requirements documented for the complete
upstream LingBot-VLA training environment.

## Package Scope

The wheel contains the model and deployment packages required for inference:

```text
deploy/
lingbotvla/
```

Repository-level training scripts, task utilities, tests, checkpoints, and
datasets are not bundled into the wheel.

Model checkpoints must be obtained separately. See the upstream LingBot-VLA
project for the published model weights and full model documentation.

## Zero-LeRobot Inference Runtime

LeRobot is not required by the RPent inference path.

The RLinf runtime uses:

* `transformers.PretrainedConfig` for model configuration
* `torch.nn.Module` for the policy runtime
* lazy loading for training/data-only modules

As a result:

```text
pip install rlinf-lingbotvla
```

does not install LeRobot.

The inference implementation was validated against the previous runtime before
release.

## Training

A `train` extra is provided for dependencies that are outside the inference
path:

```bash
pip install "rlinf-lingbotvla[train]==0.1.1"
```

This extra contains supporting training/data dependencies maintained by this
distribution.

Full LingBot-VLA training still requires the upstream training setup and its
additional dependencies, including the upstream LeRobot-based data/training
workflow.

For complete post-training instructions, dataset conversion, robot
configuration, and checkpoint preparation, use the upstream documentation:

[https://github.com/Robbyant/lingbot-vla](https://github.com/Robbyant/lingbot-vla)

## RPent Integration

This package is maintained as the VLA side of the RPent RoboTwin runtime:

```text
RoboTwin environment
        ↓
rlinf-robotwin-runtime

LingBot-VLA inference
        ↓
rlinf-lingbotvla

motion planning
        ↓
NVIDIA cuRobo

        ↓
      RPent
```

Source repositories:

* RLinf runtime: [https://github.com/RLinf/lingbot-vla](https://github.com/RLinf/lingbot-vla)
* Upstream LingBot-VLA: [https://github.com/Robbyant/lingbot-vla](https://github.com/Robbyant/lingbot-vla)
* RPent: [https://github.com/RLinf/RPent](https://github.com/RLinf/RPent)

## License and Attribution

LingBot-VLA is based on the upstream Robbyant LingBot-VLA project and retains
its Apache-2.0 licensing and upstream attribution.

For the technical report, citation information, checkpoints, datasets, and
full training documentation, please refer to the upstream project.
