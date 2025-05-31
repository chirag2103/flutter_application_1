import express from 'express';
const router = express.Router();
import * as userController from '../controllers/userController.js';
import auth from '../middleware/auth.js';

// Public routes
router.post('/register', userController.register);
router.post('/login', userController.login);

// Protected route
router.get('/profile', auth, userController.getProfile);

export default router;
