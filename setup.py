from setuptools import setup, find_packages

setup(
    name="blackmamba-lang",
    version="1.4.0",
    description="Black Mamba (.bmb) — High-Speed, Zero-Cost-Abstraction Programming Language & Multi-Target Compiler",
    long_description=open("README.md", encoding="utf-8").read(),
    long_description_content_type="text/markdown",
    author="KiCode",
    author_email="kicode01@users.noreply.github.com",
    url="https://github.com/kicode01/blackmamba-lang",
    packages=find_packages(),
    package_data={
        "mamba": ["stdlib/*.bmb"],
    },
    entry_points={
        "console_scripts": [
            "bmb=mamba.cli:main",
            "blackmamba=mamba.cli:main",
        ],
    },
    classifiers=[
        "Development Status :: 5 - Production/Stable",
        "Topic :: Software Development :: Compilers",
        "License :: OSI Approved :: MIT License",
        "Programming Language :: Python :: 3",
    ],
    python_requires=">=3.8",
)
