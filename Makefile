all:
	podman-compose up

clean:
	$(RM) -r _site

rootless:
	podman run --rm --interactive --tty --publish 4000:4000 --volume .:/srv/jekyll:Z --env JEKYLL_ROOTLESS=1 --env LOCAL_QUBES_DOCS=1 jekyll/jekyll:pages jekyll serve

.PHONY: all clean rootless
