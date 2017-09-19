# Author: nakinor
# Created: 2017-08-17
# Revised: 2017-09-19

TXTFILES=`find htmls/refman -type file -size +8k`
BEFORE_TAG_A='<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">'
AFTER_TAG_A='<!DOCTYPE html>'

BEFORE_TAG_B='<html>'
AFTER_TAG_B='<html lang="ja">'

BEFORE_TAG_C='</title>'
AFTER_TAG_C='<meta charset="UTF-8" />'

BEFORE_TAG_D='<tt class="key">'
AFTER_TAG_D='<code class="tt-key">'

BEFORE_TAG_E='<tt>'
AFTER_TAG_E='<code>'

BEFORE_TAG_F='</tt>'
AFTER_TAG_F='</code>'

BEFORE_TAG_G='<hr>'
AFTER_TAG_G='<hr />'

BEFORE_TAG_H='<br>'
AFTER_TAG_H='<br />'

# ファイルの置き換えができるのは GNU sed だけ
# 文字列にスラッシュ / が含まれているので、区切り文字はバーティカル | で
for f in ${TXTFILES}
do
	sed -i -e "1,1s|$BEFORE_TAG_A|$AFTER_TAG_A|" $1 $f
	sed -i -e "1,2s|$BEFORE_TAG_B|$AFTER_TAG_B|" $1 $f
	sed -i -e "s|$BEFORE_TAG_C|$BEFORE_TAG_C\n$AFTER_TAG_C|" $1 $f
	sed -i -e "s|$BEFORE_TAG_D|$AFTER_TAG_D|g" $1 $f
	sed -i -e "s|$BEFORE_TAG_E|$AFTER_TAG_E|g" $1 $f
	sed -i -e "s|$BEFORE_TAG_F|$AFTER_TAG_F|g" $1 $f
#	sed -i -e "s|$BEFORE_TAG_G|$AFTER_TAG_G|" $1 $f
#	sed -i -e "s|$BEFORE_TAG_H|$AFTER_TAG_H|" $1 $f
done

