mkdir to-lint
git status -s | grep -v " D" | cut -b4- | egrep '\.swift' | while read filename; do
	cp $filename to-lint 
done

if find to-lint -mindepth 1 -print -quit | grep -q .; then
	swiftlint lint --path to-lint --reporter "html" > out.html
	open out.html
else
	echo "Lint didn't find any file"
fi
rm -rf to-lint
