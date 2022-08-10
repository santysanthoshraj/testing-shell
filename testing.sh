#!/bin/sh
file="./test1.properties"
while IFS='=' read -r key value
do
    key=$(echo $key | tr '.' '_')
    eval ${key}=\${value}
done < "$file"
api_key=${data_api_key}
app_key=${data_app_key}
#data = {"monitor_tags":"*","start":+int(currenttime)}
start=$(date +%s)
runtime="10 minute"
end=$(date -ud "$runtime" +%s)
sleep $(( (RANDOM % 10) + 1 ));
echo "Muting host monitor..."
json_val=$(curl -X POST "https://app.datadoghq.com/api/v1/downtime" -H "Content-type: application/json" -H "DD-API-KEY: ${api_key}" -H "DD-APPLICATION-KEY: ${app_key}" -d '{"scope":"cluster-name:cluster-1", "monitor_tags":["compliance:pci","environment:production","product:ls"], "start":"'"$start"'", "end":"'"$end"'", "recurrence": {"type": "days","period": 1}}')
code_val=$(jq -r '.id' <<< "$json_val")
#echo "$code_val"
curl -X DELETE "https://app.datadoghq.com/api/v1/downtime/$code_val" -H "Content-type: application/json" -H "DD-API-KEY: ${api_key}" -H "DD-APPLICATION-KEY: ${app_key}"
exit 0
