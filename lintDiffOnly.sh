#!/bin/bash

# .swiftlint.yml backup
if [ -e .swiftlint.yml ]
then
	VAR="$(date +'%m-%d-%Y').swiftlint.yml"
	mv .swiftlint.yml $VAR 
fi

# get options: -i rule_do_disable
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

# files to lint
mkdir to-lint
git status -s | grep -v " D" | grep -v ".yml" | cut -b4- | egrep '\.swift' | while read filename; do
	cp $filename to-lint 
done

if find to-lint -mindepth 1 -print -quit | grep -q .; then
	swiftlint lint --path to-lint --reporter "html" > out.html
	open out.html
else
	echo "Lint didn't find any file"
fi

# remove disabled rules
if [ -e .swiftlint.yml ]
then
	rm .swiftlint.yml
fi

# retrieve .swiftlint.yml
if [ -n "${VAR}" ]
then
	mv $VAR .swiftlint.yml
fi

rm -rf to-lint
