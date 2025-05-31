// Import necessary modules
const admin = require('firebase-admin');
const { getStorage } = require('firebase-admin/storage');
const path = require('path');
const serviceAccount = require('../firebase-service-account.json');

// Initialize Firebase Admin SDK
if (!admin.apps.length) {
  admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
    storageBucket: process.env.FIREBASE_STORAGE_BUCKET,
  });
}

const bucket = getStorage().bucket();

const uploadFile = async (filePath, destination) => {
  await bucket.upload(filePath, {
    destination,
    metadata: {
      cacheControl: 'public,max-age=31536000',
    },
  });
  const file = bucket.file(destination);
  const [url] = await file.getSignedUrl({
    action: 'read',
    expires: '03-01-2500',
  });
  return url;
};

export const deleteFile = async (destination) => {
  const file = bucket.file(destination);
  await file.delete();
};
