#!/usr/bin/env python
import sys
import os
import logging

from glob import glob

def crawl_and_replace(base_folder, old_string, new_string, check_ext=None, git=False, debug=False):
    for dirpath, dirnames, filenames in os.walk(base_folder):
        filenames = [f for f in filenames if old_string in f]
        if check_ext is not None:
            filenames = [f for f in filenames if f.split(".")[-1] in check_ext]

        for filename in filenames:
            old_path = os.path.join(dirpath, filename)
            new_path = os.path.join(dirpath, filename.replace(old_string,new_string))

            os_command = "{} mv {} {}".format("git" if git else "",old_path,new_path)
            if debug:
                logging.info(os_command)
            else:
                os.system(os_command)

    
if __name__ == "__main__":
    import argparse
    ##############################################################################################################
    ##############################################################################################################
    # Argument parser definitions:
    argumentparser = argparse.ArgumentParser(
        description='Script for bulkrenaming file'
    )
    argumentparser.add_argument(
        "--logging",
        action = "store",
        help = "Define logging level: CRITICAL - 50, ERROR - 40, WARNING - 30, INFO - 20, DEBUG - 10, NOTSET - 0 \nSet to 0 to activate ROOT root messages",
        type=int,
        default=20
    )
    argumentparser.add_argument(
        "--base",
        action = "store",
        help = "Base folder, that the script stars to crawl",
        type = str,
        required=True,
    )
    argumentparser.add_argument(
        "--oldString",
        action = "store",
        help = "Substring of the filename that should be replace",
        type = str,
        required=True,
    )
    argumentparser.add_argument(
        "--newString",
        action = "store",
        help = "New substring",
        type = str,
        required=True,
    )
    argumentparser.add_argument(
        "--ext",
        action = "store",
        help = "If something is passed, that extention of the file will be checked.",
        type = str,
        nargs = "+",
        default = None
    )
    argumentparser.add_argument(
        "--debug",
        action = "store_true",
        help = "Debug mode (will print commands and not execute them)", 
    )
    argumentparser.add_argument(
        "--git",
        action = "store_true",
        help = "If passed, the git mv command will be sued ", 
    )
    args = argumentparser.parse_args()
    ##############################################################################################################
    ##############################################################################################################
    logging.basicConfig(
        format=('[%(asctime)s] %(levelname)-8s %(message)s'),
        level=args.logging,
        datefmt="%H:%M:%S"
    )
    
    crawl_and_replace(base_folder=args.base, old_string=args.oldString, new_string=args.newString, check_ext=args.ext, git=args.git, debug=args.debug)

