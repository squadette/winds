index.html: winds.xml winds.xsl
	xsltproc --nonet -o $@ winds.xsl $<
	cp index.html winds.css ~/public_html/winds/
