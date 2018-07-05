PRG = /usr/local/bin/texi2any
NVCHECK_DICT = $(HOME)/dev/vimdoc-ja/dict.yml
HTML_OPT_NS = --no-split --html --css-include=style.css
HTML_OPT_S = --no-node-files --html --css-ref=style.css
ORIG = $(HOME)/dev/macvim/runtime
TRAN = ./
HTMLFILES=`find htmls/refman -name "*.html"`
MISCFILES="htmls/refman/Mu-Ci-.html htmls/refman/usr_005ftoc_002etxt.html"

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
	doc/os_dos.texi doc/os_mac.texi doc/os_unix.texi doc/os_win32.texi\
	doc/pi_getscript.texi doc/pi_gzip.texi doc/pi_logipat.texi \
	doc/pi_netrw.texi doc/pi_paren.texi doc/pi_spec.texi doc/pi_tar.texi \
	doc/pi_vimball.texi doc/pi_zip.texi doc/gui_mac.texi

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
# 2018.03.19 usr_24.txt, eval.txt は原文が UTF-8 になった。
# 2018.03.30 spell.txt, quotes.txt は原文が UTF-8 になった。
# 2018.05.07 map.txt, mlang.txt は原文が UTF-8 になった。
INCONVENIENTFILES = $(ORIG)/doc/farsi.txt

.PHONY: first html onehtml pdf diffja nvcheck tagcheck clean

first:
	@echo
	@echo "	onehtml:   1 ファイルの HTML 版マニュアルを生成する"
	@echo "	html:      HTML 版マニュアルを生成する"
	@echo "	pdf:       PDF 版マニュアルを生成する"
	@echo "	diffja:    本家との差分を調べる (ja-en)"
	@echo "	diffen:    本家との差分を調べる (en-en)"
	@echo "	nvcheck:   表記のゆれをチェックする"
	@echo "	tagcheck:  タグのモレをチェックする"
	@echo "	termcheck  用語マークアップのモレをチェックする"
	@echo "	  -bar:      バーティカルで囲まれたもの"
	@echo "	  -quote:    クォートで囲まれたもの"
	@echo "	  -dquote:   ダブルクォートで囲まれたもの"
	@echo "	  -bquote:   バッククォートで囲まれたもの"
	@echo "	clean:     生成したものを削除する"
	@echo

onehtml: htmls/refman.html ;
html: htmls/refman ;
pdf: pdfs/refrman.pdf ;

htmls/refman.html: $(REFMANUALS) $(USRMANUALS) $(MACVIMREF)
	${PRG} ${HTML_OPT_NS} -o $@ $<
	@echo "trick for mobile..."
	@sh utils/trick_for_mobile.sh -a $@
	@sh utils/trick_for_mobile.sh -b $@
	@echo "trick for html5..."
	@sh utils/trick_for_html5.sh $@

htmls/refman: $(REFMANUALS) $(USRMANUALS) $(MACVIMREF)
	cp style.css htmls/refman/
	${PRG} ${HTML_OPT_S} -o $@ $<
	@echo "trick for mobile..."
	@sh utils/trick_for_mobile.sh -a $(HTMLFILES)
	@sh utils/trick_for_mobile.sh -b $(MISCFILES)
	@echo "trick for html5..."
	@sh utils/trick_for_html5.sh $(HTMLFILES)

pdfs/refrman.pdf: $(REFMANUALS) $(USRMANUALS) $(MACVIMREF)
	PDFTEX=xetex texi2pdf -c -o $@ $<

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
	@ruby utils/check_vdj_terms.rb --tags doc/*.texi

termcheck-bar:
	@ruby utils/check_vdj_terms.rb --bar doc/*.texi

termcheck-quote:
	@ruby utils/check_vdj_terms.rb --quote doc/*.texi

termcheck-dquote:
	@ruby utils/check_vdj_terms.rb --doublequote doc/*.texi

termcheck-bquote:
	@ruby utils/check_vdj_terms.rb --backquote doc/*.texi

clean:
	@find htmls -name "*.html" | xargs rm
	@find pdfs -name "*.pdf" | xargs rm
