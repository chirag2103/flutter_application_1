import express from 'express';
const router = express.Router();
import * as messageController from '../controllers/messageController.js';
import auth from '../middleware/auth.js';

// Protected routes for message management
router.post('/', auth, messageController.sendMessage);
router.get('/', auth, messageController.getMessages);
// router.put('/:id/read', auth, messageController.markAsRead);

export default router;
