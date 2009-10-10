#!/bin/sh


I18N=lib/EasyCMS2/I18N
mkdir -p $I18N
xgettext.pl -v -v -v --output=$I18N/messages.pot \
   --directory=lib/ --directory=root/ \
   --plugin 'perl=pm,pl' --plugin 'tt2=tt,js,xml' --plugin 'formfu=yml'
if [ -f $I18N/messages.pot ];  then
for i in no en; do
    echo $i
       if [ -f $I18N/$i.po ]; then
           msgmerge --backup=none --update $I18N/$i.po $I18N/messages.pot
       else
        msginit --no-translator --input=$I18N/messages.pot --output=$I18N/$i.po --locale=$i
    fi
done
else
   echo "No strings found during extraction";
fi