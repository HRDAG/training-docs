### Scripts

#### Style requirements
_Script contains:_
- [] Standard script header and footer
- [] Double-spaces between functions and class definitions
- [] Single-space within code
- [] Logical function and variable names

_Script does NOT contain:_
- [] Commented code
- [] Space around variable names as arguments in parentheses
- [] Unused modules
- [] Remnants of abandoned approaches/methods

#### Core logic requirements
- [] Assert statements that trace I/O along function calls and manipulations
- [] Logging of data characteristics, manipulations performed, and reports 
- [] Digestible and readily debuggable units of code
    - [] Multiple small scripts instead of a single long script
- [] Ideal solutions per the corresponding language's docs

```
#!/usr/local/bin/python
# -*- coding: utf-8 -*-
# vim: set ts=4 sts=0 sw=4 si fenc=utf-8 et:
# vim: set fdm=marker fmr={{{,}}} fdl=0 foldcolumn=4:
# Authors:     BP
# Maintainers: BP
# Copyright:   2023, HRDAG, GPL v2 or later
# =========================================
# DPA/filter/src/find_officers.py

# ---- dependencies {{{
from os import listdir
from pathlib import Path
from sys import stdout
import argparse
import logging
import re
import pandas as pd
#}}}

# ---- support methods {{{
def get_args():
    parser = argparse.ArgumentParser()
    parser.add_argument("--input", default="output/complaints.parquet")
    parser.add_argument("--output", default="output/named-officers.parquet")
    args = parser.parse_args()
    assert Path(args.input).exists()
    return args


def get_logger(sname, file_name=None):
    logger = logging.getLogger(sname)
    logger.setLevel(logging.DEBUG)
    formatter = logging.Formatter("%(asctime)s - %(levelname)s " +
                                  "- %(message)s", datefmt='%Y-%m-%d %H:%M:%S')
    stream_handler = logging.StreamHandler(stdout)
    stream_handler.setFormatter(formatter)
    logger.addHandler(stream_handler)
    if file_name:
        file_handler = logging.FileHandler(file_name)
        file_handler.setFormatter(formatter)
        logger.addHandler(file_handler)
    return logger


def find_officer_names(line):
    pattern = re.compile("(OFFICER\s[A-Z]+\s[A-Z]+\s[#][0-9]{4,})", flags=re.I|re.M)
    found = re.findall(pattern, line)
    if (not found) | (found == []): return None
    return found
#}}}

# ---- main {{{
if __name__ == '__main__':
    # setup logging
    logger = get_logger(__name__, "output/find_officers.log")

    # arg handling
    args = get_args()
    
    complaints = pd.read_parquet(args.input, columns=['complaint_id', 'allegation_text'])
    complaints['named_officers'] = complaints.allegation_text.apply(find_officer_names)
    complaints.to_parquet(args.output)
    
    logger.info("done.")
    
#}}}
# done.
```

# done.
