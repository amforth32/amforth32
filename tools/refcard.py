#!/usr/bin/env python3

"""
refcard reads the build/amforth.toc file in the current directory and produces a quick reference of words listed there.

It uses core/dev/categories to organize and sort the words. In the categories file, category definition starts with
category name and colon on the first line, followed by lines listing the words in order, offset from the start of the line by a tab.
Next category follows using the same format.

The .toc file consists of a single line for each word. The word line starts with the word type keyword (CODEWORD, COLON, ...), followed
by the word name in double quotes, followed by a symbolic label for the word, followed by optional comment that can include
the stack signature enclosed in parens, e.g. (n1 n2 -- n3), which can be followed by short description. The word line is terminated
by file/line reference separated from the rest of the line with character @.

The output of refcard is a series of tables, one for each category, listing the word name, stack signature and description
The output format can be simple columnar ascii, or html tables.
"""

import sys
import os
import re
import html
import argparse

def read_build_info():
    pattern = re.compile(r'.*> 7:\.ascii "(.*)"\n')
    bits = {}
    #for fn in ['words/env-cpu.s', 'words/env-board.s', 'words/build-info.s']:
    with open('build/amforth.lst-as', 'r') as f:
        key = None
        for line in f:
            if key:
                match = pattern.match(line)
                if match:
                    bits[key] = match.group(1)
                    key = None
                continue
            if line.endswith("PFA_ENV_CPU:\n"):
                key = 'cpu'
            elif line.endswith("PFA_ENV_BOARD:\n"):
                key = 'board'
            elif line.endswith("PFA_ENV_BUILD_TIME:\n"):
                key = 'time'
            elif line.endswith("PFA_ENV_BUILD_REV:\n"):
                key = 'rev'
    return f"{bits['cpu']} / {bits['board']} {bits['rev']} {bits['time']}"

def parse_legend_md(filepath):
    """
    Parses the legend.md file and extracts markdown tables.
    Returns a dictionary: { section_name: [(col1, col2), ...] }
    """
    legend = {}
    current_section = None
    current_table = []

    with open(filepath, 'r') as f:
        for line in f:
            line = line.rstrip()
            if not line:
                continue
            
            # Check for section heading
            if line.startswith('# '):
                # Save previous table if any
                if current_section and current_table:
                    legend[current_section] = current_table
                current_section = line[2:]  # Remove '# '
                current_table = []
                continue
            
            # Skip table header separators
            if line.startswith('---'):
                continue
            
            # Split table row into cells
            cols = [col.strip().replace("||", "|") for col in line.split(' | ')]
            # Remove empty strings from start/end (before first | and after last |)
            cols = [col for col in cols if col]
            if len(cols) >= 2:
                current_table.append(tuple(cols))
        
        # Save the last table
        if current_section and current_table:
            legend[current_section] = current_table
    
    return legend

def parse_categories(filepath):
    """
    Parses the categories file.
    Returns a list of (category_name, [word_list]) tuples.
    """
    categories = []
    current_category = None
    current_words = []

    with open(filepath, 'r') as f:
        for line in f:
            line = line.rstrip()
            if not line:
                continue
            
            # Category definition: Name followed by colon
            if not line[0].isspace() and line.endswith(':'):
                if current_category:
                    categories.append((current_category, current_words))
                current_category = line[:-1]
                current_words = []
            # Word definition: Indented
            elif line[0].isspace():
                words = line.split()
                current_words.extend(words)
        
        # Append the last category
        if current_category:
            categories.append((current_category, current_words))

    return categories

def parse_toc(filepath, categories):
    """
    Parses the amforth.toc file.
    Returns a dictionary: { word_name: { 'signature': sig, 'description': desc } }
    Updates categories with an UNCATEGORIZED category containing
    words found in the TOC but not in the provided categories.
    """
    words_data = {}
    
    word_category_map = {}
    for category, words in categories:
        for word in words:
            word_category_map[word] = category
    uncategorized_set = set()
    mcu_words = set()
    
    if not os.path.exists(filepath):
        print(f"Error: TOC file not found at {filepath}", file=sys.stderr)
        return {}

    # Regex to capture: Type "Name" Label Comment @File
    # Example: CODEWORD "dup", DUP /* ( n -- n n ) Duplicate TOS */ @...
    pattern = re.compile(r'^(\w+)\s+"([^"]+)"\s*,\s*([^\s,]+)(\s*,\s*(\S+))?\s*((.*)\s+@\s+(\S+))?$')

    with open(filepath, 'r') as f:
        for line in f:
            line = line.strip()
            if not line:
                continue
            
            match = pattern.match(line)
            if match:
                word_type = match.group(1)
                name = match.group(2)
                # Replace double backslash with single backslash
                name = name.replace('\\\\', '\\')
                # Replace \xHH with ascii character for HH
                name = re.sub(r'\\x([0-9a-fA-F]{2})', lambda m: chr(int(m.group(1), 16)), name)
                # Replace \OOO with ascii character for OOO
                name = re.sub(r'\\([0-7]{3})', lambda m: chr(int(m.group(1), 8)), name)
                symbol = match.group(3)
                parameter = match.group(5)
                raw_comment = match.group(7).strip()
                location = match.group(8)
                location = os.path.normpath(location.replace('\\', '/'))
                
                if raw_comment.startswith("/*") and raw_comment.endswith("*/"):
                    raw_comment = raw_comment[2:-2].strip()
                elif raw_comment.startswith("@") or raw_comment.startswith("#"):
                    raw_comment = raw_comment[1:].strip()
                signature = ""
                description = raw_comment
                
                # Extract stack signature ( ... )
                sig_match = re.match(r'^((\s*\([^\)]*\))*)\s*(.*)$', raw_comment)
                if sig_match:
                    signature = sig_match.group(1)
                    description = sig_match.group(3)
                
                words_data[name] = {
                    'type': word_type,
                    'symbol': symbol,
                    'parameter': parameter if parameter else '',
                    'signature': signature,
                    'description': description,
                    'location': location
                }
                
                
                if name not in word_category_map:
                    if 'mcu' in location.split('/'):
                        mcu_words.add(name)
                    else:
                        uncategorized_set.add(name)
    
    if mcu_words:
        categories.append(("MCU", sorted(mcu_words)))
    if uncategorized_set:
        categories.append(("UNCATEGORIZED", sorted(uncategorized_set)))
    
    return words_data

def generate_refcard(categories_file, toc_file):
    categories = parse_categories(categories_file)
    words_db = parse_toc(toc_file, categories)
    
    if not categories or not words_db:
        return

    # Column widths
    w_name = 20
    w_sig = 30
    
    # Header
    print(f"{'Word':<{w_name}} {'Stack Signature':<{w_sig}} Description")
    print("=" * 80)

    for cat_name, word_list in categories:
        print(f"\n{cat_name}")
        print("-" * len(cat_name))
        
        # Compute optimal column widths for this category
        w_name = 0
        w_sig = 0
        for word in word_list:
            w_name = max(w_name, len(word))
            data = words_db.get(word)
            if data:
                w_sig = max(w_sig, len(data['signature']))

        for word in word_list:
            data = words_db.get(word)
            if data:
                name = word
                sig = data['signature']
                desc = data['description']
                print(f"{name:<{w_name}} {sig:<{w_sig}} {desc}")
            else:
                # Word in category but not in TOC
                print(f"{word:<{w_name}} {'':<{w_sig}}")

def generate_html_refcard(categories_file, toc_file):
    categories = parse_categories(categories_file)
    words_db = parse_toc(toc_file, categories)
    build_info = read_build_info()
    
    # Parse legend
    script_dir = os.path.dirname(os.path.abspath(__file__))
    legend_file = os.path.join(script_dir, "../core/dev/legend.md")
    legend = parse_legend_md(legend_file)
    
    if not categories or not words_db:
        return

    print("<!DOCTYPE html>")
    print("<html>")
    print("<head>")
    print("<title>AmForth32 Reference Card</title>")
    print("<style>")
    css_path = os.path.join(script_dir, 'refcard.css')
    with open(css_path, 'r') as f:
        print(f.read())
    print("</style>")
    print("</head>")
    print("<body>")
    print("<h1>AmForth32 Reference Card</h1>")
    print(f'<h2>{build_info}</h2>')

    print("<p>")
    links = []
    for cat_name, _ in categories:
        anchor = html.escape(cat_name)
        links.append(f'<a href="#{anchor}">{anchor}</a>')
    links.append(f'<a href="#LEGEND">LEGEND</a>')
    print(" | ".join(links))
    print("</p>")

    for cat_name, word_list in categories:
        print(f'<h2 id="{html.escape(cat_name)}">{html.escape(cat_name)}</h2>')
        print("<table>")
        print("<tr><th>Word</th><th>Type</th><th>Stack Signature</th><th>Description</th><th>Location</th></tr>")
        
        for word in word_list:
            data = words_db.get(word)
            if data:
                name = html.escape(word)
                symbol = html.escape(data['symbol'])
                type = html.escape(data['type'])
                if data['signature']:
                    sig = html.escape(data['signature'])
                else:
                    sig = html.escape(data['parameter'])
                desc = html.escape(data['description'])
                loc = html.escape(data['location'])
                if not type in ['HEADLESS', 'NONAME']:
                    print(f"<tr><td title=\"{symbol}\">{name}</td><td>{type}</td><td>{sig}</td><td>{desc}</td><td>{loc}<td></tr>")
            else:
                name = html.escape(word)
                print(f"<tr><td>{name}</td></tr>")
        print("</table>")

    # Add Legend section from parsed legend data
    print('<h2 id="LEGEND">LEGEND</h2>')
    for section_name, table_rows in legend.items():
        print(f'<h3>{html.escape(section_name)}</h3>')
        print('<table>')
        print('<tr>' + ''.join(f'<th>{html.escape(h)}</th>' for h in table_rows[0]) + '</tr>')
        for row in table_rows[1:]:
            print('<tr>' + ''.join(f'<td>{html.escape(col)}</td>' for col in row) + '</tr>')
        print('</table>')

    print("</body>")
    print("</html>")

if __name__ == "__main__":
    # Default paths based on description
    script_dir = os.path.dirname(os.path.abspath(__file__))
    default_categories = os.path.join(script_dir, "../core/dev/categories")
    
    parser = argparse.ArgumentParser(description="Generate AmForth reference card")
    parser.add_argument("toc_path", nargs='?', default="build/amforth.toc", help="Path to amforth.toc file")
    parser.add_argument("categories_path", nargs='?', default=default_categories, help="Path to categories file")
    parser.add_argument("--html", action="store_true", help="Output in HTML format")
    
    args = parser.parse_args()
    
    if args.html:
        generate_html_refcard(args.categories_path, args.toc_path)
    else:
        generate_refcard(args.categories_path, args.toc_path)