import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lampcontrol/networklist.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:lampcontrol/shared/snack.dart';

import 'LoadingScreen/loading.dart';

void main() => runApp(MyApp());

BuildContext scaffoldContext;

SnackBar displaySnackBar(String msg) {
  final snackBar = SnackBar(
    content: Text(msg,style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
    backgroundColor: Colors.blue[200],
    action: SnackBarAction(
      label: 'Ok',
      onPressed: (){},
    ),
  );
  return snackBar;
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lamp Controller',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new Scaffold(body:MyHomePage(title: 'Lamp Controller')),
    );
  }
}

class MyHomePage extends StatefulWidget {

  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String ipadd='';
  _SaveData(String message) async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("IPAddress", message);
    debugPrint("Saved successfully with ${_ipaddress.text}");
    setState(() {
      url = 'http://' + sharedPreferences.getString("IPAddress") + ':800/';
    });
  }
  _LoadSavedData() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      if(sharedPreferences.getString("IPAddress") != null && sharedPreferences.getString("IPAddress").isNotEmpty){
        _SavedData = sharedPreferences.getString("IPAddress");
        url = 'http://' + sharedPreferences.getString("IPAddress") + ':800/';
      }else{
        _SavedData = "";
      }
      _ipaddress.text = _SavedData;
    });}
  String _SavedData = "";

  var _ipaddress = new TextEditingController();
  var _texttosend = new TextEditingController();
  String _status = '';
  String url = ''; //IP Address which is configured in NodeMCU Sketch
  var response;
  String _error = '';
  bool loading = false;
  void initState(){
    super.initState();
    _LoadSavedData();
    getInitLedState();
  }

  getInitLedState() async {
    try {
      if(url != null && url.isNotEmpty) {
        response = await http.get(url, headers: {"Accept": "plain/text"});
        setState(() {
          _status = response.body;
        });
      }
    } catch (e) {
      // If NodeMCU is not connected, it will throw error
      print(e);
      if (this.mounted) {
        setState(() {
          _status = 'Not Connected';
        });
      }
    }
  }

  sendData() async{
    try {
      debugPrint("URL = "+url);
      response = await http.get(url + _texttosend.text, headers: {"Accept": "plain/text"});
    } catch (e) {
      // If NodeMCU is not connected, it will throw error
      setState(() {
        _error = e;
      });
      print(e);
      Scaffold.of(context).showSnackBar(snack().displaySnackBar('Module Not Connected'));
    }
  }

  timeoutfunction() {
    setState(() {
      loading = false;
      debugPrint('Time out');
      Scaffold.of(context).showSnackBar(snack().displaySnackBar('Time-out'));
    });
  }
  turnOnLed(BuildContext context) async {
    try {
      debugPrint("URL = "+url);
      setState(() {
        loading = true;
      });
      response = await http.get(url + 'led/0', headers: {"Accept": "plain/text"},).timeout(const Duration(seconds: 5));
      setState(() {
        _status = response.body;
        debugPrint(response.body);
        Scaffold.of(context).showSnackBar(snack().displaySnackBar(response.body));
        loading = false;
        //displaySnackBar(context, response.body);
      });
    } on TimeoutException catch(_) {
      timeoutfunction();
    }
    catch (e) {
      // If NodeMCU is not connected, it will throw error
      setState(() {
        loading = false;
        _error = e;
      });
      print(e);
      Scaffold.of(context).showSnackBar(snack().displaySnackBar('Module Not Connected'));
    }
  }

  turnOffLed() async {
    try {
      setState(() {
        loading = true;
      });
      response = await http.get(url + 'led/1', headers: {"Accept": "plain/text"}).timeout(const Duration(seconds: 5));
      setState(() {
        _status = response.body;
        print(response.body);
        Scaffold.of(context).showSnackBar(snack().displaySnackBar(response.body));
        loading = false;
        //displaySnackBar(context, response.body);
      });
    } on TimeoutException catch(_) {
      timeoutfunction();
    }
    catch (e) {
      // If NodeMCU is not connected, it will throw error
      setState(() {
        loading = false;
        _error = e;
      });
      print(e);
      Scaffold.of(context).showSnackBar(snack().displaySnackBar('Module Not Connected'));
      //displaySnackBar(context, 'Module Not Connected');
    }
  }
  BuildContext scaffoldContext;
  @override
  Widget build(BuildContext context) {
    return loading? Loading():Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          new IconButton(icon: new Icon(Icons.network_check), onPressed: () async{
            final r = await Navigator.push(context, MaterialPageRoute(builder: (context)=>networkclass()));
            setState(() {
              if (r != null && r.toString().isNotEmpty){
                _ipaddress.text = r.toString();
                _SaveData(_ipaddress.text);
              }
            }
            );
          })
        ],
      ),
      body: Container(
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height:18),
            new TextField(
              controller: _ipaddress,
              decoration: new InputDecoration(
                  hintText: 'Enter Device IP Address',
                  icon: Icon(Icons.web_asset,color: Colors.blue,),
                fillColor: Colors.white,
                filled: true
              ),
            ),
            Divider(height: 50,),
            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new RaisedButton(
                    onPressed: (){
                      _SaveData(_ipaddress.text);
                      turnOnLed(context);
                      },
                    child: new Text(
                  'ON',
                  style: new TextStyle(color: Colors.white,fontWeight: FontWeight.w300,fontSize: 20),
                ), color: Colors.green[400]),
                SizedBox(width: 40,),
                new RaisedButton(onPressed: (){
                  _SaveData(_ipaddress.text);
                  turnOffLed();
                }, child: new Text(
                  'OFF',
                  style: new TextStyle(color: Colors.white,fontWeight: FontWeight.w300,fontSize: 20),
                ), color: Colors.red[200])
              ],
            ),
            Text(
              '$_status',
              textAlign: TextAlign.center,
              style: new TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
