const functions = require('firebase-functions');
const admin = require('firebase-admin');
var firebase = require("firebase/app");

// Add the Firebase products that you want to use
require("firebase/auth");
require("firebase/firestore");

const firebaseConfig = {
    apiKey: "AIzaSyCinM5h8epVA69l1x0V-Kjh5wtX-3hQLfU",
    authDomain: "autumn-database.firebaseapp.com",
    databaseURL: "https://autumn-database.firebaseio.com",
    projectId: "autumn-database",
    storageBucket: "autumn-database.appspot.com",
    messagingSenderId: "62260457293",
    appId: "1:62260457293:web:eea497a35e4cd1e6809104",
    measurementId: "G-7322BJPPGG"
};

firebase.initializeApp(firebaseConfig);
admin.initializeApp();
// firbase.initializeApp(firebaseConfig);

// Create and Deploy Your First Cloud Functions
// https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//     response.send("Hello from Firebase!");
// });
// var db = firebase.firestore();
exports.aggregateRatings = functions.firestore
    .document('movie/{movieId}/reviews/{reviewsId}')
    .onWrite((change, context) => {

        var db = admin.firestore();
        var ratingVal = change.after.data().score;

        // Get a reference to the restaurant
        var restRef = db.collection('movie').doc(context.params.movieId);

        // Update aggregations in a transaction
        return db.runTransaction(transaction => {
            return transaction.get(restRef).then(restDoc => {
                // Compute new number of ratings
                var newNumRatings = restDoc.data().numRatings + 1;

                // Compute new average rating
                var oldRatingTotal = restDoc.data().avgRating * restDoc.data().numRatings;
                var newAvgRating = (oldRatingTotal + ratingVal) / newNumRatings;

                // Update restaurant info
                return transaction.update(restRef, {
                    avgRating: newAvgRating,
                    numRatings: newNumRatings
                });
            });
        });
    });