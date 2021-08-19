import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart' as intl;
import 'package:progressive_time_picker/progressive_time_picker.dart';

void main() {
  /// To set fixed device orientation
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then(
    (value) => runApp(MyApp()),
  );
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ClockTimeFormat _clockTimeFormat = ClockTimeFormat.twentyFourHours;
  int _inBedTime = 0;
  int _outBedTime = 96;       /// 8 hours = 96 * 12 / 288
  double _sleepGoal = 8.0;
  bool _isSleepGoal = false;

  @override
  void initState() {
    super.initState();
    _isSleepGoal = (_sleepGoal >= 8.0) ? true : false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF141925),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            'Sleep Time',
            style: TextStyle(
              color: Color(0xFF3CDAF7),
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          TimePicker(
            divisions: 288,
            init: _inBedTime,
            end: _outBedTime,
            height: 260.0,
            width: 260.0,
            onSelectionChange: _updateLabels,
            onSelectionEnd: (a, b) => print('onSelectionEnd $a $b'),
            primarySectors: _clockTimeFormat.value,
            secondarySectors: _clockTimeFormat.value * 2,
            decoration: TimePickerDecoration(
              baseColor: Color(0xFF1F2633),
              pickerBaseCirclePadding: 15.0,
              sweepDecoration: TimePickerSweepDecoration(
                pickerStrokeWidth: 30.0,
                pickerColor: _isSleepGoal ? Color(0xFF3CDAF7) : Colors.white,
                showConnector: true,
              ),
              initHandlerDecoration: TimePickerHandlerDecoration(
                color: Color(0xFF141925),
                shape: BoxShape.circle,
                radius: 12.0,
                icon: Icon(
                  Icons.power_settings_new_outlined,
                  size: 20.0,
                  color: Color(0xFF3CDAF7),
                ),
              ),
              endHandlerDecoration: TimePickerHandlerDecoration(
                color: Color(0xFF141925),
                shape: BoxShape.circle,
                radius: 12.0,
                icon: Icon(
                  Icons.notifications_active_outlined,
                  size: 20.0,
                  color: Color(0xFF3CDAF7),
                ),
              ),
              primarySectorsDecoration: TimePickerClockSectorDecoration(
                color: Colors.white,
                width: 1.0,
                size: 4.0,
                radiusPadding: 25.0,
              ),
              secondarySectorsDecoration: TimePickerClockSectorDecoration(
                color: Color(0xFF3CDAF7),
                width: 1.0,
                size: 2.0,
                radiusPadding: 25.0,
              ),
              clockNumberDecoration: TimePickerClockNumberDecoration(
                defaultTextColor: Colors.white,
                defaultFontSize: 12.0,
                scaleFactor: 2.0,
                showNumberIndicators: true,
                clockTimeFormat: _clockTimeFormat,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(62.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${_formatIntervalTime(_inBedTime, _outBedTime)}',
                    style: TextStyle(
                        fontSize: 14.0,
                        color: _isSleepGoal ? Color(0xFF3CDAF7) : Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: 300.0,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Color(0xFF1F2633),
              borderRadius: BorderRadius.circular(25.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                _isSleepGoal
                    ? "Above Sleep Goal (>=8) 😄"
                    : 'below Sleep Goal (<=8) 😴',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _timeWidget(
                'BedTime',
                _inBedTime,
                Icon(
                  Icons.power_settings_new_outlined,
                  size: 25.0,
                  color: Color(0xFF3CDAF7),
                ),
              ),
              _timeWidget(
                'WakeUp',
                _outBedTime,
                Icon(
                  Icons.notifications_active_outlined,
                  size: 25.0,
                  color: Color(0xFF3CDAF7),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _timeWidget(String title, int time, Icon icon) {
    return Container(
      width: 150.0,
      decoration: BoxDecoration(
        color: Color(0xFF1F2633),
        borderRadius: BorderRadius.circular(25.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          children: [
            Text(
              '${_formatTime(time)}',
              style: TextStyle(
                color: Color(0xFF3CDAF7),
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 15),
            Text(
              '$title',
              style: TextStyle(
                color: Color(0xFF3CDAF7),
                fontSize: 16,
              ),
            ),
            SizedBox(height: 10),
            icon,
          ],
        ),
      ),
    );
  }

  void _updateLabels(int init, int end) {
    _inBedTime = init;
    _outBedTime = end;
    _isSleepGoal =
        _validateSleepGoal(inTime: init, outTime: end, sleepGoal: _sleepGoal);
    setState(() {});
  }

  bool _validateSleepGoal(
      {required int inTime, required int outTime, required double sleepGoal}) {
    var sleepTime =
        outTime > inTime ? outTime - inTime : 288 - inTime + outTime;
    var sleepHours = sleepTime ~/
        ((_clockTimeFormat == ClockTimeFormat.twelveHours) ? 24 : 12);
    return (sleepHours >= sleepGoal) ? true : false;
  }

  String _formatTime(int time) {
    if (time == 0) {
      return '00:00';
    }
    var hours =
        time ~/ ((_clockTimeFormat == ClockTimeFormat.twelveHours) ? 24 : 12);
    var strHours = intl.NumberFormat('00').format(hours);

    var minutes = (time % 12) * 5;
    var strMinutes = intl.NumberFormat('00').format(minutes);

    return '$strHours:$strMinutes';
  }

  String _formatIntervalTime(int init, int end) {
    var sleepTime = end > init ? end - init : 288 - init + end;
    var hours = sleepTime ~/
        ((_clockTimeFormat == ClockTimeFormat.twelveHours) ? 24 : 12);
    var strHours = intl.NumberFormat('00').format(hours);

    var minutes = (sleepTime % 12) * 5;
    var strMinutes = intl.NumberFormat('00').format(minutes);

    return '${strHours}Hr ${strMinutes}Min';
  }
}
