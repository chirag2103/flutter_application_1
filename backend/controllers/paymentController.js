import Payment from '../models/Payment.js';
import Joi from 'joi';

const paymentSchema = Joi.object({
  order: Joi.string().required(),
  amount: Joi.number().required(),
  method: Joi.string().valid('cash_on_delivery', 'online').required(),
  status: Joi.string().valid('pending', 'completed', 'failed').optional(),
  transactionId: Joi.string().optional(),
});

export const createPayment = async (req, res, next) => {
  try {
    const { error } = paymentSchema.validate(req.body);
    if (error) return res.status(400).json({ error: error.details[0].message });

    const payment = new Payment(req.body);
    await payment.save();
    res.status(201).json(payment);
  } catch (err) {
    next(err);
  }
};

export const updatePaymentStatus = async (req, res, next) => {
  try {
    const { status, transactionId } = req.body;
    const payment = await Payment.findById(req.params.id);
    if (!payment) return res.status(404).json({ error: 'Payment not found' });

    if (status) payment.status = status;
    if (transactionId) payment.transactionId = transactionId;

    await payment.save();
    res.json(payment);
  } catch (err) {
    next(err);
  }
};

export const getPayments = async (req, res, next) => {
  try {
    const payments = await Payment.find().populate('order');
    res.json(payments);
  } catch (err) {
    next(err);
  }
};

export const getPaymentById = async (req, res, next) => {
  try {
    const payment = await Payment.findById(req.params.id).populate('order');
    if (!payment) return res.status(404).json({ error: 'Payment not found' });
    res.json(payment);
  } catch (err) {
    next(err);
  }
};
