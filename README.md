# pythoneda-sandbox/python-artifact-application-artifact

Artifact space for <https://github.com/pythoneda-sandbox/python-artifact-application>.

## How to run it

``` sh
nix run 'https://github.com/pythoneda-sandbox/python-artifact-application-artifact/[version]?dir=python-artifact-application'
```

### Usage

``` sh
nix run https://github.com/pythoneda-sandbox/python-artifact-application-artifact/[version] [-h|--help] [-r|--repository-folder folder] [-e|--event event] [-t|--tag tag]
```
- `-h|--help`: Prints the usage.
- `-r|--repository-folder`: The folder where <https://github.com/pythoneda-sandbox/python-artifact-application> is cloned.
- `-e|--event`: The event to send. See <https://github.com/pythoneda-shared-artifact/events>.
- `-t|--tag`: If the event is `TagPushed`, specify the tag.

