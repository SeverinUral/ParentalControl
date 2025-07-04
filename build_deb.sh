#!/bin/bash
# Fomenko A V  2025 (c)

cp -vf parentalcontrol deb/parentalcontrol/usr/bin/parentalcontrol

chmod +x deb/parentalcontrol/usr/bin/parentalcontrol

echo "Previous $(grep '^Version:' deb/parentalcontrol/DEBIAN/control)"
echo "Enter Version (x.x-x.x):"
read VERSION

rm -rfv deb/parentalcontrol/DEBIAN/control 

CONTROL_FILE="Package: parentalcontrol
Version: $VERSION
Section: misc
Architecture: all
Priority: optional
Depends: python3, python3-psutil
Maintainer: Alex <alexfomg@gmail.com>
Description: Parental Control
Installed-Size: $(du -sb deb/parentalcontrol | grep -o '^[0-9]*')" 

echo "$CONTROL_FILE" > deb/parentalcontrol/DEBIAN/control 

cd deb/
./make_deb.sh 
