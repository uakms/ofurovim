# Author: nakinor
# Created: 2017-02-26
# Revised: 2018-04-02

# HTML 自体を変更しなくても CSS 側でかなりの部分が対応することができたので
# bullet の変更と viewport の追加をするだけにした

while getopts ab OPT
do
    case $OPT in
        "a" ) FLAG_A="TRUE" ;;
        "b" ) FLAG_B="TRUE" ;;
    esac
done

shift `expr $OPTIND - 1`

STR_A='</title>'
TAG_A='<meta name="viewport" content="width=device-width, initial-scale=1.0" />'

STR_B='&bull; '
TAG_B=''

# ファイルの置き換えができるのは GNU sed だけ
# 文字列にスラッシュ / が含まれているので、区切り文字はバーティカル | で
if [ "$FLAG_A" = "TRUE" ]; then
    for f in $@
    do
        echo "  \033[32m->\033[0m "$f
	    sed -i -e "1,10s|$STR_A|$STR_A\n$TAG_A|" $f
    done
fi

if [ "$FLAG_B" = "TRUE" ]; then
    for f in $@
    do
        echo "  \033[32m->\033[0m "$f
        sed -i -e "s|$STR_B|$TAG_B|" $f
    done
fi
