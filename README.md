# Velociraptor

Velociraptor is a small action that allows you to decrypt blackbox encoded
secrets and use them to push images to a google cloud docker registry.

A simple workflow looks something like the following.

```hcl
workflow "Dinosaur" {
  on = "Push"
  resolves = "Raptor"
}

action "Raptor" {
  secrets = ["RAPTOR_GPG"]
  uses = "sevenmind/velociraptor"
}
```

That's it! The velociraptor action will build your image, push it to google
cloud and exit.

---

The following configuration options exist

| Name            | Description                             | Default             |
|:----------------|:----------------------------------------|:--------------------|
| RAPTOR_GPG      | A base64 encoded tar archive of gpg data| `-`                 |
| RAPTOR_IMAGE    | The name the built image should be taged| Repository Name     |
| RAPTOR_REGISTRY | The registry to push the image to       | eu.gcr.io/***REMOVED***|
