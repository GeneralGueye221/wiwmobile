import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wiwmedia_wiwsport_v3/reusable/CustomSearchDelegate.dart';
import 'package:url_launcher/url_launcher.dart';

class Help extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
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
      body:
      ListView(
        shrinkWrap: true,
        children: <Widget>[
          Container(
              padding: EdgeInsets.only(left: 13),
              child: Column(
                children: <Widget>[
                  SizedBox(height: 30,),
                  Text(
                    "Mentions Légales",
                    style: TextStyle(
                      fontFamily: "DINNextLTPro-MediumCond",
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    "Dernière mise à jour : 01 juillet 2020",
                    style: TextStyle(
                      fontFamily: "DINNextLTPro-MediumCond",
                      fontWeight: FontWeight.normal,
                      fontSize: 17,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Text(
                    "WIWMEDIA SARL éditeur du site wiwsport.com",
                    style: TextStyle(
                      fontFamily: "DINNextLTPro-MediumCond",
                      fontWeight: FontWeight.normal,
                      fontSize: 17,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Text(
                    "Société à Responsabilité Limitée (S.A.R.L) au capital de 1 000 000 FCFA",
                    style: TextStyle(
                      fontFamily: "DINNextLTPro-MediumCond",
                      fontWeight: FontWeight.normal,
                      fontSize: 17,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Text(
                    "Siège social : Cité Keur Gorgui, Dakar Sénégal",
                    style: TextStyle(
                      fontFamily: "DINNextLTPro-MediumCond",
                      fontWeight: FontWeight.normal,
                      fontSize: 17,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Text(
                    "Hébergeur : OVH",
                    style: TextStyle(
                      fontFamily: "DINNextLTPro-MediumCond",
                      fontWeight: FontWeight.normal,
                      fontSize: 17,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Nous contacter : contact@wiwsport.com",
                    style: TextStyle(
                      fontFamily: "DINNextLTPro-MediumCond",
                      fontWeight: FontWeight.normal,
                      fontSize: 17,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "+221 33 825 55 85",
                    style: TextStyle(
                      fontFamily: "DINNextLTPro-MediumCond",
                      fontWeight: FontWeight.normal,
                      fontSize: 17,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Text(
                    "Les utilisateurs, de wiwsport sont tenus de respecter la légalité et en particulier les dispositions de la loi Informatique et libertés dont la violation est sanctionnée pénalement. Ils doivent notamment s’abstenir, s’agissant des informations auxquelles ils accèdent, de toute collecte, captation, déformation ou utilisation et d’une manière générale de tout acte susceptible de porter atteinte à la vie privée ou à la réputation des personnes. Les utilisateurs sont informés, conformément aux dispositions de la loi Informatique et libertés qu’ils disposent d’un droit d’accès et de rectification relativement aux informations les concernant auprès de WIWMEDIA SARL.",
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
                    " La structure générale, ainsi que les textes et images composant wiwsport sont la propriété de la société WIWMEDIA SARL. Toute représentation totale ou partielle de wiwsport ou d’un ou plusieurs de ses composants, par quelque procédé que ce soit, sans autorisation expresse de la société WIWMEDIA SARL est interdite et constituerait une contrefaçon sanctionnée par le Code de la propriété intellectuelle.",
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
                    "Les marques de la société WIWMEDIA SARL figurant sur wiwsport sont des marques déposées. Toute reproduction totale ou partielle de ces marques sans autorisation expresse de la société WIWMEDIA SARL est donc également interdite.",
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
                    "Enfin, les contenus issus d’autres sources mentionnées et les liens hypertextes mis en place en direction d’autres sites présents sur le réseau internet ne sauraient engager la responsabilité de la société WIWMEDIA SARL.",
                    style: TextStyle(
                      fontFamily: "DINNextLTPro-MediumCond",
                      fontWeight: FontWeight.normal,
                      fontSize: 17,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    height: 70,
                  ),
                ],
              )
          ),
        ],
      ),
    );
  }
}
