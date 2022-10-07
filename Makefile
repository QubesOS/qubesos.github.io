all:
	podman-compose up

clean:
	$(RM) -r _site

rootless:
	podman run --interactive --tty --publish 4000:4000 --volume .:/srv/jekyll --env JEKYLL_ROOTLESS=1 jekyll/jekyll:pages jekyll serve

.PHONY: all clean rootless
