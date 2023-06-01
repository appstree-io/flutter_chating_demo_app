const functions = require("firebase-functions");
const admin = require('firebase-admin');
admin.initializeApp();
// exports.helloWorld = functions.https.onCall((request, response) => {
//     // functions.logger.info("Hello logs!", { structuredData: true });
//     // response.send("Hello from Firebase!");
//     return ("Hello Word");
// });

function sendPushToToken(accessToken, notificationContent, options,) {
    return admin.messaging().sendToDevice(accessToken, notificationContent, options)
        .then(function (result) {
            console.log("Notification sent successfully");
            return null;
        }).catch(function (error) {
            console.log('Notification sent failed', error);
            return null;
        });
}

exports.sendMessageNotificationToReciever = functions.https.onCall(async (data, context) => {
    var msgBody = data.msg;
    var senderName = data.sender;
    //var senderImageUrl = data.imageUrl;
    var recieverToken = data.token;

    let token = recieverToken;
    var notificationTitle = senderName;
    var notificationBody = msgBody;
    // var notificationImage = senderImageUrl;

    const notificationContent = {
        notification: {
            title: notificationTitle,
            body: notificationBody,
            //image: notificationImage,
        },
        data: {
            title: notificationTitle,
            body: notificationBody,
            click_action: "FLUTTER_NOTIFICATION_CLICK",
            sound: "default",
        }
    };
    var options = {
        priority: "high",
        timeToLive: 60 * 60 * 24
    };
    sendPushToToken(token, notificationContent, options)
    return { repeat_message: "ok!" }

});