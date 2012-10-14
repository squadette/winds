
XML_FILES = $(patsubst %.txt, %.xml, $(wildcard *.txt))

.PHONY: all
all: ${XML_FILES} index.html

index.html: winds.xsl

index.html: ${XML_FILES}

index.html: winds.xml
	SGML_CATALOG_FILES=/usr/local/etc/xml/catalog xsltproc --catalogs -o $@ winds.xsl $< 2> missed.tmp
	cat missed.tmp | sed -e 's/Error: no ID for constraint linkend: //' | sort | uniq -c | sort -n > missed
	git diff missed | cat
	rm -f missed.tmp

%.xml: %.txt to-docbook.pl Makefile
	./to-docbook.pl < $< | fmt -w 70 > $@.tmp
	mv $@.tmp $@

.PHONY: stat
stat:
	wc -w *.txt
