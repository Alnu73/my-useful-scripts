#!/bin/bash

access_token="$1"
help_msg="Positional arguments: Google Drive Access Token\nOptional arguments:\n\t-h show this help message.\n\t-f file name [default: <date>.png].\n\t file path [default: current folder]."
file_name="$(date +%F-%T).png"
save_path="."

while getopts 'hf:p:' flag;
do
    case "${flag}" in
        h)
            echo -e "$help_msg"
            exit;;
        f)
            file_name=${OPTARG};;
        p)
            save_path=${OPTARG};;
        *)
            echo "[$0]: Invalid flag! Exiting."
            exit;;
    esac
done
shift $(($OPTIND - 1))
full_path="$save_path/$file_name"
maim "$full_path"
echo "Screenshot saved in $full_path"
file_size=$(wc -c < "$full_path")

curl -H "Content-Type: image/jpeg" -H "Content-Length: $file_size" -H "Authorization: Bearer $access_token}" -F "file=@$full_path;type=image/png" -X POST https://www.googleapis.com/upload/drive/v3/files?uploadType=media
