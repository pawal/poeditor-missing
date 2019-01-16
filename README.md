Tools to help translators
=========================

## `missing.sh`

Use a poeditor json file to find extranous translations to be removed from projects.

Usage:
`./missing.sh -p ~/dev/project/src -l ~/dev/project/src/assets/i18n/en.json`

The result will be a list of strings (context+terms) to be removed from your poeditor project.
