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
  secrets = ["RAPTOR_KEY"]
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

By default your image will have the following tags

- latest
- the git branch it was pushed on
- the first 7 characters of the commit sha
- the full commit sha
