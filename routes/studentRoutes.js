const express = require('express');
const jwt = require('jsonwebtoken');
const router = express.Router();

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

// Vacancies list
router.get('/vacancies', authMiddleware('student'), async (req, res) => {
  const pool = req.app.locals.pool;
  try {
    const [rows] = await pool.query(`
      SELECT j.Job_ID, j.Title, j.no_of_positions,
        COALESCE(SUM(CASE WHEN a.Appln_status <> 'Rejected' THEN 1 ELSE 0 END),0) as enrolled,
        (j.no_of_positions - COALESCE(SUM(CASE WHEN a.Appln_status <> 'Rejected' THEN 1 ELSE 0 END),0)) as positions_left
      FROM Job j
      LEFT JOIN Application a ON j.Job_ID = a.Job_ID
      GROUP BY j.Job_ID
      ORDER BY j.date_posted DESC
    `);
    res.json({ vacancies: rows });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Apply to job
router.post('/apply', authMiddleware('student'), async (req, res) => {
  const pool = req.app.locals.pool;
  try {
    const { job_id, appln_date, resume_link } = req.body;
    if (!job_id) return res.status(400).json({ error: 'Missing job_id' });
    const [max] = await pool.query('SELECT IFNULL(MAX(Appln_ID),0) as mx FROM Application');
    const nextId = (max[0].mx || 0) + 1;
    await pool.query(
      'INSERT INTO Application (Appln_ID, Appln_date, Appln_status, Resume_link, Student_SRN, Job_ID, Company_ID, Admin_ID) VALUES (?,?,?,?,?,?,?,?)',
      [nextId, appln_date || new Date(), 'Pending', resume_link || null, req.user.ref_id, job_id, null, null]
    );
    res.json({ ok: true, message: 'Application submitted successfully' });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

module.exports = router;
