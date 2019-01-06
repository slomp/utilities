# Copyright (C) 2019 Marcos Slomp - All Rights Reserved
# You may use, distribute and modify this code under the
# terms of the MIT license.

# update package list and upgrade packages
pacman -Syuu
#--force (deprecated in favor of --overwrite)
#--overwrite *

# cleanup
pacman -Scc

exit
