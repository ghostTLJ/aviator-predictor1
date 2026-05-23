const express = require('express');
const router = express.Router();

router.get('/', (req, res) => {
  res.json({
    models: [
      { id: 'rf_classifier', name: 'Random Forest', accuracy: 0.82 },
      { id: 'linear_regression', name: 'Linear Regression', accuracy: 0.75 }
    ]
  });
});

module.exports = router;