# Export primary

gpg --homedir ~/gpg-primary --armor --export $KSK_ID > ~/ksk-secure/$KSK_ID.public.gpg-key
gpg --homedir ~/gpg-primary --armor --export-secret-keys $KSK_ID > ~/ksk-secure/$KSK_ID.private.gpg-key
gpg --homedir ~/gpg-primary --armor --export-secret-subkeys $KSK_ID > ~/ksk-secure/$KSK_ID.sub-private.gpg-key
gpg --homedir ~/gpg-primary --export-ownertrust > ~/ksk-secure/ownertrust.txt

