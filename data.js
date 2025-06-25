const fs = require("fs");
const { faker } = require("@faker-js/faker");
const bcrypt = require("bcryptjs");

async function generateUsers(count = 1000) {
  const users = [];
  const hashedPassword = await bcrypt.hash("123456", 10);
  const timestamp = new Date("2025-06-13T10:48:40.437Z");
  const pic = "https://icon-library.com/images/anonymous-avatar-icon/anonymous-avatar-icon-25.jpg";

  for (let i = 0; i < count; i++) {
    users.push({
     _id: faker.string.uuid().replace(/-/g, "").slice(0, 24), // mimic ObjectId
      name: faker.person.fullName().toUpperCase(),
      email: faker.internet.email(),
      password: hashedPassword,
      pic,
      createdAt: timestamp,
      updatedAt: timestamp,
      __v: 0
    });
  }

  fs.writeFileSync("detailed_sample_users.json", JSON.stringify(users, null, 2));
  console.log("✅ File saved: detailed_sample_users.json");
}

generateUsers();
