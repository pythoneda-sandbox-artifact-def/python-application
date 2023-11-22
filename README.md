# pythoneda-sandbox-artifact/python-application

Definition of <https://github.com/pythoneda-sandbox-artifact/python-application>.

## How to declare it in your flake

Check the latest tag of this repository and use it instead of the `[version]` placeholder below.

```nix
{
  description = "[..]";
  inputs = rec {
    [..]
    pythoneda-sandbox-artifact-python-application = {
      [optional follows]
      url =
        "github:pythoneda-sandbox-artifact-def/python-application/[version]";
    };
  };
  outputs = [..]
};
```

Should you use another PythonEDA modules, you might want to pin those also used by this project. The same applies to [https://nixos/nixpkgs](nixpkgs "nixpkgs") and [https://github.com/numtide/flake-utils](flake-utils "flake-utils").

## How to run it

``` sh
nix run 'https://github.com/pythoneda-sandbox-artifact-def/python-application/[version]'
```

### Usage

``` sh
nix run https://github.com/pythoneda-sandbox-artifact-def/python-application/[version] [-h|--help] [-r|--repository-folder folder] [-e|--event event] [-t|--tag tag]
```
- `-h|--help`: Prints the usage.
- `-r|--repository-folder`: The folder where <https://github.com/pythoneda-sandbox-artifact/python-artifact> is cloned.
- `-e|--event`: The event to send. See <https://github.com/pythoneda-shared-artifact/events>.
- `-t|--tag`: If the event is `TagPushed`, specify the tag.

