all:
	bundle exec jekyll build

clean:
	$(RM) -r _site

serve:
	bundle exec jekyll serve --watch

.PHONY: all clean serve
