import mongoose from 'mongoose';

const serviceSchema = new mongoose.Schema({
  category: {
    type: String,
    enum: ['planning', 'labour', 'material'],
    required: true,
  },
  name: {
    type: String,
    required: true,
    trim: true,
  },
  description: {
    type: String,
    trim: true,
  },
  price: {
    type: Number,
    required: true,
  },
  mediaUrls: [
    {
      type: String,
    },
  ],
  dealerId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true,
  },
  createdAt: {
    type: Date,
    default: Date.now,
  },
});

export default mongoose.model('Service', serviceSchema);
