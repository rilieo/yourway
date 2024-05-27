// Import the functions you need from the SDKs you need
import { initializeApp } from "firebase/app";
import { getFirestore, setDoc, getDoc, doc } from "firebase/firestore";
import "dotenv/config";
import stations from "./stations.json" assert { type: "json" };

const firebaseConfig = {
    apiKey: process.env.FIREBASE_API_KEY,
    authDomain: process.env.FIREBASE_AUTH_DOMAIN,
    projectId: process.env.FIREBASE_PROJECT_ID,
    storageBucket: process.env.FIREBASE_STORAGE_BUCKET,
    messagingSenderId: process.env.FIREBASE_MESSAGING_SENDER_ID,
    appId: process.env.FIREBASE_APP_ID,
    measurementId: process.env.FIREBASE_MEASUREMENT_ID
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);
const db = getFirestore(app);

const collectionName = "allStations";

class subwayStation {
    constructor(id, location, name, stops) {
        this.id = id;
        this.location = location;
        this.name = name;
        this.stops = stops;
    }

    async save() {
        try {
            await setDoc(doc(db, collectionName, this.id), {
                id: this.id,
                location: this.location,
                name: this.name,
                stops: this.stops
            });
        }
        catch (e) {
            console.error(e);
        }
    }

    async get() {
        try {
            const docSnap = await getDoc(doc(db, collectionName, this.id));
            if (docSnap.exists()) {
                const data = docSnap.data();
                return data;
            }
            else {
                console.error("No such document!");
            }
        }
        catch (e) {
            console.error(e);
        }
    }
}


for (let station in stations) {
    const newStation = new subwayStation(stations[station].id, stations[station].location, stations[station].name, stations[station].stops);
    newStation.save();
}
