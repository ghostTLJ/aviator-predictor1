const express = require('express');
const router = express.Router();

router.get('/', (req, res) => {
  res.json({ message: 'Fetching predictions' });
});

router.post('/', (req, res) => {
  res.json({
    prediction: {
      ml_prediction: 2.45,
      confidence: 0.78,
      timestamp: new Date()
    }
  });
});

router.get('/accuracy', (req, res) => {
  res.json({
    accuracy: 0.78,
    precision: 0.82,
    total_predictions: 1250,
    correct_predictions: 975
  });
});

module.exports = router;