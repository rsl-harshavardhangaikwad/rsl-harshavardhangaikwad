// ============================================================
// MongoDB Advanced Assignment — Tasks 1 to 5
// Database: company_advanced
// ============================================================

// ============================================================
// TASK 1: Schema Validation and Data Creation
// ============================================================

use("company_advanced");

// Drop collection for a fresh start
db.employees.drop();

// Create employees collection with $jsonSchema validation
db.createCollection("employees", {
  validator: {
    $jsonSchema: {
      bsonType: "object",
      required: ["name", "departmentId", "experience", "active"],
      properties: {
        name: {
          bsonType: "string",
          description: "name must be a string and is required"
        },
        departmentId: {
          bsonType: "int",
          description: "departmentId must be an integer and is required"
        },
        experience: {
          bsonType: "int",
          description: "experience must be an integer and is required"
        },
        active: {
          bsonType: "bool",
          description: "active must be a boolean and is required"
        }
      }
    }
  },
  validationLevel: "strict",
  validationAction: "error"
});

// Insert 3 valid employee documents
db.employees.insertMany([
  {
    _id: 1,
    name: "John",
    departmentId: 10,
    skills: ["Java", "MongoDB"],
    experience: 4,
    active: true,
    certifications: [
      { name: "MongoDB", status: "Expired", expiryYear: 2026 }
    ]
  },
  {
    _id: 2,
    name: "Alice",
    departmentId: 10,
    skills: ["Python", "MongoDB"],
    experience: 6,
    active: true,
    certifications: [
      { name: "MongoDB", status: "Active", expiryYear: 2028 }
    ]
  },
  {
    _id: 3,
    name: "David",
    departmentId: 20,
    skills: ["Communication"],
    experience: 3,
    active: false,
    certifications: [
      { name: "Communication", status: "Active", expiryYear: 2027 }
    ]
  }
]);

// Test validation — must be rejected
try {
  db.employees.insertOne({
    _id: 99,
    name: 123,
    departmentId: "HR",
    experience: "one",
    active: "yes"
  });
} catch (e) {
  print("Invalid document rejected: " + e.message);
}

// Verify: count must be 3
db.employees.countDocuments();


// ============================================================
// TASK 2: Advanced Array Queries and Updates
// ============================================================

// 2.1 Find employees with MongoDB certification status Active
db.employees.find({
  certifications: {
    $elemMatch: { name: "MongoDB", status: "Active" }
  }
});

// 2.2 Update John's MongoDB certification from Expired to Active
db.employees.updateOne(
  { name: "John", "certifications.name": "MongoDB" },
  { $set: { "certifications.$.status": "Active" } }
);

// 2.3 Set status to "Renewal Due" where expiryYear < 2027
db.employees.updateMany(
  {},
  { $set: { "certifications.$[cert].status": "Renewal Due" } },
  { arrayFilters: [ { "cert.expiryYear": { $lt: 2027 } } ] }
);

// Verify final certifications for John and Alice
db.employees.find(
  { name: { $in: ["John", "Alice"] } },
  { name: 1, certifications: 1, _id: 0 }
);


// ============================================================
// TASK 3: Bulk Write Operations
// ============================================================

db.employees.bulkWrite([
  // 1. Increase John's experience by 1
  {
    updateOne: {
      filter: { name: "John" },
      update: { $inc: { experience: 1 } }
    }
  },
  // 2. Set Alice's active to false
  {
    updateOne: {
      filter: { name: "Alice" },
      update: { $set: { active: false } }
    }
  },
  // 3. Insert Emma
  {
    insertOne: {
      document: {
        _id: 4,
        name: "Emma",
        departmentId: 20,
        skills: ["Excel"],
        experience: 2,
        active: true,
        certifications: [
          { name: "Excel", status: "Active", expiryYear: 2026 }
        ]
      }
    }
  }
]);

// Verify: John.experience=5, Alice.active=false, total docs=4
db.employees.find({ name: { $in: ["John", "Alice", "Emma"] } }, { name: 1, experience: 1, active: 1, _id: 0 });
db.employees.countDocuments();


// ============================================================
// TASK 4: Advanced Aggregation
// ============================================================

// Create departments collection
db.departments.drop();
db.departments.insertMany([
  { _id: 10, name: "Engineering" },
  { _id: 20, name: "HR" }
]);

// 4.1 Join employees with departments using $lookup and $unwind
db.employees.aggregate([
  {
    $lookup: {
      from: "departments",
      localField: "departmentId",
      foreignField: "_id",
      as: "departmentInfo"
    }
  },
  { $unwind: "$departmentInfo" },
  {
    $project: {
      _id: 0,
      name: 1,
      departmentName: "$departmentInfo.name"
    }
  },
  { $sort: { name: 1 } }
]);

// 4.2 Count employees per skill
db.employees.aggregate([
  { $unwind: "$skills" },
  {
    $group: {
      _id: "$skills",
      employeeCount: { $sum: 1 }
    }
  },
  { $sort: { employeeCount: -1, _id: 1 } }
]);

// 4.3 Active employee names and total count using $facet
db.employees.aggregate([
  {
    $facet: {
      activeEmployeeNames: [
        { $match: { active: true } },
        { $sort: { name: 1 } },
        { $project: { _id: 0, name: 1 } }
      ],
      totalActiveCount: [
        { $match: { active: true } },
        { $count: "count" }
      ]
    }
  }
]);


// ============================================================
// TASK 5: Indexing and Query Performance
// ============================================================

// 5.1 Create compound index on departmentId + name
db.employees.createIndex({ departmentId: 1, name: 1 });

// Verify indexes
db.employees.getIndexes();

// 5.2 explain("executionStats") for departmentId:10 sorted by name
db.employees.find({ departmentId: 10 }).sort({ name: 1 }).explain("executionStats");

// 5.3 Create sessions collection and TTL index
db.sessions.drop();
db.sessions.insertOne({
  _id: 1,
  userName: "John",
  expiresAt: new Date(Date.now() + 600000)
});

db.sessions.createIndex(
  { expiresAt: 1 },
  { expireAfterSeconds: 0 }
);

// Verify TTL index
db.sessions.getIndexes();
