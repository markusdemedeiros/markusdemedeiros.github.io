#!/usr/bin/python3

import sys, os


# Generate a posts_index markdown file 

# pandoc that into index.html with template.html

# for each post in posts/*.md, pandoc it into pages/*.html with 


with open("./template.html", "r") as template_file:
    template = template_file.read()
    for file in os.listdir("pages"):
        with open(file, "w") as outfile, open("pages/{}".format(file), "r") as infile:
            print("Building page {}".format(file))
            outfile.write(template.replace("<content>", infile.read()))

    
    
