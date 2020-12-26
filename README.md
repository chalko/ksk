# Key Singing Key 


# Terminology

KSK:
 Key Sigining Key,  The Primary key used to generate other keys

Secondary:  
  Keys generated by the KSK.  These are the keys used everyday

# Prequeisits

Airgap linux system

* ununtu 20 live disk


## Passphrases

I used diceware.com

You will need 4 sperate passphrases

* KSK drive encryption
* KSK gpg
* tansfer drive encryption 
* secondary gpg  

## USB drives

### KSK drive

* FAT partition "KSK"
* luks ext4 ksk-secure

### Transfer drive

* xfer
  * FAT
* xfer-secure
  *LUKS ext4
# Processes

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
rm -rf ~/.gnupg $USB/ksk-secure/* ~/gpg-secondary ~/KSK
```

Create neeed dirs

``` 
mkdir ~/.gnupg 
chmod 700 ~/.gnupg
mkdir ~/gpg-secondary
chmod 700 ~/gpg-secondary
mkdir ~/KSK
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

Set environment varialbes to for KSK id and fingerprint

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

Export ksk

```
gpg --armor --export-secret-keys $KSK_ID > $KSK_ID.private.gpg-key
gpg --armor --export $KSK_ID > ~$KSK_ID.public.gpg-key

```

copy to USB

```
cp ${KSK_FINGERPRINT}.rev $USB/ksk-secure/${KSK_FINGERPRINT}.rev 
cp $KSK_ID.private.gpg-key $USB/ksk-secure/$KSK_ID.private.gpg-key
cp ~/KSK/$KSK_ID.public.gpg-key $USB/ksk-secure/$KSK_ID.public.gpg-key
cp ~/KSK/* $USB/KSK/
```

eject USB and copy to others



# Export Secondary keys

First import the primary
TODO


prep
```
rm -rf gpg-secondary
rm -rf xfer
mkdir xfer
mkdir gpg-secondary
chmod 700 gpg-secondary

```

copy gpg.conf


Setup just the secondary with different password
```
gpg --amror --export-secret-subkeys $KSK_ID > subkeys
gpg --homedir gpg-secondary/ --import subkeys
gpg --homedir gpg-secondary/ --import ~/KSK/$KSK_ID.public.gpg-key
gpg --homedir gpg-secondary/ 

```

extract just the secondary keys

``` 
gpg --homedir gpg-secondary/ --armor --export-secret-subkeys $KSK_ID > $KSK_ID.secret-subkeys.gpg-key
```


copy to the USB

```
cp $KSK_ID.secret-subkeys.gpg-key $USB/key-xfer-secure
cp $KSK_ID.public.gpg-key $USB/key-xfer-secure
cp KSK/* $USB/key-xfer

```







# Desired

git
paperkey

