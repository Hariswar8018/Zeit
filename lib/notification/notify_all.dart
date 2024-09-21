import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_cloud_messaging_flutter/firebase_cloud_messaging_flutter.dart';
import 'package:zeit/model/usermodel.dart';

class NotifyAll{
 static  sendNotifications(String id,String name, String desc) async {
    // Fetch tokens from Firestore where 'arrayField' contains '1257'
   try{
    QuerySnapshot usersSnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .where('jobfollower', arrayContains:id)
        .get();

    List<String> tokens = [];

    // Extract tokens from the fetched documents
    // Extract tokens from the fetched documents
    usersSnapshot.docs.forEach((doc) {
      // Explicitly cast doc.data() to Map<String, dynamic>
      var data = doc.data() as Map<String, dynamic>;

      var user = UserModel.fromJson(data); // Assuming UserModel.fromJson correctly initializes from Map
      print(data);
      if (user.token != null) {
        tokens.add(user.token);
      }
    });
    await sendNotificationsCompany(name, desc, tokens);
   }catch(e){
     print(e);
   }
  }
  static Future<void> sendNotificationsCompany(String name, String desc,List tokens) async {
    var server = FirebaseCloudMessagingServer(
      serviceAccountFileContent,
    );
    for(String token in tokens){
      try{
      var result = await server.send(
        FirebaseSend(
          validateOnly: false,
          message: FirebaseMessage(
            notification: FirebaseNotification(
              title: name,
              body: desc,
            ),
            android: FirebaseAndroidConfig(
              ttl: '3s', // Optional TTL for notification
              /// Add Delay in String. If you want to add 1 minute delay then add it like "60s"
              notification: FirebaseAndroidNotification(
                icon: 'ic_notification', // Optional icon
                color: '#009999', // Optional color
              ),
            ),
            token: token, // Send notification to specific user's token
          ),
        ),
      );

      // Print request response
      print(result.toString());
      }catch(e){
        print(e);
      }
    }

  }

 static  sendc(String name, String desc) async {
   // Fetch tokens from Firestore where 'arrayField' contains '1257'
   try{
     QuerySnapshot usersSnapshot = await FirebaseFirestore.instance
         .collection('Users')
         .get();

     List<String> tokens = [];

     // Extract tokens from the fetched documents
     // Extract tokens from the fetched documents
     usersSnapshot.docs.forEach((doc) {
       // Explicitly cast doc.data() to Map<String, dynamic>
       var data = doc.data() as Map<String, dynamic>;

       var user = UserModel.fromJson(data); // Assuming UserModel.fromJson correctly initializes from Map
       print(data);
       if (user.token != null) {
         tokens.add(user.token);
       }
     });
     await sendNotificationsCompany(name, desc, tokens);
   }catch(e){
     print(e);
   }
 }
  static final serviceAccountFileContent = <String, String>{
    'type': "service_account",
    'project_id':"zeit-554a2",
    'private_key_id': "e30837f7dea716767b23e3e08eaa92583c692c70",
    'private_key':  "-----BEGIN PRIVATE KEY-----\nMIIEvwIBADANBgkqhkiG9w0BAQEFAASCBKkwggSlAgEAAoIBAQDWJYG1VEkLXTL1\nqNWguWgEr4xjS3EP35qi5AC5BN2S2YGIVCRclvjgIc2kGdp5DixP75o6KZ7aGiLv\ni1ctloENlpPfGvwH0p+Ua0wtNQ1NVX2wlCyogjguTcmpVY0aePHCWRJz+UgrE+eO\n9n1l/z80ngT/Diy727+EFUamCx3nl6c4BhzRQzdEEl2zWkrN50VH453RQGvoMdSV\nwGWseV+X+C9ZYxUhzNLnzbxKZNUQUIM285d4o3ef3yvzGtFtDkKsqDw+oUVbqOgq\nDLh3uVRC92IoeR0954dJgsWVtNphlbeoM+Y7h5HKa9p6r+6Wk75Dl6AvA8ys2Bol\n9DDW2/yvAgMBAAECggEAAtU+MQrraHYULYHNSbIKOT2lSs79sOsRXaRMiiYRVFcC\nSq5qSLtKkZSA5vHcnQtd9LTDwo84ZcRAwBCE17qM/IQIcsQln2je6ZS9zj9MbMB7\nyDE9ogEPAzXOPCpAkqAU+rA4+UXL+Z3qy05hfE7zJBwPDty+JMIUd4fchmfRPnYR\n8sauSm0YUDj98mK2Z6g9bEyv6VD/+jmZveB9cTL4bT/1eKhQbN9ol8SyK4NwBc6s\n3zkNJ1dQIp9H+gE+1aeMe1wVQYnDUF3yIAgRGPDm9/5M7vBESGUmUDPmC9EMVrgi\nh1NnN+iljIolZNWW8v1F0ebTAnv3i3L3tHlWxNr2+QKBgQDwW6n94JBncOrqxlKI\nLTNb0m4nf1ywrpBX022/LhpwwfRPl6KN2BviMYu//M4zD/ILh4XXUWMWB5L1ZFv9\nFJj7DkpJ/2E1Jy9+1LHydc79Z5s0rWGynrqHLAic3AX9+W0U/2S4BxjBgr+7uxRU\n2blUIz4Ctb7EJpzC5qZ8bjoaNQKBgQDkFSlQg6EsJqAqLX//WCvEr5g97AwYwndF\n/jHH83i7ZM/9Ghn4neR5qlyUArSXmDo+bsl3/caWw0jJ0DrkBkJz77Hqro/UhZjc\nM1d8xygT3HYu4vfB05s4/5ec2db40lEDquV13RKNyfoXX1q0b7jPWlQH+bguMjk6\necEVfts30wKBgQDwTKRSRl34nOKwH+DJdm8/YM1yPZn8pjl3JNE27q/OhYpsvIvu\nxd1ysdgm9Gduk4WI01ATKbInhyD8pv50slATx4CsJF8aFfgdFCZn4jI0FI4OBz2C\np8CSfYqK0EpJVUIiWQdoGOg+JyrrVCkKf7YSkT1g1jVHw9a74H8YLdd29QKBgQC5\ngXib0qNo3HWSOHWNgfH/Q+4oFu9zx97on6lvflfo2kLMEcmjyw/D4MrxWw306kwc\n8VCNdmtpvaVa9zCeu3SbBQ4I2TeEW7CLEHsMspKnLL02v0VRcUEjZ8axPQA6Whyo\nRfvhFBB+IBN3pQeKEAAZLdeAsRua/yBKrjJbwFSeHwKBgQCFEGB7bZ7CNr/yqOs+\nukPBTYI8SAx5y+pQNY6fv256STXgmJHYmzdhSZgq3UTSwxaUuYcHGDP+bKzsXSvX\nlqn21bDxxEXsfwqe6j0s92b6aACOS1Hya7oa8sRP8u53gTS4p4LGWFtdWCrzXyJK\nP7sClAy0qhOov40/LMbHqHXkiQ==\n-----END PRIVATE KEY-----\n",
    'client_email': "firebase-adminsdk-xbswu@zeit-554a2.iam.gserviceaccount.com",
    'client_id':"104400668405470482177",
    'auth_uri':  "https://accounts.google.com/o/oauth2/auth",
    'token_uri':  "https://oauth2.googleapis.com/token",
    'auth_provider_x509_cert_url':  "https://www.googleapis.com/oauth2/v1/certs",
    'client_x509_cert_url': "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-xbswu%40zeit-554a2.iam.gserviceaccount.com",
  };
}