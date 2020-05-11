import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

admin.initializeApp();


const fcm = admin.messaging();


export const sentToTopic = functions.firestore
    .document('groupe/{groupeID}/Markers/{markerID}')
    .onCreate( async ( snapshot , context) =>  {
        const mark = snapshot.data();


        const payload: admin.messaging.MessagingPayload = {
            notification: {
                title: mark.icon,
                body: mark.text,
                clickAction: 'FLUTTER_NOTIFICATION_CLICK'

            }
        };
        return fcm.sendToTopic(`groupe/${context.params.groupeID}/Markers`,payload);
    });

