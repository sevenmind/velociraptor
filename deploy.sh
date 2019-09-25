#!/bin/sh

set -e

# A standard deployment program. It will look for a key file in .github, which
# has at this point been decrypted, and push the same to docker.
#
# Usage ./deploy.sh

image="$INPUT_IMAGE"
if [ ! "$image" ]; then
    # The name of the image is the repo name, we extract this as the last part
    # of the owner/repo-name object passed using awk.
    image=$(echo "$GITHUB_REPOSITORY" | awk -F '/' '{print $NF}')
fi

registry="$INPUT_REGISTRY"

echo "Building image $image and pushing it to $registry..."

echo "Looking for service account passwords..."
key=$(ls -1 .github/*.json | head -n 1)

if [ ! "$key" ]; then
    echo "Could not find a json key in the .github directory!"
    exit 1
fi
echo "Found key $key!"

echo "Adding .github to .dockerignore..."
echo ".github" >> .dockerignore

echo "Authenticating with google..."
docker login -u _json_key --password-stdin https://eu.gcr.io < $key

# Run the provided script to deploy...
if [ ! "$INPUT_PUSH_ONLY" ]; then
    echo "using existing image of $image"
    docker images
else
    echo "Building image..."
    docker build . -t $image
fi

echo "Tagging image..."
branch=$(echo "$GITHUB_REF" | awk -F '/' '{print $NF}')
docker tag $image $registry/$image:latest
docker tag $image $registry/$image:$GITHUB_SHA
docker tag $image $registry/$image:$branch
docker tag $image $registry/$image:${GITHUB_SHA:0:7}

echo "Pushing image..."
docker push $registry/$image
