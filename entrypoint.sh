#!/bin/sh

# Unlocks a repository from a provided GPG configuration and runs the passed
# script.
#
# Usage ./entyrypoint.sh /path/to/script

set -e

fail() {
    if [ $? == 0 ]; then
        return
    fi
    cat <<EOF
        ,
       /|
      / |
     /  /
    |   |
   /    |
   |    \\_
   |      \\__
   \\       __\\_______
    \\                 \\_
    | /                 \\
    \\/                   \\
     |                    |
     \\                   \\|
     |                    \\
     \\                     |
     /\\    \\_               \\
    / |      \\__ (   )       \\
   /  \\      / |\\\\  /       __\\____
snd|  ,     |  /\\ \\ \\__    |       \\_
   \\_/|\\___/   \\   \\}}}\\__|  (@)     )
    \\)\\)\\)      \\_\\---\\   \\|       \\ \\
                  \\>\\>\\>   \\   /\\__o_o)
                            | /  VVVVV
                            \\ \\    \\
                             \\ \\MMMMM                  oh bugger!
                              \\______/         _____ /
                                              |  O O|
                                             /___|_|/\\_
                                        ==( |          |
                                             (o)====(o)
EOF
}
trap fail EXIT

# Ensure that the GitHub GPG key is present
if [ ! "$INPUT_KEY" ]; then
    printf "You must provide a GPG private key in order to access your "
    printf "black box encrypted secrets!\n\n"
    exit 1
fi

# Authenticate via gpg
echo "Extracting gpg with: "
gpg --version

# Set the gpg home directory (see man gpg)
mkdir -m 0700 -p /tmp/.gnupg
export GNUPGHOME=/tmp/.gnupg

# Extract the provided gpg information in order to allow decryption...

printf "$INPUT_KEY" | gpg -v --import

# Unlock the repo
echo "Unlocking repo..."
blackbox_postdeploy

# Run the provided script to deploy...
if [ ! "$INPUT_DECRPYT_ONLY" ]; then
    sh /deploy.sh
fi


cat <<EOF
                                                     ___._
                                                   .'  <0>'-.._
                                                  /  /.--.____")
                                                 |   \\   __.-'~
                                                 |  :  -'/
                                                /:.  :.-'
__________                                     | : '. |
'--.____  '--------.______       _.----.-----./      :/
        '--.__            \`'----/       '-.      __ :/
              '-.___           :           \\   .'  )/
                    '---._           _.-'   ] /  _/
                         '-._      _/     _/ / _/
                             \\_ .-'____.-'__< |  \\___
                               <_______.\\    \\_\\_---.7
                              |   /'=r_.-'     _\\\\ =/
                          .--'   /            ._/'>
                        .'   _.-'
                       / .--'
                      /,/
                      |/\`)                                         DONE!
                      'c=,
EOF
