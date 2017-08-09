# Author: nakinor
# Created: 2017-08-09
# Revised: 2017-08-09

TXTFILES=`find . -name "*_002etxt.html"`
STR_A='</title>'
TAG_A='<meta name="viewport" content="width=device-width, initial-scale=1.0" />'

# ファイルの置き換えができるのは GNU sed だけ
# 文字列にスラッシュ / が含まれているので、区切り文字はバーティカル | で
for f in ${TXTFILES}
do
	sed -i -e "1,10s|$STR_A|$STR_A\n$TAG_A|" $1 $f
done

