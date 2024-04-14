#!/usr/bin/env python3

import os
import subprocess

posts = "./posts/"
pages = "./pages/"
template = "./blog_template.html"

# Clean pages folder
for filename in os.listdir(pages):
    f = os.path.join(pages, filename)
    os.remove(f)

# Render new pages
for filename in os.listdir(posts):
    post_source = os.path.join(posts, filename)
    post_dest   = os.path.join(pages, os.path.splitext(filename)[0]) + ".html"
    print("rendering: ", post_dest)
    subprocess.run(["pandoc", post_source, "-o", post_dest, "--template=" + template])

# TODO: Update index on homepage from metadata?
