#!/bin/sh

# A standard deployment program. It will look for a key file in .github, which
# has at this point been decrypted, and push the same to docker.
#
# Usage ./deploy.sh

image=${RAPTOR_IMAGE_NAME:-$GITHUB_REPOSITORY}
registry="$RAPTOR_IMAGE_REGISTRY"

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

echo "Building image..."
docker build . -t $image

echo "Tagging image..."
docker tag $image $registry/$image:latest
docker tag $image $registry/$image:$GITHUB_SHA
docker tag $image $registry/$image:$GITHUB_REF
docker tag $image $registry/$image:${GITHUB_SHA:0:7}

echo "Pushing image..."
docker push $registry/$image
