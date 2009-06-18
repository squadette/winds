
XML_FILES = $(patsubst %.txt, %.xml, $(wildcard *.txt))

.PHONY: all
all: ${XML_FILES} index.html

index.html: winds.xsl

index.html: ${XML_FILES}

index.html: winds.xml
	xsltproc --nonet -o $@ winds.xsl $< 2> missed
	cat missed | sort | uniq -c | sort -n
	wc -l missed
	cp index.html winds.css ~/public_html/winds/

%.xml: %.txt to-docbook.pl Makefile
	./to-docbook.pl < $< | fmt -w 130 > $@.tmp
	mv $@.tmp $@

.PHONY: stat
stat:
	wc -w *.txt
