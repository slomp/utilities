# Copyright (C) 2019 Marcos Slomp - All Rights Reserved
# You may use, distribute and modify this code under the
# terms of the MIT license.

# -np : never visit parent, only visit children
# -nc : don't download file if it already exists locally
# -r : recurse
# -R "index.html*" : acoid downloading auto-generated 'index.html' file
# $1 : sh parameter corresponding to an URL
wget -r -nc -np -R "index.html*" $1
