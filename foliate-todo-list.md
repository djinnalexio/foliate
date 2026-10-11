# Personal TODO list

- [ ] Multiple columns in portrait mode/vertical window #1599

>Not sure if this is intended or a bug, but if a monitor is in portrait mode or the foliate window is vertical the text is restricted to only column instead of multiple.
>It would be nice to read on a monitor in portrait mode with two columns instead of being restricted to one column.

- [ ] Visible line between columns #1590

>I'd like to suggest the option to have a visible vertical line separating the columns in two-column mode, so it looks more like the separate pages of an open book. It should probably be the color of the dimmed/de-emphasized text from whatever theme is in use, so it's not too jarring.

- [ ] In scrolled mode, going back a page (PageUp) on the cover page gets stuck #1563

>If you go back a page using the keyboard shortcut (Page Up) on the cover page, Foliate gets "stuck" on the cover page and no longer allows you to navigate to other pages until you go back to the library and re-open the book.
>To Reproduce
>Use single-page view on an epub (not sure if required, but this is the context where I encountered the bug)
>Go to the cover page of a book
>Press the "Page Up" key to go back a page
>Pressing "Page Up" on the cover page should do nothing and leave you on the cover page while still being able to navigate the rest of the book properly.

- [x] Update translations (POT file and the french locale)

Update the POT file:

```bash
xgettext --files-from=po/POTFILES --from-code=UTF-8 --package-name=com.github.johnfactotum.Foliate -o po/com.github.johnfactotum.Foliate.pot --add-comments=Translators: --copyright-holder="Foliate Contributors"
```

Update the PO files:

```bash
for po in po/*.po; do msgmerge --update --backup=none "$po" po/com.github.johnfactotum.Foliate.pot; done
```

Check the PO files:

```bash
for po in po/*.po; do msgfmt --check-format --check-header --check-domain -o /dev/null $po; done
```

Statistics of the PO files:

```bash
for po in po/*.po; do echo "$(basename $po .po): $(msgfmt --check --statistics -o /dev/null $po 2>&1)"; done
```

- [x] new keywords in com.github.johnfactotum.Foliate.desktop

```in
Keywords=books;ebooks;library;epub;reader;ereader;viewer;
```

- [x] shortcut to return to library
