PRG = /usr/local/bin/texi2any
PRG_MTO = $(HOME)/project/mto/src/mto.py
HTML_OPT_NS = --html --no-split --css-include=style.css
HTML_OPT_S = --html --css-ref=style.css
ORIG = $(HOME)/dev/vim/runtime
TRAN = ./

REFMANUALS = \
	doc/help.texi \
	doc/quickref.texi \
	doc/uganda.texi \
	doc/sponsor.texi \
	doc/intro.texi doc/helphelp.texi doc/index.texi doc/howto.texi \
	doc/tips.texi doc/message.texi doc/quotes.texi doc/debug.texi \
	doc/develop.texi \
	doc/starting.texi doc/editing.texi doc/motion.texi doc/scroll.texi \
	doc/insert.texi doc/change.texi doc/indent.texi doc/undo.texi \
	doc/repeat.texi doc/visual.texi doc/various.texi doc/recover.texi \
	doc/cmdline.texi doc/options.texi doc/pattern.texi doc/map.texi \
	doc/tagsrch.texi

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

.PHONY: usrhtml refonehtml refhtml usrpdf refpdf kyukana \
	first diffja nvcheck clean

first:
	@echo
	@echo "	usrhtml: HTML 版のユーザーマニュアルを生成する"
	@echo "	refhtml: HTML 版のリファレンスマニュアルを生成する"
	@echo "	usrpdf:  PDF 版のユーザーマニュアルを生成する"
	@echo "	refpdf:  PDF 版のリファレンスマニュアルを生成する"
	@echo "	kyukana: 旧字旧仮名に変換したユーザーマニュアルを生成する"
	@echo "	diffja:  本家との差分を調べる"
	@echo "	nvcheck: 表記のゆれをチェックする"
	@echo "	clean:   生成したものを削除する"
	@echo

usrhtml: htmls/usrman.html ;
refonehtml: htmls/refman.html ;
refhtml: htmls/refman ;
usrpdf: pdfs/userman.pdf ;
refpdf: pdfs/refrman.pdf ;
kyukana: htmls/tk-ok-usrman.html ;

htmls/usrman.html: $(USRMANUALS)
	sh utils/change_oum.sh doc/usr_toc.texi
	${PRG} ${HTML_OPT_NS} -o $@ $<
	sh utils/trick_for_mobile.sh $@
	mv doc/org_usr_toc.texi doc/usr_toc.texi

htmls/refman.html: $(REFMANUALS) $(USRMANUALS)
	${PRG} ${HTML_OPT_NS} -o $@ $<

htmls/refman: $(REFMANUALS) $(USRMANUALS)
	cp style.css htmls/refman/
	${PRG} ${HTML_OPT_S} -o $@ $<
	sh utils/trick_for_mobile.sh htmls/refman/usr_005ftoc_002etxt.html

pdfs/userman.pdf: $(USRMANUALS)
	PDFTEX=luatex texi2pdf -c -o $@ $<

pdfs/refrman.pdf: $(REFMANUALS)
	PDFTEX=luatex texi2pdf -c -o $@ $<

htmls/tk-usrman.html: htmls/usrman.html
	python3 $(PRG_MTO) tradkana $< > $@

htmls/tk-ok-usrman.html: htmls/tk-usrman.html
	python3 $(PRG_MTO) oldkanji $< > $@

diffja:
	@cp $(ORIG)/doc/usr_24.txt $(ORIG)/doc/org_usr_24.txt
	@iconv -f LATIN1 -t UTF8 $(ORIG)/doc/org_usr_24.txt > $(ORIG)/doc/usr_24.txt
	@cp $(ORIG)/doc/quotes.txt $(ORIG)/doc/org_quotes.txt
	@iconv -f LATIN1 -t UTF8 $(ORIG)/doc/org_quotes.txt > $(ORIG)/doc/quotes.txt
	@cp $(ORIG)/doc/map.txt $(ORIG)/doc/org_map.txt
	@iconv -f LATIN1 -t UTF8 $(ORIG)/doc/org_map.txt > $(ORIG)/doc/map.txt
	@ORIG_DOC=$(ORIG) ruby utils/diff_trans.rb $(USRMANUALS) $(REFMANUALS)
	@mv $(ORIG)/doc/org_usr_24.txt $(ORIG)/doc/usr_24.txt
	@mv $(ORIG)/doc/org_quotes.txt $(ORIG)/doc/quotes.txt
	@mv $(ORIG)/doc/org_map.txt $(ORIG)/doc/map.txt

nvcheck:
	nvcheck doc/*.texi

clean:
	@find htmls -name "*.html" | xargs rm
	@find pdfs -name "*.pdf" | xargs rm
