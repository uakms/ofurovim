# Author: nakinor
# Created: 2017-08-17
# Revised: 2018-04-02
#
# DOCTYPE を HTML5 用に変更し、使われなくなった tt を code に変更する
# また、hr と br も変更 (しない)

BEFORE_A='<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">'
AFTER_A='<!DOCTYPE html>'

BEFORE_B='<html>'
AFTER_B='<html lang="ja">'

BEFORE_C='<meta http-equiv="Content-Type" content="text/html; charset=utf-8">'
AFTER_C=''

BEFORE_D='</title>'
AFTER_D='<meta charset="utf-8" />'

BEFORE_E='<style type="text/css">'
AFTER_E='<style>'

BEFORE_F='<tt class="key">'
AFTER_F='<code class="tt-key">'

BEFORE_G='<tt>'
AFTER_G='<code>'

BEFORE_H='</tt>'
AFTER_H='</code>'

# XHTML とは違い HTML では問題ないみたい
BEFORE_I='<hr>'
AFTER_I='<hr />'

BEFORE_J='<br>'
AFTER_J='<br />'

# ファイルの置き換えができるのは GNU sed だけ
# 文字列にスラッシュ / が含まれているので、区切り文字はバーティカル | で
for f in $@
do
    echo "  \033[32m->\033[0m "$f
    sed -i -e "1,1s|$BEFORE_A|$AFTER_A|" $f
    sed -i -e "1,2s|$BEFORE_B|$AFTER_B|" $f
    sed -i -e "1,5s|$BEFORE_C|$AFTER_C|" $f
    sed -i -e "1,10s|$BEFORE_D|$BEFORE_D\n$AFTER_D|" $f
    sed -i -e "1,25s|$BEFORE_E|$AFTER_E|" $f
    sed -i -e "s|$BEFORE_F|$AFTER_F|g" $f
    sed -i -e "s|$BEFORE_G|$AFTER_G|g" $f
    sed -i -e "s|$BEFORE_H|$AFTER_H|g" $f
    # sed -i -e "s|$BEFORE_I|$AFTER_I|g" $f
    # sed -i -e "s|$BEFORE_J|$AFTER_J|g" $f
done
