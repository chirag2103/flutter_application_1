import express from 'express';
const router = express.Router();
import * as orderController from '../controllers/orderController.js';
import auth from '../middleware/auth.js';

// Protected routes for order management
router.post('/', auth, orderController.createOrder);
router.put('/:id', auth, orderController.updateOrder);
router.delete('/:id', auth, orderController.deleteOrder);
router.get('/', auth, orderController.getOrders);
router.get('/:id', auth, orderController.getOrderById);

export default router;
