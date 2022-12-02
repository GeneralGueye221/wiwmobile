import 'dart:async';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:ads/ads.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:wiwmedia_wiwsport_v3/pages/HomePage.dart';


import 'package:uni_links/uni_links.dart';
import 'package:uni_links/uni_links.dart' as UniLink;
import 'package:flutter/widgets.dart';
import 'package:wiwmedia_wiwsport_v3/services/current_user.dart';


Future<void> main() async {
  //Admob.initialize("ca-app-pub-3940256099942544~3347511713");
  WidgetsFlutterBinding.ensureInitialized();
  Admob.initialize("ca-app-pub-9120523919163473~3676757066");
  await Firebase.initializeApp();

  checkDeepLink();
  runApp(wiwmobile());
}

Future checkDeepLink() async {
  StreamSubscription _sub;
  try {
    print("checkDeepLink");
    await UniLink.getInitialLink();
    _sub = UniLink.getUriLinksStream().listen((Uri uri) {
      print('uri: $uri');
      WidgetsFlutterBinding.ensureInitialized();
      runApp(wiwmobile(url: uri));
    }, onError: (err) {
      // Handle exception by warning the user their action did not succeed

      print("onError");
    });
  } on PlatformException {
    print("PlatformException");
  } on Exception {
    print('Exception thrown');
  }
}

class wiwmobile extends StatefulWidget {
  final url;

  wiwmobile({this.url});

  @override
  _wiwmobileState createState() => _wiwmobileState();
}
class _wiwmobileState extends State<wiwmobile> {

  static FirebaseAnalytics analytics = new FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer =
  new FirebaseAnalyticsObserver(analytics: analytics);

  //Ads ads = Ads("ca-app-pub-9120523919163473~3676757066");
  InterstitialAd _interstitial;
  InterstitialAd createIntertitial(){
    return InterstitialAd(
        adUnitId: 'ca-app-pub-9120523919163473/8396114161',
        //'ca-app-pub-3940256099942544/1033173712', TEST
        listener: (MobileAdEvent event){
          if(event == MobileAdEvent.opened) {
            setState(()=>showads=false);
          print("======================================================> PUB LOADED !");
          }
          if(event == MobileAdEvent.failedToLoad) {
            setState(()=>showads=false);
          print("======================================================> ERROR ON PUB LOADING !");
          }
        }
    );
  }
  bool showads = true;


  @override
  void initState() { 
    super.initState();
    FirebaseAdMob.instance.initialize(appId:"ca-app-pub-9120523919163473~3676757066");
    if(showads == true){
     // createIntertitial()..load()..show();
    }    
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool launch = true;
    OneSignal.shared.init('d09d7444-d427-4340-a940-86f500566f9d');
    OneSignal.shared.setInFocusDisplayType(
        OSNotificationDisplayType.notification);


    return ChangeNotifierProvider(
      create: (context) => CurrentUser(),
      child: MaterialApp(
        title: 'WIWSPORT',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          iconTheme: IconThemeData(color: Colors.white24),
          primarySwatch: Colors.teal,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        navigatorObservers: [observer],
        home: StreamBuilder(
          stream: getLinksStream(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              // our app started by configured links// we retrieve all query parameters , tzd://genius-team.com?product_id=1
              return HomePage(analytics: analytics,
                observer: observer,
                goto: widget.url.toString(),
                launched: true,);
              // we just print all //parameters but you can now do whatever you want, for example open //product details page.
            } else {
              // our app started normally
              return HomePage(analytics: analytics,
                observer: observer,
                goto: null,
                launched: true,);
            }
          },
        ),
      ),
    );
    
  }
}







