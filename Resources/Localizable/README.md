# js-mobile-locales
General Information
--------------------
Main idea to share the localization files between mobile projects.

We decided to use Twin command line tool (https://github.com/mobiata/twine).


## Usage
### Tags  
  At the moment we have 3 types of tags:
  - ios
  - android
  - new

### Commands
#### For iOS
```
{twine} generate-all-string-files {source} {destination} --format apple --tags ios
```
#### For Android
```
{twine} generate-all-string-files {source} {destination} --format android --tags android
```
#### For the new strings
```
{twine} generate-all-string-files {source} {destination} --format {platform} --tags new
```

We add new strings and use tag `new` for them.
After those strings were translated we need remove tag `new`

#### Steps
- combine all `.txt` files into one file `locales.txt`
 ```
 cat all_values/*.txt > locales.txt
 ```
- generate localizable files
```
//TODO: code sample
```
- remove `locales.txt` file
```
rm locales.txt
```

#### Get New Strings
- combine all `.txt` files into one file `locales.txt`
- generate only strings for tag `new` (english)
```
twine generate-all-string-files `strings.file` `outupPath` --tags `tag1`
```
- remove `locales.txt` file


#### Validation
```
twine validate-strings-file `strings.file`
```
twine generate-all-string-files "$localizationFolderPath/$allLocalizationsFileName" "$outupPath" --tags new