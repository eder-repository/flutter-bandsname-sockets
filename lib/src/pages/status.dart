import 'package:band_name/src/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StatusPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context);

    // print(socketService.toString());
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text('server Status: ${socketService.serverStatus}')],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.message),
        onPressed: () {
          // emitir mensaje
          socketService.socket.emit('nuevo-mensaje',
              {'nombre': 'flutter', 'mensaje': 'hola desde flutter'});
        },
      ),
    );
  }
}
