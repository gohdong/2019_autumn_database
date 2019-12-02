const functions = require('firebase-functions');
const admin = require('firebase-admin');
var firebase = require("firebase/app");
var config = require('./src/config');

// Add the Firebase products that you want to use
require("firebase/auth");
require("firebase/firestore");

firebase.initializeApp(config.api());
admin.initializeApp();


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