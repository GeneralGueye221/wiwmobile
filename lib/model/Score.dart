class ScorreMatch {}
class Fixature {}
//
class Statue {}

//TEAM data
class Team {
  int id;
  String name;
  String logo;

    

}

//GOAL data
class Goal {
  int home;
  int away;
  Goal(home, away);

  factory Goal.fromJson(Map<String, dynamic>json) {
    return Goal(json['home'], json['away']);
  }
}
