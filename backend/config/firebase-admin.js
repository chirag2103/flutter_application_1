import admin from 'firebase-admin';
import { fileURLToPath } from 'url';
import { dirname, join } from 'path';
import dotenv from 'dotenv';

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

dotenv.config();

const serviceAccount = JSON.parse(
  process.env.FIREBASE_SERVICE_ACCOUNT ||
    require('../firebase-service-account.json')
);

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  storageBucket: 'constructionapp-18a34.appspot.com',
});

export const db = admin.firestore();
export const auth = admin.auth();
export const storage = admin.storage();

export default admin;
