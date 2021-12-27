echo "# mpv EDL v0"
while IFS=, read -r name ; do
                 echo "$(wslpath -w "$name")"
done < "$1"
