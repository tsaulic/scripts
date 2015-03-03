#! env ruby

TOC_LINK_REGEX = /(?<indent>\s*?)\* \[(?<title>.+?)\]\((?<filename>.+?)\)/

def pandoc(file)
    `pandoc #{file} --to markdown_github --base-header-level=3 --indented-code-classes=rust --atx-headers`
end

def normalize_title(title)
    # Some chapter titles start with Roman numerals, e.g. "I: The Basics"
    title.sub /(([IV]+):\s)/, ''
end

book = <<-eos
---
title: "The Rust Programming Language"
creator: "The Rust Team"
date: #{Time.new().strftime("%Y-%m-%d")}
language: en
description: "This book will teach you about the Rust Programming Language. Rust is a modern systems programming language focusing on safety and speed. It accomplishes these goals by being memory safe without using garbage collection."
...

eos

book << pandoc("README.md")
book << "\n\n"

File.open("SUMMARY.md", "r").each_line do |line|
    link = TOC_LINK_REGEX.match(line)
    if link
        level = link[:indent].length == 0 ? "#" : "##"
        book << "#{level} #{normalize_title link[:title]}\n\n"
        book << pandoc(link[:filename])
        book << "\n\n"
    end
end

File.open("_all.md", "w") { |file|
    file.write(book)
}

`pandoc _all.md --smart --normalize --standalone --number-sections --output=all.epub`
