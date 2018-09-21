all:
	mv Gemfile _Gemfile && docker-compose up && mv _Gemfile Gemfile

clean:
	$(RM) -r _site

.PHONY: all clean
