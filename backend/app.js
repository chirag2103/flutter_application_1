import dotenv from 'dotenv';
import express, { json } from 'express';
import mongoose from 'mongoose';
import { connectDB } from './config/db.js';
import cors from 'cors';
import morgan from 'morgan';

import userRoutes from './routes/user.js';
import serviceRoutes from './routes/service.js';
import orderRoutes from './routes/order.js';
import paymentRoutes from './routes/payment.js';
import messageRoutes from './routes/message.js';
import dealerRateRoutes from './routes/dealerRate.js';
const app = express();

// Middleware
app.use(cors());
app.use(morgan('dev'));
app.use(json());

dotenv.config({ path: './config/config.env' });

// MongoDB connection
connectDB();

// Register user routes
app.use('/api/users', userRoutes);
app.use('/api/services', serviceRoutes);
app.use('/api/orders', orderRoutes);
app.use('/api/payments', paymentRoutes);
app.use('/api/messages', messageRoutes);
app.use('/api/dealer-rates', dealerRateRoutes);

// Basic health check route
app.get('/', (req, res) => {
  res.json({ message: 'Construction Management Backend is running' });
});

// Centralized error handling middleware
app.use((err, req, res, next) => {
  console.error(err.stack);
  res
    .status(err.status || 500)
    .json({ error: err.message || 'Internal Server Error' });
});

// Start server
const PORT = process.env.PORT || 5000;
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
