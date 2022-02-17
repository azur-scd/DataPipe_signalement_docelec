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
import platform
import subprocess
import lxml

splitchar = ":"
os_platform = platform.system()

w_options = ['ftf', 'cairn_titre_a_titre', 'cairn_qsj', 'cairn_couperin', 'cyberlibris', 'numilog']
atoz_cols_to_remove = ['Edition','Editor', 'Illustrator', 'DOI', 'PeerReviewed','CustomCoverageBegin',
       'CustomCoverageEnd', 'CoverageStatement', 'Embargo', 'CustomEmbargo',
       'Description', 'Subject', 'PackageContentType',
       'CreateCustom', 'HideOnPublicationFinder', 'Delete',
       'OrderedThroughEBSCO', 'IsCustom', 'UserDefinedField1',
       'UserDefinedField2', 'UserDefinedField3', 'UserDefinedField4',
       'UserDefinedField5', 'PackageType', 'AllowEBSCOtoSelectNewTitles','PackageID','VendorName','VendorID']

def file_path(relative_path):
    folder = os.path.dirname(os.path.abspath("__file__"))
    path_parts = relative_path.split("/")
    new_path = os.path.join(folder, *path_parts)
    return new_path

def exec_w(**kwargs):
    """
    Parameters
    ----------
    workflow : str, possible values are ftf|cairn_qsj|cairn_titre_a_titre|cyberlibris|numilog
    filename : str, name of the data source file (.csv or .xml) in the HOME/source-files/ folder
    """
    workflow=kwargs.get('workflow')
    filename=kwargs.get('filename')    
    
    # check some verifs
    if str(workflow) not in w_options:
        print("Error in workflow argument value, authorized values are : atoz|cairn_qsj|cairn_titre_a_titre|cyberlibris|numilog")
    elif not(file_path('source_files/'+filename)):
        print("Error in source filename path : check if file exists in the /source_files/ folder, or if the given name is correct")
    else:
        print("Processing %s with %s file..." % (workflow,filename))
    
    if workflow == "ftf":
        df = pd.read_csv(file_path('source_files/'+filename), sep=',', encoding='utf8')
        df = df.drop(atoz_cols_to_remove, axis=1).fillna('').replace('&', '&amp;')
        df.drop(df[(df.PackageName == 'Business Source Complete') & ((df.ResourceType == 'Report') | (df.ResourceType == 'Book Series'))].index, inplace=True)
        df.to_xml(path_or_buffer=file_path('temporary_files/ftf_temp.xml'), root_name='Resources', row_name='Resource', encoding='utf-8', xml_declaration=True, pretty_print=True, parser='lxml')
        if os_platform == 'Windows':
            print(subprocess.run([file_path('run_saxon.bat'),file_path('xslt/ftf4primo.xsl'),file_path('temporary_files/ftf_temp.xml'),file_path('result_files/ftf.xml')], shell=True, check=True, capture_output=True))
        if os_platform == 'Linux':
            print(subprocess.run(['/bin/bash','./run_saxon.sh',file_path('xslt/ftf4primo.xsl'),file_path('temporary_files/ftf_temp.xml'),file_path('result_files/ftf.xml')]))
        print("...End processing")
    
    if workflow == 'numilog':
        if os_platform == 'Windows':
            print(subprocess.run([file_path('run_saxon.bat'),file_path('xslt/numilog4primo.xsl'),file_path('source_files/'+filename),file_path('result_files/numilog.xml')], shell=True, check=True, capture_output=True))
        if os_platform == 'Linux':
            print(subprocess.run(['/bin/bash','./run_saxon.sh',file_path('xslt/numilog4primo.xsl'),file_path('source_files/'+filename),file_path('result_files/numilog.xml')]))
        print("...End processing")

    if workflow == 'cairn_titre_a_titre':
        if os_platform == 'Windows':
            print(subprocess.run([file_path('run_saxon.bat'),file_path('xslt/cairn_titre_a_titre4primo.xsl'),file_path('source_files/'+filename),file_path('result_files/cairn_tat_result_'+filename)], shell=True, check=True, capture_output=True))
        if os_platform == 'Linux':
            print(subprocess.run(['/bin/bash','./run_saxon.sh',file_path('xslt/cairn_titre_a_titre4primo.xsl'),file_path('source_files/'+filename),file_path('result_files/cairn_tat_result_'+filename)]))
        print("...End processing") 

    if workflow == 'cairn_qsj':
        if os_platform == 'Windows':
            print(subprocess.run([file_path('run_saxon.bat'),file_path('xslt/cairn_qsj4primo.xsl'),file_path('source_files/'+filename),file_path('result_files/cairn_qsj_result_'+filename)], shell=True, check=True, capture_output=True))
        if os_platform == 'Linux':
            print(subprocess.run(['/bin/bash','./run_saxon.sh',file_path('xslt/cairn_qsj4primo.xsl'),file_path('source_files/'+filename),file_path('result_files/cairn_sqj_result_'+filename)]))
        print("...End processing")

    if workflow == 'cairn_couperin':
        if os_platform == 'Windows':
            print(subprocess.run([file_path('run_saxon.bat'),file_path('xslt/cairn_couperin4primo.xsl'),file_path('source_files/'+filename),file_path('result_files/cairn_couperin_result_'+filename)], shell=True, check=True, capture_output=True))
        if os_platform == 'Linux':
            print(subprocess.run(['/bin/bash','./run_saxon.sh',file_path('xslt/cairn_couperin4primo.xsl'),file_path('source_files/'+filename),file_path('result_files/cairn_couperin_result_'+filename)]))
        print("...End processing") 

    if workflow == 'cyberlibris':
        if os_platform == 'Windows':
            print(subprocess.run([file_path('run_saxon.bat'),file_path('xslt/cyberlibris4primo.xsl'),file_path('source_files/'+filename),file_path('result_files/cyberlibris_result_'+filename)], shell=True, check=True, capture_output=True))
        if os_platform == 'Linux':
            print(subprocess.run(['/bin/bash','./run_saxon.sh',file_path('xslt/cyberlibris4primo.xsl'),file_path('source_files/'+filename),file_path('result_files/cyberlibris_result_'+filename)]))
        print("...End processing")		
        
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
    exec_w(workflow=arg_w,filename=arg_f)
    
    
if __name__ == "__main__":
    if len(sys.argv) > 3:
        print("Too many arguments, Usage: %s -f:<filename> -w:<workflow>" % sys.argv[0])
    elif len(sys.argv) < 3:
        print("Missing one or two arguments, Usage: %s -f:<filename> -w:<workflow>" % sys.argv[0])
    else:
        main(*sys.argv[1:])