# Copyright (C) 2019 Marcos Slomp - All Rights Reserved
# You may use, distribute and modify this code under the
# terms of the MIT license.

function pause()
{
	read -p "$*"
}



if [ $# -eq 0 ]
then
	echo
else
	pushd $1
fi

for directory in */ ; do
	echo $directory
	pushd "$directory"
		git fetch
		git pull
	popd
	echo
done

pause "Press [Enter] to quit..."

if [ $# -eq 0 ]
then
	echo
else
	popd
fi
