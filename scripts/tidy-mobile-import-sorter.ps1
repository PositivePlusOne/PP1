# of the form "// <importedLibraryName> imports:" on one line, followed by an empty line, followed by
# another line of the format "// <importedLibraryName> imports:" on next line. Then add it to array 'files'
$dartFiles = Get-ChildItem -Recurse -Include "*.dart" -File | ForEach-Object { $_.FullName }

Write-Output "Found $($dartFiles.Count) dart files"

$files = @()
foreach($dartFile in $dartFiles) {
    $content = Get-Content -Path $dartFile -Raw
    if ($content -match '^(?s)// ([A-Za-z]+) imports:\r?\n\r?\n// \1 imports:') {
        $files += $dartFile
    }
}

Write-Output "Found $($files.Count) dart files with double imports"

# Loop through each file in the 'files' array and remove the first two lines of each file
foreach ($file in $files) {
    $content = Get-Content -Path $file
    $newContent = $content | Select-Object -Skip 2
    $newContent | Set-Content -Path $file
}
