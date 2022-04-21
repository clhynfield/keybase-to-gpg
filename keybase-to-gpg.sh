#!/usr/bin/env sh

export GPG_TTY=$(tty)
echo "hostname: $(hostname)"
keybase login --devicename $(hostname) clhynfield
keybase pgp export | gpg --import
keybase pgp export --secret | gpg --import --allow-secret-key-import
GPG_SECRET_KEYID=$(gpg --list-secret-keys  --keyid-format SHORT | awk '/^sec/{sub(".*/","",$2); print$2}')
echo "default-key:0:\"$GPG_SECRET_KEYID\"" | gpgconf --change-options gpg
echo test | gpg --clearsign
keybase deprovision

git config --global user.signingkey $GPG_SECRET_KEYID
git config --global commit.gpgsign true
