# MongoDB Advanced Assignment — Answers

## Task 7: MCQ Answers

| Q   | Answer | Explanation |
|-----|--------|-------------|
| Q1  | **B**  | Schema validation rejects documents that do not follow required fields or data types. |
| Q2  | **B**  | `$elemMatch` ensures multiple conditions match the **same** array object. |
| Q3  | **C**  | `arrayFilters` updates **selected** array elements that match a condition. |
| Q4  | **A**  | `bulkWrite()` is useful when several write operations should be sent together in one call. |
| Q5  | **C**  | `$lookup` joins documents from another collection. |
| Q6  | **B**  | `IXSCAN` in `explain()` output indicates MongoDB used an index. |
| Q7  | **C**  | `abortTransaction()` rolls back all uncommitted transaction changes. |
| Q8  | **B**  | `w: "majority"` means a majority of voting data-bearing replica-set members acknowledge the write. |
| Q9  | **C**  | When a Primary fails, eligible members hold an election for a new Primary. |
| Q10 | **B**  | A high-cardinality field that distributes traffic and matches common queries is the best shard key. |
| Q11 | **A**  | Change Streams allow an application to listen for inserts, updates, replacements, and deletes. |
| Q12 | **C**  | Use TLS, restricted network access, and least-privilege credentials in production. |

---

## Task 5.2: explain("executionStats") Values

Query used:
```js
db.employees.find({ departmentId: 10 }).sort({ name: 1 }).explain("executionStats")
```

| Metric                | Value                                  |
|-----------------------|----------------------------------------|
| Winning Plan Stage    | **IXSCAN** (index: `departmentId_1_name_1`) |
| nReturned             | **2**                                  |
| totalDocsExamined     | **2**                                  |
| totalKeysExamined     | **2**                                  |

> **Note:** MongoDB used the compound index `departmentId_1_name_1` (IXSCAN).
> `totalDocsExamined = nReturned = 2` confirms the index is working efficiently with no extra scans.

---

## Task 6: Backup and Restore Verification

| Collection   | Original DB Count | Restored DB Count |
|-------------|-------------------|-------------------|
| employees   | 4                 | 4                 |
| departments | 2                 | 2                 |
| sessions    | 1                 | 1                 |

**Total restored:** 7 documents, 0 failures.
