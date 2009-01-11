
XML_FILES = $(patsubst %.txt, %.xml, $(wildcard *.txt))

.PHONY: all
all: ${XML_FILES} index.html

index.html: winds.xsl

index.html: ${XML_FILES}

index.html: winds.xml
	xsltproc --nonet -o $@ winds.xsl $<
	cp index.html winds.css ~/public_html/winds/

%.xml: %.txt to-docbook.pl
	./to-docbook.pl < $< > $@.tmp
	mv $@.tmp $@

.PHONY: stat
stat:
	wc -w *.txt
