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
if [ ! "$RAPTOR_GPG" ]; then
    printf "You must provide a GPG configuration in order to access your "
    printf "black box encrypted secrets!\n\n"
    printf "This should be gziped tar file \n"
    exit 1
fi

# Authenticate via gpg
echo "Extracting gpg with: "
gpg --version

# Set the gpg home directory (see man gpg)
mkdir -m 0700 -p /tmp/.gnupg
export GNUPGHOME=/tmp/.gnupg

# Extract the provided gpg information in order to allow decryption...
echo $RAPTOR_GPG | base64 -d | tar -C /tmp/.gnupg -xvpf -

# Import key ring
#if [ -f ./keyrings/live/pubring.kbx ]; then
#    gpg --import ./keyrings/live/pubring.kbx
#elif [ -f ./keyrings/live/pubring.gpg ]; then
#    gpg --import ./keyrings/live/pubring.gpg
#elif [ -f ./.blackbox/pubring.kbx ]; then
#    gpg --import ./.blackbox/pubring.kbx
#elif [ -f ./.blackbox/pubring.gpg ]; then
#    gpg --import ./.blackbox/pubring.gpg
#else
#    echo "Looks like you don't have any black box keys present!"
#    exit 1
#fi

# Unlock the repo
echo "Unlocking repo..."
blackbox_postdeploy

# Run the provided script to deploy...
cmd="$1"
sh ${cmd:-/deploy.sh}


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
