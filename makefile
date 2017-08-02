BUILD := doc
OUTPUT := $(BUILD)/css
TMP := $(BUILD)/tmp

css := $(patsubst css/%.scss,$(OUTPUT)/%.css,$(wildcard css/*.scss))

md := $(patsubst %.md,$(TMP)/%.xml,$(wildcard *.md))

mdFiles := $(shell find . -type f -name "*.md")

.PHONY: all clean css tei2html md2tei

all: clean css md2tei tei2html

clean:
	@echo 'cleaning…'
	@rm -rf $(BUILD) $(TMP) .sass*

css: $(css)

md2tei: $(md)

tei2html:
	@for f in $(shell find $(TMP) -type f -name "*.xml") ; \
	do echo 'transforming…' $$f ; \
	teitohtml $$f $$f.html ; \
	done ;

$(OUTPUT):
	mkdir -p $(OUTPUT)

$(OUTPUT)/%.css: css/%.scss $(OUTPUT)
	sass $< $@

$(TMP):
	mkdir $(TMP)

$(TMP)/%.xml: %.md $(mdFiles) $(OUTPUT) $(TMP)
	markdowntotei $< $@
