# Splunk SPL Query Notes

A reference collection of Splunk Processing Language (SPL) queries covering the `search` command, the `where` command, and the `eval` command

---

## 1. Search Command Basics

The `search` command is used for filtering events at index time — keyword matching, field filtering, time ranges, and comparisons.

| Purpose | Query |
|---|---|
| Basic keyword search | `index=BotsV3 "error"` |
| Field filtering | `index=BotsV3 Source_IP="10.0.0.1"` |
| Time-range filtering | `index=BotsV3 event_code=4625 earliest=-15y latest=-5y` |
| Event type filtering | `index=BotsV3 eventtype=cpu` |
| Overarching field filter | `index=BotsV3 eventtype=cpu cpu` |
| Wildcard searching | `index=BotsV3 user="*admin*"` |
| Comparison operator (greater than) | `index=BotsV3 bytes > 1000000` |
| Multiple values with `IN` | `index=BotsV3 event_code IN(4624, 4625, 4634)` |
| Negation with `NOT IN` | `index=BotsV3 NOT event_code IN(...)` |
| URI path filtering | `index=BotsV3 sourcetype=stream:http URI_path="admin*"` |
| Protocol / service filtering | `index=BotsV3 protocol=TCP` |
| User agent search | `index=BotsV3 user_agent="*Googlebot*"` |

---

## 2. `search` vs `where`

`search` filters raw events (fast, index-aware). `where` filters on computed/evaluated fields (works on results already in the pipeline, supports expressions).

### `search` command examples

```spl
index=bots3 user=admin
index=bots3 action="failed login"
index=bots3 status=200 user=guest
```

### `where` command examples

```spl
# Numeric comparison on a derived field
| eval response_time_seconds = response_time/1000
| where response_time_seconds > 2

# Range filtering
| where bytes > 1000 AND bytes < 5000

# Time-based filtering (business hours)
| where strftime(_time, "%H") >= 9 AND strftime(_time, "%H") <= 15

# Null checks
| where isnotnull(user)
| where isnull(user)

# Wildcard usage (SQL-style LIKE)
| where like(signature, "%crypto%")

# Complex logic (combining conditions)
| where like(signature, "%crypto%") AND severity="high"
```

**Key takeaway:** use `search` for simple, indexed field/keyword filtering; switch to `where` when you need computed comparisons, null checks, or `LIKE`-style pattern matching after an `eval`.

---

## 3. `eval` Command Cookbook

The `eval` command creates or transforms fields. Below are common patterns, each paired with its query.

### Conditional labeling with `if`

```spl
index=botsv3 
| eval byte_category=if(bytes>1000000, "high", "low") 
| table bytes, byte_category
```

### Unit conversion (math on fields)

```spl
index=botsv3 
| eval response_time_sec=response_time/1000 
| table response_time, response_time_sec
```

### Boolean-style conversion

```spl
index=botsv3 
| eval login_status=if(status=="success", 1, 0) 
| table status, login_status
```

### String concatenation

```spl
index=botsv3 
| eval connection=source_ip.":".dest_ip 
| table source_ip, dest_ip, connection
```

### Multi-condition classification with `case`

```spl
index=botsv3 
| eval status_category=case(
    status>=200 AND status<300, "success", 
    status>=400 AND status<500, "client_error", 
    status>=500, "server_error", 
    1=1, "other"
  ) 
| table status, status_category
```

### Rate / average calculation

```spl
index=botsv3 
| eval bytes_per_second=bytes/duration 
| table bytes, duration, bytes_per_second
```

### Field splitting (extract domain from email)

```spl
index=botsv3 
| eval domain=mvindex(split(email, "@"), 1) 
| table email, domain
```

### Time formatting (extract day of week)

```spl
index=botsv3 
| eval day_of_week=strftime(_time, "%A") 
| table _time, day_of_week
```

### Flagging suspicious values

```spl
index=botsv3 
| eval suspicious_user_agent=case(
    user_agent LIKE "%Googlebot%", "yes", 
    1=1, "no"
  ) 
| table user_agent, suspicious_user_agent
```

### Case normalization

```spl
index=botsv3 
| eval lower_user_agent=lower(user_agent) 
| table user_agent, lower_user_agent
```

---

## Quick Reference: Common Functions Used

| Function | Purpose |
|---|---|
| `if(condition, true_val, false_val)` | Simple two-branch conditional |
| `case(cond1, val1, cond2, val2, ..., 1=1, default)` | Multi-branch conditional |
| `isnull(field)` / `isnotnull(field)` | Null checks |
| `like(field, "%pattern%")` | SQL-style wildcard match (`%` = wildcard) |
| `strftime(_time, "%H")` / `"%A"` | Format epoch time into hour / weekday, etc. |
| `split(field, "delim")` | Split string into a multivalue field |
| `mvindex(mv_field, n)` | Get nth element from a multivalue field |
| `lower(field)` | Lowercase a string field |
| `.` (dot operator) | String concatenation in `eval` |

---

*Notes compiled from a Splunk SPL tutorial using the BOTS v3 dataset. Timestamps from the original source were dropped for readability; reorganize by topic (Search Basics → Search vs Where → Eval Cookbook) for easier reference.*
