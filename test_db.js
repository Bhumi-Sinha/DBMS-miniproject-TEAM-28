require('dotenv').config();
const mysql = require('mysql2/promise');

async function testConnection() {
  try {
    const pool = mysql.createPool({
      host: process.env.DB_HOST,
      user: process.env.DB_USER,
      password: process.env.DB_PASS,
      database: process.env.DB_NAME,
    });

    const [rows] = await pool.query('SHOW TABLES;');
    console.log('✅ Connected successfully! Tables:', rows);
    process.exit();
  } catch (err) {
    console.error('❌ Database connection failed:', err.message);
  }
}

testConnection();
