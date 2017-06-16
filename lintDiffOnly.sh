mkdir to-lint
git status -s | cut -b4- | egrep '\.swift' | while read filename; do
	cp $filename to-lint 
done
swiftlint lint --path to-lint --reporter "html" > out.html
rm -rf to-lint
open out.html
