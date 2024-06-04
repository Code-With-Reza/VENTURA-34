#!/bin/bash

# Change to the current directory
cd "$(pwd)" || exit

# Check if there are changes to commit
if [ -z "$(git status --porcelain)" ]; then
  echo "No changes to commit."
  exit 0
fi

# Function to commit a batch of files
commit_batch() {
  local files=("$@")
  local batch_msg="Committing batch of ${#files[@]} files"
  
  git add "${files[@]}"
  git commit -m "$batch_msg"
}

# Get a list of all changed files
changed_files=($(git status --porcelain | awk '{print $2}'))

# Batch size
batch_size=100
total_files=${#changed_files[@]}

# Commit files in batches
for ((i=0; i<total_files; i+=batch_size)); do
  batch=("${changed_files[@]:i:batch_size}")
  commit_batch "${batch[@]}"
done

# Push the commits to the remote repository
git push

echo "All changes committed and pushed to remote repository."
