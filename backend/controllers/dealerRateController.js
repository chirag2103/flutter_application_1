import DealerRate from '../models/DealerRate.js';
import Joi from 'joi';

const dealerRateSchema = Joi.object({
  dealer: Joi.string().required(),
  service: Joi.string().required(),
  rate: Joi.number().required(),
});

export const createDealerRate = async (req, res, next) => {
  try {
    const { error } = dealerRateSchema.validate(req.body);
    if (error) return res.status(400).json({ error: error.details[0].message });

    const dealerRate = new DealerRate(req.body);
    await dealerRate.save();
    res.status(201).json(dealerRate);
  } catch (err) {
    next(err);
  }
};

export const updateDealerRate = async (req, res) => {
  try {
    const dealerRate = await DealerRate.findById(req.params.id);
    if (!dealerRate) {
      return res.status(404).json({ message: 'Dealer rate not found' });
    }

    if (dealerRate.dealer.toString() !== req.user.id) {
      return res.status(403).json({ message: 'Not authorized' });
    }

    const updatedDealerRate = await DealerRate.findByIdAndUpdate(
      req.params.id,
      req.body,
      { new: true }
    );
    res.json(updatedDealerRate);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

export const getDealerRates = async (req, res) => {
  try {
    const dealerRates = await DealerRate.find()
      .populate('dealer', 'name email phone')
      .sort('-createdAt');
    res.json(dealerRates);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

export const getDealerRateById = async (req, res, next) => {
  try {
    const dealerRate = await DealerRate.findById(req.params.id)
      .populate('dealer', 'name email')
      .populate('service', 'name category price');
    if (!dealerRate)
      return res.status(404).json({ error: 'Dealer rate not found' });
    res.json(dealerRate);
  } catch (err) {
    next(err);
  }
};

export const deleteDealerRate = async (req, res) => {
  try {
    const dealerRate = await DealerRate.findById(req.params.id);
    if (!dealerRate) {
      return res.status(404).json({ message: 'Dealer rate not found' });
    }

    if (dealerRate.dealer.toString() !== req.user.id) {
      return res.status(403).json({ message: 'Not authorized' });
    }

    await dealerRate.remove();
    res.json({ message: 'Dealer rate removed' });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

export const addDealerRate = async (req, res) => {
  try {
    const { materialType, price, location, availability } = req.body;
    const dealerRate = new DealerRate({
      dealer: req.user.id,
      materialType,
      price,
      location,
      availability,
    });
    await dealerRate.save();
    res.status(201).json(dealerRate);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

export const getNearbyDealerRates = async (req, res) => {
  try {
    const { latitude, longitude, maxDistance = 10000 } = req.query;

    const dealerRates = await DealerRate.find({
      location: {
        $near: {
          $geometry: {
            type: 'Point',
            coordinates: [parseFloat(longitude), parseFloat(latitude)],
          },
          $maxDistance: parseInt(maxDistance),
        },
      },
    }).populate('dealer', 'name email phone');

    res.json(dealerRates);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};
