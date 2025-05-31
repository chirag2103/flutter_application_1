import express from 'express';
const router = express.Router();
import * as serviceController from '../controllers/serviceController.js';
import auth from '../middleware/auth.js';

// Protected routes for service management
router.post('/', auth, serviceController.addService);
router.put('/:id', auth, serviceController.updateService);
router.delete('/:id', auth, serviceController.deleteService);
router.get('/', auth, serviceController.getServices);
router.get('/:id', auth, serviceController.getServiceById);

export default router;
