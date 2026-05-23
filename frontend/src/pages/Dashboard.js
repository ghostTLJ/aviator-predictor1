import React, { useState, useEffect } from 'react';
import axios from 'axios';

function Dashboard({ socket }) {
  const [prediction, setPrediction] = useState(null);
  const [stats, setStats] = useState({ accuracy: 0, total: 0 });

  useEffect(() => {
    const fetchData = async () => {
      try {
        const pred = await axios.post(`${process.env.REACT_APP_API_URL}/api/predictions`);
        const acc = await axios.get(`${process.env.REACT_APP_API_URL}/api/predictions/accuracy`);
        setPrediction(pred.data.prediction);
        setStats(acc.data);
      } catch (error) {
        console.error('Error fetching data:', error);
      }
    };
    fetchData();
  }, []);

  return (
    <div className="p-8 max-w-4xl mx-auto">
      <h1 className="text-4xl font-bold mb-8">Dashboard</h1>
      
      <div className="grid grid-cols-3 gap-6 mb-8">
        <div className="bg-white p-6 rounded shadow">
          <h3 className="text-gray-600 mb-2">Accuracy</h3>
          <p className="text-3xl font-bold text-green-500">{(stats.accuracy * 100).toFixed(1)}%</p>
        </div>
        <div className="bg-white p-6 rounded shadow">
          <h3 className="text-gray-600 mb-2">Total Predictions</h3>
          <p className="text-3xl font-bold text-blue-500">{stats.total}</p>
        </div>
        <div className="bg-white p-6 rounded shadow">
          <h3 className="text-gray-600 mb-2">Status</h3>
          <p className="text-3xl font-bold text-yellow-500">Ready</p>
        </div>
      </div>

      {prediction && (
        <div className="bg-white p-8 rounded shadow">
          <h2 className="text-2xl font-bold mb-4">Current Prediction</h2>
          <p className="text-lg">ML Prediction: <span className="font-bold text-green-500">{prediction.ml_prediction?.toFixed(2)}x</span></p>
          <p className="text-lg mt-2">Confidence: <span className="font-bold">{(prediction.confidence * 100).toFixed(1)}%</span></p>
        </div>
      )}
    </div>
  );
}

export default Dashboard;