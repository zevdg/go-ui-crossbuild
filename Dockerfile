FROM magj/go-ui-crossbuild-base
COPY gouicrossbuild.sh /bin/gouicrossbuild
RUN chmod +x /bin/gouicrossbuild
WORKDIR /go/src/project_root
