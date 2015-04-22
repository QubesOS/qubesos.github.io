JEKYLLOPTS = --verbose --trace

all:
	jekyll build $(JEKYLLOPTS)

clean:
	$(RM) -r _site

serve:
	jekyll serve $(JEKYLLOPTS)

.PHONY: all clean serve
