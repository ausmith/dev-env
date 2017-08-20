# dev-env

Abstracting my local development environment into a single container
to move the toolchain into something that can easily be updated on a
regular basis. Takes advantage of the isolation found when using a
container so I can avoid conflicts with OS level tools (like the
default `sed` tool in Mac OS X being different than the latest from
GNU `sed`).

## How to use

```
# Build the container
make build
# Run the container
make run
# Exec into the container for all your working glory
docker exec --user=${USER} -it dev bash

...

# Cleanup any running container
make cleanup
```

## Dependencies

While not REQUIRED to run the container, some nice helpers have been
baked into my dotfiles. These can be found at [ausmith/dotfiles](https://github.com/ausmith/dotfiles).

Otherwise, you need a version of docker to build the container.

### ausmith/dotfiles: parts to call out

* In the `profile` we have an alias for `devenv`, this gives us
quick access into our development environment's container
* In the `bashrc` we have a section denoted with `<SSH agent setup>`
that is to ensure the SSH agent is running with the right ID
