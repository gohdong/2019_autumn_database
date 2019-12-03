const functions = require('firebase-functions');
const admin = require('firebase-admin');
var firebase = require("firebase/app");
var config = require('./src/config');


// Add the Firebase products that you want to use
require("firebase/auth");
require("firebase/firestore");


firebase.initializeApp(config.api());
admin.initializeApp();
var db = admin.firestore();
exports.aggregateRatings = functions.firestore
    .document('reviews/{reviewsId}')
    .onWrite((change, context) => {

        var ratingVal = change.after.data().score;
        // Get a reference to the restaurant
        var restRef = db.collection('movie').doc(change.after.data().movieID);

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


exports.increaseSpectator = functions.firestore.document('payment_movie/{payment_movieId}').onWrite((change, context) => {
    var ratingVal = change.after.data().seats.length;

    // Get a reference to the restaurant
    var restRef = db.collection('movie').doc(change.after.data().movieID);

    // Update aggregations in a transaction
    return db.runTransaction(transaction => {
        return transaction.get(restRef).then(restDoc => {
            // Compute new number of ratings
            var newSpectator = restDoc.data().spectator + ratingVal;
            // Update restaurant info
            return transaction.update(restRef, {
                spectator: newSpectator,
            });
        });
    });


});


exports.decreaseSelectSeats = functions.firestore
    .document('payment_movie/{payment_movieId}')
    .onDelete(async snapshot => {

        const payment = snapshot.data();

        var restRef = db.collection('time_table').doc(payment.time_tableID);

        // Update aggregations in a transaction
        return db.runTransaction(transaction => {
            return transaction.get(restRef).then(restDoc => {
                // Compute new number of ratings
                var newSelectCount = restDoc.data().select_count - payment.seats.length;

                return transaction.update(restRef, {
                    select_count : newSelectCount,
                });
            });
        });
    });

exports.resetSelectSeat = functions.firestore
    .document('payment_movie/{payment_movieId}')
    .onDelete(async snapshot => {

        const payment = snapshot.data();

        var restRef = db.collection('time_table').doc(payment.time_tableID).collection('seats').doc('1');

        // Update aggregations in a transaction
        return db.runTransaction(transaction => {
            return transaction.get(restRef).then(restDoc => {
                // Compute new number of ratings
                var newSelectCount = restDoc.data().select_count - payment.seats.length;

                for (var i=0;i<payment.seats.length;i++){
                    var seat = payment.seats[i];
                    var seatNum = seat+".number";
                    transaction.update(restRef,{
                        [seatNum] : "1"
                    });

                }

                return true;
            });
        });
    });
