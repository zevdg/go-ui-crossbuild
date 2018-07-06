# go-ui-crossbuild

Cross compiler for use with the [go ui library](https://github.com/andlabs/ui)  
Builds amd64 binaries for linux, windows and macOS(darwin)  
[zevdg/go-ui-crossbuild on dockerhub](https://hub.docker.com/r/zevdg/go-ui-crossbuild/)

### Usage

Mount your project to `/go/src/project_root` and invoke the `gouicrossbuild` command

#### Example

```bash
# -u flag creates files as the current user instead of root
# -e flag fixes issue with go's cache when running as non-root in docker
docker run -u $(id -u) -e XDG_CACHE_HOME='/tmp/.cache' \
-v $GOPATH/github.com/my-org/my-project:/go/src/project_root \
zevdg/go-ui-crossbuild gouicrossbuild [options]
```

### gouicrossbuild usage

`gouicrossbuild [-s src_directory] [-p package_directory] [-o output_directory] [go_build_args...]`

#### Options

All paths must be relative to the project root

**src_directory** (default '.')  
The root source folder  
Must contain a vendor directory that includes "github.com/andlabs/ui"  
This parameter will be deprecated once https://github.com/andlabs/ui/issues/230 is fixed

**package_directory** (default '.')  
 The directory containing the package to be built

**output_directory** (default '.')  
 Where to save the build output

#### Examples

```
# build the package at <project_root> with vendor directory <project_root>/vendor
# output to <project_root>
gouicrossbuild

# build the package at <project_root>/src/cmd/gui with vendor directory <project_root>/src/vendor
# output to <project_root>/bin
gouicrossbuild -s src -p src/cmd/gui -o bin
```

## Licensing info

Building for macOS uses code from the Apple SDK  
[Please read and understand the Apple Xcode and SDK license before using.](https://www.apple.com/legal/sla/docs/xcode.pdf)
