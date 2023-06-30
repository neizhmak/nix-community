{ lib
, buildPythonPackage
, ddt
, fetchFromGitHub
, importlib-metadata
, jsonschema
, lxml
, packageurl-python
, py-serializable
, pythonRelaxDepsHook
, poetry-core
, pytestCheckHook
, pythonOlder
, requirements-parser
, sortedcontainers
, setuptools
, toml
, types-setuptools
, types-toml
, xmldiff
}:

buildPythonPackage rec {
  pname = "cyclonedx-python-lib";
  version = "4.0.1";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "CycloneDX";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-GCY7M0XnVsGyuADSq/EzOy9fged5frj+hRDLhs2Uq8I=";
  };

  nativeBuildInputs = [
    poetry-core
    pythonRelaxDepsHook
  ];

  propagatedBuildInputs = [
    importlib-metadata
    packageurl-python
    requirements-parser
    setuptools
    sortedcontainers
    toml
    py-serializable
    types-setuptools
    types-toml
  ];

  nativeCheckInputs = [
    ddt
    jsonschema
    lxml
    pytestCheckHook
    xmldiff
  ];

  pythonImportsCheck = [
    "cyclonedx"
  ];

  pythonRelaxDeps = [
    "py-serializable"
  ];

  preCheck = ''
    export PYTHONPATH=tests''${PYTHONPATH+:$PYTHONPATH}
  '';

  pytestFlagsArray = [
    "tests/"
  ];

  disabledTests = [
    # These tests require network access.
    "test_bom_v1_3_with_metadata_component"
    "test_bom_v1_4_with_metadata_component"
  ];

  meta = with lib; {
    description = "Python library for generating CycloneDX SBOMs";
    homepage = "https://github.com/CycloneDX/cyclonedx-python-lib";
    changelog = "https://github.com/CycloneDX/cyclonedx-python-lib/releases/tag/v${version}";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
