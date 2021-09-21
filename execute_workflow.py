#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""
Created on Tue Sep 21 09:59:49 2021
@author: Géraldine Geoffroy

Automate the Primo pre-harvesting data processing (all sources : journals & ebooks)
"""
import numpy as np
import pandas as pd
import os
import sys
import subprocess
import lxml

splitchar = ":"
atoz_cols_to_remove = ['Edition','Editor', 'Illustrator', 'DOI', 'PeerReviewed','CustomCoverageBegin',
       'CustomCoverageEnd', 'CoverageStatement', 'Embargo', 'CustomEmbargo',
       'Description', 'Subject', 'PackageContentType',
       'CreateCustom', 'HideOnPublicationFinder', 'Delete',
       'OrderedThroughEBSCO', 'IsCustom', 'UserDefinedField1',
       'UserDefinedField2', 'UserDefinedField3', 'UserDefinedField4',
       'UserDefinedField5', 'PackageType', 'AllowEbscoToAddNewTitles',
       'Unnamed: 40']

def file_path(relative_path):
    folder = os.path.dirname(os.path.abspath("__file__"))
    path_parts = relative_path.split("/")
    new_path = os.path.join(folder, *path_parts)
    return new_path

def exec_w(**kwargs):
    """
    Parameters
    ----------
    workflow : str, possible values are atoz|cairn_qsj|cairn_titre_a_titre|cyberlibris|numilog
    filename : str, name of the data source file (.csv or .xml) in the HOME/source-files/ folder
    spinner: bool, whether display a task spinner (used in notebook) or not
    """
    workflow=kwargs.get('workflow')
    filename=kwargs.get('filename')
    spinner=kwargs.get('spinner')
    
    spin = 0
    
    if workflow == "atoz":
        actions = "df = pd.read_csv('source_files/'+filename, sep=',', encoding='utf8')$df = df.drop(atoz_cols_to_remove, axis=1).fillna('').replace('&', '&amp;')$df.drop(df[(df.PackageName == 'Business Source Complete') & ((df.ResourceType == 'Report') | (df.ResourceType == 'Book Series'))].index, inplace=True)$df.to_xml(path_or_buffer='temporary_files/atoz_export.xml', root_name='Resources', row_name='Resource', encoding='utf-8', xml_declaration=True, pretty_print=True, parser='lxml')$print(subprocess.run(['run_saxon.bat',file_path('xslt/atoztemp4primo.xsl'),file_path('temporary_files/atoz_export.xml'),file_path('result_files/atoz.xml')], shell=True, check=True, capture_output=True)"
        actions_list = list(actions.split("$"))
        for i in actions_list:
            if spinner:
                spin = actions_list.index(i)
                return i
            else:
                return i
        
        
def main(*args):
    arg_w = None
    arg_f = None
    for argument in args:
        if not(splitchar in argument):
            print("Syntax error in argument, Usage of arguments must be : -f:<filename> -w:<workflow>") 
        else:
            if (argument.split(splitchar)[0] != "-w") & (argument.split(splitchar)[0] != "-f"):
                print("Syntax error in argument, Usage of arguments must be : -f:<filename> -w:<workflow>") 
            elif argument.split(splitchar)[0] == "-w":
                arg_w = argument.split(splitchar)[1]
            elif argument.split(splitchar)[0] == "-f":
                arg_f = argument.split(splitchar)[1]
    exec_w(workflow=arg_w,filename=arg_f,spinner=False)
    
    
if __name__ == "__main__":
    if len(sys.argv) > 3:
        print("Too many arguments, Usage: %s -f:<filename> -w:<workflow>" % sys.argv[0])
    elif len(sys.argv) < 3:
        print("Missing workflow argument, Usage: %s -f:<filename> -w:<workflow>" % sys.argv[0])
    else:
        main(*sys.argv[1:])