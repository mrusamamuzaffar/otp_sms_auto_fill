import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

import 'otp_digit_container.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Color(0xFF3E5B67)
  ));
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'otp_auto_fill',
    home: OtpAutoFill(),
  ));
}

class OtpAutoFill extends StatefulWidget {
  const OtpAutoFill({Key? key}) : super(key: key);

  @override
  State<OtpAutoFill> createState() => _OtpAutoFillState();
}

class _OtpAutoFillState extends State<OtpAutoFill> {
  static const platform = MethodChannel('otp_auto_fill_flutter');
  String otp = '    ', buttonText = 'waiting for SMS...';

  void _smsReadPermission() async{
    // PermissionStatus permissionStatus = await Permission.sms.request();
    if(await Permission.sms.request().isGranted) {
      _initSmsListener();
    }
  }

  Future<void> _initSmsListener() async {
    String? otpSms;
    int? d1,d2,d3,d4;

    try {
      otpSms = await platform.invokeMethod('getSms');
      otpSms = otpSms ?? '';

      if (otpSms.contains('Usama.co')) {

        otpSms = otpSms.substring(0, 4);

        d1 = int.tryParse(otpSms[0]);
        d2 = int.tryParse(otpSms[1]);
        d3 = int.tryParse(otpSms[2]);
        d4 = int.tryParse(otpSms[3]);

        if(d1 != null && d2 != null && d3 != null && d4 != null) {
          otp = '$d1$d2$d3$d4';
        }
        else {
          otp = '    ';
        }

        buttonText = 'Submit';
        _initSmsListener();
        Future.delayed(const Duration(milliseconds: 100), (){
          setState(() {});
        });
      }
      else {
        _initSmsListener();
      }
    } on PlatformException {
      buttonText = 'failed to get SMS';
    }
  }

  Future<void> _unRegisterListener() async {
    try {
       await platform.invokeMethod('unregisterListener');
    } on PlatformException {
      debugPrint('exception');
    }

  }

  @override
  void initState() {
    _smsReadPermission();
    super.initState();
  }

  @override
  void dispose() {
    _unRegisterListener();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF3E5B67),
      body: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.20,),
          const Padding(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: Text(
              'Usama.co',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 50,
                  fontWeight: FontWeight.bold
              ),
            ),
          ),
          const SizedBox(height: 100,),
          const Padding(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: Text(
              'Please wait, your 4 digits code will be filled automatically.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold
              ),
            ),
          ),
          const SizedBox(height: 30,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              OtpDigitContainer(digit: otp[0]),
              OtpDigitContainer(digit: otp[1]),
              OtpDigitContainer(digit: otp[2]),
              OtpDigitContainer(digit: otp[3]),
            ],
          ),
          const SizedBox(height: 100,),
          Text(
              buttonText,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          )
        ],
      ),
    );
  }
}

