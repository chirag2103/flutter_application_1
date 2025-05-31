import Order from '../models/Order.js';
import Joi from 'joi';

const orderServiceSchema = Joi.object({
  service: Joi.string().required(),
  quantity: Joi.number().min(1).default(1),
});

const orderSchema = Joi.object({
  customer: Joi.string().required(),
  services: Joi.array().items(orderServiceSchema).min(1).required(),
  dealer: Joi.string().optional(),
  status: Joi.string()
    .valid('pending', 'confirmed', 'in_progress', 'completed', 'cancelled')
    .optional(),
  totalAmount: Joi.number().required(),
  paymentStatus: Joi.string().valid('pending', 'paid', 'failed').optional(),
});

export const createOrder = async (req, res, next) => {
  try {
    const { error } = orderSchema.validate(req.body);
    if (error) return res.status(400).json({ error: error.details[0].message });

    const order = new Order(req.body);
    await order.save();
    res.status(201).json(order);
  } catch (err) {
    next(err);
  }
};

export const updateOrder = async (req, res, next) => {
  try {
    const { error } = orderSchema.validate(req.body);
    if (error) return res.status(400).json({ error: error.details[0].message });

    const order = await Order.findByIdAndUpdate(req.params.id, req.body, {
      new: true,
    });
    if (!order) return res.status(404).json({ error: 'Order not found' });
    res.json(order);
  } catch (err) {
    next(err);
  }
};

export const getOrders = async (req, res, next) => {
  try {
    const orders = await Order.find()
      .populate('customer', 'name email')
      .populate('services.service', 'name category price')
      .populate('dealer', 'name email');
    res.json(orders);
  } catch (err) {
    next(err);
  }
};

export const getOrderById = async (req, res, next) => {
  try {
    const order = await Order.findById(req.params.id)
      .populate('customer', 'name email')
      .populate('services.service', 'name category price')
      .populate('dealer', 'name email');
    if (!order) return res.status(404).json({ error: 'Order not found' });
    res.json(order);
  } catch (err) {
    next(err);
  }
};

export const deleteOrder = async (req, res, next) => {
  try {
    const order = await Order.findByIdAndDelete(req.params.id);
    if (!order) return res.status(404).json({ error: 'Order not found' });
    res.json({ message: 'Order deleted' });
  } catch (err) {
    next(err);
  }
};
