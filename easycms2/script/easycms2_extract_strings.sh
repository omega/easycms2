#!/bin/sh
BASE=lib/EasyCMS2/I18N

find lib root script -type f -not -path '*.svn*' -not -name 'MochiKit.js' \( -name '*.pm' -or -name '*.tt' -or -name '*.js' -or -name '*.yml' \) > filelist.tmp
mkdir -p $BASE
for i in 'en' 'no'; do
    echo "lang: $i"
    xgettext.pl --files-from=filelist.tmp -o $BASE/$i.po
done;

rm filelist.tmp
