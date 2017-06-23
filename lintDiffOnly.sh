#!/bin/bash

while getopts i: option; do
	case "$option" in
		i) RULES+=("$OPTARG");;
	esac
done
shift $((OPTIND -1))
if [ -n "$RULES" ]; then
	printf "disabled_rules:\n" > .swiftlint.yml
	for rule in "${RULES[@]}"; do
		TO_EXCLUDE+="- ${rule}"$'\n'
	done
	echo "${TO_EXCLUDE}" >> .swiftlint.yml
fi

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
rm .swiftlint.yml
rm -rf to-lint
