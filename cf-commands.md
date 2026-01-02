# ☁️ Cloud Foundry (CF) Command Cheatsheet
---

## General Notes

Cloud Foundry exposes multiple API versions.  
If a command fails, explicitly try `/v2` or `/v3`.

Most list APIs are paginated.  
Use `page` and `per_page` to fetch complete data.

`jq` is commonly used to filter JSON output.

---

## Application Details

Get application runtime statistics:  
`cf curl v2/apps/<APP_GUID>/stats`

Example (show host information only):  
`cf curl v2/apps/ab1a0672-0465-45b9-a67f-8fe84ca1b21d/stats | grep host`

Get application summary (routes, services, state):  
`cf curl v2/apps/<APP_GUID>/summary`

---

## Users

List all users (maximum supported page size is 5000):  
`cf curl "v3/users?page=1&per_page=5000" | jq -r '.resources[].username'`

---

## Organizations, Spaces, Applications

List organizations using v2 API:  
`cf curl v2/organizations`

List organizations, spaces, and apps using v3 API:  
`cf curl v3/organizations`  
`cf curl v3/spaces`  
`cf curl v3/apps`

---

## Pagination (v3)

Fetch large result sets using pagination:  
`cf curl v3/organizations?page=1&per_page=100`

Look for these fields in the response:
- total_results
- total_pages
- next
- previous

---

## Application Events

View events for a specific application (use app GUID):  
`cf curl v2/events?q=actee:<APP_GUID>`

---

## Audit Events

View platform-wide audit events:  
`cf curl v3/audit_events`

References:  
https://docs.cloudfoundry.org/running/managing-cf/audit-events.html  
https://v3-apidocs.cloudfoundry.org

---

## Blobstore Cleanup (Admin Only)

Clean buildpack cache (safe operation):  
`cf curl -X DELETE /v2/blobstores/buildpack_cache`

Clean resource cache (internal blobstore):  
`ssh blobstore-vm`  
`rm -rf /var/vcap/store/shared/cc-resources/*`

---

## App and Process Utilities

Get application GUID:  
`cf app APP_NAME --guid`

List application processes:  
`cf curl /v3/apps/<APP_GUID>/processes`

Clear custom start command:  
`cf curl /v2/apps/<APP_GUID> -X PUT -d '{"command":""}'`

Restage application:  
`cf restage APP_NAME`

Restart application:  
`cf restart APP_NAME`

---

## Run Tasks

Run a task on an application:  
`cf run-task APP_NAME COMMAND [-k DISK] [-m MEMORY] [--name TASK_NAME]`

Example:  
`cf run-task example-app "nc ip port -v" --name task1`

---

## CFDOT Commands

Show help and cell information:  
`cfdot --help`  
`cfdot cells`  
`cfdot cells --json`

Check cell state:  
`cfdot cell-state <CELL_GUID>`

Compare desired vs actual LRPs:  
`cfdot desired-lrp-scheduling-infos | jq '.instances | jq -s "add"'`

Group actual LRPs by state:  
`cfdot actual-lrps | jq -s -r 'group_by(.state)[] | .[0].state + ": " + (length | tostring)'`

Find crashed process GUIDs:  
`cfdot actual-lrp-groups | jq '.instance | select(.state == "CRASHED").process_guid' | cut -c 2-37 | sort -u`

---
