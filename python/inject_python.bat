:: Copyright (C) 2019 Marcos Slomp - All Rights Reserved
:: You may use, distribute and modify this code under the
:: terms of the MIT license.

@SET PYTHON_VERSION=%1

:: if no Python version is given, default to Python 3.x
@IF [%PYTHON_VERSION%] == [] set PYTHON_VERSION=3

@SET PATH=<path-to-python>\\%PYTHON_VERSION%;%PATH%
where python
