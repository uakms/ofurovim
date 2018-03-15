PRG = /usr/local/bin/texi2any
PRG_MTO = $(HOME)/project/mto/src/mto.py
NVCHECK_DICT = $(HOME)/dev/vimdoc-ja/dict.yml
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
	doc/tagsrch.texi doc/quickfix.texi doc/windows.texi doc/tabpage.texi \
	doc/syntax.texi doc/spell.texi doc/diff.texi doc/autocmd.texi \
	doc/filetype.texi doc/eval.texi doc/channel.texi doc/fold.texi \
	doc/print.texi doc/remote.texi doc/term.texi doc/terminal.texi \
	doc/digraph.texi doc/mbyte.texi doc/mlang.texi doc/arabic.texi \
	doc/farsi.texi doc/hebrew.texi doc/russian.texi doc/ft_ada.texi \
	doc/ft_rust.texi doc/ft_sql.texi doc/hangulin.texi doc/rileft.texi \
	doc/gui.texi doc/gui_w32.texi doc/gui_x11.texi \
	doc/if_cscop.texi doc/if_lua.texi doc/if_mzsch.texi doc/if_perl.texi \
	doc/if_pyth.texi doc/if_tcl.texi doc/if_ole.texi doc/if_ruby.texi \
	doc/debugger.texi doc/workshop.texi doc/netbeans.texi doc/sign.texi \
	doc/vi_diff.texi \
	doc/os_mac.texi doc/os_unix.texi \
	doc/pi_getscript.texi doc/pi_spec.texi

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

# そのまま diff をかけると不都合があるので UTF-8 に変換するファイル
INCONVENIENTFILES = \
	$(ORIG)/doc/usr_24.txt \
	$(ORIG)/doc/quotes.txt \
	$(ORIG)/doc/map.txt \
	$(ORIG)/doc/spell.txt \
	$(ORIG)/doc/eval.txt \
	$(ORIG)/doc/mlang.txt \
	$(ORIG)/doc/farsi.txt

.PHONY: usrhtml refonehtml refhtml usrpdf refpdf kyukana \
	first diffja nvcheck clean

first:
	@echo
	@echo "	usrhtml:  HTML 版のユーザーマニュアルを生成する"
	@echo "	refhtml:  HTML 版のリファレンスマニュアルを生成する"
	@echo "	usrpdf:   PDF 版のユーザーマニュアルを生成する"
	@echo "	refpdf:   PDF 版のリファレンスマニュアルを生成する"
	@echo "	kyukana:  旧字旧仮名に変換したユーザーマニュアルを生成する"
	@echo "	diffja:   本家との差分を調べる (ja-en)"
	@echo "	diffen:   本家との差分を調べる (en-en)"
	@echo "	nvcheck:  表記のゆれをチェックする"
	@echo "	tagcheck: タグのモレをチェックする"
	@echo "	clean:    生成したものを削除する"
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
	sh utils/trick_for_mobile_usr.sh $@
	mv doc/org_usr_toc.texi doc/usr_toc.texi

htmls/refman.html: $(REFMANUALS) $(USRMANUALS)
	${PRG} ${HTML_OPT_NS} -o $@ $<

htmls/refman: $(REFMANUALS) $(USRMANUALS)
	cp style.css htmls/refman/
	${PRG} ${HTML_OPT_S} -o $@ $<
	sh utils/trick_for_mobile_usr.sh htmls/refman/usr_005ftoc_002etxt.html
	sh utils/trick_for_mobile_ref.sh htmls/refman/Mu-Ci-.html
	sh utils/trick_for_mobile.sh
	sh utils/trick_for_html5.sh

pdfs/userman.pdf: $(USRMANUALS)
	PDFTEX=xetex texi2pdf -c -o $@ $<

pdfs/refrman.pdf: $(REFMANUALS)
	PDFTEX=xetex texi2pdf -c -o $@ $<

htmls/tk-usrman.html: htmls/usrman.html
	python3 $(PRG_MTO) tradkana $< > $@

htmls/tk-ok-usrman.html: htmls/tk-usrman.html
	python3 $(PRG_MTO) oldkanji $< > $@

diffja:
	@sh utils/prepare_for_diff.sh -a $(INCONVENIENTFILES)
	@ruby utils/diff_trans.rb --dir=$(ORIG) $(USRMANUALS) $(REFMANUALS)
	@sh utils/prepare_for_diff.sh -z $(INCONVENIENTFILES)

diffen:
	@diff -q -r $(HOME)/dev/vimdoc-ja/en $(ORIG)/doc | grep differ | \
	sed 's/Files .* and .*\/\(.*\) differ/> \1/'

nvcheck:
	nvcheck -d $(NVCHECK_DICT) doc/*.texi

tagcheck:
	@ruby utils/check_tag.rb

clean:
	@find htmls -name "*.html" | xargs rm
	@find pdfs -name "*.pdf" | xargs rm
