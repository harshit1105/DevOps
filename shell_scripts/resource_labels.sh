#!/bin/bash

###################################
# Description: Update the resource labels of a GKE cluster
# - Read the GKE cluster name from text file
# - Get cluster location and existing labels
# - Add new resource labels while preserving existing ones
###################################

# Read the GKE cluster name from text file
read -p "Enter the file name containing the GKE cluster name: " cluster_file

# Check if the file exists
if [ ! -f "$cluster_file" ]; then
    echo "File not found."
    exit 1
fi

# Read the GKE cluster name from the file
cluster_name=$(cat "$cluster_file")

# Get cluster location
location=$(gcloud container clusters list --filter="name=${cluster_name}" --format="get(location)")

if [ -z "$location" ]; then
    echo "Error: Could not determine cluster location"
    exit 1
fi

# Create backup directory if it doesn't exist
backup_dir="cluster_backups"
mkdir -p "$backup_dir"

# Generate timestamp for backup file
timestamp=$(date +"%Y%m%d_%H%M%S")
backup_file="${backup_dir}/${cluster_name}_${timestamp}.yaml"

# Backup existing cluster configuration
echo "Creating backup of cluster configuration..."
gcloud container clusters describe "$cluster_name" \
    --location="$location" \
    --format="yaml" > "$backup_file"

if [ $? -eq 0 ]; then
    echo "Backup created successfully at: $backup_file"
else
    echo "Error: Failed to create backup"
    exit 1
fi

# Get existing labels
existing_labels=$(gcloud container clusters describe "$cluster_name" \
    --location="$location" \
    --format="json" | \
    jq -r '.resourceLabels | to_entries | map("\(.key)=\(.value)") | join(",")')

# Read the new resource labels from the user
read -p "Enter the new resource labels (key1=value1,key2=value2,...): " new_labels

# Combine existing and new labels
if [ -n "$existing_labels" ]; then
    combined_labels="${existing_labels},${new_labels}"
else
    combined_labels="$new_labels"
fi

# Update the resource labels of the GKE cluster
echo "Updating labels..."
gcloud container clusters update "$cluster_name" \
    --location="$location" \
    --update-labels="$combined_labels"

echo "Successfully updated labels for cluster $cluster_name in location $location"
echo "New label set: $combined_labels"
