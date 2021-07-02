#! /bin/bash

# ==============================================================================
# CONFIG
# ==============================================================================
OUTPUT_DIRECTORY="/tmp/efs/output/"
ZIP_DIRECTORY="/tmp/efs/zip/"

RCLONE_CONFIG_PATH="/src/rclone.conf"
RCLONE_FOLDER_GDRIVE="gdrive:"
RCLONE_FOLDER_S3="s3:"
RCLONE_DEBUG="-vv --dump bodies --retries 1"

#
# ENV VARS
#
VAR_GDRIVE_RCLONE_CONFIG=$GDRIVE_RCLONE_CONFIG
VAR_OUTPUT_S3=$OUTPUT_S3

# ==============================================================================
# UTILS
# ==============================================================================
function cleanup() {
    echo "[*] Cleaning up EFS: ${OUTPUT_DIRECTORY}"
    rm -rf $OUTPUT_DIRECTORY

    echo "[*] Cleaning up EFS:  ${ZIP_DIRECTORY}"
    rm -rf $ZIP_DIRECTORY
}

# ==============================================================================
# RUN
# ==============================================================================
#
# Setup folders
#
echo "[*] Cleaning up folders..."
cleanup

echo "[*] Creating output directory: ${OUTPUT_DIRECTORY}"
mkdir -p $OUTPUT_DIRECTORY

echo "[*] Creating zip directory: ${ZIP_DIRECTORY}"
mkdir -p $ZIP_DIRECTORY

#
# Retrieve config
#
echo "[*] Fetching rclone config file..."
echo "$VAR_GDRIVE_RCLONE_CONFIG" > $RCLONE_CONFIG_PATH

#
# Run rclone
#
cmd="rclone --config ${RCLONE_CONFIG_PATH} --drive-acknowledge-abuse copy ${RCLONE_FOLDER_GDRIVE}/ ${OUTPUT_DIRECTORY}"
echo "[*] Running rclone: ${cmd}"
$cmd

if [ $? -ne 0 ]; then
    echo "[ERROR] Backing up GDrive failed"
    cleanup
    exit 1
else
    echo "[*] Ingestion complete"
fi

#
# Zip data
#
today_date=$(date +'%Y-%m-%d')
zip_name="${today_date}_gdrive_backup.zip"
fname="${ZIP_DIRECTORY}${zip_name}"

echo "[*] Zipping output folder: ${fname}"
zip -rq $fname $OUTPUT_DIRECTORY

#
# Sync to S3
#
echo "[*] Uploading ZIP to S3: ${VAR_OUTPUT_S3}/${zip_name}"
rclone --config ${RCLONE_CONFIG_PATH} copy $fname ${RCLONE_FOLDER_S3}${VAR_OUTPUT_S3}

#
# Cleanup
#
echo "[*] Cleaning up folders..."
cleanup

echo "[!] Completed!"
