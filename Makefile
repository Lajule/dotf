GOMPLATE ?= docker run --rm -u "$$(id -u):$$(id -g)" -v "$${PWD}:/src" -w /src hairyhenderson/gomplate:stable

all:
	$(GOMPLATE)
	(cd .tmp && tar czvf ../dotf.tar.gz .)

.PHONY: clean
clean:
	$(RM) -r .tmp dotf.tar.gz
