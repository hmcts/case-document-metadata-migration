#!/bin/bash
## Usage: ./getSampleRecordsForVerification.sh <csv directory>
##
path=${1}

if [[ -z "$path" ]]; then
    echo "${RED}ERROR: Usage: ./getSampleRecordsForVerification.sh <csvs directory>"
    exit 99
fi

outputFile=one_record_from_each_csv.txt
if [[ -f "$outputFile" ]] ; then
    rm "$outputFile"
fi

for file in ${path}/*.csv
do
   sed -n '2p;1000p;$p' < "$file" >> ${outputFile}
   printf "\n" >> ${outputFile}
done
echo "##first, thousand and last doc records from each csv##"
cat ${outputFile}
echo "##SQL to verify against dm store database ##"
query='select documentmetadata_id, name, value from documentmetadata where documentmetadata_id in ('
while IFS= read -r line
do
query=$query"'"$(echo $line | cut -d "," -f4)"',"
done < ${outputFile}

finalQuery=${query%,}");"
echo ${finalQuery}
