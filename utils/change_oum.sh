# Author: nakinor
# Created: 2017-03-18
# Revised: 2017-03-18

NODE_preA='@node usr_toc.txt, usr_01.txt'
NODE_aftA='@node 目次, usr_01.txt'
NODE_preB='@anchor{user-manual}'
NODE_aftB='@anchor{user-manual}\n@cindex usr_toc.txt'
NODE_preC='@c \* Indexes::'
NODE_aftC='* Indexes::'

function putHeader() {
cat <<EOF
\input texinfo-ja              @c -*- mode: texinfo; coding: utf-8 -*-
@clear EN
@clear JA
@set JA
@ifset JA  @c ----------- v -----------  JA  ----------- v -----------
@documentencoding UTF-8
@documentlanguage ja
@setfilename vim_user_manual.info
@settitle Vim User Manual
@syncodeindex vr cp
@syncodeindex fn cp
@finalout
@afourpaper

@titlepage
@title Vim ユーザーマニュアル
@page
@vskip 0pt plus 1filll
@end titlepage
@iftex
@shortcontents
@contents
@end iftex
@end ifset @c ----------- ^ -----------  JA  ----------- ^ -----------

EOF
}

function putFooter() {
cat <<EOF

@include usr_01.texi
@include usr_02.texi
@include usr_03.texi
@include usr_04.texi
@include usr_05.texi
@include usr_06.texi
@include usr_07.texi
@include usr_08.texi
@include usr_09.texi
@include usr_10.texi
@include usr_11.texi
@include usr_12.texi
@include usr_20.texi
@include usr_21.texi
@include usr_22.texi
@include usr_23.texi
@include usr_24.texi
@include usr_25.texi
@include usr_26.texi
@include usr_27.texi
@include usr_28.texi
@include usr_29.texi
@include usr_30.texi
@include usr_31.texi
@include usr_32.texi
@include usr_40.texi
@include usr_41.texi
@include usr_42.texi
@include usr_43.texi
@include usr_44.texi
@include usr_45.texi
@include usr_90.texi

@unnumbered Indexes
@node Indexes

@printindex cp

@bye
EOF
}

mv doc/usr_toc.texi doc/org_usr_toc.texi
putHeader > doc/usr_toc.texi
cat doc/org_usr_toc.texi >> doc/usr_toc.texi
putFooter >> doc/usr_toc.texi

sed -i -e "s|$NODE_preA|$NODE_aftA|" $1
sed -i -e "s|$NODE_preB|$NODE_aftB|" $1
sed -i -e "s|$NODE_preC|$NODE_aftC|" $1
