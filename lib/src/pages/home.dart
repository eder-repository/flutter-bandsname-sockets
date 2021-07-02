import 'dart:io';

import 'package:band_name/src/models/band_models.dart';
import 'package:band_name/src/services/socket_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<BandModel> bands = [
    // BandModel(id: '1', name: 'Metalica', votes: 5),
    // BandModel(id: '2', name: 'Queen', votes: 1),
    // BandModel(id: '3', name: 'Heroes del silencio', votes: 2),
    // BandModel(id: '4', name: 'Bon Jovi', votes: 5),
  ];
  @override
  void initState() {
    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket.on(
        'active-bands',
        (payload) => {
              this.bands = (payload as List)
                  .map((band) => BandModel.fromMap(band))
                  .toList(),
              setState(() {})
            });

    super.initState();
  }

  @override
  void dispose() {
    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket.off('active-bands');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context).serverStatus;

    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        actions: [
          Container(
              margin: EdgeInsets.only(right: 10),
              child: socketService == ServerStatus.Online
                  ? Icon(
                      Icons.check_circle,
                      color: Colors.blue[300],
                      // Icons.offline_bolt,
                      // color: Colors.red[300],
                    )
                  : Icon(
                      // Icons.check_circle,
                      // color: Colors.blue[300],
                      Icons.offline_bolt,
                      color: Colors.red[300],
                    ))
        ],
        title: Text(
          'BandName',
          style: TextStyle(color: Colors.black87),
        ),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          _showGrafic(),
          Expanded(
            child: ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: bands.length,
                itemBuilder: (BuildContext context, int index) =>
                    _bandTitle(bands[index])),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 1,
        child: Icon(Icons.add),
        onPressed: addNewBand,
      ),
    );
  }

  Widget _bandTitle(BandModel band) {
    final socketService = Provider.of<SocketService>(context);
    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) {
        socketService.socket.emit('delete-band', {'id': band.id});
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
          socketService.socket.emit('vote-band', {'id': band.id});
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
    final socketService = Provider.of<SocketService>(context, listen: false);
    if (name.length > 1) {
      socketService.socket.emit('add-band', {'name': name});
    }

    Navigator.pop(context);
  }

  Widget _showGrafic() {
    Map<String, double> dataMap = Map();

    bands.forEach((band) {
      dataMap.putIfAbsent(band.name, () => band.votes.toDouble());
    });
    return Container(
        width: double.infinity, height: 200, child: PieChart(dataMap: dataMap));
  }
}
