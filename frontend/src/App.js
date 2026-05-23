import React, { useState, useEffect } from 'react';
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import io from 'socket.io-client';
import Navbar from './components/Navbar';
import Dashboard from './pages/Dashboard';
import './App.css';

function App() {
  const [socket, setSocket] = useState(null);
  const [isConnected, setIsConnected] = useState(false);

  useEffect(() => {
    const newSocket = io(process.env.REACT_APP_WS_URL || 'http://localhost:5000');
    newSocket.on('connect', () => setIsConnected(true));
    newSocket.on('disconnect', () => setIsConnected(false));
    setSocket(newSocket);
    return () => newSocket.close();
  }, []);

  return (
    <Router>
      <div className="App">
        <Navbar isConnected={isConnected} />
        <Routes>
          <Route path="/" element={<Dashboard socket={socket} />} />
        </Routes>
      </div>
    </Router>
  );
}

export default App;