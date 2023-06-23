#!/bin/bash

# Search for all the dart files in current directory and its subdirectories that start with a comment
# of the form "// <importedLibraryName> imports:" on one line, followed by an empty line, followed by
# another line of the format "// <importedLibraryName> imports:" on next line. Then add it to array 'files'

echo
echo 'Deleting duplicate imports...'

if [[ "$OSTYPE" == "darwin"* ]]; then
    files=( $(ggrep -Przl '^(?s)// ([A-Za-z]+) imports:\n\n// \1 imports:' --include='*.dart' . ) )
else
    files=( $(grep -Przl '^(?s)// ([A-Za-z]+) imports:\n\n// \1 imports:' --include='*.dart' . ) )
fi

# Loop through each file in the 'files' array and remove the first two lines of each file
for file in "${files[@]}"; do
  if [[ "$OSTYPE" == "darwin"* ]]; then
    gsed -i '1,2d' "$file"
  else
    sed -i '1,2d' "$file"
  fi  
done