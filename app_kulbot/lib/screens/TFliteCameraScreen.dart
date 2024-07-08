import 'package:flutter/material.dart';
import 'package:TEST/models/screen_params.dart';
import 'package:TEST/widgets/detector_widget.dart';
import 'package:flutter/services.dart';

/// [TFliteCamera] stacks [DetectorWidget]
class TFliteCamera extends StatefulWidget {
  const TFliteCamera({super.key});

  @override
  State<TFliteCamera> createState() => _TFliteCameraState();
}

class _TFliteCameraState extends State<TFliteCamera> {
void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override

   void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    super.dispose();
  }


  Widget build(BuildContext context) {
    ScreenParams.screenSize = MediaQuery.sizeOf(context);
    return Scaffold(
      key: GlobalKey(),
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("TensorFlow Camera"),
      ),
      body: const DetectorWidget(),
    );
  }
}
