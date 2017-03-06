PRG = /usr/local/bin/texi2any
PRG_KANA=$(HOME)/project/mto/src/mto.py
HTML_OPT = --html --css-include=style.css
ORIG = $(HOME)/dev/vim/runtime
TRAN = ./

REFMANUALS = \
	doc/help.texi \
	doc/quickref.texi \
	doc/uganda.texi \
	doc/sponsor.texi \
	doc/intro.texi \
	doc/helphelp.texi \
	doc/index.texi \
	doc/howto.texi \
	doc/tips.texi \
	doc/message.texi \
	doc/quotes.texi \
	doc/debug.texi \
	doc/develop.texi \
	doc/starting.texi \
	doc/editing.texi \
	doc/motion.texi \
	doc/scroll.texi \
	doc/insert.texi

USRMANUALS = \
	doc/usr_toc.texi \
	doc/usr_01.texi doc/usr_02.texi doc/usr_03.texi doc/usr_04.texi \
	doc/usr_05.texi doc/usr_06.texi doc/usr_07.texi doc/usr_08.texi \
	doc/usr_09.texi doc/usr_10.texi doc/usr_11.texi doc/usr_12.texi \
	doc/usr_20.texi doc/usr_21.texi doc/usr_22.texi doc/usr_23.texi \
	doc/usr_24.texi doc/usr_25.texi doc/usr_26.texi doc/usr_27.texi \
	doc/usr_28.texi doc/usr_29.texi doc/usr_30.texi doc/usr_31.texi \
	doc/usr_32.texi doc/usr_40.texi doc/usr_41.texi doc/usr_42.texi \
	doc/usr_43.texi doc/usr_44.texi doc/usr_45.texi doc/usr_90.texi

usrhtml: htmls/usrman.html ;
refonehtml: htmls/refman.html ;
refhtml: htmls/refman ;
usrpdf: pdfs/userman.pdf ;
refpdf: pdfs/refrman.pdf ;
kyukana: htmls/tk-ok-usrman.html ;

htmls/usrman.html: $(USRMANUALS)
	${PRG} ${HTML_OPT} --no-split -o $@ $<
	sh utils/trick_for_mobile.sh $@

htmls/refman.html: $(REFMANUALS) $(USRMANUALS)
	${PRG} ${HTML_OPT} --no-split -o $@ $<

htmls/refman: $(REFMANUALS) $(USRMANUALS)
	${PRG} ${HTML_OPT} -o $@ $<

pdfs/userman.pdf: $(USRMANUALS)
	PDFTEX=luatex texi2pdf -c -o $@ $<

pdfs/refrman.pdf: $(REFMANUALS)
	PDFTEX=luatex texi2pdf -c -o $@ $<

htmls/tk-usrman.html: htmls/usrman.html
	python3 $(PRG_KANA) tradkana $< > $@

htmls/tk-ok-usrman.html: htmls/tk-usrman.html
	python3 $(PRG_KANA) oldkanji $< > $@

diffja:
	@cp $(ORIG)/doc/usr_24.txt $(ORIG)/doc/org_usr_24.txt
	@iconv -f LATIN1 -t UTF8 $(ORIG)/doc/org_usr_24.txt > $(ORIG)/doc/usr_24.txt
	@cp $(ORIG)/doc/quotes.txt $(ORIG)/doc/org_quotes.txt
	@iconv -f LATIN1 -t UTF8 $(ORIG)/doc/org_quotes.txt > $(ORIG)/doc/quotes.txt
	@ORIG_DOC=$(ORIG) ruby utils/diff_trans.rb $(USRMANUALS) $(REFMANUALS)
	@mv $(ORIG)/doc/org_usr_24.txt $(ORIG)/doc/usr_24.txt
	@mv $(ORIG)/doc/org_quotes.txt $(ORIG)/doc/quotes.txt

nvcheck:
	nvcheck doc/*.texi

clean:
	@rm -r htmls/*
	@rm -r pdfs/*
