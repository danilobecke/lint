folder="to-lint-$(date +'%m-%d-%Y')"
mkdir $folder
git status -s | grep -v " D" | cut -b4- | egrep '\.swift' | while read filename; do
	cp $filename $folder 
done

if find $folder -mindepth 1 -print -quit | grep -q .; then
	swiftlint lint --path $folder --reporter "html" > out.html
	open out.html
else
	echo "Lint didn't find any file"
fi
rm -rf $folder 
