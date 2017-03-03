# Author: nakinor
# Created: 2017-02-26
# Revised: 2017-03-02

TAG_A='<meta name="viewport" content="width=device-width, initial-scale=1.0" />'
TAG_B='</pre>'
TAG_C='<pre class="menu-comment">'

STR_A='<title>Vim User Manual</title>'
STR_B='シングルファイルで印刷に適した HTML 形式と PDF 形式のユーザーマニュアルが用意されています:'
STR_C='最初から順番に読んで基本的なコマンドを学びましょう。'
STR_D='これらの項目は好きな順番で読んでも構いません。'
STR_E='blank,buffers,curdir,folds,help,options,winsize'
STR_F='blank, buffers, curdir, folds, help, options, winsize'
STR_G='Vim User Manual'

# ファイルの置き換えができるのは GNU sed だけ
# 文字列にスラッシュ / が含まれているので、区切り文字はバーティカル | で
sed -i -e "1,10s|$STR_A|$STR_A\n$TAG_A|" $1
sed -i -e "1,600s|$STR_B|$TAG_B$STR_B$TAG_C|" $1
sed -i -e "1,600s|$STR_C|$TAG_B$STR_C$TAG_C|" $1
sed -i -e "1,600s|$STR_D|$TAG_B$STR_D$TAG_C|" $1
sed -i -e "1,8000s|$STR_E|$STR_F|" $1
sed -i -e "1,300s|$STR_G|お風呂で Vim マニュアル|" $1
sed -i -e "1,900s|&bull; ||" $1
