PRG = /usr/local/bin/texi2any
HTML_OPT = --html --no-split --css-include=style.css
ORIG = $(HOME)/dev/vim/runtime/
TRAN = ./

USRMANUALS = \
	doc/usr_toc.texi \
	doc/usr_01.texi \
	doc/usr_02.texi \
	doc/usr_03.texi \
	doc/usr_04.texi \
	doc/usr_05.texi \
	doc/usr_06.texi \
	doc/usr_07.texi \
	doc/usr_08.texi \
	doc/usr_09.texi \
	doc/usr_10.texi \
	doc/usr_11.texi \
	doc/usr_12.texi

html: htmls/usrman.html ;
pdf: pdfs/userman.pdf ;

htmls/usrman.html: $(USRMANUALS)
	${PRG} ${HTML_OPT} -o $@ $<

pdfs/userman.pdf: $(USRMANUALS)
	@ PDFTEX=luatex texi2pdf -c -o $@ $<

diffja:
	@ ORIG_DOC=$(ORIG) ruby utils/diff_trans.rb $(USRMANUALS)

clean:
	@rm htmls/*
	@rm pdfs/*
