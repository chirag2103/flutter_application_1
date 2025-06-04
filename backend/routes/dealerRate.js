import express from 'express';
import auth from '../middleware/auth.js';
import {
  addDealerRate,
  getDealerRates,
  updateDealerRate,
  deleteDealerRate,
  getNearbyDealerRates,
} from '../controllers/dealerRateController.js';

const router = express.Router();

// Protected routes for dealer rate management
router.post('/', auth, addDealerRate);
router.get('/', getDealerRates);
router.get('/nearby', getNearbyDealerRates);
router.put('/:id', auth, updateDealerRate);
router.delete('/:id', auth, deleteDealerRate);

export default router;
