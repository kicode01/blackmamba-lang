# tests/test_phase8d_autograd.py
# Comprehensive test suite for Phase 8D: GPU Tensor Autograd & Native ML Training Engine

import os
import sys
import math
import unittest
import argparse

from mamba.autograd import (
    Tensor, Linear, LoRALinear, MSELoss, CrossEntropyLoss,
    SGD, AdamW, emit_gpu_tensor_shader
)
from mamba.cli import cmd_autograd, compile_source_to_mir


class TestPhase8DAutograd(unittest.TestCase):

    def test_tensor_creation_and_properties(self):
        t1 = Tensor([1.0, 2.0, 3.0, 4.0], shape=(2, 2), requires_grad=True)
        self.assertEqual(t1.shape, (2, 2))
        self.assertEqual(t1.size, 4)
        self.assertTrue(t1.requires_grad)
        self.assertEqual(len(t1.grad), 4)

        z = Tensor.zeros(3, 3)
        self.assertEqual(z.data, [0.0] * 9)
        self.assertEqual(z.shape, (3, 3))

        o = Tensor.ones(2, 4)
        self.assertEqual(o.data, [1.0] * 8)

        r = Tensor.randn(4, 4, seed=42)
        self.assertEqual(len(r.data), 16)
        self.assertAlmostEqual(sum(r.data) / 16.0, 0.0, delta=1.0)

    def test_basic_arithmetic_autograd(self):
        # f(x, y) = 3x + y^2
        x = Tensor([2.0], requires_grad=True)
        y = Tensor([3.0], requires_grad=True)

        f = x * 3.0 + y * y
        f.backward()

        self.assertAlmostEqual(f.item(), 15.0)
        self.assertAlmostEqual(x.grad[0], 3.0)  # df/dx = 3
        self.assertAlmostEqual(y.grad[0], 6.0)  # df/dy = 2*y = 6

    def test_matmul_autograd(self):
        # A: (2, 3), B: (3, 2)
        A = Tensor([
            [1.0, 2.0, 3.0],
            [4.0, 5.0, 6.0]
        ], requires_grad=True)

        B = Tensor([
            [7.0, 8.0],
            [9.0, 1.0],
            [2.0, 3.0]
        ], requires_grad=True)

        # C = A @ B
        # C[0, 0] = 1*7 + 2*9 + 3*2 = 7 + 18 + 6 = 31
        # C[0, 1] = 1*8 + 2*1 + 3*3 = 8 + 2 + 9 = 19
        # C[1, 0] = 4*7 + 5*9 + 6*2 = 28 + 45 + 12 = 85
        # C[1, 1] = 4*8 + 5*1 + 6*3 = 32 + 5 + 18 = 55
        C = A @ B
        self.assertEqual(C.shape, (2, 2))
        self.assertAlmostEqual(C.data[0], 31.0)
        self.assertAlmostEqual(C.data[1], 19.0)
        self.assertAlmostEqual(C.data[2], 85.0)
        self.assertAlmostEqual(C.data[3], 55.0)

        loss = C.sum()
        loss.backward()

        # dLoss/dA = ones(2, 2) @ B^T
        # B^T = [[7, 9, 2], [8, 1, 3]]
        # row 0 of dLoss/dA = [7+8, 9+1, 2+3] = [15, 10, 5]
        # row 1 of dLoss/dA = [15, 10, 5]
        self.assertAlmostEqual(A.grad[0], 15.0)
        self.assertAlmostEqual(A.grad[1], 10.0)
        self.assertAlmostEqual(A.grad[2], 5.0)
        self.assertAlmostEqual(A.grad[3], 15.0)

    def test_activations_autograd(self):
        # ReLU
        x = Tensor([-2.0, 3.0], requires_grad=True)
        y = x.relu().sum()
        y.backward()
        self.assertEqual(x.grad, [0.0, 1.0])

        # Sigmoid
        x2 = Tensor([0.0], requires_grad=True)
        y2 = x2.sigmoid()
        self.assertAlmostEqual(y2.item(), 0.5)
        y2.backward()
        # d sigmoid(0) / dx = 0.5 * (1 - 0.5) = 0.25
        self.assertAlmostEqual(x2.grad[0], 0.25)

        # Tanh
        x3 = Tensor([0.0], requires_grad=True)
        y3 = x3.tanh()
        self.assertAlmostEqual(y3.item(), 0.0)
        y3.backward()
        # d tanh(0) / dx = 1 - 0^2 = 1.0
        self.assertAlmostEqual(x3.grad[0], 1.0)

    def test_reshape_and_transpose_autograd(self):
        x = Tensor([1.0, 2.0, 3.0, 4.0, 5.0, 6.0], shape=(2, 3), requires_grad=True)
        y = x.reshape(3, 2).transpose()  # shape becomes (2, 3)
        self.assertEqual(y.shape, (2, 3))
        loss = (y * 2.0).sum()
        loss.backward()
        self.assertEqual(len(x.grad), 6)
        for g in x.grad:
            self.assertAlmostEqual(g, 2.0)

    def test_optimizers_sgd_and_adamw(self):
        # Simple parameter optimization
        p1 = Tensor([10.0], requires_grad=True)
        opt_sgd = SGD([p1], lr=0.1, momentum=0.9)
        p1.grad = [2.0]
        opt_sgd.step()
        # p1 = 10.0 - 0.1 * 2.0 = 9.8
        self.assertAlmostEqual(p1.item(), 9.8)

        p2 = Tensor([10.0], requires_grad=True)
        opt_adamw = AdamW([p2], lr=0.1, weight_decay=0.01)
        p2.grad = [2.0]
        opt_adamw.step()
        self.assertTrue(p2.item() < 10.0)

    def test_linear_regression_training_convergence(self):
        # Learn y = 2x + 1
        X = Tensor([[1.0], [2.0], [3.0], [4.0]])
        Y = Tensor([[3.0], [5.0], [7.0], [9.0]])

        model = Linear(1, 1, seed=42)
        opt = AdamW(model.parameters(), lr=0.1)
        criterion = MSELoss()

        initial_loss = None
        final_loss = None
        for epoch in range(100):
            opt.zero_grad()
            pred = model(X)
            loss = criterion(pred, Y)
            if epoch == 0:
                initial_loss = loss.item()
            loss.backward()
            opt.step()
            final_loss = loss.item()

        self.assertIsNotNone(initial_loss)
        self.assertIsNotNone(final_loss)
        self.assertTrue(final_loss < initial_loss * 0.1, f"Loss didn't decrease enough: {initial_loss} -> {final_loss}")
        self.assertTrue(final_loss < 0.05)

    def test_lora_linear_peft(self):
        lora = LoRALinear(in_features=4, out_features=2, r=2, alpha=4.0, seed=42)
        self.assertFalse(lora.base_weight.requires_grad)
        self.assertTrue(lora.lora_A.requires_grad)
        self.assertTrue(lora.lora_B.requires_grad)

        x = Tensor.randn(3, 4, seed=1)
        out = lora(x)
        self.assertEqual(out.shape, (3, 2))

        # Because lora_B is initialized to zeros, adapter output is zero initially
        base_expected = x @ lora.base_weight
        for a, b in zip(out.data, base_expected.data):
            self.assertAlmostEqual(a, b, places=5)

        loss = out.sum()
        loss.backward()
        self.assertIsNone(lora.base_weight.grad)
        self.assertIsNotNone(lora.lora_A.grad)
        self.assertIsNotNone(lora.lora_B.grad)

    def test_cross_entropy_loss(self):
        loss_fn = CrossEntropyLoss()
        logits = Tensor([[2.0, 1.0, 0.1], [0.5, 2.5, 0.2]], requires_grad=True)
        targets = [0, 1]  # correct classes

        loss = loss_fn(logits, targets)
        self.assertTrue(loss.item() > 0.0)
        loss.backward()
        self.assertEqual(len(logits.grad), 6)

    def test_gpu_tensor_shader_emission(self):
        shader = emit_gpu_tensor_shader(op="matmul", m=32, k=32, n=32)
        self.assertEqual(shader["operation"], "matmul")
        self.assertIn("@compute @workgroup_size(8, 8)", shader["wgsl_shader"])
        self.assertIn("var<storage, read_write> C", shader["wgsl_shader"])
        self.assertTrue(shader["spirv_bytes"] > 0)

    def test_cli_autograd_subcommands(self):
        # 1. Train command
        train_args = argparse.Namespace(
            action="train",
            epochs=10,
            lr=0.05,
            model="linear",
            json=True,
        )
        rc = cmd_autograd(train_args)
        self.assertEqual(rc, 0)

        # 2. Bench command
        bench_args = argparse.Namespace(
            action="bench",
            dim=32,
            iters=10,
            json=True,
        )
        rc = cmd_autograd(bench_args)
        self.assertEqual(rc, 0)

        # 3. Emit command
        emit_args = argparse.Namespace(
            action="emit",
            target="webgpu",
            op="matmul",
            dims="16,16,16",
            output=None,
            json=True,
        )
        rc = cmd_autograd(emit_args)
        self.assertEqual(rc, 0)

    def test_native_bmb_autograd_stdlib(self):
        stdlib_path = os.path.join(os.path.dirname(os.path.dirname(__file__)), "mamba", "stdlib", "autograd.bmb")
        self.assertTrue(os.path.exists(stdlib_path))
        with open(stdlib_path, "r", encoding="utf-8") as f:
            src = f.read()

        mir = compile_source_to_mir(src, filename=stdlib_path)
        self.assertIsNotNone(mir)
        self.assertTrue(len(mir.functions) >= 4)


if __name__ == "__main__":
    unittest.main()
