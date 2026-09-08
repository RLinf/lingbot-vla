# rlinf-lingbotvla runtime install.
#
# LeRobot has been cut from the inference path: deploy uses transformers'
# PretrainedConfig/nn.Module and the training/data-only lerobot imports are
# lazy. The runtime therefore no longer installs lerobot or applies the
# former apply-lerobot-slim patches. Training still needs lerobot; install
# it separately in a training env.

git submodule update --init --recursive --remote
pip install -e .
pip install -e ./lingbotvla/models/vla/vision_models/lingbot-depth/ --no-deps
pip install -e ./lingbotvla/models/vla/vision_models/MoGe/
pip install flash-attn==2.8.3 --no-build-isolation
