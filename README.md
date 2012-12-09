# Website to PDF Builder, aka Cyle's Bookmaker

## Requirements

* Ruby 1.8
* Prawn gem
* Nokogiri gem

## What this script doesn't do

Right now this script doesn't make a title page or a table of contents, though someday I'd like to add that.

## What this script definitely does

I like writing in plain text and then in HTML. I didn't like the idea of manually reformatting over 100 pages of HTML into InDesign to get things looking print-ready, so I made this. There were other of these kinds of re-formatters across the web but they either didn't work as well as I wanted or they were expensive. This script takes one page of HTML, properly formatted, and turns it into a US Trade sized PDF, complete with major and minor section headers.

By default it uses PT Serif for the body text and Open Sans for section text, but the TTF files are not included, and you can definitely change these options when editing the script itself.

## Step One, format your book in HTML

The bookmaker script only pays attention to one thing: a div with an ID of "book". Inside that div, you put divs with the class name "major-section" and then inside that more divs with the class name "minor-section". Inside the major-section divs you can put an H1 tag to designate major section headers, which will take up an entire page. Inside the minor-section divs you can put an H2 tag to designate minor section, or chapter, headers, which will take up half of a page. Inside the minor-section divs you can put unordered lists and paragraph tags. The bookmaker script will ignore everything else.

## Step Two, run the script

Edit the script in a plain text editor like TextMate or something. The first 30 or so lines of the script contain the URL to the book, the name of the book, the author, the default fonts, the size, etc. Edit these to your liking.

The script should be run in Terminal. That's it. A good old fashion `ruby bookmaker.rb` will do it. Make sure you have the font files in the same directory, or specify their absolute paths when editing the script.

## Acknowledgements

First, Prawn is an amazing Ruby library for creating PDFs. It does half of the work in this script. Secondly, Nokogiri is another amazing Ruby library for parsing HTML/XML documents. It does the other half of the work in this script. The only thing I'm really doing here is brining them together in a way that worked best for me.
