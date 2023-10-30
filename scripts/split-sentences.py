#!/usr/bin/env python

import sys
import re

# TODO: explain how the regexes work
def split_sentences(text):
    # Remove hyphens at the end of lines and join lines without a dot separator
    text = re.sub(r'-(\n|$)', '', text)
    text = re.sub(r'(?<!\.)\n', ' ', text)

    # Split text into sentences using regex pattern
    sentences = re.split(r'(?<!\w\.\w.)(?<![A-Z][a-z]\.)(?<=\.|\?|\!)\s', text)

    return sentences


input_text = sys.stdin.read()

sentences = split_sentences(input_text)

for sentence in sentences:
    print(sentence)
