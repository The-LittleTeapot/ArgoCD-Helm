#!/bin/bash

# Exit when any command fails
set -e

#!/bin/bash

# Initialize flags for version increment
increment_major=false
increment_minor=false
increment_patch=false

# Function to show usage
usage() {
    echo "Usage: $0 -v <current_ver> [-m (for major) | -n (for minor) | -p (for patch)]"
    echo "  -v  Version string in 'major.minor.patch' format"
    echo "  -m  Increment major version"
    echo "  -n  Increment minor version"
    echo "  -p  Increment patch version"
    exit 1
}

# Parse command line options
while getopts "v:mnp" opt; do
  case $opt in
    v)
      current_ver="${OPTARG}"
      ;;
    m)
      increment_major=true
      ;;
    n)
      increment_minor=true
      ;;
    p)
      increment_patch=true
      ;;
    *)
      usage
      ;;
  esac
done

# Check if version is provided
if [ -z "${current_ver}" ]; then
    echo "Error: Version must be provided with -v"
    usage
fi

# Extract version components using awk
major=$(echo ${current_ver} | awk -F'.' '{print $1}')
minor=$(echo ${current_ver} | awk -F'.' '{print $2}')
patch=$(echo ${current_ver} | awk -F'.' '{print $3}')

# Apply increments based on flags
if [ "${increment_major}" = "true" ]; then
    major=$((major + 1))
fi

if [ "${increment_minor}" = "true" ]; then
    minor=$((minor + 1))
fi

if [ "${increment_patch}" = "true" ]; then
    patch=$((patch + 1))
fi

# Construct new version
new_ver="${major}.${minor}.${patch}"

# Output the new version
echo ${new_ver}


# # Simulate release of the new docker images
# docker tag nginx:1.23.3 aputra/nginx:$new_ver

# # Push new version to dockerhub
# docker push aputra/nginx:$new_ver

# # Create temporary folder
# tmp_dir=$(mktemp -d)
# echo $tmp_dir

# # Clone GitHub repo
# git clone git@github.com:antonputra/lesson-158.git $tmp_dir

# # Update image tag
# sed -i '' -e "s/aputra\/nginx:.*/aputra\/nginx:$new_ver/g" $tmp_dir/my-app/1-deployment.yaml

# # Commit and push
# cd $tmp_dir
# git add .
# git commit -m "Update image to $new_ver"
# git push

# # Optionally on build agents - remove folder
# rm -rf $tmp_dir