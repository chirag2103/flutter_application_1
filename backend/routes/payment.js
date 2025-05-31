import express from 'express';
const router = express.Router();
import * as paymentController from '../controllers/paymentController.js';
import auth from '../middleware/auth.js';

// Protected routes for payment management
router.post('/', auth, paymentController.createPayment);
router.put('/:id', auth, paymentController.updatePaymentStatus);
router.get('/', auth, paymentController.getPayments);
router.get('/:id', auth, paymentController.getPaymentById);

export default router;
