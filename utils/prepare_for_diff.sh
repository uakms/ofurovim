# Author: nakinor
# Created: 2017-08-15
# Revised: 2018-03-25

# そのまま diff をかけると不都合があるので iconv で UTF-8 に変換する
# また z オプションでその逆も行なう

while getopts az OPT
do
    case $OPT in
        "a" ) FLAG_A="TRUE" ;;
        "z" ) FLAG_Z="TRUE" ;;
    esac
done

shift `expr $OPTIND - 1`

if [ "$FLAG_A" = "TRUE" ]; then
    for f in $@
    do
        cp $f ${f%.txt}_orig.txt
        iconv -f LATIN1 -t UTF8 ${f%.txt}_orig.txt > $f
    done
fi

if [ "$FLAG_Z" = "TRUE" ]; then
    for f in $@
    do
        mv ${f%.txt}_orig.txt $f 
    done
fi
