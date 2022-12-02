import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:overlay_screen/overlay_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:wiwmedia_wiwsport_v3/model/user.dart';

import 'package:wiwmedia_wiwsport_v3/pages/HomePage.dart';
import 'package:wiwmedia_wiwsport_v3/pages/User/AccountPage.dart';
import 'package:wiwmedia_wiwsport_v3/pages/User/Connexion.dart';
import 'package:wiwmedia_wiwsport_v3/reusable/CustomSearchDelegate.dart';
import 'package:wiwmedia_wiwsport_v3/screens/charte.dart';
import 'package:wiwmedia_wiwsport_v3/screens/contact_page.dart';
import 'package:wiwmedia_wiwsport_v3/screens/help_page.dart';
import 'package:wiwmedia_wiwsport_v3/screens/menu/page_basket_actu.dart';
import 'package:wiwmedia_wiwsport_v3/screens/menu/page_foot_actu.dart';
import 'package:wiwmedia_wiwsport_v3/screens/menu/page_newsletter.dart';
import 'package:wiwmedia_wiwsport_v3/screens/menu/page_taekwondo.dart';
import 'package:wiwmedia_wiwsport_v3/screens/settings.page.dart';

import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class TheDrawer extends StatefulWidget {
  final bool isConnect;
  final Utilisateur user;

  TheDrawer({
    @required this.isConnect,
    this.user,
  });

  @override
  _TheDrawerState createState() => _TheDrawerState();
}

class _TheDrawerState extends State<TheDrawer> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    FirebaseAuth.instance.authStateChanges().listen((User user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    });
    bool isUser = FirebaseAuth.instance.currentUser != null;
    print("IS_USER ? -> $isUser");
  }

  @override
  Widget build(BuildContext context) {
    OverlayScreen().saveScreens({
      'login': CustomOverlayScreen(
        backgroundColor: Colors.teal.withOpacity(0.5),
        content: ToConnect(isArticle: false),
      ),
    });
    return Drawer(
      child: ListView(
        children: <Widget>[
          SizedBox(
            height: 30,
          ),
          InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType.fade,
                    child: CustomSearchDelegate(),
                  ),
                );
              },
              child: Image.asset('assets/images/bar.png')),
          SizedBox(height: 30),
          Text("    Suivez wiwsport",
              textAlign: TextAlign.justify,
              style: TextStyle(
                  fontFamily: "DINNextLTPro-MediumCond",
                  fontSize: 15,
                  fontWeight: FontWeight.bold)),
          Container(
            child: Row(
              children: <Widget>[
                //Text("        "),
                IconButton(
                  icon: SvgPicture.asset("assets/icons/facebook.svg",
                      height: 35, width: 44),
                  onPressed: () async {
                    const url = "https://facebook.com/wiwsport";
                    if (await canLaunch(url))
                      await launch(url);
                    else
                      throw "Could not launch $url";
                  },
                ),
                IconButton(
                  icon: SvgPicture.asset("assets/icons/twittor.svg",
                      height: 25, width: 44),
                  onPressed: () async {
                    const url = "https://twitter.com/wiwsport";
                    if (await canLaunch(url))
                      await launch(url);
                    else
                      throw "Could not launch $url";
                  },
                ),
                IconButton(
                  icon: SvgPicture.asset("assets/icons/insta.svg",
                      height: 35, width: 44),
                  onPressed: () async {
                    const url = "https://www.instagram.com/wiwsport";
                    if (await canLaunch(url))
                      await launch(url);
                    else
                      throw "Could not launch $url";
                  },
                ),
                IconButton(
                  icon: SvgPicture.asset("assets/icons/youtube.svg",
                      height: 35, width: 44),
                  onPressed: () async {
                    const url = "https://www.wiwsport.com/youtube";
                    if (await canLaunch(url))
                      await launch(url);
                    else
                      throw "Could not launch $url";
                  },
                ),
                IconButton(
                  icon: SvgPicture.asset("assets/icons/pint.svg",
                      height: 35, width: 44),
                  onPressed: () async {
                    const url =
                        "https://www.pinterest.com/wiwsport/wiwsportcom/";
                    if (await canLaunch(url))
                      await launch(url);
                    else
                      throw "Could not launch $url";
                  },
                ),
                IconButton(
                  icon: SvgPicture.asset("assets/icons/link.svg",
                      height: 35, width: 44),
                  onPressed: () async {
                    const url =
                        "https://www.linkedin.com/company/wiwsport-com/";
                    if (await canLaunch(url))
                      await launch(url);
                    else
                      throw "Could not launch $url";
                  },
                ),
              ],
            ),
          ),
          //Divider( color: Colors.black, height: 36 ),
          //Divider(),
          ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SvgPicture.asset("assets/icons/partager.svg",
                    height: 15, width: 20),
                SizedBox(width: 10),
                Text("Partager l'application",
                    style: TextStyle(
                        fontFamily: "DINNextLTPro-MediumCond",
                        fontSize: 15,
                        fontWeight: FontWeight.bold)),
              ],
            ),
            onTap: () => Share.share(
              "J'utilise l'application wiwsport. Télécharge la aussi sur https://wiwsport.com/appmobile",
            ),
          ),

          _setConnectButton(),

          Divider(color: Colors.black, height: 27),
          ListTile(
              title: Text("À la une",
                  style: TextStyle(
                      fontFamily: "DINNextLTPro-MediumCond",
                      fontSize: 15,
                      fontWeight: FontWeight.bold)),
              onTap: () {
                Navigator.push(
                    context,
                    PageTransition(
                    type: PageTransitionType.fade,
                    child : HomePage()
                      ),
                );
              }),
          //Divider(),
          Theme(
            data: Theme.of(context).copyWith(accentColor: Color(0xFF339966)),
            child: ExpansionTile(
              title: Text("Football",
                  style: TextStyle(
                      fontFamily: "DINNextLTPro-MediumCond",
                      fontSize: 15,
                      fontWeight: FontWeight.bold)),
              children: <Widget>[
                ListTile(
                    title: Text(
                      "     Actu",
                      style: TextStyle(
                          fontFamily: "DINNextLTPro-MediumCond", fontSize: 15),
                    ),
                    onTap: () {
                      Navigator.push(
                    context,
                    PageTransition(
                    type: PageTransitionType.fade,
                    child : HomePage(
                                user: widget.user,
                                isUser: widget.isConnect,
                                index: 1,
                              )),
                      );
                    }),
                ListTile(
                    title: Text(
                      "     Equipe Nationale",
                      style: TextStyle(
                          fontFamily: "DINNextLTPro-MediumCond", fontSize: 15),
                    ),
                    onTap: () {
                      Navigator.push(
                    context,
                    PageTransition(
                    type: PageTransitionType.fade,
                    child : PageFootActu(
                                  user: widget.user,
                                  isUser: widget.isConnect,
                                  index: 2)),
                      );
                    }),
                ListTile(
                    title: Text(
                      "     Actu des Lions",
                      style: TextStyle(
                          fontFamily: "DINNextLTPro-MediumCond", fontSize: 15),
                    ),
                    onTap: () {
                      Navigator.push(
                    context,
                    PageTransition(
                    type: PageTransitionType.fade,
                    child : PageFootActu(
                                  user: widget.user,
                                  isUser: widget.isConnect,
                                  index: 3)),
                      );
                    }),
                ListTile(
                    title: Text(
                      "     But des Lions",
                      style: TextStyle(
                          fontFamily: "DINNextLTPro-MediumCond", fontSize: 15),
                    ),
                    onTap: () {
                      Navigator.push(
                    context,
                    PageTransition(
                    type: PageTransitionType.fade,
                    child : PageFootActu(
                                user: widget.user,
                                isUser: widget.isConnect,
                                index: 4,
                              )),
                      );
                    }),
                ListTile(
                    title: Text("     Mercato",
                        style: TextStyle(
                            fontFamily: "DINNextLTPro-MediumCond",
                            fontSize: 15)),
                    onTap: () {
                      Navigator.push(
                    context,
                    PageTransition(
                    type: PageTransitionType.fade,
                    child : PageFootActu(
                                user: widget.user,
                                isUser: widget.isConnect,
                                index: 5,
                              )),
                      );
                    }),
                ListTile(
                    title: Text("     Ligue Pro",
                        style: TextStyle(
                            fontFamily: "DINNextLTPro-MediumCond",
                            fontSize: 15)),
                    onTap: () {
                      Navigator.push(
                    context,
                    PageTransition(
                    type: PageTransitionType.fade,
                    child : PageFootActu(
                                user: widget.user,
                                isUser: widget.isConnect,
                                index: 6,
                              )),
                      );
                    }),
                ListTile(
                    title: Text("     Beach Soccer",
                        style: TextStyle(
                            fontFamily: "DINNextLTPro-MediumCond",
                            fontSize: 15)),
                    onTap: () {
                      Navigator.push(
                    context,
                    PageTransition(
                    type: PageTransitionType.fade,
                    child : PageFootActu(
                                user: widget.user,
                                isUser: widget.isConnect,
                                index: 7,
                              )),
                      );
                    }),
                ListTile(
                    title: Text(
                      "     Teqball",
                      style: TextStyle(
                          fontFamily: "DINNextLTPro-MediumCond", fontSize: 15),
                    ),
                    onTap: () {
                      Navigator.push(
                    context,
                    PageTransition(
                    type: PageTransitionType.fade,
                    child : PageFootActu(
                                user: widget.user,
                                isUser: widget.isConnect,
                                index: 8,
                              )),
                      );
                    }),
                ListTile(
                    title: Text("     Football Féminin",
                        style: TextStyle(
                            fontFamily: "DINNextLTPro-MediumCond",
                            fontSize: 15)),
                    onTap: () {
                      Navigator.push(
                    context,
                    PageTransition(
                    type: PageTransitionType.fade,
                    child : PageFootActu(
                                user: widget.user,
                                isUser: widget.isConnect,
                                index: 9,
                              )),
                      );
                    }),
                ListTile(
                    title: Text("     Navétanes",
                        style: TextStyle(
                            fontFamily: "DINNextLTPro-MediumCond",
                            fontSize: 15)),
                    onTap: () {
                      Navigator.push(
                    context,
                    PageTransition(
                    type: PageTransitionType.fade,
                    child : PageFootActu(
                                user: widget.user,
                                isUser: widget.isConnect,
                                index: 10,
                              )),
                      );
                    }),
              ],
            ),
          ),
          Theme(
            data: Theme.of(context).copyWith(accentColor: Color(0xFF339966)),
            child: ExpansionTile(
              title: Text("Basket",
                  style: TextStyle(
                      fontFamily: "DINNextLTPro-MediumCond",
                      fontSize: 15,
                      fontWeight: FontWeight.bold)),
              children: <Widget>[
                ListTile(
                    title: Text("     Actu",
                        style: TextStyle(
                            fontFamily: "DINNextLTPro-MediumCond",
                            fontSize: 15)),
                    onTap: () {
                      Navigator.push(
                    context,
                    PageTransition(
                    type: PageTransitionType.fade,
                    child : HomePage(
                                user: widget.user,
                                isUser: widget.isConnect,
                                index: 2,
                              )),
                      );
                    }),
                ListTile(
                  title: Text(
                    "     Equipe Nationale",
                    style: TextStyle(
                        fontFamily: "DINNextLTPro-MediumCond", fontSize: 15),
                  ),
                  onTap: () {
                    Navigator.push(
                    context,
                    PageTransition(
                    type: PageTransitionType.fade,
                    child : PageBasketActu(
                              user: widget.user,
                              isUser: widget.isConnect,
                              index: 2,
                            )),
                    );
                  },
                ),
                ListTile(
                    title: Text(
                      "     Actu des Lions",
                      style: TextStyle(
                          fontFamily: "DINNextLTPro-MediumCond", fontSize: 15),
                    ),
                    onTap: () {
                      Navigator.push(
                    context,
                    PageTransition(
                    type: PageTransitionType.fade,
                    child : PageBasketActu(
                                user: widget.user,
                                isUser: widget.isConnect,
                                index: 3,
                              )),
                      );
                    }),
                ListTile(
                    title: Text("     NBA",
                        style: TextStyle(
                            fontFamily: "DINNextLTPro-MediumCond",
                            fontSize: 15)),
                    onTap: () {
                      Navigator.push(
                    context,
                    PageTransition(
                    type: PageTransitionType.fade,
                    child : PageBasketActu(
                                user: widget.user,
                                isUser: widget.isConnect,
                                index: 4,
                              )),
                      );
                    }),
                ListTile(
                    title: Text("     Basket local",
                        style: TextStyle(
                            fontFamily: "DINNextLTPro-MediumCond",
                            fontSize: 15)),
                    onTap: () {
                      Navigator.push(
                    context,
                    PageTransition(
                    type: PageTransitionType.fade,
                    child : PageBasketActu(
                                  user: widget.user,
                                  isUser: widget.isConnect,
                                  index: 5)),
                      );
                    }),
              ],
            ),
          ),

          ListTile(
              title: Text("Lamb",
                  style: TextStyle(
                      fontFamily: "DINNextLTPro-MediumCond",
                      fontSize: 15,
                      fontWeight: FontWeight.bold)),
              onTap: () {
                Navigator.push(
                    context,
                    PageTransition(
                    type: PageTransitionType.fade,
                    child : HomePage(
                          user: widget.user,
                          isUser: widget.isConnect,
                          index: 3,
                        )),
                );
              }),
          Theme(
            data: Theme.of(context).copyWith(accentColor: Color(0xFF339966)),
            child: ExpansionTile(
              title: Text("Combat",
                  style: TextStyle(
                      fontFamily: "DINNextLTPro-MediumCond",
                      fontSize: 15,
                      fontWeight: FontWeight.bold)),
              children: <Widget>[
                ListTile(
                    title: Text("     Actu",
                        style: TextStyle(
                            fontFamily: "DINNextLTPro-MediumCond",
                            fontSize: 15)),
                    onTap: () {
                      Navigator.push(
                    context,
                    PageTransition(
                    type: PageTransitionType.fade,
                    child : HomePage(
                                user: widget.user,
                                isUser: widget.isConnect,
                                index: 4,
                              )),
                      );
                    }),
                ListTile(
                  title: Text(
                    "     Taekwondo ",
                    style: TextStyle(
                        fontFamily: "DINNextLTPro-MediumCond", fontSize: 15),
                  ),
                  onTap: () {
                    Navigator.push(
                    context,
                    PageTransition(
                    type: PageTransitionType.fade,
                    child : PageArtMars(
                                widget.user, widget.isConnect, 2)),
                    );
                  },
                ),
                ListTile(
                  title: Text(
                    "     Judo",
                    style: TextStyle(
                        fontFamily: "DINNextLTPro-MediumCond", fontSize: 15),
                  ),
                  onTap: () {
                    Navigator.push(
                    context,
                    PageTransition(
                    type: PageTransitionType.fade,
                    child : PageArtMars(
                                widget.user, widget.isConnect, 3)),
                    );
                  },
                ),
                ListTile(
                  title: Text(
                    "     Karaté",
                    style: TextStyle(
                        fontFamily: "DINNextLTPro-MediumCond", fontSize: 15),
                  ),
                  onTap: () {
                    Navigator.push(
                    context,
                    PageTransition(
                    type: PageTransitionType.fade,
                    child : PageArtMars(
                                widget.user, widget.isConnect, 4)),
                    );
                  },
                ),
                ListTile(
                  title: Text(
                    "     Kung-fu",
                    style: TextStyle(
                        fontFamily: "DINNextLTPro-MediumCond", fontSize: 15),
                  ),
                  onTap: () {
                    Navigator.push(
                    context,
                    PageTransition(
                    type: PageTransitionType.fade,
                    child : PageArtMars(
                                widget.user, widget.isConnect, 5)),
                    );
                  },
                ),
                ListTile(
                  title: Text(
                    "     Lutte",
                    style: TextStyle(
                        fontFamily: "DINNextLTPro-MediumCond", fontSize: 15),
                  ),
                  onTap: () {
                    Navigator.push(
                    context,
                    PageTransition(
                    type: PageTransitionType.fade,
                    child : PageArtMars(
                                widget.user, widget.isConnect, 6)),
                    );
                  },
                ),
                ListTile(
                    title: Text(
                      "     Boxe",
                      style: TextStyle(
                          fontFamily: "DINNextLTPro-MediumCond", fontSize: 15),
                    ),
                    onTap: () {
                      Navigator.push(
                    context,
                    PageTransition(
                    type: PageTransitionType.fade,
                    child : PageArtMars(
                                  widget.user, widget.isConnect, 7)),
                      );
                    }),
                ListTile(
                    title: Text("     MMA",
                        style: TextStyle(
                            fontFamily: "DINNextLTPro-MediumCond",
                            fontSize: 15)),
                    onTap: () {
                      Navigator.push(
                    context,
                    PageTransition(
                    type: PageTransitionType.fade,
                    child : PageArtMars(
                                  widget.user, widget.isConnect, 8)),
                      );
                    }),
              ],
            ),
          ),
          ListTile(
              title: Text("Athlétisme",
                  style: TextStyle(
                      fontFamily: "DINNextLTPro-MediumCond",
                      fontSize: 15,
                      fontWeight: FontWeight.bold)),
              onTap: () {
                Navigator.push(
                    context,
                    PageTransition(
                    type: PageTransitionType.fade,
                    child : HomePage(
                          user: widget.user,
                          isUser: widget.isConnect,
                          index: 5,
                        )),
                );
              }),
          ListTile(
              title: Text("Tennis",
                  style: TextStyle(
                      fontFamily: "DINNextLTPro-MediumCond",
                      fontSize: 15,
                      fontWeight: FontWeight.bold)),
              onTap: () {
                Navigator.push(
                    context,
                    PageTransition(
                    type: PageTransitionType.fade,
                    child : HomePage(
                          user: widget.user,
                          isUser: widget.isConnect,
                          index: 6,
                        )),
                );
              }),
          ListTile(
              title: Text("Handball",
                  style: TextStyle(
                      fontFamily: "DINNextLTPro-MediumCond",
                      fontSize: 15,
                      fontWeight: FontWeight.bold)),
              onTap: () {
                Navigator.push(
                    context,
                    PageTransition(
                    type: PageTransitionType.fade,
                    child : HomePage(
                          user: widget.user,
                          isUser: widget.isConnect,
                          index: 7,
                        )),
                );
              }),
          ListTile(
              title: Text("Volley-ball",
                  style: TextStyle(
                      fontFamily: "DINNextLTPro-MediumCond",
                      fontSize: 15,
                      fontWeight: FontWeight.bold)),
              onTap: () {
                Navigator.push(
                    context,
                    PageTransition(
                    type: PageTransitionType.fade,
                    child : HomePage(
                          user: widget.user,
                          isUser: widget.isConnect,
                          index: 8,
                        )),
                );
              }),
          ListTile(
              title: Text("Rugby",
                  style: TextStyle(
                      fontFamily: "DINNextLTPro-MediumCond",
                      fontSize: 15,
                      fontWeight: FontWeight.bold)),
              onTap: () {
                Navigator.push(
                    context,
                    PageTransition(
                    type: PageTransitionType.fade,
                    child : HomePage(
                          user: widget.user,
                          isUser: widget.isConnect,
                          index: 9,
                        )),
                );
              }),
          ListTile(
              title: Text("Auto-Moto",
                  style: TextStyle(
                      fontFamily: "DINNextLTPro-MediumCond",
                      fontSize: 15,
                      fontWeight: FontWeight.bold)),
              onTap: () {
                Navigator.push(
                    context,
                    PageTransition(
                    type: PageTransitionType.fade,
                    child : HomePage(
                          user: widget.user,
                          isUser: widget.isConnect,
                          index: 10,
                        )),
                );
              }),
          ListTile(
              title: Text("Cyclisme",
                  style: TextStyle(
                      fontFamily: "DINNextLTPro-MediumCond",
                      fontSize: 15,
                      fontWeight: FontWeight.bold)),
              onTap: () {
                Navigator.push(
                    context,
                    PageTransition(
                    type: PageTransitionType.fade,
                    child : HomePage(
                          user: widget.user,
                          isUser: widget.isConnect,
                          index: 11,
                        )),
                );
              }),
          ListTile(
              title: Text("Natation",
                  style: TextStyle(
                      fontFamily: "DINNextLTPro-MediumCond",
                      fontSize: 15,
                      fontWeight: FontWeight.bold)),
              onTap: () {
                Navigator.push(
                    context,
                    PageTransition(
                    type: PageTransitionType.fade,
                    child : HomePage(
                          user: widget.user,
                          isUser: widget.isConnect,
                          index: 12,
                        )),
                );
              }),
          ListTile(
              title: Text("Roller",
                  style: TextStyle(
                      fontFamily: "DINNextLTPro-MediumCond",
                      fontSize: 15,
                      fontWeight: FontWeight.bold)),
              onTap: () {
                Navigator.push(
                    context,
                    PageTransition(
                    type: PageTransitionType.fade,
                    child : HomePage(
                          user: widget.user,
                          isUser: widget.isConnect,
                          index: 13,
                        )),
                );
              }),
          ListTile(
              title: Text("Golf",
                  style: TextStyle(
                      fontFamily: "DINNextLTPro-MediumCond",
                      fontSize: 15,
                      fontWeight: FontWeight.bold)),
              onTap: () {
                Navigator.push(
                    context,
                    PageTransition(
                    type: PageTransitionType.fade,
                    child : HomePage(
                          user: widget.user,
                          isUser: widget.isConnect,
                          index: 14,
                        )),
                );
              }),
          ListTile(
              title: Text("Olympisme",
                  style: TextStyle(
                      fontFamily: "DINNextLTPro-MediumCond",
                      fontSize: 15,
                      fontWeight: FontWeight.bold)),
              onTap: () {
                Navigator.push(
                    context,
                    PageTransition(
                    type: PageTransitionType.fade,
                    child : HomePage(
                          user: widget.user,
                          isUser: widget.isConnect,
                          index: 15,
                        )),
                );
              }),
          ListTile(
              title: Text("e-sport",
                  style: TextStyle(
                      fontFamily: "DINNextLTPro-MediumCond",
                      fontSize: 15,
                      fontWeight: FontWeight.bold)),
              onTap: () {
                Navigator.push(
                    context,
                    PageTransition(
                    type: PageTransitionType.fade,
                    child : HomePage(
                          user: widget.user,
                          isUser: widget.isConnect,
                          index: 16,
                        )),
                );
              }),
          ListTile(
              title: Text("Autres/Omnisport",
                  style: TextStyle(
                      fontFamily: "DINNextLTPro-MediumCond",
                      fontSize: 15,
                      fontWeight: FontWeight.bold)),
              onTap: () {
                Navigator.push(
                    context,
                    PageTransition(
                    type: PageTransitionType.fade,
                    child : HomePage(
                          user: widget.user,
                          isUser: widget.isConnect,
                          index: 17,
                        )),
                );
              }),
          Divider(color: Colors.black, height: 36),

          ListTile(
              //leading: Icon(Icons.help),
              title: Text("Mentions légales",
                  style: TextStyle(
                      fontFamily: "Arial",
                      fontSize: 17,
                      fontWeight: FontWeight.normal)),
              onTap: () {
                Navigator.push(
                    context,
                    PageTransition(
                    type: PageTransitionType.fade,
                    child : Help()),
                );
              }),
          ListTile(
            //leading: Icon(Icons.help),
              title: Text("Charte commentaires",
                  style: TextStyle(
                      fontFamily: "Arial",
                      fontSize: 17,
                      fontWeight: FontWeight.normal)),
              onTap: () {
                Navigator.push(
                  context,
                  PageTransition(
                      type: PageTransitionType.fade,
                      child : Charte()),
                );
              }),
          ListTile(
              //leading: Icon(Icons.contact_mail),
              title: Text("Nous contacter",
                  style: TextStyle(
                      fontFamily: "Arial",
                      fontSize: 17,
                      fontWeight: FontWeight.normal)),
              onTap: () {
                Navigator.push(
                    context,
                    PageTransition(
                    type: PageTransitionType.fade,
                    child : ContactPage()),
                );
              }),
          ListTile(
              //leading: Icon(Icons.contact_mail),
              title: Text("Newsletter",
                  style: TextStyle(
                      fontFamily: "Arial",
                      fontSize: 17,
                      fontWeight: FontWeight.normal)),
              onTap: () {
                Navigator.push(
                    context,
                    PageTransition(
                    type: PageTransitionType.fade,
                    child : NewsLetterPage()),
                );
              }),
          ListTile(
              //leading: Icon(Icons.settings),
              title: Text("Paramètres",
                  style: TextStyle(
                      fontFamily: "Arial",
                      fontSize: 17,
                      fontWeight: FontWeight.normal)),
              onTap: () {
                Navigator.push(
                    context,
                    PageTransition(
                    type: PageTransitionType.fade,
                    child : SettingsPage()),
                );
              }),
        ],
      ),
    );
  }

  Widget _setConnectButton() {
    return !widget.isConnect
        ? ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.login,
                  color: Colors.black,
                ),
                SizedBox(width: 10),
                Container(
                  padding: EdgeInsets.only(top: 4.0),
                  child: Text("Se connecter",
                      style: TextStyle(
                          fontFamily: "DINNextLTPro-MediumCond",
                          fontSize: 15,
                          fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            onTap: () => login(),
          )
        : ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.person,
                  color: Colors.black,
                ),
                SizedBox(width: 10),
                Text("Mon  compte",
                    style: TextStyle(
                        fontFamily: "DINNextLTPro-MediumCond",
                        fontSize: 15,
                        fontWeight: FontWeight.bold)),
              ],
            ),
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AccountPage(user: widget.user))),
          );
  }

  //FONCTIONS
  bool isConnected;
  var cpt = 0;
  login() async {
    if (OverlayScreen().state == Screen.none) {
      OverlayScreen().show(
        context,
        identifier: 'login',
      );
      //print('-------------------------------------------------------------------> 0');
    }
    //Navigator.push(context, MaterialPageRoute(builder: (context)=>ToConnect(isArticle: false)));
  }

  logout() async {
    await FirebaseAuth.instance.signOut();
    checkUser();
  }

  checkUser() async {
    if (await FirebaseAuth.instance.currentUser != null) {
      setState(() {
        isConnected = true;
      });
    } else {
      setState(() {
        isConnected = false;
      });
    }
  }
}
