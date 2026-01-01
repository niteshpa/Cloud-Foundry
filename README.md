# Cloud-Foundry

BOSH Tasks – Clean Notes
List Tasks
bosh tasks --recent
Lists the most recent 30 BOSH tasks.
bosh tasks -r=500
Lists the last 500 tasks. The number can be any value.
bosh tasks
Lists all currently running BOSH tasks.
Task Details
bosh task <TASK_ID>
Shows the overview of a specific task.
bosh task <TASK_ID> --debug
Displays the specific task logs in debug mode.
bosh task <TASK_ID> --cpi
Used to track CPI logs (Cloud Provider Interface logs).
Disk Information
bosh -d <deployment_name> is -i --column="Disk CIDs"
Displays Disk CIDs attached to instances of a deployment.




cf apps | grep "[0-9]/[1]" | awk '{print $1, $2, $3}'

#!/bin/bash

buildpack_name="staticfile"
output_file="apps_with_buildpack.txt"

echo "ORG | SPACE | APP | BUILDPACK" > "$output_file"

orgs=$(cf orgs | tail -n +4 | awk '{print $1}')

for org in $orgs; do
  cf t -o "$org" >/dev/null
  spaces=$(cf spaces | tail -n +4 | awk '{print $1}')

  for space in $spaces; do
    cf t -s "$space" >/dev/null
    apps=$(cf apps | tail -n +4 | awk '{print $1}')

    for app in $apps; do
      buildpack_info=$(cf app "$app" | grep -E "^buildpack" | awk '{print $2}')
      if [[ "$buildpack_info" == *"$buildpack_name"* ]]; then
        echo "$org | $space | $app | $buildpack_info" >> "$output_file"
      fi
    done
  done
done



