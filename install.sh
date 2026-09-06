# rlinf-lingbotvla runtime install.
#
# lerobot==0.4.2 is installed with --no-deps because of two resolver-verified
# structural version conflicts (Round 2 / Phase 3):
#   lerobot pins datasets>=4.0,<4.2  vs  LingBot runtime pin datasets==3.6.0
#   lerobot pins gymnasium>=1.1.1    vs  RoboTwin env-runtime pin gymnasium==0.29.1
# The runtime deliberately stays on the older versions; lerobot's
# dataset/training code (the only caller of datasets>=4 / gymnasium>=1.1) is
# not on the inference path.
#
# The `apply-lerobot-slim` console script (shipped in this wheel as package
# data under lingbotvla/lerobot_slim/patches/, resolved via importlib.resources)
# reapplies the three load-bearing import overrides that remove lerobot's
# hardware-dep import chain, so --no-deps is safe for inference. It is
# fail-closed (version/SHA-guarded, idempotent). See
# lingbotvla/lerobot_slim/patches/README.md.

git submodule update --init --recursive --remote
pip install -e .
pip install --no-deps "lerobot==0.4.2"
apply-lerobot-slim
pip install -e ./lingbotvla/models/vla/vision_models/lingbot-depth/ --no-deps
pip install -e ./lingbotvla/models/vla/vision_models/MoGe/
pip install flash-attn==2.8.3 --no-build-isolation
