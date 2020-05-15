import 'package:flutter/material.dart';
import 'package:lampcontrol/LoadingScreen/loading.dart';
import 'package:wifi/wifi.dart';
import 'package:ping_discover_network/ping_discover_network.dart';
class networkclass extends StatefulWidget {
  @override
  _networkclassState createState() => _networkclassState();
}

class _networkclassState extends State<networkclass> {
  bool loadingobject = false;
  ListView listView;
  final List<String> items = [];
  @override
  Widget build(BuildContext context) {
    return loadingobject? Loading(): Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.blue[200],
        title: Text('Searching in current network'),
      ),
      body: new Container(
        child: _myListView(context),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.network_check),
        onPressed: ()=>scan(),
      ),
    );
  }


  Widget _myListView(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context,index){
        return Card(
            child:ListTile(
              leading: Icon(Icons.network_wifi,color: Colors.blue,),
              title: Text('${items[index]}'),
              onTap: (){
                print('${items[index]}');
                Navigator.pop(context,'${items[index]}');
              },
        ));
      },
    );
  }

  void scan() async {
    // NetworkAnalyzer.discover pings PORT:IP one by one according to timeout.
    // NetworkAnalyzer.discover2 pings all PORT:IP addresses at once.

    const port = 800;

    final stream = NetworkAnalyzer.discover2(
      '192.168.1',
      port,
      timeout: Duration(milliseconds: 5000),
    );

    int found = 0;
    items.clear();
    stream.listen((NetworkAddress addr) {
      if (addr.exists) {
        found++;
        print('Found device: ${addr.ip}:$port');
        setState(() {
          items.add("${addr.ip}");
        });
      }
    }).onDone(() => print('Finish. Found $found device(s)'));

  }
}




