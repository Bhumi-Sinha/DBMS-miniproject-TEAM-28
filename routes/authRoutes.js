const express = require('express');
const jwt = require('jsonwebtoken');
const bcrypt = require('bcrypt');
const router = express.Router();

const jwtSecret = process.env.JWT_SECRET || 'verysecret';

// Temporary in-memory users list
const users = [
  { username: 'admin1', password: 'adminpass', role: 'admin', ref_id: 1 },
  { username: 'PES2UG22CS001', password: 'studentpass', role: 'student', ref_id: 'PES2UG22CS001' }
];

// Generate JWT token
function generateToken(user) {
  return jwt.sign(
    { username: user.username, role: user.role, ref_id: user.ref_id },
    jwtSecret,
    { expiresIn: '8h' }
  );
}

// -----------------------------
// SIGNUP
// -----------------------------
router.post('/signup', async (req, res) => {
  try {
    const { username, password, role, ref_id } = req.body;
    if (!username || !password || !role)
      return res.status(400).json({ error: 'Missing fields' });

    const existing = users.find(u => u.username === username);
    if (existing)
      return res.status(400).json({ error: 'User already exists' });

    const hashed = await bcrypt.hash(password, 10);
    const newUser = { username, password: hashed, role, ref_id };
    users.push(newUser);

    const token = generateToken(newUser);
    res.json({ token, user: newUser });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Server error' });
  }
});

// -----------------------------
// LOGIN
// -----------------------------
router.post('/login', async (req, res) => {
  try {
    const { username, password } = req.body;
    const user = users.find(u => u.username === username);
    if (!user)
      return res.status(400).json({ error: 'User not found' });

    const passwordMatch = await bcrypt.compare(password, user.password).catch(() => false);
    const plainMatch = password === user.password;

    if (!passwordMatch && !plainMatch)
      return res.status(400).json({ error: 'Invalid credentials' });

    const token = generateToken(user);
    res.json({ token, user });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Server error' });
  }
});

module.exports = router;
