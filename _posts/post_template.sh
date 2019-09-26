#!/usr/bin/env bash

# This script is designed to create a markdown file that
# generates a formatted Jekyll header. It prompts the user
# for a phrase and that phrase is utilized in the name of
# the markdown file that is created.

# To run, copy this file to your desired directory.
# Change to the directory where you just copied this file.
# In a terminal prompt, type:. post_template.sh

# Set variables
POST_DATE=$(date '+%Y-%m-%d')
MD_LINE="---"
LAYOUT="layout: post"
TITLE="title: "
DATE_LINE="date: "
CATEGORIES="categories: "
TAGS="tags: "
PROJECTS="projects: "

# Ask user for input
echo "Enter title:"
read PHRASE
echo "You entered $PHRASE"

echo "Enter categories: (Analysis, Goals, Processing, Protocols)"
read PHRASE2
echo "You entered $PHRASE2"

echo "Enter tags: include []"
read PHRASE3
echo "You entered $PHRASE3"

echo "Enter projects: include []" 
read PHRASE4
echo "You entered $PHRASE4"

# Remove spaces from PHRASE and replace with hyphens
FORMATTED_PHRASE="$(echo -ne "${PHRASE}" | tr [:space:] '-')"

# Save new filename using POST_DATE and FORMATTED_PHRASE variables.
NEW_MD_FILE="$(echo -n "${POST_DATE}"-"${FORMATTED_PHRASE}")".md


# Prints formatted Jekyll header utilizing POST_DATE and user-entered PHRASE.
# Writes contents to NEW_MD_FILE
printf "%s\n%s\n%s%s\n%s'%s'\n%s%s\n%s%s\n%s%s\n" "$MD_LINE" "$LAYOUT" "$TITLE" "$PHRASE" "$DATE_LINE" "$POST_DATE" "$CATEGORIES" "$PHRASE2" "$TAGS" "$PHRASE3" "$PROJECTS" "$PHRASE4" "$MD_LINE" >> \
"$NEW_MD_FILE"

# Opens NEW_MD_FILE in nano text editor for editing.
nano "$NEW_MD_FILE"


# Use git to stage, commit, and push NEW_MD_FILE to GitHub
git add "$NEW_MD_FILE"
git commit -m "created new post: $NEW_MD_FILE"
git push origin master
