#!/bin/bash

# 遍历 docs/ 下所有 .adoc 文件
for file in docs/*.adoc; do
  # 转成 Markdown
  pandoc "$file" -t gfm -o "${file%.adoc}.md"
done

echo "AsciiDoc → Markdown conversion done."
