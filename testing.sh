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
runtime="4 minute"
end=$(date -ud "$runtime" +%s)
echo "Muting host monitor..."
json_val=$(curl -X POST "https://app.datadoghq.com/api/v1/downtime" -H "Content-type: application/json" -H "DD-API-KEY: ${api_key}" -H "DD-APPLICATION-KEY: ${app_key}" -d '{"scope":"cluster-name:cluster-1", "monitor_tags":["compliance:"'"$compliance"'","environment:"'"$environment"'","product:"'"$product"'"], "start":"'"$start"'", "end":"'"$end"'", "recurrence": {"type": "days","period": 1}}')
