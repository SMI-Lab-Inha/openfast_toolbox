# Student Setup for `openfast_toolbox`

This guide is intended for students who need a clean, repeatable Python environment for `openfast_toolbox`.

The recommended environment name is:

```powershell
openfast-toolbox-env
```

## What students need

Students need two things:

1. a Python environment with the required packages
2. an OpenFAST executable available on the machine

This repository only installs the Python toolbox. It does **not** install the OpenFAST executable itself.

## Recommended installation workflow

Open PowerShell and run:

```powershell
git clone https://github.com/SMI-Lab-Inha/openfast_toolbox.git
cd openfast_toolbox

conda env create -f environment.yml
conda activate openfast-toolbox-env

python -m pip install -e .
python -m ipykernel install --user --name openfast-toolbox-env --display-name "openfast-toolbox-env"
```

## If the environment already exists

Use:

```powershell
conda activate openfast-toolbox-env
python -m pip install -e .
```

## OpenFAST executable

Students must also make sure OpenFAST is accessible.

Any one of the following is acceptable:

1. `OpenFAST.exe` is on `PATH`
2. the environment variable `OPENFAST_EXE` points to the executable
3. the notebook or script sets the executable path explicitly

Example in PowerShell:

```powershell
$env:OPENFAST_EXE = "C:\Path\To\OpenFAST.exe"
```

## Verification

After installation, run these checks in PowerShell.

### Check Python packages

```powershell
python -c "import openfast_toolbox, numpy, pandas, matplotlib; print('Python environment OK')"
```

### Check Jupyter kernel

```powershell
python -m jupyter kernelspec list
```

You should see `openfast-toolbox-env` in the list.

### Check OpenFAST

If OpenFAST is on `PATH`:

```powershell
OpenFAST.exe /h
```

If you are using `OPENFAST_EXE`:

```powershell
& $env:OPENFAST_EXE /h
```

## Troubleshooting

### `conda` is not on PATH

If Miniconda or Anaconda is installed but `conda` is not on `PATH`, students can use the full path to `conda.exe` or `_conda.exe`.

Example:

```powershell
& "C:\Users\<username>\miniconda3\condabin\conda.bat" activate openfast-toolbox-env
```

or

```powershell
& "C:\Users\<username>\miniconda3\_conda.exe" env create -f environment.yml
```

### Wrong Python environment in Jupyter

Make sure the notebook kernel is set to:

```text
openfast-toolbox-env
```

### Editable install points to the wrong clone

Check:

```powershell
python -m pip show openfast_toolbox
```

The displayed location should match the repository folder the student actually cloned.

## Suggested classroom checklist

Before students start the notebook, ask them to verify:

1. `conda activate openfast-toolbox-env` works
2. `python -c "import openfast_toolbox"` works
3. `OpenFAST.exe /h` or `& $env:OPENFAST_EXE /h` works
4. Jupyter shows the `openfast-toolbox-env` kernel
