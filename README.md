# Velociraptor

Velociraptor is a small action that allows you to decrypt blackbox encoded
secrets and use them to push images to a google cloud docker registry. It
uses a provided gpg key in order to decrypt blackbox data which is than
available for any script passed as an argument.

If you do not pass any arguments to Velociraptor it follows its default
functionality of building an image and pushing to google cloud. It does this in
the following stages:

1. Looks for an encrypted JSON service account in the `.github/` folder, and
   decrypts it. (currently it looks for any `.json` file therein).
2. Adds the decrypted `.github` folder to your `.dockerignore`
3. Builds your image
4. Tags your image with the following default tags.
- latest
- the git branch it was pushed on
- the first 7 characters of the commit sha
- the full commit sha
5. Pushes to the provided repository.


A simple workflow looks something like the following.

```yaml
name: Demonstrate Velociraptor

# The event you wish to trigger your build on. This is almost allways push for
more CI integrations, but you can also restrict Velociraptor to merge if you wish.
on: push


jobs:
  deploy:
    # First we will download your code...
    name: Deploy With Raptor
    uses: ubuntu-latest
    steps:
    # Get your code
    - uses: actions/checkout@master

    # Build and deploy
    - uses: sevenmind/velociraptor@master
      with:
        registry: "docker.io/username"
        image: "image-name"
        key: ${{ secrets.RAPTOR_KEY }}
```

That's it! The velociraptor action will build your image, push it to google
cloud and exit.


> Note in previous version of Velociraptor we used a prefix of `RAPTOR_` for our
> arguments. This is no longer necessary as GitHub naively prefixes them. Be
> sure to change your configuration accordingly when upgrading!

## Decrypt Only

Sometimes you don't want to push to Google Cloud Registry, but do want to access
your secrets. To do this simply run velociraptor with `DECRYPT_ONLY: true` and
it will exit after executing a successful blackbox post deploy.

---

The following configuration options exist

| Name           | Description                             | Default         |
|:---------------|:----------------------------------------|:----------------|
| `KEY`          | A key authorized to decrypt secrets     | `-`             |
| `IMAGE`        | The name the built image should be taged| Repository Name |
| `REGISTRY`     | The registry to push the image to       | `-`             |
| `DECRYPT_ONLY` | Only decrypt, don't push the image      | `false`         |

---

If you want to do more, you can also pass the path to a script as an argument.
It will then be run with access to a docker executable and ALL decrypted
secrets.


## Recent Changes

Recently GitHub upgraded the capabilities of GitHub actions to support expanded
capabilities. This has dramatically increased the capabilities of github
Deployments, so of course Velociraptor has been updated to take advantage of
these features. However, if you are using a legacy version, you may notice some
breaking changes for older workflows. In that case please use a legacy copy of
velociraptor by specifying

```hcl
uses = "sevenmind/velociraptor@3414e2fb1a3f55280eac2d1de3576a6885c2017e"
```
