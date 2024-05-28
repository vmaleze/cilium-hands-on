#!/bin/sh -e

cd "$(dirname $0)"

config=$(cat - <<EOF
Host $(cat ../instance-address)
  HostName $(cat ../instance-address)
  User ubuntu
  IdentityFile $(pwd)/../ssh.key
EOF
)

echo "Pour pouvoir se connecter par SSH, ce script doit mettre à jour le fichier ~/.ssh/config avec le contenu suivant:
$config"

echo -n "Mettre à jour le fichier (mettre N si le fichier est déjà à jour)? (O/N): "

read response

if [ "${response}" = "O" ]
then
    mkdir -p ~/.ssh
    cp ~/.ssh/config ~/.ssh/config.backup$(date +%s)
    echo "" >> ~/.ssh/config
    echo "$config" >> ~/.ssh/config
    echo "" >> ~/.ssh/config
fi

code --remote ssh-remote+ubuntu@$(cat ../instance-address) /home/ubuntu/workshop