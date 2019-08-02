# Velociraptor

Velociraptor is a small action that allows you to decrypt blackbox encoded
secrets and use them to push images to a google cloud docker registry. It
uses a provided gpg key in order to decrypt blackbox data which is than
available for any script passed as an argument.

If you do not pass any arguments to Velociraptor it follows its default
functionality of building an image and pushgin to google cloud. It does this in
the following stages:

1. Looks for an encrypted JSON service account in the `.github/` folder, and
   decrypts it. (currently it looks for any `.json` file therin).
2. Builds your image
3. Tags your image with the following default tags.
- latest
- the git branch it was pushed on
- the first 7 characters of the commit sha
- the full commit sha
4. Pushes to the provided repository.


A simple workflow looks something like the following.

```hcl
workflow "Dinosaur" {
  on = "Push"
  resolves = "Raptor"
}

action "Raptor" {
  secrets = ["RAPTOR_KEY"]
  env {
    RAPTOR_REGISTRY = "docker.io/username"
    RAPTOR_IMAGE = "image-name"
  }
  uses = "sevenmind/velociraptor@master"
}
```

That's it! The velociraptor action will build your image, push it to google
cloud and exit.

---

The following configuration options exist

| Name            | Description                             | Default         |
|:----------------|:----------------------------------------|:----------------|
| RAPTOR_KEY      | A key authorized to decrypt secrets     | `-`             |
| RAPTOR_IMAGE    | The name the built image should be taged| Repository Name |
| RAPTOR_REGISTRY | The registry to push the image to       | `-`             |

---

If you want to do more, you can also pass the path to a script as an argument.
It will then be run with access to a docker executable and ALL decrypted
secrets.
