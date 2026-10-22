// ============================================================
// Task 1: Schema Validation and Data Creation
// Database: company_advanced
// ============================================================

// Step 1: Switch to fresh database
use("company_advanced");

// Step 2: Drop collection if it already exists (for fresh start)
db.employees.drop();

// Step 2: Create employees collection with $jsonSchema validation
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

print("✅ Collection 'employees' created with $jsonSchema validation.");

// Step 3: Insert the starting dataset (3 valid documents)
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

print("✅ 3 valid employee documents inserted successfully.");
print("📊 Current document count: " + db.employees.countDocuments());

// Step 4: Test validation - attempt to insert invalid document
print("\n🚫 Attempting to insert INVALID document (should be rejected)...");

try {
  db.employees.insertOne({
    _id: 99,
    name: 123,
    departmentId: "HR",
    experience: "one",
    active: "yes"
  });
  print("❌ ERROR: Invalid document was inserted (validation not working!)");
} catch (e) {
  print("✅ Invalid document correctly REJECTED by schema validation.");
  print("   Error: " + e.message);
}

// Final verification
print("\n📋 Final Verification:");
print("   Valid employee documents: " + db.employees.countDocuments());
print("   Invalid document: rejected by schema validation");
print("\n📄 All employee documents in the collection:");
db.employees.find().forEach(doc => printjson(doc));
