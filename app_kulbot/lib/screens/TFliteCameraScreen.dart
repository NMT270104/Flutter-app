import 'package:flutter/material.dart';
import 'package:Kulbot/models/screen_params.dart';
import 'package:Kulbot/widgets/detector_widget.dart';
import 'package:flutter/services.dart';

/// [TFliteCamera] stacks [DetectorWidget]
class TFliteCamera extends StatefulWidget {
  const TFliteCamera({super.key});

  @override
  State<TFliteCamera> createState() => _TFliteCameraState();
}

class _TFliteCameraState extends State<TFliteCamera> {

  List<String> _items = [];
  String? _selectedItem;

void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    _loadData();
  }

  @override

   void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    super.dispose();
  }


  Future<void> _loadData() async {
    final String data = await rootBundle.loadString('assets/models/ssd_mobilenet.txt');
    setState(() {
      _items = data.split('\n').map((item) => item.trim()).toList();
      _selectedItem = _items.isNotEmpty ? _items[0] : null;
    });
  }

  Widget build(BuildContext context) {
    ScreenParams.screenSize = MediaQuery.sizeOf(context);
    return Scaffold(
      key: GlobalKey(),
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("TensorFlow Camera"),
        actions: [
          Container(
            child: Center(
              child: DropdownButton<String>(
              value: _selectedItem,
              items: _items.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedItem = newValue;
                });
              },
            ),
            ),
          )
        ],
      ),
      body: DetectorWidget(detectorvalue: _selectedItem),
    );
  }
}
