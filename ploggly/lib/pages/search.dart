import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ploggly/widgets/progress.dart';


class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}
FirebaseAuth fAuth = FirebaseAuth.instance;
FirebaseUser loggedInUser;
final userRef = Firestore.instance.collection('users');

class _SearchState extends State<Search> {

   Future<QuerySnapshot> searchResultFuture;
   TextEditingController searchController = TextEditingController();

  handleSearch(String query){
      Future<QuerySnapshot> users = userRef
      .where("name",isGreaterThanOrEqualTo:query)
      .getDocuments();
      
      setState(() {
        searchResultFuture = users; 
      });

  }
  clearSearch(){
    searchController.clear();
  }

  AppBar buildSearchField(){
    return AppBar(
        backgroundColor: Colors.white,
        title: TextFormField(
          controller: searchController,
          decoration: InputDecoration(
            hintText: "Search for a user...",
      
            filled: true,
            prefixIcon: Icon(
              Icons.account_box,
              size: 28.0,
            ),
            suffixIcon: IconButton(
              icon: Icon(Icons.clear),
              onPressed: ()=>print('cleared'),
            )
          ),
          onFieldSubmitted: handleSearch,
        )
    );
  }



  Container buildNoContent(){
    return Container(
        child: Center(
            child: ListView(
              children: <Widget>[
                SizedBox(height: 250.0,),
                Text("Find Users", textAlign: TextAlign.center,
                style: TextStyle(
                  color:Colors.grey[300],
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w600,
                  fontSize: 60.0,
                ),
                )
              ],
            ),
        ),
    );
  }

  buildSearchResults(){
    return FutureBuilder(
      future:searchResultFuture,
      builder: (context,snapshot){
        if(!snapshot.hasData){
          return circularProgress();
        }
        List<Container> searchResults = [];
        snapshot.data.documents.forEach((doc){
         
          searchResults.add(
          Container(
            color:Colors.pink,
            child: Column(
              children: <Widget>[
                GestureDetector(
                  onTap: ()=> print('tapped'),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.grey,
                      backgroundImage: CachedNetworkImageProvider(doc['profpic']),
                    ),
                    title: Text(doc['name'],
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Montserrat',
                    ),
                    ),
                    subtitle: Text(doc['username'],style: TextStyle(color: Colors.white),),
                  ),
                ),
                Divider(height: 2.0,color: Colors.white54,)
              ],
            ),
          )
          );
        });
        return ListView(
            children: searchResults
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
        appBar: buildSearchField(),
        body: searchResultFuture == null ? buildNoContent()
        : buildSearchResults(),
    );
  }
}

