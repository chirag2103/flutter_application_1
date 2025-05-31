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

export const updateDealerRate = async (req, res, next) => {
  try {
    const { error } = dealerRateSchema.validate(req.body);
    if (error) return res.status(400).json({ error: error.details[0].message });

    const dealerRate = await DealerRate.findByIdAndUpdate(
      req.params.id,
      req.body,
      { new: true }
    );
    if (!dealerRate)
      return res.status(404).json({ error: 'Dealer rate not found' });
    res.json(dealerRate);
  } catch (err) {
    next(err);
  }
};

export const getDealerRates = async (req, res, next) => {
  try {
    const dealerRates = await DealerRate.find()
      .populate('dealer', 'name email')
      .populate('service', 'name category price');
    res.json(dealerRates);
  } catch (err) {
    next(err);
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

export const deleteDealerRate = async (req, res, next) => {
  try {
    const dealerRate = await DealerRate.findByIdAndDelete(req.params.id);
    if (!dealerRate)
      return res.status(404).json({ error: 'Dealer rate not found' });
    res.json({ message: 'Dealer rate deleted' });
  } catch (err) {
    next(err);
  }
};
