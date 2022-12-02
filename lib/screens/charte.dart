import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:wiwmedia_wiwsport_v3/model/user.dart';

import 'menu/page_newsletter.dart';

class Charte extends StatelessWidget {

  final Utilisateur user;
  final bool isUser;
  Charte({this.isUser, this.user});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          iconSize: 24,
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          Container(
            margin: const EdgeInsets.fromLTRB(3.0, 15.0, 9.0, 15.0),
            padding: const EdgeInsets.fromLTRB(3, 1, 3, 3),
            decoration: BoxDecoration(
              border: Border.all(color: Color(0xFFabd9c2), width: 1),
              color: Color(0xFFabd9c2),
            ),
            child: InkWell(
              onTap: () {
                return Navigator.push(
                  context,
                  MaterialPageRoute(
                      settings: RouteSettings(name: 'newsletter'),
                      builder: (BuildContext context) {
                        return NewsLetterPage();
                      },
                      fullscreenDialog: true),
                );
              },
              child: Text(" s'abonner ",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                    fontFamily: "DINNextLTPro-MediumCond",
                    color: Colors.black,
                  )),
            ),
          ),
        ],
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Container(
          alignment: Alignment.topLeft,
          child: Column(
            children: [
              Text(
                "Charte des commentaires aux publications wiwsport",
                style: TextStyle(
                    fontFamily: "DINNextLTPro-MediumCond", fontSize: 25, fontWeight: FontWeight.bold),
                textAlign: TextAlign.start,
              ),
              SizedBox(height: 15),
              Text(
                "Vous êtes nombreux à contribuer, débattre et donner votre avis sur nos différents contenus et nous sommes heureux de recevoir vos contributions et réactions qui enrichissent nos publications.",
                style: TextStyle(
                    fontFamily: "DINNextLTPro-MediumCond", fontSize: 15,  fontWeight: FontWeight.normal),
                textAlign: TextAlign.start,
              ),
              SizedBox(height: 15),
              Text(
                " Afin que les plateformes wiwsport reste des lieux d'échange et de dialogue respectueux, découvrez les critères de modération appliqués aux commentaires. ",
                style: TextStyle(
                    fontFamily: "DINNextLTPro-MediumCond", fontSize: 15, fontWeight: FontWeight.normal),
              textAlign: TextAlign.start,
              ),
              SizedBox(height: 15),
              Container(
                alignment: Alignment.topLeft,
                child: Text(
                  "1. A quoi servent les commentaires wiwsport ",
                  style: TextStyle(
                      fontFamily: "DINNextLTPro-MediumCond", fontSize: 15, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.start,
                ),
              ),
              SizedBox(height: 15),
              Text(
                "Les commentaires permettent aux lecteurs du site et de l'application L'Équipe de donner leur point de point de vue et d'enrichir les débats et discussions relatifs au contenu sur lequel ils réagissent. Chaque contribution est encouragée dans un esprit de débat constructif et dans le respect de la liberté d'expression. ",
                style: TextStyle(
                    fontFamily: "DINNextLTPro-MediumCond", fontSize: 15, fontWeight: FontWeight.normal),
              textAlign: TextAlign.start,
              ),
              SizedBox(height: 15),
              Container(
                alignment: Alignment.topLeft,
                child: Text(
                  "2. Qui peut écrire un commentaire ?",
                  style: TextStyle(
                      fontFamily: "DINNextLTPro-MediumCond", fontSize: 15, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.start,
                ),
              ),
              SizedBox(height: 15),
              Text(
                "Toute personne disposant d'un compte numérique sur le site ou l'application wiwsport peut écrire un commentaire à la suite d'un contenu publié. La contribution sera associée au pseudonyme de l'auteur et la date de publication. Il est important de noter que les pseudonymes sont soumis aux mêmes critères de modération que les commentaires.",
                style: TextStyle(
                    fontFamily: "DINNextLTPro-MediumCond", fontSize: 15, fontWeight: FontWeight.normal),
              textAlign: TextAlign.start,
              ),
              SizedBox(height: 15),
              Text(
                "3. Dans quels cas un commentaire peut-il être supprimé ?",
                style: TextStyle(
                    fontFamily: "DINNextLTPro-MediumCond", fontSize: 15, fontWeight: FontWeight.bold),
              textAlign: TextAlign.start,
              ),
              SizedBox(height: 15),
              Text(
                '''Les commentaires doivent être respectueux et conformes. Ainsi seront supprimés ou non publiés :

     •	les propos contraires à l'ordre public et aux bonnes mœurs, à caractère nuisible, menaçant, abusif, constitutif de harcèlement, vulgaire, obscène, haineux ;
     •	les contributions insultantes, diffamatoires, racistes, sexistes, discriminantes ou misogynes ;
     •	les incitations aux crimes, aux délits ou au suicide ;
     •	les incitations au tabagisme, à la consommation d'alcool ou à la consommation de substances faisant l'objet d'une interdiction législative ;
     •	les contributions à caractères politiques ou religieux ;
     •	les contributions portant atteinte d'une quelconque manière aux mineurs ;
     •	les contributions susceptibles de dévaloriser ou ridiculiser une personnalité, un journaliste, un utilisateur ou toute autre personne. Les propos peuvent être critiques dans la mesure où ils sont argumentés et portent sur un fait et non une personne.
     •	les propos agressifs, dirigés à l'encontre d'une marque, d'un produit, d'un organisme ou d'une personne ;
     •	les contributions dévoilant des coordonnées personnelles, telles que les nom et prénom, l'adresse postale, l'email, le numéro de téléphone ou toute autre information permettant l'identification manifeste d'un individu ;
     •	les propos incompréhensibles, par leur grammaire, syntaxe, ou l'usage d'une langue ou d'un style de langage ne permettant pas une compréhension immédiate du propos ;
     •	les contributions promotionnelles et à caractère publicitaire ;
     •	les liens vers des sites internet ;
     •	les commentaires en réponse à une contribution qui aurait été supprimée pour l'une des raisons précédemment citées.
                  
Les propos tenus par un utilisateur dont le pseudonyme serait usurpé, irrespectueux ou tombant dans l'une des catégories évoquées ci-dessus seront également supprimés.
                  
Les équipes de modération de wiwsport se réservent le droit de supprimer tout commentaire qu'elles considéreraient comme déplacé ou contraire à l'esprit et aux valeurs du site. En cas d'abus répétés ou de multiplication de contributions inappropriées, les utilisateurs pourront se voir avertir d'une éventuelle suspension de leur compte.
                ''',
                style: TextStyle(
                    fontFamily: "DINNextLTPro-MediumCond", fontSize: 15, fontWeight: FontWeight.normal),
              textAlign: TextAlign.start,
              ),
              SizedBox(height: 15),
              Container(
                alignment: Alignment.topLeft,
                child: Text(
                  "4. Puis-je modifier un commentaire ?",
                  style: TextStyle(
                      fontFamily: "DINNextLTPro-MediumCond", fontSize: 15, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.start,
                ),
              ),
              SizedBox(height: 15),
              Text(
                "Une fois votre commentaire publié, il n'est plus possible de l'éditer pour en modifier le contenu.",
                style: TextStyle(
                    fontFamily: "DINNextLTPro-MediumCond", fontSize: 15, fontWeight: FontWeight.normal),
              textAlign: TextAlign.start,
              ),
              SizedBox(height: 15),
              Text(
                "5. Je constate des abus dans les commentaires d'un autre utilisateur, que faire ?",
                style: TextStyle(
                    fontFamily: "DINNextLTPro-MediumCond", fontSize: 15, fontWeight: FontWeight.bold),
              textAlign: TextAlign.start,
              ),
              SizedBox(height: 15),
              Text(
                "Si vous observez un comportement inapproprié ou ne répondant pas aux points évoqués ci-dessus, vous pouvez le signaler aux équipes de modération en cliquant sur le drapeau présent à droite du commentaire en question. Les équipes de modération examineront alors en priorité la teneur du propos et pourront procéder, si le caractère inapproprié est confirmé, à sa suppression.",
                style: TextStyle(
                    fontFamily: "DINNextLTPro-MediumCond", fontSize: 15, fontWeight: FontWeight.normal),
              textAlign: TextAlign.start,
              ),
              SizedBox(height: 15),Text(
                "Notez cependant que l'espace de commentaires est un lieu de débat où peuvent intervenir des divergences d'opinion. Si vous n'êtes pas en accord avec un propos mais que celui-ci n'enfreint aucune règle de modération, il ne sera pas supprimé.",
                style: TextStyle(
                    fontFamily: "DINNextLTPro-MediumCond", fontSize: 15, fontWeight: FontWeight.normal),
              textAlign: TextAlign.start,
              ),
              SizedBox(height: 15),
              Container(
                alignment: Alignment.topLeft,
                child: Text(
                  "6. J'ai des questions sur la modération",
                  style: TextStyle(
                      fontFamily: "DINNextLTPro-MediumCond", fontSize: 15, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.start,
                ),
              ),
              SizedBox(height: 15),
              Text(
                "Pour toute question sur l'espace des commentaires, contactez l'adresse contact@wiwsport.com.",
                style: TextStyle(
                    fontFamily: "DINNextLTPro-MediumCond", fontSize: 15, fontWeight: FontWeight.normal),
              textAlign: TextAlign.start,
              ),
              SizedBox(height: 30),
              Container(
                alignment: Alignment.topLeft,
                child: Text(
                  "publié le 17 août 2021",
                  style: TextStyle(
                      fontFamily: "DINNextLTPro-MediumCond", fontSize: 15, fontWeight: FontWeight.normal),
                  textAlign: TextAlign.start,
                ),
              ),
              SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }
}
