function save_object_to_csv() {
    echo "$(jq -r '(.[0] | keys_unsorted), (.[] | to_entries | map(.value))|@csv'<<<"$1")" > "$2"
}
function save_array_to_csv() {
    echo "$(jq -r '@csv'<<<"$1")" > "$2"
#      echo "$(jq -r 'map([.] | join(", ")) | join("\n")'<<<"$1")" > "$2"
}

JSON_FILE=$(curl -s "http://mahdiy.ir/dns/hw0/data.json")
lnames=$(jq -r 'map(.Lname) | sort' <<<"$JSON_FILE")
save_array_to_csv "$lnames" "snapshot-1.log"


length=$(jq -r 'length' <<<"$JSON_FILE")
save_array_to_csv ["$length"] "snapshot-2.log"

info=$(jq -r '.[] | select(.Lname == "Moradi" and .Fname=="Sepide")' <<<"$JSON_FILE")
echo "$info" >"snapshot-3.log"

sorted=$(jq -r 'sort_by(.Fname)' <<<"$JSON_FILE")
echo "$sorted" >"snapshot-4.log"

max_net=$(jq -r 'max_by(.Net)' <<<"$JSON_FILE")
max_fname=$(jq -r '.Fname' <<<"$max_net")
max_lname=$(jq -r '.Lname' <<<"$max_net")
min_net=$(jq -r 'min_by(.Net)' <<<"$JSON_FILE")
min_fname=$(jq -r '.Fname' <<<"$min_net")
min_lname=$(jq -r '.Lname' <<<"$min_net")
echo "${min_fname} ${min_lname}" >"snapshot-5.log"
echo "${max_fname} ${max_lname}" >>"snapshot-5.log"

changed=$(echo "$JSON_FILE" | tr 'm' 'h')
changed=$(jq -r '.' <<<"$changed")
echo "$changed" >"snapshot-6.log"

students=$(jq -r '.' <<<"$JSON_FILE")
students=$(jq -r 'map(. | .mean=(.OS + .Net + .Algo + .NSec + .Sof)/5)' <<<"$students")
echo "$students" >"snapshot-7.log"

>"snapshot-8.log"
for course in OS Net Algo NSec Sof; do
  echo $course >>"snapshot-8.log"
  echo $(jq --arg course "$course" -r "map(.$course) | add / length" <<<"$JSON_FILE") >>"snapshot-8.log"
done

echo $(jq -r '. += [{"Lname": "Fatemi Jahromi", "Fname": "Seyed Alireza", "OS": 20, "Net": 20, "Algo": 20, "Nsec": 20, "Sof": 20}]' <<<"$JSON_FILE") >"snapshot-9.log"
#for student in $students; do
#done

soft_grades=$(jq -r ".[].Sof" <<<"$JSON_FILE")
echo $((IFS=$'\n';sort <<< "${soft_grades[*]}") | uniq -c ) > "snapshot-10.log"

save_object_to_csv $JSON_FILE "a.csv"