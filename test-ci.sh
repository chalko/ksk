#!/bin/bash
set -e

echo "Installing prerequisites..."
# Debian stretch is archived, update sources.list
echo "deb http://archive.debian.org/debian stretch main" > /etc/apt/sources.list
echo "deb http://archive.debian.org/debian-security stretch/updates main" >> /etc/apt/sources.list
# Disable Check-Valid-Until because archive signatures are expired
apt-get -o Acquire::Check-Valid-Until=false --allow-unauthenticated update || true
apt-get install -y --allow-unauthenticated gnupg git

echo "Setting up KSK_WORKDIR"
export KSK_WORKDIR=/dev/shm/ksk_work
mkdir -p $KSK_WORKDIR

# Use the current directory as the source for ksk
export KSK_SOURCE_DIR=$(pwd)

echo "Copying scripts to a safe working directory to mimic install..."
cp -r $KSK_SOURCE_DIR $KSK_WORKDIR/ksk
cd $KSK_WORKDIR/ksk

echo "Running install-ksk.sh (skip because we already copied to ksk, but let's test if it handles the repo)"
# We won't run install-ksk.sh as it clones from the current dir's .git to ~/ksk.
# Let's just use the current copy as ~/ksk.
# Actually, the scripts expect to find things in $KSK_WORKDIR or $DIR.

# Let's set KSK_WORKDIR to the current user's home since scripts currently hardcode some ~/,
# but wait, the plan was to not change the ~/ inside the scripts just yet according to user instructions.
# Let's set HOME=$KSK_WORKDIR so that ~/ resolves to our temp dir.
export HOME=$KSK_WORKDIR

# Git config to prevent author unknown issues
git config --global user.email "test@example.com"
git config --global user.name "Test User"

echo "Running create-primary-keys.sh..."
KSK_NAME="Test User" KSK_EMAIL="test@example.com" KSK_PASSPHRASE="testphrase" ./create-primary-keys.sh

echo "Verifying primary keys were created..."
if [ ! -d "$HOME/gpg-primary" ]; then
    echo "Failed: $HOME/gpg-primary not created"
    exit 1
fi
if [ ! -d "$HOME/ksk-secure" ]; then
    echo "Failed: $HOME/ksk-secure not created"
    exit 1
fi

echo "Running extract-secondary-keys.sh..."
KSK_PASSPHRASE="testphrase" ./extract-secondary-keys.sh

echo "Verifying secondary keys were extracted..."
if [ ! -d "$HOME/secondary-secure" ]; then
    echo "Failed: $HOME/secondary-secure not created"
    exit 1
fi

echo "Testing backup-primary-keys.sh..."
./backup-primary-keys.sh $HOME/backup-primary

if [ ! -d "$HOME/backup-primary" ]; then
    echo "Failed: backup-primary not created"
    exit 1
fi

echo "Testing backup-secondary-keys.sh..."
./backup-secondary-keys.sh $HOME/backup-secondary

if [ ! -d "$HOME/backup-secondary" ]; then
    echo "Failed: backup-secondary not created"
    exit 1
fi

echo "All CI tests passed successfully!"
