#!/bin/bash

# Function to recursively calculate the size of files and folders
calculate_size() {
    local item="$1"
    
    # Check if the item is a file or directory
    if [ -f "$item" ]; then
        du -b "$item" | cut -f1
    elif [ -d "$item" ]; then
        local total_size=0
        for subitem in "$item"/*; do
            total_size=$((total_size + $(calculate_size "$subitem")))
        done
        echo "$total_size"
    else
        echo "0"
    fi
}

# Calculate the size of the current directory
total_size=$(calculate_size ".")

# Output the total size, automatically selecting appropriate units (B, KB, MB, GB)
if [ $total_size -lt 1024 ]; then
    echo "Total size: ${total_size}B"
elif [ $total_size -lt 1048576 ]; then
    echo "Total size: $(($total_size / 1024))KB"
elif [ $total_size -lt 1073741824 ]; then
    echo "Total size: $(($total_size / 1024 / 1024))MB"
else
    echo "Total size: $(($total_size / 1024 / 1024 / 1024))GB"
fi
