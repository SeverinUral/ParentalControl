#!/bin/bash
# Fomenko A V  2025 (c)

POSTINST="
IyEvYmluL2Jhc2gKIyBGb21lbmtvIEEgViAoYykKCnNldCAtZSAjIGZhaWwgb24gYW55IGVycm9yCnNl
dCAtdSAjIHRyZWF0IHVuc2V0IHZhcmlhYmxlcyBhcyBlcnJvcnMKCiMgPT09PT09WyBUcmFwIEVycm9y
cyBdPT09PT09IwpzZXQgLUUgIyBsZXQgc2hlbGwgZnVuY3Rpb25zIGluaGVyaXQgRVJSIHRyYXAKCiMg
VHJhcCBub24tbm9ybWFsIGV4aXQgc2lnbmFsczoKIyAxL0hVUCwgMi9JTlQsIDMvUVVJVCwgMTUvVEVS
TSwgRVJSCnRyYXAgZXJyX2hhbmRsZXIgMSAyIDMgMTUgRVJSCmZ1bmN0aW9uIGVycl9oYW5kbGVyIHsK
bG9jYWwgZXhpdF9zdGF0dXM9JHsxOi0kP30KbG9nZ2VyIC1zIC1wICJzeXNsb2cuZXJyIiAtdCAib290
eW5jLmRlYiIgInN1cGVyc2guZGViIHNjcmlwdCAnJDAnIGVycm9yIGNvZGUgJGV4aXRfc3RhdHVzIChs
aW5lICRCQVNIX0xJTkVOTzogJyRCQVNIX0NPTU1BTkQnKSIKZXhpdCAkZXhpdF9zdGF0dXMKfQoKY2ht
b2QgNjQ0IC9saWIvc3lzdGVtZC9zeXN0ZW0vcGFyZW50YWxjb250cm9sLnNlcnZpY2UKc3lzdGVtY3Rs
IGRhZW1vbi1yZWxvYWQKc3lzdGVtY3RsIGVuYWJsZSBwYXJlbnRhbGNvbnRyb2wKc3lzdGVtY3RsIHN0
YXJ0IHBhcmVudGFsY29udHJvbAoKZXhpdCAwCg=="
POSTRM="
IyEvYmluL2Jhc2gKIyBGb21lbmtvIEEgViAoYykKCnNldCAtZSAjIGZhaWwgb24gYW55IGVycm9yCnNl
dCAtdSAjIHRyZWF0IHVuc2V0IHZhcmlhYmxlcyBhcyBlcnJvcnMKCiMgPT09PT09WyBUcmFwIEVycm9y
cyBdPT09PT09IwpzZXQgLUUgIyBsZXQgc2hlbGwgZnVuY3Rpb25zIGluaGVyaXQgRVJSIHRyYXAKCiMg
VHJhcCBub24tbm9ybWFsIGV4aXQgc2lnbmFsczoKIyAxL0hVUCwgMi9JTlQsIDMvUVVJVCwgMTUvVEVS
TSwgRVJSCnRyYXAgZXJyX2hhbmRsZXIgMSAyIDMgMTUgRVJSCmZ1bmN0aW9uIGVycl9oYW5kbGVyIHsK
bG9jYWwgZXhpdF9zdGF0dXM9JHsxOi0kP30KbG9nZ2VyIC1zIC1wICJzeXNsb2cuZXJyIiAtdCAib290
eW5jLmRlYiIgInN1cGVyc2guZGViIHNjcmlwdCAnJDAnIGVycm9yIGNvZGUgJGV4aXRfc3RhdHVzIChs
aW5lICRCQVNIX0xJTkVOTzogJyRCQVNIX0NPTU1BTkQnKSIKZXhpdCAkZXhpdF9zdGF0dXMKfQoKI3N5
c3RlbWN0bCBzdG9wIHBhcmVudGFsY29udHJvbApzeXN0ZW1jdGwgZGlzYWJsZSBwYXJlbnRhbGNvbnRy
b2wKcm0gLXJmIC9saWIvc3lzdGVtZC9zeXN0ZW0vcGFyZW50YWxjb250cm9sLnNlcnZpY2UKc3lzdGVt
Y3RsIGRhZW1vbi1yZWxvYWQKCmV4aXQgMAo="
SERVICE="[Unit]
Description=Parental control
After=multi-user.target
[Service]
Type=idle
ExecStart=/usr/bin/parentalcontrol
User=root
Group=root
[Install]
WantedBy=multi-user.target"

mkdir -pv deb/parentalcontrol/{DEBIAN/,lib/systemd/system/,usr/bin/}

echo "$POSTINST" | base64 -di > deb/parentalcontrol/DEBIAN/postinst
echo "$POSTRM" | base64 -di > deb/parentalcontrol/DEBIAN/postrm
echo "$SERVICE" > deb/parentalcontrol/lib/systemd/system/parentalcontrol.service

chmod +x deb/parentalcontrol/DEBIAN/post*

cp -vf parentalcontrol deb/parentalcontrol/usr/bin/parentalcontrol
chmod +x deb/parentalcontrol/usr/bin/parentalcontrol

echo "Previous version $(ls *.deb | grep -o '[0-9]*.[0-9]*-[0-9]*.[0-9]*')"
read -p "Enter Version (x.x-x.x): " VERSION

rm -rfv *.deb

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

fakeroot dpkg-deb --build parentalcontrol .

mv *.deb ..

cd ..

rm -rf deb
