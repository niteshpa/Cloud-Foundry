
### BOSH Tasks

```bash
bosh tasks --recent
bosh tasks -r=500
bosh tasks
```

```bash
bosh task <TASK_ID>
bosh task <TASK_ID> --debug
bosh task <TASK_ID> --cpi
```

### Disk / Resurrection

```bash
bosh -d appMetrics-<DEPLOYMENT_GUID> is -i --column="Disk CIDs"
bosh -d appMetrics-<DEPLOYMENT_GUID> cck
```

```bash
bosh update-resurrection on
bosh curl /resurrection
```

---

### VM Vitals & Disk Usage

```bash
bosh -d <deployment> vms --vitals --json
```

```bash
bosh vms --vitals --json | jq -r '.Tables[].Rows[] | [.instance,.ephemeral_disk_usage,.persistent_disk_usage] | @tsv' | column -t
```

```bash
bosh vms --vitals --json | jq -r '.Tables[].Rows[] | [.instance,.cpu_sys,.cpu_user,.memory_usage] | @tsv' | column -t
```

---

## Cloud Foundry (CF)

### App Stats

```bash
cf curl /v2/apps/<APP_GUID>/stats
cf curl /v2/apps/<APP_GUID>/stats | grep host
```

### Users (v3)

```bash
cf curl "/v3/users?page=1&per_page=5000" | jq -r '.resources[].username'
```

> `per_page=5000` is the maximum supported

---

### Organizations / Spaces / Apps

```bash
cf curl /v2/organizations
cf curl /v3/organizations
cf curl /v3/spaces
cf curl /v3/apps
```

### Pagination (v3)

```bash
cf curl /v3/organizations?page=1&per_page=100
```

---

### App Events & Summary

```bash
cf curl /v2/events?q=actee:<APP_GUID>
cf curl /v2/apps/<APP_GUID>/summary
```

---

### Audit Events

```bash
cf curl /v3/audit_events
```

Docs:

* [https://docs.cloudfoundry.org/running/managing-cf/audit-events.html](https://docs.cloudfoundry.org/running/managing-cf/audit-events.html)
* [https://v3-apidocs.cloudfoundry.org](https://v3-apidocs.cloudfoundry.org)

---

### App Lifecycle

```bash
cf app <APP_NAME> --guid
cf curl /v3/apps/<GUID>/processes
cf curl /v2/apps/<GUID> -X PUT -d '{"command":""}'
cf restage <APP_NAME>
cf restart <APP_NAME>
```

### Run Task

```bash
cf run-task <APP_NAME> <COMMAND> -k <DISK> -m <MEMORY> --name <TASK_NAME>
```

Example:

```bash
cf run-task example-app "nc ip port -v" --name task1
```

---

## 3. cf-dot

```bash
cf dot --help
cf dot cells
cf dot cells --json
cf dot cell-state <CELL_GUID>
```

```bash
cf dot desired-lrp-scheduling-infos | jq '.instances' | jq -s 'add'
```

```bash
cf dot actual-lrps | jq -s 'group_by(.state)[] | {state: .[0].state, count: length}'
```

```bash
cf dot actual-lrp-groups | jq '.instance | select(.state=="CRASHED").process_guid' | cut -c 2-37 | sort -u
```

---

## CredHub

```bash
credhub f | grep uaa | grep opsman
```

```bash
credhub get -n PATH
credhub get -n PATH
```

```bash
credhub set -n /cf/dev/product-properties/networking_poe_ssl_certs_0_key -t value -v "$(X.com.key)"
```

---

##  UAAC

```bash
uaac target <UAA_URL>
uaac targets
uaac context
```

```bash
uaac token client get admin -s <SECRET>
uaac users
uaac user get <username>
uaac user delete <username>
```

### Role Management

```bash
uaac member add cloud_controller.admin <user>
uaac member add healthwatch.admin <user>
```


## 6. Ops Manager / SSH / BBR

```bash
ssh -o StrictHostKeyChecking=no -i bbr.pem bbr@10.X.X.X
```

```bash
sb.pem -> obtained from Ops Manager
Director IP: https://opsman/api/v0/deployed/director/status
```

Docs:
[https://docs.vmware.com/en/VMware-Tanzu-Operations-Manager](https://docs.vmware.com/en/VMware-Tanzu-Operations-Manager)

---

## Git Bash & Linux

```bash
export MY_VAR="example"
```

```bash
cat urls.txt | while read url; do start "$url"; done
```

> urls.txt must contain valid FQDNs line by line

---

## Ruby / YAML

```bash
ruby -ryaml -e "p YAML.load(STDIN.read)" < cf-mgmt.yaml
```

---

## Loops & Automation

### While Loop

```bash
while read var; do cf app $var | grep -B 1 "requested state"; done < list.txt
```

### For Loop

```bash
for i in $(cat list.txt); do cf app $i | grep -A 1 name; done
```

```bash
for i in $(bosh ds --column=name | grep iso); do bosh -d $i vms | awk '{print $1}'; done
```

---

## Errands

```bash
BOSH_CLIENT=ops_manager bosh -e <ENV> -d cf run-errand push-apps-manager
```

---

## MySQL

```bash
mysql --defaults-file=/var/vcap/jobs/pxc-mysql/config/mylogin.cnf
```

```sql
show databases;
show tables;
select * from <table> limit 10;
```

```sql
select * from scaling_events;
```

```sql
UPDATE performance_schema.setup_consumers
SET enabled='YES'
WHERE NAME='events_statements_cpu';
```

---

##  AWS S3 (Custom Endpoint)

```bash
aws configure
```

```bash
aws s3api list-buckets --endpoint-url  <> --no-verify-ssl
aws s3api list-object-versions --bucket <bucket> --endpoint-url <>
aws s3api list-objects --bucket <bucket> --endpoint-url <>
```

---

##  OpenSSL

```bash
openssl rsa -noout -modulus -in X.com.key | openssl md5
openssl x509 -noout -modulus -in X.com.cer | openssl md5
```

```bash
openssl x509 -noout -dates -in certificate.cer
openssl x509 -in certificate.cer -text -noout
```

---

## Curl

```bash
curl -Ik https://url.com/login
```

```bash
curl -k -L -s -o /dev/null -w "%{http_code}" https://your-url.com
```

---

## Windows CMD / Shortcuts

```text
Win + V        Clipboard history
Win + D        Desktop
Alt + Tab      Switch apps
Ctrl + Shift + Esc  Task Manager
```

```cmd
snippingtool /clip
```

---

## Excel Formulas

```excel
=XLOOKUP([@Org],APPCODE[Org (in PCF)],APPCODE[LOBT])
```

```excel
=VLOOKUP(lookup_value,table_array,col_index_num,FALSE)
```

```excel
=IFERROR(VLOOKUP(D2,Table4[#All],2,FALSE),0)
```

```excel
=IF(ISNA(VLOOKUP(B4,Sheet1!$A$2:$A$42,1,FALSE)),"No Match","Match")
```

---
