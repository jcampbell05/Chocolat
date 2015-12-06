# Chocolat

![Poster image from the movie 'Chocolat'](poster.png)

Generate podspecs from Swift packages.

## Usage

```bash
$ chocolat-cli Package.swift >MyPod.podspec.json
```

Make sure you run it from a Git checkout of your project, as Chocolat gets certain
metadata directly from Git. Having your repository hosted on GitHub will also
improve the generated output. The required `summary` attribute is not filled.

## Installation

Chocolat requires Swift 2.2, as it uses the [Swift Package Manager][1] to parse
the `Package.swift` files.

## Unit Tests

You can run the unit test using `make`:

```
$ make test
```

[1]: https://swift.org/package-manager/
