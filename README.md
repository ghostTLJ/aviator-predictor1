# Aviator Predictor for Spin City

A real-time machine learning-based crash multiplier predictor for Spin City's Aviator game. This application uses statistical analysis and ML models to predict crash multipliers before rounds start.

## Features

- 🤖 **Machine Learning Models**: Random Forest & Linear Regression for crash prediction
- 📊 **Statistical Analysis**: Pattern recognition and trend analysis
- 🔄 **Real-time API Integration**: Live connection to Spin City API via WebSockets
- 📱 **React Frontend**: Interactive UI with real-time predictions and visualization
- 🔌 **RESTful Backend**: Node.js/Express with Python ML services
- 📈 **Data Persistence**: Historical data storage and analysis
- 🎯 **Accuracy Tracking**: Monitor prediction performance metrics

## Quick Start

### Prerequisites
- Node.js 14+
- Python 3.8+
- Docker & Docker Compose (recommended)

### Option 1: Docker (Recommended)

```bash
git clone https://github.com/tanatswajiri0-arch/aviator-predictor1.git
cd aviator-predictor1
cp .env.example .env
docker-compose up -d
```

Access:
- Frontend: http://localhost:3000
- Backend: http://localhost:5000
- ML Service: http://localhost:5001

### Option 2: Local Development

```bash
# Backend
cd backend && npm install && npm start

# ML Service (new terminal)
cd ml-service && pip install -r requirements.txt && python app.py

# Frontend (new terminal)
cd frontend && npm install && npm start
```

## Project Structure

```
├── backend/              # Node.js/Express API
├── ml-service/           # Python ML microservice
├── frontend/             # React application
├── docker-compose.yml    # Docker orchestration
└── .env.example          # Environment template
```

## License

MIT License - See LICENSE file

⚠️ **Disclaimer**: This is a prediction tool for research/entertainment only. No guarantees on outcomes.