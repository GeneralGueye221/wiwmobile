import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wiwmedia_wiwsport_v3/reusable/CustomSearchDelegate.dart';
import 'package:url_launcher/url_launcher.dart';



class ContactPage extends StatelessWidget {

  Goto(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    }
    else
      throw "Could not launch $url";
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        backgroundColor: Colors.white,
        appBar:  AppBar(
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
        body: ListView(
            shrinkWrap: true,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: 13),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      "Contact",
                      style: TextStyle(
                        fontFamily: "DINNextLTPro-MediumCond",
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Text(
                      "wiwsport, n°1 de l’actualité sportive du Sénégal sur internet et mobile, est édité par wiwmedia agence globale et intégrée de communication et marketing sportif.",
                      style: TextStyle(
                        fontFamily: "DINNextLTPro-MediumCond",
                        fontWeight: FontWeight.normal,
                        fontSize: 17,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      "Cité Keur Gorgui, Dakar Sénégal",
                      style: TextStyle(
                        fontFamily: "DINNextLTPro-MediumCond",
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    ListTile(
                      leading: Icon(Icons.phone),
                      title: Text(
                        "+221 781507472",
                        style: TextStyle(
                          fontFamily: "DINNextLTPro-MediumCond",
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                          color: Colors.black,
                        ),
                      ),
                      onTap: () => launch("tel:+221781507472"),
                    ),
                    ListTile(
                      leading: Icon(Icons.email),
                      title: Text(
                        "contact@wiwsport.com",
                        style: TextStyle(
                          fontFamily: "DINNextLTPro-MediumCond",
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                          color: Colors.black,
                        ),
                      ),
                      onTap: () => launch("mailto:contact@wiwsport.com"),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    ListTile(
                      leading: SvgPicture.asset("assets/icons/site.svg",
                          height: 30, width: 50),
                      title: Text(
                        "Notre site web",
                        style: TextStyle(
                          fontFamily: "DINNextLTPro-MediumCond",
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                          color: Colors.black,
                        ),
                      ),
                      onTap: () async {
                        const url = "https://wiwsport.com";
                        if (await canLaunch(url))
                          await launch(url);
                        else
                          throw "Could not launch $url";
                      },
                    ),

                    ListTile(
                      leading: SvgPicture.asset("assets/icons/facebook.svg",
                          height: 30, width: 50),
                      title: Text(
                        "Notre page Facebook",
                        style: TextStyle(
                          fontFamily: "DINNextLTPro-MediumCond",
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                          color: Colors.black,
                        ),
                      ),
                      onTap: () async {
                        const url = "https://facebook.com/wiwsport";
                        if (await canLaunch(url))
                          await launch(url);
                        else
                          throw "Could not launch $url";
                      },
                    ),
                  ListTile(
                    leading: SvgPicture.asset("assets/icons/twittor.svg",
                        height: 25, width: 44),
                    title: Text(
                      "Notre compte Twitter",
                      style: TextStyle(
                        fontFamily: "DINNextLTPro-MediumCond",
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        color: Colors.black,
                      ),
                    ),
                    onTap: () async {
                      const url = "https://twitter.com/wiwsport";
                      if (await canLaunch(url))
                        await launch(url);
                      else
                        throw "Could not launch $url";
                    },
                  ),
                    ListTile(
                      leading: SvgPicture.asset("assets/icons/insta.svg",
                          height: 25, width: 44),
                      title: Text(
                        "Notre compte Instagram",
                        style: TextStyle(
                          fontFamily: "DINNextLTPro-MediumCond",
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                          color: Colors.black,
                        ),
                      ),
                      onTap: () async {
                        const url = "https://www.instagram.com/wiwsport";
                        if (await canLaunch(url))
                          await launch(url);
                        else
                          throw "Could not launch $url";
                      },
                    ),
                    ListTile(
                      leading: SvgPicture.asset("assets/icons/youtube.svg",
                          height: 25, width: 44),
                      title: Text(
                        "Notre chaîne Youtube",
                        style: TextStyle(
                          fontFamily: "DINNextLTPro-MediumCond",
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                          color: Colors.black,
                        ),
                      ),
                      onTap: () async {
                        const url = "https://www.wiwsport.com/youtube";
                        if (await canLaunch(url))
                          await launch(url);
                        else
                          throw "Could not launch $url";
                      },
                    ),
                    ListTile(
                      leading: SvgPicture.asset("assets/icons/pint.svg",
                          height: 35, width: 44),
                      title: Text(
                        "Notre page Pinterest",
                        style: TextStyle(
                          fontFamily: "DINNextLTPro-MediumCond",
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                          color: Colors.black,
                        ),
                      ),
                      onTap: () async {
                        const url = "https://www.pinterest.com/wiwsport/wiwsportcom/";
                        if (await canLaunch(url))
                          await launch(url);
                        else
                          throw "Could not launch $url";
                      },
                    ),
                    ListTile(
                      leading: SvgPicture.asset("assets/icons/link.svg",
                          height: 35, width: 44),
                      title: Text(
                        "Notre page LinkedIn",
                        style: TextStyle(
                          fontFamily: "DINNextLTPro-MediumCond",
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                          color: Colors.black,
                        ),
                      ),
                      onTap: () async {
                        const url = "https://www.linkedin.com/company/wiwsport-com/";
                        if (await canLaunch(url))
                          await launch(url);
                        else
                          throw "Could not launch $url";
                      },
                    ),
                    SizedBox(height: 100,)
                  ],
                )
              )
            ]
        ),
    );
  }
}
