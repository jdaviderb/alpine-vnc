# About
x11vnc on alpine 3.7 linux (based on danielguerra/alpine-vnc) with configured chromium and AutoFirma (Spanish digital signature application).

The chromium will have a test1 auto-signed certificate

It must be run in privileged container or chromium will not run for alpine user.

User: alpine
Password: alpine 

# Usage

docker run -d -p 5900:5900 rcgcoder/alpine-vnc

After this use vnc-client to connect to your alpine.
Right click shows the menu

Everything runs as user alpine. This user has sudo rights.

The password=alpine you can change is with passwd in
the xterm.


