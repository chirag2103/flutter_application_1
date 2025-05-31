import Message from '../models/Message.js';
import Joi from 'joi';

const messageSchema = Joi.object({
  sender: Joi.string().required(),
  receiver: Joi.string().required(),
  content: Joi.string().required(),
  timestamp: Joi.date().optional(),
});

export const sendMessage = async (req, res, next) => {
  try {
    const { error } = messageSchema.validate(req.body);
    if (error) return res.status(400).json({ error: error.details[0].message });

    const message = new Message(req.body);
    await message.save();
    res.status(201).json(message);
  } catch (err) {
    next(err);
  }
};

export const updateMessage = async (req, res, next) => {
  try {
    const { error } = messageSchema.validate(req.body);
    if (error) return res.status(400).json({ error: error.details[0].message });

    const message = await Message.findByIdAndUpdate(req.params.id, req.body, {
      new: true,
    });
    if (!message) return res.status(404).json({ error: 'Message not found' });
    res.json(message);
  } catch (err) {
    next(err);
  }
};

export const getMessages = async (req, res, next) => {
  try {
    const messages = await Message.find()
      .populate('sender', 'name email')
      .populate('receiver', 'name email');
    res.json(messages);
  } catch (err) {
    next(err);
  }
};

export const getMessageById = async (req, res, next) => {
  try {
    const message = await Message.findById(req.params.id)
      .populate('sender', 'name email')
      .populate('receiver', 'name email');
    if (!message) return res.status(404).json({ error: 'Message not found' });
    res.json(message);
  } catch (err) {
    next(err);
  }
};

export const deleteMessage = async (req, res, next) => {
  try {
    const message = await Message.findByIdAndDelete(req.params.id);
    if (!message) return res.status(404).json({ error: 'Message not found' });
    res.json({ message: 'Message deleted' });
  } catch (err) {
    next(err);
  }
};
