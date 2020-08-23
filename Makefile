all:
	mv Gemfile _Gemfile && podman-compose up && mv _Gemfile Gemfile

clean:
	$(RM) -r _site

.PHONY: all clean
