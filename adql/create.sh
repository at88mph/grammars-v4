#!/bin/zsh

input_file="examples/sources.adql"

# Read all lines into an array, preserving empty lines
lines=( "${(@f)$(<"$input_file")}" )

# Iterate over each line and create a file with line number and content
for (( i = 1; i <= $#lines; i++ )); do
  line="${lines[i]}"
  output_file="examples/example_${i}.adql"
  print -r -- "$line" > "$output_file"
  echo "Created: $output_file with line $i"
done   
