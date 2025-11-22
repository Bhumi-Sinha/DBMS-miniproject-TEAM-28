const jwt = require('jsonwebtoken');
const secret = process.env.JWT_SECRET;

exports.authMiddleware = (role) => {
  return (req, res, next) => {
    const auth = req.headers.authorization;
    if (!auth) return res.status(401).json({ error: 'Missing token' });
    const token = auth.split(' ')[1];
    try {
      const decoded = jwt.verify(token, secret);
      if (role && decoded.role !== role) return res.status(403).json({ error: 'Forbidden' });
      req.user = decoded;
      next();
    } catch (err) {
      return res.status(401).json({ error: 'Invalid or expired token' });
    }
  };
};
