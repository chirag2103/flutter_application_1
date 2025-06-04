import mongoose from 'mongoose';

const dealerRateSchema = new mongoose.Schema(
  {
    dealer: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User',
      required: true,
    },
    materialType: {
      type: String,
      required: true,
      enum: [
        'cement',
        'sand',
        'bricks',
        'steel',
        'wood',
        'paint',
        'tiles',
        'other',
      ],
    },
    price: {
      type: Number,
      required: true,
    },
    location: {
      type: {
        type: String,
        enum: ['Point'],
        required: true,
      },
      coordinates: {
        type: [Number],
        required: true,
      },
    },
    availability: {
      type: Boolean,
      default: true,
    },
    ratings: [
      {
        user: {
          type: mongoose.Schema.Types.ObjectId,
          ref: 'User',
        },
        rating: {
          type: Number,
          min: 1,
          max: 5,
        },
        review: String,
      },
    ],
    averageRating: {
      type: Number,
      default: 0,
    },
  },
  {
    timestamps: true,
  }
);

// Create a 2dsphere index for location-based queries
dealerRateSchema.index({ location: '2dsphere' });

// Calculate average rating before saving
dealerRateSchema.pre('save', function (next) {
  if (this.ratings.length > 0) {
    this.averageRating =
      this.ratings.reduce((acc, curr) => acc + curr.rating, 0) /
      this.ratings.length;
  }
  next();
});

const DealerRate = mongoose.model('DealerRate', dealerRateSchema);

export default DealerRate;
