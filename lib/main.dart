import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(
        title: 'Firebase Demo',
        subtitle: "Test Describtion",
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title, this.subtitle}) : super(key: key);

  final String title;
  final String subtitle;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  Widget _buildUserListItem(BuildContext context, DocumentSnapshot document) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Expanded(
            child: document["name"] == null?
            Text("0",style: Theme.of(context).textTheme.headline,):
            Text(
              document["name"],
              style: Theme.of(context).textTheme.headline,
            ),
          ),
          Container(
            decoration: const BoxDecoration(color: Colors.blueGrey),
            padding: const EdgeInsets.all(10.0),
            child: document["rank"] == null?
            Text("0",style: Theme.of(context).textTheme.display1,):
            Text(
              document["rank"].toString(),
              style: Theme.of(context).textTheme.display1,
            ),
          )
        ],
      ),
      onTap: () {
        document.reference.updateData({
          "rank": document["rank"]+1
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: StreamBuilder(
          stream: Firestore.instance.collection("ChatUsers").snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return const Text("Loading...");
            else
              return ListView.builder(
                itemExtent: 80.0,
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) =>
                    _buildUserListItem(context, snapshot.data.documents[index]),
              );
          },
        ));
  }
}
