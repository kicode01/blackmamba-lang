from setuptools import setup, find_packages

setup(
    name="tinytalk-lang",
    version="4.2.0",
    description="TinyTalk (.tnt) & Black Mamba (.bmb) — Smalltalk Live Heritage, Explosive Performance & Zero-Syntax Substrate",
    long_description=open("README.md", encoding="utf-8").read(),
    long_description_content_type="text/markdown",
    author="KiCode",
    author_email="kicode01@users.noreply.github.com",
    url="https://github.com/kicode01/tinytalk-lang",
    packages=find_packages(),
    package_data={
        "mamba": ["stdlib/*.tnt", "stdlib/*.bmb", "selfhost/*.tnt", "selfhost/*.bmb"],
        "tinytalk": ["stdlib/*.tnt", "stdlib/*.bmb", "selfhost/*.tnt", "selfhost/*.bmb"],
    },
    entry_points={
        "console_scripts": [
            "tnt=tinytalk.cli:main",
            "tinytalk=tinytalk.cli:main",
            "bmb=tinytalk.cli:main",
            "blackmamba=tinytalk.cli:main",
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
