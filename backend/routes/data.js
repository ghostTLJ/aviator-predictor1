const express = require('express');
const router = express.Router();

router.get('/rounds', (req, res) => {
  res.json({ rounds: [], total: 0 });
});

router.post('/train', (req, res) => {
  res.json({ status: 'Training started', jobId: 'job_' + Date.now() });
});

module.exports = router;