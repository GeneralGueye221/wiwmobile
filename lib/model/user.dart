class Utilisateur {
   String id;
   String pseudo;
   var pp;
   String numberphone;
   String email;
   String password;

  Utilisateur({this.id,this.email, this.pp, this.password, this.numberphone, this.pseudo});

  factory Utilisateur.fromJSON(Map<String, dynamic> json) {
     return Utilisateur(
        id: json['uid'],
        pseudo: json['pseudo'],
        pp: json['pp'],
        numberphone: json['numberPhone'],
        email: json['email'],
        password: json['password']
     );
  }

  Map<String, dynamic> toJson() =>
       {
         'uid': id,
         'pseudo': pseudo,
         'pp': pp,
         'numberPhone': numberphone,
         'email': email,
         'password':password,
       };
}