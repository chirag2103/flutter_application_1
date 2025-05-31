import Service from '../models/Service.js';
import Joi from 'joi';
// const { uploadFile, deleteFile } = require('../utils/firebaseStorage.js');
import path from 'path';
import fs from 'fs';

const serviceSchema = Joi.object({
  category: Joi.string().valid('planning', 'labour', 'material').required(),
  name: Joi.string().required(),
  description: Joi.string().optional().allow(''),
  price: Joi.number().required(),
  mediaUrls: Joi.array().items(Joi.string().uri()).optional(),
});

export const addService = async (req, res, next) => {
  try {
    console.log(req.body);
    if (req.user.role !== 'Dealer') {
      return res.status(403).json({ error: 'Only dealers can add services' });
    }
    console.log(req.body);

    const { error, value: validatedData } = serviceSchema.validate(req.body);
    if (error) return res.status(400).json({ error: error.details[0].message });

    // 2. Add dealerId AFTER validation
    const serviceData = {
      ...validatedData, // validated fields from Joi
      dealerId: req.user.id, // added server-side
    };

    // Handle media upload if files are provided
    if (req.files && req.files.length > 0) {
      const mediaUrls = [];
      for (const file of req.files) {
        const url = await uploadFile(file.path, `services/${file.filename}`);
        mediaUrls.push(url);
        // Optionally delete local file after upload
        fs.unlinkSync(file.path);
      }
      req.body.mediaUrls = mediaUrls;
    }

    const service = new Service(serviceData);
    await service.save();
    res.status(201).json(service);
  } catch (err) {
    next(err);
  }
};

export const updateService = async (req, res, next) => {
  try {
    const { error } = serviceSchema.validate(req.body);
    if (error) return res.status(400).json({ error: error.details[0].message });

    const service = await Service.findByIdAndUpdate(req.params.id, req.body, {
      new: true,
    });
    if (!service) return res.status(404).json({ error: 'Service not found' });
    res.json(service);
  } catch (err) {
    next(err);
  }
};

export const deleteService = async (req, res, next) => {
  try {
    const service = await Service.findByIdAndDelete(req.params.id);
    if (!service) return res.status(404).json({ error: 'Service not found' });
    res.json({ message: 'Service deleted' });
  } catch (err) {
    next(err);
  }
};

export const getServices = async (req, res, next) => {
  try {
    if (req.user.type === 'Dealer') {
      const services = await Service.find({ dealerId: req.user.id });
      return res.json(services);
    }
    // For other user types, return all services or handle accordingly
    const services = await Service.find();
    res.json(services);
  } catch (err) {
    next(err);
  }
};

export const getServiceById = async (req, res, next) => {
  try {
    const service = await Service.findById(req.params.id);
    if (!service) return res.status(404).json({ error: 'Service not found' });
    res.json(service);
  } catch (err) {
    next(err);
  }
};
