#!/usr/bin/env python3
# vim: set ts=4 sts=0 sw=4 si fenc=utf-8 et:
# vim: set fdm=marker fmr={{{,}}} fdl=0 foldcolumn=4:
# Authors:     BP
# Maintainers: BP
# Copyright:   2023, HRDAG, GPL v2 or later
# =========================================

# dependencies --- {{{
from pathlib import Path
from sys import stdout
import argparse
import logging
import pandas as pd
import rapidfuzz
import line_profiler

profile = line_profiler.LineProfiler()
# }}}

# support methods --- {{{
def get_args():
    parser = argparse.ArgumentParser()
    parser.add_argument("--lines", default="output/lines.parquet")
    parser.add_argument("--output", default="output/rf-py-cdist.parquet")
    args = parser.parse_args()
    assert Path(args.lines).exists()
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


@profile
def procdist(lines):
    return rapidfuzz.process.cdist(lines, lines,
                                   scorer=rapidfuzz.distance.Levenshtein.distance,
                                   workers=-1).flatten()
# }}}

# main --- {{{
if __name__ == '__main__':
    
    # setup logging
    logger = get_logger(__name__, "output/L-py-singl.log")

    # arg handling
    args = get_args()

    pairs = pd.read_parquet(args.pairs)
    lines = pairs.line_a.unique()
    # the cdist method wants to do the pairing between colla and collb
    # but we want to do the pairing and possible filtering ourselves
    # using unique lines preserves this example but isnt ideal if set(colla) != set(collb)
    pairs['rapidfuzz_levdist'] = procdist(lines)
    assert (pairs.loc[pairs.line_a == pairs.line_b, 'rapidfuzz_levdist'] == 0).all()
    pairs.to_parquet(args.output)
# }}}
