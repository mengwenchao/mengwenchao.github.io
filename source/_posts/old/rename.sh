
for f in *.html
do
	newtitle=`egrep  title $f | awk '{print $2}'`
	newfilename=`echo $f | sed "s/\(.*\)-\%.*.html/\1-$newtitle/"`
	mv $f $newfilename.md
done
