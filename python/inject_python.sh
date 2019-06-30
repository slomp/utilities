# Copyright (C) 2019 Marcos Slomp - All Rights Reserved
# You may use, distribute and modify this code under the
# terms of the MIT license.

# NOTE: in order for the environment variable to have effect on the calling parent
# shell make sure to call it through "source inject_python.sh" or ". inject_python.sh"

PYTHON_VERSION=$1

# if no Python version is given, default to Python 3.x
if [ -z "${PYTHON_VERSION}" ]
then
    PYTHON_VERSION=3
fi

export PATH=<path-to-python>/${PYTHON_VERSION}:$PATH
which python
