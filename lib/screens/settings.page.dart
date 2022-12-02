import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:wiwmedia_wiwsport_v3/main.dart';
import 'package:wiwmedia_wiwsport_v3/reusable/CustomSearchDelegate.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

onSwitch(){

}

class _SettingsPageState extends State<SettingsPage> {
  bool value = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title: Center(
              child: Image.asset('assets/images/logo_wiwsport.png', height: 300, width: 120),
            ),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 10.0),
            child: Builder(
              builder: (context) => IconButton(
                icon: SvgPicture.asset(
                  "assets/icons/search.svg",
                  height: 17,
                  width: 35,
                ),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => CustomSearchDelegate()));
                },
              ),
            ),
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 8,
        centerTitle: false,
        titleSpacing: 0,
        iconTheme: IconThemeData(color: Colors.black54),
      ),
      body: Center(
        child: ListView(
          children: <Widget>[
            SizedBox(height: 10,),
            Padding(padding: EdgeInsets.all(15),
              child: Text("Notifications", style: TextStyle(
                  fontFamily: "DINNextLTPro-MediumCond",
                  fontSize: 20,
                  fontWeight: FontWeight.bold),)),
            Container(
              height: 60,
              child: SettingsList(
                sections: [
                  SettingsSection(
                    tiles: [
                      SettingsTile.switchTile(
                        title: 'Alertes Majeures',
                        titleTextStyle: TextStyle(
                            fontFamily: "DINNextLTPro-MediumCond",
                            fontSize: 17,
                            fontWeight: FontWeight.bold),
                        switchValue: value,
                        onToggle: (bool value) {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20,),

          ],
        ),
      )

    );
  }
}
