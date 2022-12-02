class Category {
  final nom, id;
  Category({this.nom, this.id});
}

List<Category> categories = [
  Category(id: 0, nom: "à la une"),
  Category(id: 63, nom: "football"),
  Category(id: 75, nom: "basket"),
  Category(id: 0, nom: "lamb"),
  Category(id: 4, nom: "combat"),
  Category(id: 5, nom: "athlétisme"),
  Category(id: 6, nom: "tennis"),
  Category(id: 7, nom: "handball"),
  Category(id: 8, nom: "volley-ball"),
  Category(id: 9, nom: "rugby"),
  Category(id: 10, nom: "auto-moto"),
  Category(id: 11, nom: "cyclisme"),
  Category(id: 12, nom: "natation"),
  Category(id: 13, nom: "roller"),
  Category(id: 14, nom: "golf"),
  Category(id: 15, nom: "olympisme"),
  Category(id: 16, nom: "e-sport"),
  Category(id: 17, nom: "autres/omnisport"),
];

List<Category> categories_explorer = [
  Category(id: 0, nom: "nouveautés"),
  Category(id: 63, nom: "LIVE"),
  Category(id: 75, nom: "wiwsport TV"),
];

List<Category> categories_salon = [
  //Category(id:0, nom: "tendances"),
  Category(id:1, nom: "  récents  "),
  Category(id:3, nom: "mes discussions"),
];