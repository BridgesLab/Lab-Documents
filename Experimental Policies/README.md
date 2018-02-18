To generate mediawiki files from md files use pandoc to conver the markdown file generated via R into mediawiki format and upload that way.

```pandoc -o general-statistics.mw general-statistics.md -t mediawiki```