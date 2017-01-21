<#
    .SYNOPSIS

    script is used to import and summarize multiple txt files with file extensions in windows fsrm (fileserver ressource manager)

    .DESCRIPTION
    the script imports the content of txt files to fsrm. the txt files should look like the sample txt files in github.They have to be located 
    in the same directory. This directory should be defined in variable. Another variable is the filegroupname, you can see this in fsrm
     
    .EXAMPLE
    -

    .Notes
    -
    this script does not create filegroup or filescreens etc.the current extensions configured will be saved in a legay txt file with date
    further information on my blog: http://blog.it-koehler.com
  
    ---------------------------------------------------------------------------------
                                                                                 
    Script:       import-fileextensions-v02.ps1                                      
    Author:       A. Koehler; blog.it-koehler.com
    ModifyDate:   21/01/2017                                                        
    Usage:        
    Version:      0.2
                                                                                  
    ---------------------------------------------------------------------------------
#>
#define variable
#path containing txt files  (without  '\' at the end!)
$txtfilepath = 'C:\Temp\ransomware'
#fsrm filegroup detecting ransomware 
$filegroupname = 'Ransomware'

#########beginning of the script########
$date=((Get-Date).ToString('yyyy-MM-dd-HH-mm-ss'))
#export the existing extensions to legacy txt files
$legacyfile = (Get-ChildItem $txtfilepath -Recurse -Include '*.txt') | Where-Object {$_.Name -like "*-legacy-ext*"}
#check if legacy txt file available, if not create it, otherwise import txt files
if(!$legacyfile)
  {
  (Get-FsrmFileGroup -Name $filegroupname).IncludePattern | Out-File "$txtfilepath\$date-legacy-ext.txt"
  }
#import content from txt files 
$txtfiles = (Get-ChildItem $txtfilepath -Recurse -Include '*.txt').Name
#import content from all txt files inside directory
foreach ($txtfile in $txtfiles)
  {
  $txtfilescomplpath = $txtfilepath+'\'+ $txtfile
  #convert all content to lower
  $fileext += @((Get-Content $txtfilescomplpath).ToLower())
  }
#sort and eliminate double entries
$compareext = $fileext | Sort-Object -Unique
Set-FsrmFileGroup -Name $filegroupname -IncludePattern ($compareext)
