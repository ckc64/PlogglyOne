const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//  response.send("Hello from Firebase!");
// });
exports.onCreateFollower = functions.firestore
.document("/followers/{userId}/usersFollower/{followerId}")
.onCreate( async (snapshot,context) => {
    const userId = context.params.userId;
    const followerId = context.params.followerId;

    console.log("Follower Created",snapshot.id)
    //create followed users posts
    const followedUserRef = admin
    .firestore()
    .collection('posts')
    .doc(userId)
    .collection('userPosts');

    //create following users timeline ref
    const timelinePostsRef = admin
    .firestore()
    .collection('timeline')
    .doc(followerId)
    .collection('timelinePosts');

    //get followed users posts
    
    const querySnapshot = await followedUserRef.get();

    //add each user post to following users timeline

    querySnapshot.forEach(doc =>{
        if(doc.exists){
            const postId = doc.id;
           const postData = doc.data();
           timelinePostsRef.doc(postId).set(postData); 
        }
    });


});

exports.onDeleteFollower = functions.firestore
    .document("/followers/{userId}/usersFollower/{followerId}")
    .onDelete(async (snapshot, context)=>{
        console.log("Follower Delete",snapshot.id);

        const userId = context.params.userId;
        const followerId = context.params.followerId;

        const timelinePostsRef = admin
        .firestore()
        .collection('timeline')
        .doc(followerId)
        .collection('timelinePosts')
        .where("ownerId","==",userId);

        const querySnapshot = await timelinePostsRef.get();
        querySnapshot.forEach(doc=>{
            if(doc.exists){
                doc.ref.delete();   
            }
        });

    });