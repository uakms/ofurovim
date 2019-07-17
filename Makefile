PRG = /usr/local/bin/texi2any
HTML_OPT_NS = --no-split --html --css-include=style.css
HTML_OPT_S = --no-node-files --html --css-ref=style.css
ORIG = $(HOME)/dev/macvim/runtime/doc
SRCFILE = texis/help.texi $(wildcard texis/*.texi)
NVCHECK_DICT = $(HOME)/dev/vimdoc-ja/dict.yml
HTMLFILES = `find htmls/refman -name "*.html"`
MISCFILES = htmls/refman/Mu-Ci-.html \
            htmls/refman/usr_005ftoc_002etxt.html

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

htmls/refman.html: $(SRCFILE)
	@mkdir -p htmls
	${PRG} ${HTML_OPT_NS} -o $@ $<
	@echo "trick for mobile..."
	@sh utils/trick_for_mobile.sh -a $@
	@sh utils/trick_for_mobile.sh -b $@
	@echo "trick for html5..."
	@sh utils/trick_for_html5.sh $@

htmls/refman: $(SRCFILE)
	@mkdir -p htmls
	${PRG} ${HTML_OPT_S} -o $@ $<
	@echo "trick for mobile..."
	@sh utils/trick_for_mobile.sh -a $(HTMLFILES)
	@sh utils/trick_for_mobile.sh -b $(MISCFILES)
	@echo "trick for html5..."
	@sh utils/trick_for_html5.sh $(HTMLFILES)
	cp style.css htmls/refman/

pdfs/refrman.pdf: $(SRCFILE)
	@mkdir -p pdfs
	PDFTEX=xetex texi2pdf -c -o $@ $<

diffen:
	@diff -q -r $(HOME)/dev/vimdoc-ja/en $(ORIG) | grep differ | \
	sed 's/Files .* and .*\/\(.*\) differ/> \1/'

diffja:
	@ruby utils/diff_trans.rb --dir=$(ORIG) texis/*.texi

nvcheck:
	nvcheck -d $(NVCHECK_DICT) texis/*.texi

tagcheck:
	@ruby utils/check_vdj_terms.rb --tags texis/*.texi

termcheck-bar:
	@ruby utils/check_vdj_terms.rb --bar texis/*.texi

termcheck-quote:
	@ruby utils/check_vdj_terms.rb --quote texis/*.texi

termcheck-dquote:
	@ruby utils/check_vdj_terms.rb --doublequote texis/*.texi

termcheck-bquote:
	@ruby utils/check_vdj_terms.rb --backquote texis/*.texi

clean:
	@find htmls -name "*.html" | xargs rm
	@find pdfs -name "*.pdf" | xargs rm
