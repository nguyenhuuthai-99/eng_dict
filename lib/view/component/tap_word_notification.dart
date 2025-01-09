import 'package:eng_dict/view/utils/constants.dart';
import 'package:eng_dict/view/utils/setting_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TapWordNotification extends StatefulWidget {
  String setting;
  TapWordNotification({required this.setting, super.key});

  @override
  State<TapWordNotification> createState() => _TapWordNotificationState();
}

class _TapWordNotificationState extends State<TapWordNotification> {
  bool closed = false;
  @override
  Widget build(BuildContext context) {
    return !closed ?Card(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8))
      ),
      color: const Color(0xff414141),
      child: Row(
        children: [
          const Expanded(child: Padding(
            padding: EdgeInsets.only(left: Constant.kMarginSmall),
            child: Text("Tap any word you don’t know to see its definition!", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
          )),
          IconButton(onPressed: () async{
            setState(() {
              closed = true;
            });
            Map<String, dynamic> settings = await Provider.of<SettingsService>(context, listen: false).readSettings();
            settings[widget.setting] = false;
            Provider.of<SettingsService>(context, listen: false).writeSettings(settings);
          }, icon:const Icon(Icons.close, color: Colors.white,))
        ],
      ),
    ): const SizedBox();
  }
}
