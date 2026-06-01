#!/usr/bin/env python3
"""Test file for verifying Neovim syntax highlighting.

Open this file and check that each category below has a distinct color.
Use :Inspect on any token to see its treesitter / LSP highlight group.

Expected colors (gruvbox-material "mix"):
  Green   — function/method calls
  Yellow  — classes, type annotations
  Aqua    — modules in imports
  Purple  — decorators
  Orange  — properties (self.x), special builtins
  Red     — keywords (if, for, return, etc.)
  Default — variables, parameters
"""

# ── Imports: modules should be aqua, classes/functions colored by LSP ──
import os
import json
from pathlib import Path
from argparse import ArgumentParser  # ArgumentParser → yellow (class)
from typing import Optional, List, Dict, Tuple, Union
from collections import defaultdict  # defaultdict → yellow (class)

import torch
import torch.nn as nn
from torch.utils.data import DataLoader  # DataLoader → yellow (class)


# ── Constants ──
MAX_EPOCHS: int = 100
LEARNING_RATE: float = 3e-4
DEVICE: str = "cuda" if torch.cuda.is_available() else "cpu"


# ── Decorators should be purple ──
class TextClassifier(nn.Module):
    """A simple text classifier for testing highlight groups."""

    @staticmethod
    def count_parameters(model: nn.Module) -> int:
        """Count trainable parameters."""
        return sum(p.numel() for p in model.parameters() if p.requires_grad)

    @property
    def device(self) -> torch.device:
        """Return the device of the model."""
        return next(self.parameters()).device

    def __init__(
        self,
        vocab_size: int,          # type annotations → yellow
        hidden_dim: int = 256,
        num_classes: int = 10,
        dropout: float = 0.1,
    ) -> None:
        super().__init__()
        # Properties (self.x) → orange via LSP
        self.embedding = nn.Embedding(vocab_size, hidden_dim)
        self.encoder = nn.TransformerEncoder(
            nn.TransformerEncoderLayer(d_model=hidden_dim, nhead=8),
            num_layers=6,
        )
        self.classifier = nn.Linear(hidden_dim, num_classes)
        self.dropout = nn.Dropout(dropout)

    def forward(self, input_ids: torch.Tensor) -> torch.Tensor:
        """Forward pass — function calls should be green."""
        x = self.embedding(input_ids)
        x = self.encoder(x)
        x = x.mean(dim=1)              # .mean() → green (method call)
        x = self.dropout(x)
        logits = self.classifier(x)
        return logits


# ── Built-in names in keyword args should NOT be highlighted as builtins ──
def build_parser() -> ArgumentParser:
    parser = ArgumentParser(description="Test highlighting")

    # "type" and "help" here are PARAMETERS (default fg), not builtins (green)
    parser.add_argument("--epochs", type=int, default=MAX_EPOCHS, help="Number of epochs")
    parser.add_argument("--lr", type=float, default=LEARNING_RATE, help="Learning rate")
    parser.add_argument("--device", type=str, default=DEVICE, help="Device to use")

    return parser


# ── Function calls (green) vs variables (default) ──
def train() -> None:
    args = build_parser().parse_args()     # build_parser() → green
    print(f"Training on {args.device}")    # print() → green, f-string highlighted

    # Constructor calls → yellow
    model = TextClassifier(vocab_size=30000)
    optimizer = torch.optim.Adam(model.parameters(), lr=args.lr)
    loss_fn = nn.CrossEntropyLoss()

    # Dict/list comprehensions
    metrics: Dict[str, List[float]] = defaultdict(list)
    param_count = TextClassifier.count_parameters(model)
    data_path = Path("data") / "train.jsonl"

    # type() as a FUNCTION CALL → should be green
    model_type = type(model).__name__
    config = json.loads(data_path.read_text())

    # Built-in functions → green
    total = len(metrics)
    items = sorted(metrics.items(), key=lambda x: x[1])
    unique = set(range(10))
    mapped = list(map(str, unique))

    print(f"Parameters: {param_count:,}")
    print(f"Model type: {model_type}")


if __name__ == "__main__":
    train()
