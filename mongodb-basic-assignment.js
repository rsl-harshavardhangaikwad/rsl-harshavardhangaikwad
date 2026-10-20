
// ============================================================
// TASK 1: Local Setup and Data Creation
// ============================================================

// Step 1: Verify MongoDB
// mongosh
// show dbs

// Step 2: Select the Database
use("company");

// Step 3: Insert the Dataset
db.employees.insertMany([
  {
    _id: "EMP001",
    name: "John",
    department: "Engineering",
    experience: 4,
    skills: ["Java", "SpringBoot"],
    active: true,
    address: { city: "Pune", country: "India" }
  },
  {
    _id: "EMP002",
    name: "Alice",
    department: "HR",
    experience: 3,
    skills: ["Recruitment", "Communication"],
    active: true,
    address: { city: "Mumbai", country: "India" }
  },
  {
    _id: "EMP003",
    name: "David",
    department: "Engineering",
    experience: 6,
    skills: ["Java", "MongoDB"],
    active: true,
    address: { city: "Bengaluru", country: "India" }
  },
  {
    _id: "EMP004",
    name: "Emma",
    department: "Finance",
    experience: 2,
    skills: ["Accounting", "Excel"],
    active: false,
    address: { city: "Pune", country: "India" }
  },
  {
    _id: "EMP005",
    name: "Robert",
    department: "Engineering",
    experience: 5,
    skills: ["Java", "Docker"],
    active: true,
    address: { city: "Delhi", country: "India" }
  }
]);

// Verify
db.employees.countDocuments(); // Expected: 5

// ============================================================
// TASK 2: Read and Query Operations
// ============================================================

// 2.1 Engineering Employees — sorted by name asc
db.employees.find(
  { department: "Engineering" },
  { _id: 1, name: 1, experience: 1 }
).sort({ name: 1 });

// 2.2 Experience >= 5 — exclude _id, sort by experience desc
db.employees.find(
  { experience: { $gte: 5 } },
  { _id: 0, name: 1, experience: 1 }
).sort({ experience: -1 });

// 2.3 Nested Document Query — city is Pune, sorted by name
db.employees.find(
  { "address.city": "Pune" },
  { _id: 0, name: 1, "address.city": 1 }
).sort({ name: 1 });

// 2.4 Array Query — skills contain MongoDB or SpringBoot
db.employees.find(
  { skills: { $in: ["MongoDB", "SpringBoot"] } },
  { _id: 0, name: 1 }
).sort({ name: 1 });

// 2.5 Top 2 employees by highest experience
db.employees.find(
  {},
  { _id: 0, name: 1, experience: 1 }
).sort({ experience: -1 }).limit(2);

// ============================================================
// TASK 3: Update Operations
// ============================================================

// 3.1 $inc — Increase Alice's experience by 1
db.employees.updateOne(
  { name: "Alice" },
  { $inc: { experience: 1 } }
);
// Verify: Alice experience should be 4
db.employees.findOne({ name: "Alice" }, { name: 1, experience: 1 });

// 3.2 $set — Set Emma's active to true
db.employees.updateOne(
  { name: "Emma" },
  { $set: { active: true } }
);
// Verify
db.employees.findOne({ name: "Emma" }, { name: 1, active: 1 });

// 3.3 $addToSet — Add MongoDB to Robert's skills
db.employees.updateOne(
  { name: "Robert" },
  { $addToSet: { skills: "MongoDB" } }
);
// Run again to verify no duplicate
db.employees.updateOne(
  { name: "Robert" },
  { $addToSet: { skills: "MongoDB" } }
);
// Verify — should contain Java, Docker, MongoDB (no duplicate)
db.employees.findOne({ name: "Robert" }, { name: 1, skills: 1 });

// ============================================================
// TASK 4: Delete Operation
// ============================================================

// Insert temporary document
db.employees.insertOne({
  _id: "EMP999",
  name: "Temporary Employee",
  department: "Training",
  experience: 0
});

// Delete it
db.employees.deleteOne({ _id: "EMP999" });

// Verify deleted — should return null
db.employees.findOne({ _id: "EMP999" });

// Verify original 5 remain
db.employees.countDocuments(); // Expected: 5

// ============================================================
// TASK 5: Indexing
// ============================================================

// 5.1 Check existing indexes (only _id_ should exist)
db.employees.getIndexes();

// 5.2 Create ascending index on department
db.employees.createIndex({ department: 1 });

// 5.3 Verify — should show _id_ and department_1
db.employees.getIndexes();

// ============================================================
// TASK 6: Aggregation
// ============================================================

// 6.1 Employees per department — sorted by department name
db.employees.aggregate([
  { $group: { _id: "$department", count: { $sum: 1 } } },
  { $sort: { _id: 1 } }
]);
// Expected: Engineering->3, Finance->1, HR->1

// 6.2 Average experience per department — sorted by department name
db.employees.aggregate([
  { $group: { _id: "$department", avgExperience: { $avg: "$experience" } } },
  { $sort: { _id: 1 } }
]);
// Expected: Engineering->5, Finance->2, HR->4

// 6.3 Top 2 Engineering Employees by experience
db.employees.aggregate([
  { $match: { department: "Engineering" } },
  { $project: { _id: 0, name: 1, experience: 1 } },
  { $sort: { experience: -1 } },
  { $limit: 2 }
]);
// Expected: David->6, Robert->5
