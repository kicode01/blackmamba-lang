"""
Test Suite and Adversarial Gradient Fuzzer for TinyTalk Phase 16A: Differentiable Physics.
"""

import unittest
import random
import math
from tinytalk.diff_physics import DiffVar

class TestDiffPhysics(unittest.TestCase):
    def test_polynomial_and_trig_autograd(self):
        # f(x, y) = x^2 * y + sin(x)
        # df/dx = 2*x*y + cos(x)
        # df/dy = x^2
        x = DiffVar(2.0, "x")
        y = DiffVar(3.0, "y")
        f = (x ** 2) * y + x.sin()
        f.backward()

        expected_df_dx = 2.0 * 2.0 * 3.0 + math.cos(2.0)
        expected_df_dy = 2.0 ** 2

        self.assertAlmostEqual(x.grad, expected_df_dx, places=5)
        self.assertAlmostEqual(y.grad, expected_df_dy, places=5)

    def test_adversarial_finite_difference_fuzzer_100_runs(self):
        """Fuzz autograd exactness against numerical finite difference across 100 randomized inputs."""
        rng = random.Random(31415)
        eps = 1e-6

        for trial in range(100):
            x_val = rng.uniform(0.5, 5.0)
            y_val = rng.uniform(0.5, 5.0)

            # Autodiff computation
            x = DiffVar(x_val)
            y = DiffVar(y_val)
            f = (x * y) / (x + y) + (x ** 2)
            f.backward()
            ad_grad_x = x.grad

            # Numerical finite difference: (f(x+eps) - f(x-eps)) / (2*eps)
            f_plus = ((x_val + eps) * y_val) / ((x_val + eps) + y_val) + ((x_val + eps) ** 2)
            f_minus = ((x_val - eps) * y_val) / ((x_val - eps) + y_val) + ((x_val - eps) ** 2)
            num_grad_x = (f_plus - f_minus) / (2.0 * eps)

            # Invariant: Autograd gradient matches numerical derivative within 1e-4
            self.assertAlmostEqual(
                ad_grad_x,
                num_grad_x,
                places=4,
                msg=f"Trial {trial}: Gradient mismatch! autodiff={ad_grad_x}, numerical={num_grad_x}"
            )

if __name__ == "__main__":
    unittest.main()
