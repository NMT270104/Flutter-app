import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class settingScreen extends StatefulWidget {
  const settingScreen({super.key});

  @override
  State<settingScreen> createState() => _settingScreenState();
}

class _settingScreenState extends State<settingScreen> {
  int _currentStep = 0;
  final ScrollController _scrollController = ScrollController();
  final List<GlobalKey> _keys = List.generate(4, (index) => GlobalKey());

  void _scrollToCurrentStep() {
    // Calculate the position of the current step's content and scroll to it
    final context = _keys[_currentStep].currentContext;
    if (context != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Scrollable.ensureVisible(
          context,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          alignment: 0.5, // 0.0 means top of the screen
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Settings"),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Stepper(
          currentStep: _currentStep,
          onStepTapped: (step) {
            setState(() => _currentStep = step);
            _scrollToCurrentStep();
          },
          onStepContinue: () {
            if (_currentStep < 3) {
              setState(() => _currentStep++);
              _scrollToCurrentStep();
            }
          },
          onStepCancel: () {
            if (_currentStep > 0) {
              setState(() => _currentStep--);
              _scrollToCurrentStep();
            }
          },
          steps: [
            Step(
              title: Text('Bước 1'),
              content: SingleChildScrollView(
                key: _keys[0],
                child: Text('1.Bật Bluetooth trên điện thoại của bạn. \n-Vào phần cài đặt của điện thoại. \n-Chọn Bluetooth và bật nó lên.'),
              ),
              isActive: _currentStep >= 0,
              state: _currentStep > 0 ? StepState.complete : StepState.indexed,
            ),
            Step(
              title: Text('Bước 2'),
              content: SingleChildScrollView(
                key: _keys[1],
                child: Text('2.Trong giao diện ứng dụng, bấm vào nút biểu tượng bluetooth nằm bên phải màn hình \n-Chọn tên thiết bị Bluetooth của robot để kết nối.'),
              ),
              isActive: _currentStep >= 1,
              state: _currentStep > 1 ? StepState.complete : StepState.indexed,
            ),
            Step(
              title: Text('Bước 3'),
              content: SingleChildScrollView(
                key: _keys[2],
                child: Text('3.Sử dụng các nút hoặc thanh trượt trên giao diện ứng dụng để điều khiển các chuyển động của robot (tiến, lùi, quay trái, quay phải, dừng lại, v.v.).'),
              ),
              isActive: _currentStep >= 2,
              state: _currentStep > 2 ? StepState.complete : StepState.indexed,
            ),
            Step(
              title: Text('Bước 4'),
              content: SingleChildScrollView(
                key: _keys[3],
                child: Text('4.Lưu ý:\n -Kiểm tra kết nối: Nếu robot không phản hồi, hãy đảm bảo rằng kết nối Bluetooth giữa điện thoại và robot không bị gián đoạn.\n -Khoảng cách hoạt động: Bluetooth có phạm vi hoạt động giới hạn (thường là khoảng 10 mét), vì vậy hãy giữ khoảng cách phù hợp giữa điện thoại và robot.\n -Với các bước đơn giản trên, bạn có thể dễ dàng điều khiển robot của mình thông qua ứng dụng trên điện thoại. Chúc bạn có những trải nghiệm thú vị và sáng tạo với robot của mình!'),
              ),
              isActive: _currentStep >= 3,
              state: _currentStep > 3 ? StepState.complete : StepState.indexed,
            ),
          ],
        ),
      ),
    );
  }
}