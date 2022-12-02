import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wiwmedia_wiwsport_v3/model/categories.dart';

import 'package:wiwmedia_wiwsport_v3/pages/landings/landing_page_explorer.dart';
import 'package:wiwmedia_wiwsport_v3/reusable/CustomSearchDelegate.dart';
//import 'package:wiwmedia_wiwsport_v3/screens/menu/page_newsletter.dart';

import '../MyDrawer.dart';
import 'HomePage.dart';
import 'ResearchPage.dart';
import 'ForumPage.dart';


class ExplorerPage extends StatefulWidget {
  @override
  _ExplorerPageState createState() => _ExplorerPageState();
}

class _ExplorerPageState extends State<ExplorerPage> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();


  int _selectedIndex=1;
  void _onSwitchPage(int selectedIndex) {
    if(selectedIndex==0) {
      setState(() {
        _selectedIndex =selectedIndex;
      });
      Navigator.pop(context);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) {
                return HomePage();
              }
          )
      );
    }
    if(selectedIndex==1) {
      setState(() {
        _selectedIndex =selectedIndex;
      });
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) {
                return ExplorerPage();
              }
          )
      );
    }
    if(selectedIndex==2) {
      setState(() {
        _selectedIndex =selectedIndex;
      });
      Navigator.pop(context);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) {
                return ResearchPage();
              }
          )
      );
    }
    if(selectedIndex==3) {
      setState(() {
        _selectedIndex =selectedIndex;
      });
      Navigator.pop(context);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) {
                return Salon();
              }
          )
      );
    }

  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: categories_explorer.length,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Center(
            child: Text(
            "Explorer",
            style: TextStyle(
                color: Colors.black,
                fontFamily: "Roboto",
                fontSize: 17,
                fontWeight: FontWeight.bold
            ),
          ),
          ),
          actions: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Builder(
                builder: (context) =>
                    IconButton(
                      icon: SvgPicture.asset(
                        "assets/icons/search.svg",
                        height: 17,
                        width: 35,
                      ),
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(
                                builder: (context) => CustomSearchDelegate()));
                      },
                    ),
              ),
            ),
          ],
          bottom: PreferredSize(
            preferredSize: new Size(35, 35),
            child: TabBar(
              labelPadding:
              EdgeInsets.only(left: 5, right: 15, top: 0.0, bottom: 7),
              indicatorSize: TabBarIndicatorSize.label,
              isScrollable: true,
              indicator: UnderlineTabIndicator(),
              labelColor: Colors.black,
              labelStyle: TextStyle(
                  fontFamily: "DINNextLTPro-MediumCond",
                  fontSize: 15,
                  fontWeight: FontWeight.bold),
              unselectedLabelColor: Colors.black45,
              unselectedLabelStyle: TextStyle(
                  fontFamily: "DINNextLTPro-MediumCond",
                  fontSize: 15,
                  fontWeight: FontWeight.normal),
              tabs: List.generate(
                  categories_explorer.length,
                      (index) =>
                      Text(
                        categories_explorer[index].nom,
                      )),
            ),
          ),
          //backgroundColor: currentIndex == 3 ? Color(0xffF7F8FA) : Colors.white,
          backgroundColor: Color(0xffF7F8FA),
          elevation: 8,
          centerTitle: false,
          titleSpacing: 0,
          iconTheme: IconThemeData(color: Colors.black54),
        ),
        drawer: TheDrawer(),
        body: TabBarView(
          children: [
            LandingPageNews(),
            LandingPageBuzz(),
            LandingPageFoot(),
            LandingPageBasket(),
            LandingPageCombat(),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          onTap: _onSwitchPage,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                  Icons.home,
                  color: _selectedIndex ==0 ? Colors.teal: Colors.grey
              ),
              title: Text('A la une', style: TextStyle(color:_selectedIndex ==0 ? Colors.teal: Colors.grey,fontSize: 9)),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                  Icons.explore_rounded,
                  color: _selectedIndex ==1 ? Colors.teal: Colors.grey
              ),
              title: Text('Explorer', style: TextStyle(color:_selectedIndex ==1 ? Colors.teal: Colors.grey,fontSize: 9)),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                  Icons.search,
                  color: _selectedIndex ==2 ? Colors.teal: Colors.grey
              ),
              title: Text('Rechercher', style: TextStyle(color:_selectedIndex ==2 ? Colors.teal: Colors.grey,fontSize: 9)),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                  Icons.group,
                  color: _selectedIndex ==3 ? Colors.teal: Colors.grey
              ),
              title: Text("Salon", style: TextStyle(color:_selectedIndex ==3 ? Colors.teal: Colors.grey,fontSize: 9)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _render() {
    return Column(
      children: [
        Center(
          child: AdmobBanner(
            adUnitId: 'ca-app-pub-9120523919163473/2499635678',
            adSize: AdmobBannerSize.LARGE_BANNER,
          ),
        ),

      ],
    );
  }
}
