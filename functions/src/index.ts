import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

admin.initializeApp();

const fcm = admin.messaging();


export const sentToTopic = functions.firestore
    .document('groupe/{groupeID}/Markers/{markerID}')
    .onCreate( async ( snapshot , context) =>  {
        const mark = snapshot.data() ;

        if (mark != undefined) {
            
        const payload: admin.messaging.MessagingPayload = { 
            notification: {
             
                title: `Groupe: "${mark.groupe}"`,
                body:`Membre: "${mark.sender}" \n"${mark.icon}", ${mark.text}`,
                clickAction: 'FLUTTER_NOTIFICATION_CLICK'
               
            }
        };
        return fcm.sendToTopic(context.params.groupeID,payload);
    }else {
        return null;
    }
        
    });