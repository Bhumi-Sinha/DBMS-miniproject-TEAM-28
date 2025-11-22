const express = require('express');
const router = express.Router();
const jwt = require('jsonwebtoken');

// Middleware to verify token
function authMiddleware(role) {
  const secret = process.env.JWT_SECRET || 'verysecret';
  return (req, res, next) => {
    const auth = req.headers.authorization;
    if (!auth) return res.status(401).json({ error: 'No token' });
    const token = auth.split(' ')[1];
    try {
      const data = jwt.verify(token, secret);
      if (role && data.role !== role) return res.status(403).json({ error: 'Forbidden' });
      req.user = data;
      next();
    } catch {
      res.status(401).json({ error: 'Invalid token' });
    }
  };
}

// Add student (via stored procedure)
router.post('/add-student', authMiddleware('admin'), async (req, res) => {
  const pool = req.app.locals.pool;
  try {
    const p = req.body;
    const sql = `CALL AddStudent(?,?,?,?,?,?,?,?,?,?,?,?)`;
    const params = [
      p.SRN, p.First_name, p.Middle_name || null, p.Last_name || null, p.DOB || null,
      p.Batch_year || null, p.CGPA || null, p.Email || null, p.Phone_no || null, p.Branch || null,
      req.user.ref_id || null, p.Resume_link || null
    ];
    await pool.query(sql, params);
    res.json({ ok: true, message: 'Student added successfully' });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: err.message });
  }
});

// Update vacancy
router.post('/update-vacancy', authMiddleware('admin'), async (req, res) => {
  const pool = req.app.locals.pool;
  try {
    const { job_id, new_positions } = req.body;
    if (!job_id || new_positions == null) return res.status(400).json({ error: 'Missing fields' });
    await pool.query('UPDATE Job SET no_of_positions = ? WHERE Job_ID = ?', [new_positions, job_id]);
    res.json({ ok: true, message: 'Vacancy updated' });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Jobs overview
router.get('/jobs-overview', authMiddleware('admin'), async (req, res) => {
  const pool = req.app.locals.pool;
  try {
    const [jobs] = await pool.query(`
      SELECT j.Job_ID, j.Title, j.no_of_positions,
      COALESCE(COUNT(a.Student_SRN),0) as enrolled
      FROM Job j
      LEFT JOIN Application a ON j.Job_ID = a.Job_ID AND a.Appln_status <> 'Rejected'
      GROUP BY j.Job_ID
    `);
    res.json({ jobs });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Eligible students
router.get('/eligible/:jobId', authMiddleware('admin'), async (req, res) => {
  const pool = req.app.locals.pool;
  try {
    const [rows] = await pool.query('CALL GetEligibleStudentsForJob(?)', [req.params.jobId]);
    res.json({ eligible: rows[0] || rows });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

module.exports = router;
