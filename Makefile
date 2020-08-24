all:
	podman-compose up

clean:
	$(RM) -r _site

.PHONY: all clean
