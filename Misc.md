# 🐧 Linux, Git, BOSH, Concourse & Misc Commands Cheatsheet

## Linux – Process & System Checks

Show top CPU consuming processes:
`ps aux --sort=-%cpu | head -n 6`

Find which process is using a file:
`lsof /path/to/file`

Disk usage (human-readable, sorted):
`du -h --max-depth=1 | sort -hr`

Run a script in background even after terminal closes:
`nohup ./my_script.sh &> my_output.log &`

---

## Linux – File & Text Operations

Find files and replace text:
`find . -name "*.txt" | xargs sed -i 's/OLD/NEW/g'`

Search configuration values:
`grep -R "instance-memory-limit" .`

---

## Linux – Networking & Host Info

Check hostname:
`hostnamectl`

Check open ports:
`netstat -tulnp`

---

## Git – Basic Workflow

Configure user:
`git config --global user.email "you@example.com"`
`git config --global user.name "Your Name"`

Clone repository:
`git clone <repo-url>`

Check status:
`git status`

Create and switch branch:
`git checkout -b branch_name`

Switch branch:
`git checkout master`

Pull latest changes:
`git pull`

Push changes:
`git push`

View history:
`history | grep git`

---

## Cloud Foundry & Platform Utilities

Get app GUID:
`cf app APP_NAME --guid`

Restage app:
`cf restage APP_NAME`

Restart app:
`cf restart APP_NAME`

Run a task:
`cf run-task APP_NAME "command" --name task_name`

---

## BOSH – Environment & VM Access

List deployments:
`bosh deployments`

List VMs:
`bosh vms`

SSH into a VM:
`bosh ssh <vm-name>`

Recent tasks:
`bosh tasks --recent`

Track a task:
`bosh task <task-id>`

Enable resurrection:
`bosh update-resurrection on`

---

## BOSH – Diagnostics

Check VM vitals:
`bosh vms --vitals`

Check disk CIDs:
`bosh -d <deployment> ssh <vm> -c "df -h"`

---

## Concourse (fly CLI)

List targets:
`fly targets`

Login to Concourse:
`fly -t <target> login`

List pipelines:
`fly -t <target> pipelines`

List builds:
`fly -t <target> builds`

Watch a job:
`fly -t <target> watch -j <pipeline/job>`

Trigger job:
`fly -t <target> trigger-job -j <pipeline/job>`

---

## Concourse – Resource Debugging

Check resource manually:
`fly -t <target> check-resource -r <pipeline/resource>`

---

## Paths & Logs (Common)

RabbitMQ logs:
`/var/vcap/sys/log/rabbitmq-server`

Check RabbitMQ users:
`cat /var/vcap/jobs/rabbitmq-server/etc/users`


---

## End

