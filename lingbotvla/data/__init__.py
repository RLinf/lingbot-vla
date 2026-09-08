# Copyright 2025 Bytedance Ltd. and/or its affiliates
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


from .chat_template import build_chat_template
from .data_collator import (
    CollatePipeline,
    DataCollatorWithPacking,
    DataCollatorWithPadding,
    DataCollatorWithPositionIDs,
    MakeMicroBatchCollator,
    TextSequenceShardCollator,
    UnpackDataCollator,
)
from .data_loader import build_dataloader
from .data_transform import (
    VLADataCollatorWithPacking,
)


def __getattr__(name):
    # ``dataset`` eagerly does ``from .vla_data import *`` which pulls
    # ``base_dataset`` -> lerobot. Lazy so that inference imports
    # (e.g. ``from lingbotvla.data.vla_data.utils import FeatureTransform``)
    # do not require lerobot; training still loads these on demand.
    if name in {"build_iterative_dataset", "build_mapping_dataset"}:
        from .dataset import build_iterative_dataset, build_mapping_dataset

        return {
            "build_iterative_dataset": build_iterative_dataset,
            "build_mapping_dataset": build_mapping_dataset,
        }[name]
    raise AttributeError(name)
