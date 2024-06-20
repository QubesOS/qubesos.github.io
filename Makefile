all:
	podman-compose up

clean:
	$(RM) -r _site

rootless:
	jekyll serve

rootless-setup:
	gem install --user-install github-pages webrick

.PHONY: all clean rootless rootless-setup
