# Copyright (C) 2019 Marcos Slomp - All Rights Reserved
# You may use, distribute and modify this code under the
# terms of the MIT license.

# NOTE: in order for the environment variable to have effect on the calling parent
# shell make sure to call it through "source inject_python.sh" or ". inject_python.sh"
export PATH=<path-to-WinPython>/python-2.7.13.amd64:$PATH
which python
