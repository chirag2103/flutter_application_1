import express from 'express';
const router = express.Router();
import * as dealerRateController from '../controllers/dealerRateController.js';
import auth from '../middleware/auth.js';

// Protected routes for dealer rate management
router.post('/', auth, dealerRateController.createDealerRate);
router.put('/:id', auth, dealerRateController.updateDealerRate);
router.delete('/:id', auth, dealerRateController.deleteDealerRate);
router.get('/', auth, dealerRateController.getDealerRates);
router.get('/:id', auth, dealerRateController.getDealerRateById);

export default router;
