# Cloud Foundry

## BOSH Tasks – Clean Notes

### List Tasks

```bash
bosh tasks --recent
```
Lists the most recent 30 BOSH tasks.

```bash
bosh tasks -r=500
```
Lists the last 500 tasks. The number can be any value.

```bash
bosh tasks
```
Lists all currently running BOSH tasks.

---

### Task Details

```bash
bosh task <TASK_ID>
```
Shows the overview of a specific task.

```bash
bosh task <TASK_ID> --debug
```
Displays the specific task logs in debug mode.

```bash
bosh task <TASK_ID> --cpi
```
Used to track CPI logs (Cloud Provider Interface logs).

---

