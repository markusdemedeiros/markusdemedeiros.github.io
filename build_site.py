#!/usr/bin/python3

import sys, os


with open("./template.html", "r") as template_file:
    template = template_file.read()
    for file in os.listdir("pages"):
        with open(file, "w") as outfile, open("pages/{}".format(file), "r") as infile:
            print("Building page {}".format(file))
            outfile.write(template.replace("<content>", infile.read()))

    
    
