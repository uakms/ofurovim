# Author: nakinor
# Created: 2017-08-08
# Revised: 2017-08-08

TAG_A='<meta name="viewport" content="width=device-width, initial-scale=1.0" />'
TAG_B='</pre>'
TAG_C='<pre class="menu-comment">'

STR_A='<title>目次 (Vim Reference Manual)</title>'
STR_B='ユーザーマニュアルでは編集作業の進め方を説明します。'
STR_C='リファレンスマニュアルでは Vim の詳細を説明します。'

# ファイルの置き換えができるのは GNU sed だけ
# 文字列にスラッシュ / が含まれているので、区切り文字はバーティカル | で
sed -i -e "1,10s|$STR_A|$STR_A\n$TAG_A|" $1
sed -i -e "1,200s|$STR_B|$TAG_B$STR_B$TAG_C|" $1
sed -i -e "1,300s|$STR_C|$TAG_B$STR_C$TAG_C|" $1
