# BUILD := doc
OUTPUT := doc

css := $(patsubst css/%.scss,$(OUTPUT)/css/%.css,$(wildcard css/*.scss))

md := $(patsubst %.md,$(OUTPUT)/%.xml,$(wildcard *.md))

mdFiles := $(shell find . -type f -name "*.md")

.PHONY: all clean css tei2html md2tei

all: clean css md2tei tei2html

clean:
	@echo 'cleaning…'
	@rm -rf $(OUTPUT) .sass*

css: $(OUTPUT) $(css)

md2tei: $(md)

tei2html: $(md)
	@for f in $(shell find $(OUTPUT) -type f -name "*.xml") ; \
	do echo 'transforming…' $$f ; \
	teitohtml $$f $$f.html ; \
	done ;

$(OUTPUT):
	mkdir -p $(OUTPUT)

$(OUTPUT)/css/%.css: css/%.scss
	@mkdir -p $(@D)
	sass $< $@

$(OUTPUT)/%.xml: %.md
	@mkdir -p $(@D)
	markdowntotei $< $@
