__all__ = ["VLADataset"]


def __getattr__(name):
    if name == "VLADataset":
        from .base_dataset import VLADataset

        return VLADataset
    raise AttributeError(name)
