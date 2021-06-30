import 'dart:io';

import 'package:band_name/src/models/band_models.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<BandModel> bands = [
    BandModel(id: '1', name: 'Metalica', votes: 5),
    BandModel(id: '2', name: 'Queen', votes: 1),
    BandModel(id: '3', name: 'Heroes del silencio', votes: 2),
    BandModel(id: '4', name: 'Bon Jovi', votes: 5),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: Text(
          'BandName',
          style: TextStyle(color: Colors.black87),
        ),
        backgroundColor: Colors.white,
      ),
      body: ListView.builder(
          physics: BouncingScrollPhysics(),
          itemCount: bands.length,
          itemBuilder: (BuildContext context, int index) =>
              _bandTitle(bands[index])),
      floatingActionButton: FloatingActionButton(
        elevation: 1,
        child: Icon(Icons.add),
        onPressed: addNewBand,
      ),
    );
  }

  Widget _bandTitle(BandModel band) {
    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) {
        print(direction);
      },
      background: Container(
        padding: EdgeInsets.only(left: 8.0),
        color: Colors.redAccent,
        child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'delete band',
              style: TextStyle(color: Colors.white),
            )),
      ),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(
            band.name.substring(0, 2),
          ),
          backgroundColor: Colors.blue[100],
        ),
        title: Text(band.name),
        trailing: Text(
          '${band.votes}',
          style: TextStyle(fontSize: 20),
        ),
        onTap: () {
          print(band.name);
        },
      ),
    );
  }

  addNewBand() {
    final textController = TextEditingController();

    if (Platform.isAndroid) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('New Band name:'),
              content: TextField(
                controller: textController,
              ),
              actions: [
                MaterialButton(
                  child: Text('Add'),
                  textColor: Colors.blue,
                  onPressed: () => addBandtoList(textController.text),
                  elevation: 5,
                )
              ],
            );
          });
    } else {
      showCupertinoDialog(
          context: context,
          builder: (_) {
            return CupertinoAlertDialog(
              title: Text('New Band name:'),
              content: TextField(
                controller: textController,
              ),
              actions: [
                CupertinoDialogAction(
                  child: Text('Add'),
                  isDefaultAction: true,
                  onPressed: () => addBandtoList(textController.text),
                ),
                CupertinoDialogAction(
                  child: Text('Dissmiss'),
                  isDefaultAction: true,
                  onPressed: () => Navigator.pop(context),
                )
              ],
            );
          });
    }
  }

  void addBandtoList(String name) {
    if (name.length > 1) {
      this.bands.add(
          new BandModel(id: DateTime.now().toString(), name: name, votes: 0));
      setState(() {});
    }

    Navigator.pop(context);
  }
}
