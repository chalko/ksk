# Key Singing Key 


# Terminology

KSK:
 **K**ey **S**igning **K**ey, the primary key used to generate other keys.

Secondary:  
  Keys generated by the KSK.  These are the keys used everyday

# Prerequisites

Airgap linux system

* Ubuntu 20 live disk


## Passphrases

I used [diceware](http://diceware.com).

You will need 4 separate passphrases

* KSK drive encryption
* KSK gpg
* transfer drive encryption 
* secondary gpg  

## USB drives

### KSK drive

* FAT partition "KSK"
* luks ext4 ksk-secure

### Transfer drive

* FAT partition "KSK"
* xfer-secure
  *LUKS ext4


## Scripted process

### Install KSK

On an internet connected host clone ksk source in to ~/ksk

``` 
git clone https://github.com/chalko/ksk.git ~/ksk
```

To install on an airgapped system clone source into an unencrypted partition of the xfer USB
``` 
git clone https://github.com/chalko/ksk.git /media/$USER/KSK
```

Then on the airgapped system run

``` 
/media/$USER/KSK/install-ksk.sh
```








# Manual Process

## Usefull aliases for 

```
# USB mount point
# Ubuntu live
export USB=/media/ubuntu

```




## Create Primary

WARN:This must be done from a airgapped system with a reliable OS

* insert KSK drive

Delete stuff

```
rm -rf ~/.gnupg ~/gpg-secondary
```

Create neeed dirs

``` 
mkdir ~/.gnupg 
chmod 700 ~/.gnupg
mkdir ~/gpg-secondary
chmod 700 ~/gpg-secondary
```

Copy KSK setup from clear disk

```
cp $USB/KSK/* ~/KSK
```


### Create the Primary Key

```
export NAME="My Name"
export EMAIL="my@email.com"
```

```
gpg --quick-generate-key "${NAME} <${EMAIL}>" future-default

```

Set environment variables to for KSK id and fingerprint

```
gpg -k
```

```
export KSK_ID="0xTODO"
export KSK_FINGERPRINT="TODO"
```

Copy revocation
```
cp ~/.gnupg/openpgp-revocs.d/${KSK_FINGERPRINT}.rev \
  ${KSK_FINGERPRINT}.rev
```

Create secondary signing key

```
gpg --quick-add-key $KSK_FINGERPRINT future-default sign
```

Creat a key for ssh
```
gpg --quick-add-key $KSK_FINGERPRINT rsa auth
```

Export ksk

```
rm -rf ~/ksk-secure
git clone $USB/ksk-secure/.git ~/ksk-secure
gpg --armor --export $KSK_ID > ~/ksk-secure/$KSK_ID.public.gpg-key
gpg --armor --export-secret-keys $KSK_ID > ~/ksk-secure/$KSK_ID.private.gpg-key
gpg --export-secret-subkeys --armor  $KSK_ID > ~/ksk-secure/$KSK_ID.sub_priv.gpg-key
gpg --export-ownertrust > ~/ksk-secure/ownertrust.txt

git -C ~/ksk-secure/ commit -a
```

copy to USB

```shell
git -C  $USB/ksk-secure/ pull ~/ksk-secure/.git
git -C  $USB/ksk/ pull ~/ksk/.git
```

eject USB and copy other USBs

Clean up

```shell
rm -rf  ~/ksk-secure/
```




# Export Secondary keys
Insert a KSK drive

First import the primary

```
gpg --import $USB/ksk-secure/$KSK_ID.public.gpg-key
gpg --import $USB/ksk-secure/$KSK_ID.private.gpg-key
gpg --import $USB/ksk-secure/$KSK_ID.sub_priv.gpg-key
gpg --import-ownertrust $USB/ksk-secure/ownertrust.txt

```

Remove the KSK drive

prep
```
rm -rf ~/xfer-secure
git -C  $USB/xfer-secure/ clone ~/xfer-secure
rm -rf ~/gpg-secondary
mkdir gpg-secondary
chmod 700 gpg-secondary

```


Setup just the secondary with different password
```
gpg --armor --export $KSK_ID > ~/xfer-secure/$KSK_ID.public.gpg-key
gpg --armor --export $KSK_ID > ~/ksk/$KSK_ID.public.gpg-key
gpg --armor --export-secret-subkeys $KSK_ID > subkeys
gpg --export-ownertrust > ~/xfer-secure/ownertrust.txt
gpg --homedir gpg-secondary/ --import ~/xfer-secure/$KSK_ID.public.gpg-key
gpg --homedir gpg-secondary/ --import subkeys
gpg --homedir gpg-secondary/ --import-ownertrust  ~/xfer-secure/ownertrust.txt
rm subkeys
```

change  set the xfer password

```shell
gpg --homedir gpg-secondary/ --change-passphrase $KSK_ID
```

extract just the secondary keys

``` 
gpg --homedir gpg-secondary/ \
    --armor --export-secret-subkeys $KSK_ID \
    > ~/xfer-secure/$KSK_ID.secret-subkeys.gpg-key
```

copy to the USB

```
git -C  $USB/xfer-secure/ pull ~/xfer-secure/.git
git -C  $USB/ksk/ pull ~/ksk/.git
```

cleanup

```shell
rm -rf ~/xfer-secure/
```


# update KSK

```shell
git -C  $USB/ksk/ pull ~/ksk/.git

```



# Import from transfer USB


```
gpg --import $USB/xfer-secure/$KSK_ID.public.gpg-key
gpg --import $USB/xfer-secure/$KSK_ID.secret-subkeys.gpg-key
gpg --import-ownertrust $USB/xfer-secure/ownertrust.txt

```

# Desired

git
paperkey
