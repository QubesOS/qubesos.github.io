JEKYLLOPTS = --verbose --trace

all:
	bundle exec jekyll build $(JEKYLLOPTS)

clean:
	$(RM) -r _site

serve:
	bundle exec jekyll serve --watch $(JEKYLLOPTS)

.PHONY: all clean serve
