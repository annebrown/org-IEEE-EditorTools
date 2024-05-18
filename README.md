<div style="text-align: right"><sub><sub>
    <a href="https://github.com/annebrown/?tab=repositories">
    Repo:</a> <a href="https://github.com/annebrown/org-IEEE-EditorTool/">/dotfiles/</a><a href=
                                                                                          "README.md">README.md</a>
</sub></sub></div>

---
<!-- End of Header -->

# IEEE Editor Tool

## Issue

```CommenterName:``` field in .txt editors' files is entered as one field, whereas Filemaker tool asks for first and last name separately and outputs ```<first>, <last>```.

## Description

Converts Editors' ```.txt``` files to FileMaker ```.csv``` format for input into Comments dB.

## Usage

Place executable or perl script into directory containing .txt files.  

### Windows

```
C:\Path-to-Editors-Files> IEEE-txt-2-csv
```

### Linux

```bash
$ cd path/to/editors-files
$ chmod +x IEEE-txt-csv.pl
$ ./IEEE-txt-csv.pl
```

Creates corresponding .csv files in same directory.  

Run .exe or .pl from command line to see progress and errors 
