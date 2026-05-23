import React from 'react';
import { Link } from 'react-router-dom';

function Navbar({ isConnected }) {
  return (
    <nav className="navbar bg-gray-900 text-white p-4">
      <div className="container mx-auto flex justify-between items-center">
        <Link to="/" className="text-2xl font-bold">🎯 Aviator Predictor</Link>
        <div className="flex items-center gap-2">
          <div className={`w-3 h-3 rounded-full ${isConnected ? 'bg-green-500' : 'bg-red-500'}`}></div>
          <span>{isConnected ? 'Connected' : 'Disconnected'}</span>
        </div>
      </div>
    </nav>
  );
}

export default Navbar;