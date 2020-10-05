function save_array_object_to_csv() {
    echo "$(jq -r '(.[0] | keys_unsorted), (.[] | to_entries | map(.value))|@csv'<<<"$1")" > "$2"
}
function save_object_to_csv() {
    echo "$(jq -r '(. | keys_unsorted), (. | to_entries | map(.value))|@csv'<<<"$1")" > "$2"
}
function save_array_to_csv() {
    echo "$(jq -r '@csv'<<<"$1")" > "$2"
}

# 1
JSON_FILE=$(curl -s "http://mahdiy.ir/dns/hw0/data.json")
lnames=$(jq -r 'map(.Lname) | sort' <<<"$JSON_FILE")
save_array_to_csv "$lnames" "snapshot-1.log"

# 2
length=$(jq -r 'length' <<<"$JSON_FILE")
echo "\"length\"" > "snapshot-2.log"
echo "$length" >> "snapshot-2.log"

# 3
info=$(jq -r '.[] | select(.Lname == "Moradi" and .Fname=="Sepide")' <<<"$JSON_FILE")
save_object_to_csv "$info" "snapshot-3.log"

# 4
sorted=$(jq -r 'sort_by(.Fname)' <<<"$JSON_FILE")
save_array_object_to_csv "$sorted" "snapshot-4.log"

# 5
max_net=$(jq -r 'max_by(.Net)' <<<"$JSON_FILE")
max_fname=$(jq -r '.Fname' <<<"$max_net")
max_lname=$(jq -r '.Lname' <<<"$max_net")
min_net=$(jq -r 'min_by(.Net)' <<<"$JSON_FILE")
min_fname=$(jq -r '.Fname' <<<"$min_net")
min_lname=$(jq -r '.Lname' <<<"$min_net")
echo "\"Fname\",\"Lname\"" >"snapshot-5.log"
echo "\"${min_fname}\",\"${min_lname}\"" >>"snapshot-5.log"
echo "\"${max_fname}\",\"${max_lname}\"" >>"snapshot-5.log"

# 6
changed=$(echo "$JSON_FILE" | tr 'm' 'h')
changed=$(jq -r '.' <<<"$changed")
save_array_object_to_csv "$changed" "snapshot-6.log"

# 7
students=$(jq -r '.' <<<"$JSON_FILE")
students=$(jq -r 'map(. | .mean=(.OS + .Net + .Algo + .NSec + .Sof)/5)' <<<"$students")
save_array_object_to_csv "$students" "snapshot-7.log"

# 8
echo "\"OS\",\"Net\",\"Algo\",\"NSec\",\"Sof\"">"snapshot-8.log"
declare -a avgs
for course in OS Net Algo NSec Sof
do
  avgs+=("$(jq --arg course "$course" -r "map(.$course) | add / length" <<<"$JSON_FILE")")
done
echo "$(IFS=, ; echo "${avgs[*]}")">>"snapshot-8.log"

# 9
save_array_object_to_csv "$(jq -r '. += [{"Lname": "Fatemi Jahromi", "Fname": "Seyed Alireza", "OS": 20, "Net": 20, "Algo": 20, "Nsec": 20, "Sof": 20}]' <<<"$JSON_FILE")" "snapshot-9.log"

# 10
echo "\"Freq\",\"Grade\"">"snapshot-10.log"
soft_grades=$(jq -r ".[].Sof" <<<"$JSON_FILE")
grades="$((IFS=$'\n';sort <<< "${soft_grades[*]}") | uniq)"
for grade in $grades
do
  echo "$(jq --arg grade "$grade" -r "map(select(.Sof == $grade)) | length" <<< "$JSON_FILE"), $grade" >>"snapshot-10.log"
done
