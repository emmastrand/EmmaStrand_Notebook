---
layout: post
title: Unix Shell Basics
date: '2019-06-03'
categories: Processing
tags: unix, terminal
projects: Putnam Lab
---

# Navigating Unix Shell

Author: E. Strand  
Last Updated: 20190603

This document is intended to be a guide for helpful commands in Unix Shell. Please see the below links for a more detailed introduction into what Unix Shell is and what it is used for:
- [Software Carpentry](http://swcarpentry.github.io/shell-novice/)

**Basics**:  
Code to run in Unix Shell will start with `$` following by a command. Any text starting with a `#` is a comment and will not be read by shell.

Only use dashes or underscores for file names, not spaces. If there is a space in a file name, shell won't recognize it.

`bin` is where built-in programs are stored.

Tab completion: shell will complete file names with the 'Tab' key. For example: if there is a file called `north-pacific-gyre` in the directory, if the user types `$ ls nor` and 'Tab', then shell will fill in the rest of the file name to produce `$ ls north-pacific-gyre`.

Getting help: adding `--help` after any command will output the different options of the command and tips on how to use it. Or you can read the command's manual by adding `$ man` before any command.

**Commands**:  
To list contents of a directory: `$ ls`
- `$ ls -F` classifies contents by adding markers to files. `/` indicates a folder, `@` indicates a link, and `*` indicates an executable
- `$ ls -F -a` or `$ ls -Fa`: adding the `-a` flag shows files and directories that begin with `.` and `..`
- `$ ls -l` provides a long list of details for a file or directory

To print working directory: `$ pwd`

Moving directories: `$ cd`
- `$ cd ..` moves up one directory level
- `$ cd ~` moves to user's home directory

Create a directory: `$ mkdir`

Using Nano:  
Nano is text editor within shell that only works with plain character data. This is commonly used for bash scripts.  
- Create a text file called "draft.txt": `$ nano draft.txt`

The bottom of the nano window, there are several options starting with the control key `^`.

To create a file:
- `$ nano my_file.txt`
- `$ touch my_file.txt`

To move or rename a file or directory: `$ mv`  
*Be careful with this command. `mv` will override any already existing file with that name, which could lead to data loss.*
- `$ mv -i` or `$ mv --interactive` will make shell ask you before overriding.
- `$ mv file1 file2` renames file1 to file2
- `$ mv ../file1 /rawdata/` moves file1 to the rawdata folder

To copy a file or directory: `$ cp`  
- `$ cp quotes.txt thesis/quotations.txt` copies quotes.txt file to thesis folder and renames it to quotations.txt
- `$ cp -r` copies a directory

To remove a file or directory: `$ rm`  
*Be careful with this command. Deleting is forever, there is no undo option.*
- `$ rm quotes.txt` removes quotes.txt from directory
- `$ rm -i quotes.txt` makes shell ask you before deleting
- `$ rm -r ` removes a directory

Accessing or manipulating multiple files at once:
- `*` is a wild-card character. For example, `$ ls *.txt` will read any files that end in `.txt` and `$ ls d*` will read any files that start with the letter d.
- `?` is also a wild-card but only matches one character, compared to `*` matches any number of characters.

To count the number of lines, words, or characters: `$ wc`
- `$ wc` will produce 3 columns of lines, words, characters and in that order from left to right
- `$ wc -l` produces number of lines only

To redirect a command: `>` or `>>`
- `$ wc -l file1.txt > lengths.txt` takes the number of lines from file1.txt and creates a lengths.txt file with that data; this will override any existing data in that file
- `$ wc -l file1.txt >> lengths.txt` take the number of lines from file1.txt but adds it to an already existing lengths.txt file

To view the contents of a file:
- `$ cat lengths.txt` will output the contents from the above command
- `$ less lengths.txt` will display a screen with the contents of the file. To advance the screen 'spacebar', to go back one `b`, to quit `q`.
- `$ head` outputs the first five lines of a file
- `$ tail` outputs the last five lines of a file

To sort contents of a file: `$ sort`
- `$ sort -n` sorts numerically

To "pipe" commands: `|`  
This tells shell that the ouput of the first command is the input for the second command.
- `$ wc -l *.txt | sort -n` sorts all of the values for numbers of lines in all of the txt file

To remove content:
- adjacent duplicate lines: `$ uniq`
    - `-c` flag counts the number of times a line occurred
- all duplicate lines: `$ sort file1.txt | uniq`
- certain sections of each line: `$ cut`
  - `-d` defines the delimiter; default is tab, splits each line by comma
  - `-f` specify the column to cut out

To create a loop:  
Loops will have the following structure:

```
$ for thing in list_of_things
> do
>    operation_using $thing #indentation not required, helps with legibility
> done
```
For example:
```
$ for filename in file1.dat file2.dat
> do
>   head -n 2 $filename | tail -n 1
> done
```
The above code prints the first 2 and last line of each file listed (file1.dat and file2.dat).

To print text: `$ echo`

To view or repeat previous commands:
- Use the up or down arrow to scroll through previously entered commands
- `$ Ctrl-R` to search through previously entered commands
- `$ history` to display recent commands
- `$ !number` to repeat a command by number

Running Shell Scripts:  
The formatting for shell scripts follows: `script_name.sh`
- To create and view a script: `$ nano script_name.sh`  
- To run a script: `$ bash script_name.sh`
- To save previous commands as a script: `$ history | tail -n 5 > last5lines.sh`
- `$ bash -x` the `-x` flag runs bash in debug mode and prints each command as it runs. Helpful to locate errors.

To find content: `$ grep`
- `$ grep DNA file1.txt` finds "DNA" in file1.txt
- `$ grep -w The file1.txt` limits matches to word boundaries. Otherwise, the output would include words like "Thesis" instead of only "The"s.
- `$ grep -w "is not" file1.txt` searches for a phrase - "is not"
- `$ grep -n "it" file1.txt` outputs which numbers the lines that contain "it" match
- `$ grep -i` creates a case-sensitive search
- `$ grep -v` inverts the search, lines without the designated word or phrase will output
- `$ grep --help` will outline all possible flags
- `$ grep -E '^.o' file1.txt` will search with wildcards. `-E` allows for the following pattern to be interpreted as a whole, `^` anchors the match to the start of a line, `.` matches a single character,  `o` is the search character.

Searching within files: `$ find`
- `$ find .` searches everything in the current directory
- `$ find . -type d` searches for directories within the current directory
- `$ find . -type f` outputs a listing of the files
- `$ find . -name file1.txt` searches for files by name

Using parentheses to combine commands together:
- `$ wc -l $(find . -name '*.txt')` outputs the word count for all the files that end with `.txt`
- `$ grep "FE" $(find .. -name '*.txt')` outputs files with "FE" in any files ending with `.txt` in the directory one level above
