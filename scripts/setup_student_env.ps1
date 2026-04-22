param(
    [string]$EnvName = "openfast-toolbox-env",
    [string]$CondaExe = "conda"
)

$ErrorActionPreference = "Stop"

function Invoke-Conda {
    param(
        [Parameter(Mandatory = $true)]
        [string[]]$Args
    )

    & $CondaExe @Args
    if ($LASTEXITCODE -ne 0) {
        throw "Conda command failed: $CondaExe $($Args -join ' ')"
    }
}

Write-Host "Repository root: $PSScriptRoot\.."
Write-Host "Environment name: $EnvName"
Write-Host "Conda executable : $CondaExe"

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$envFile = Join-Path $repoRoot "environment.yml"

if (-not (Test-Path $envFile)) {
    throw "environment.yml not found at: $envFile"
}

Write-Host ""
Write-Host "Creating or updating conda environment from environment.yml..."
Invoke-Conda -Args @("env", "update", "--name", $EnvName, "--file", $envFile, "--prune")

$pythonExe = Join-Path (Split-Path (Split-Path $CondaExe -Parent) -Parent) ("envs\" + $EnvName + "\python.exe")
if (-not (Test-Path $pythonExe)) {
    Write-Host "Could not infer python.exe from Conda path. Falling back to 'python' after activation is left to the user."
    Write-Host "Run manually:"
    Write-Host "  conda activate $EnvName"
    Write-Host "  python -m pip install -e ."
    Write-Host "  python -m ipykernel install --user --name $EnvName --display-name `"$EnvName`""
    exit 0
}

Write-Host ""
Write-Host "Installing editable openfast_toolbox package..."
& $pythonExe -m pip install -e $repoRoot
if ($LASTEXITCODE -ne 0) {
    throw "Editable install failed."
}

Write-Host ""
Write-Host "Registering Jupyter kernel..."
& $pythonExe -m ipykernel install --user --name $EnvName --display-name $EnvName
if ($LASTEXITCODE -ne 0) {
    throw "Kernel registration failed."
}

Write-Host ""
Write-Host "Running verification import..."
& $pythonExe -c "import openfast_toolbox, numpy, pandas, matplotlib; print('Python environment OK')"
if ($LASTEXITCODE -ne 0) {
    throw "Verification import failed."
}

Write-Host ""
Write-Host "Setup completed successfully."
Write-Host "Next step: activate the environment and verify OpenFAST.exe is available."
