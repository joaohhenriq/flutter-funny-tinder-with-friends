final List<Profile> demoProfiles = [
  new Profile(
    photos: [
      "assets/joao.jpeg",
    ],
    name: "João",
    bio: "Big boss"
  ),
  new Profile(
      photos: [
        "assets/lucas.jpeg",
        "assets/lucas2.jpeg",
      ],
      name: "Bruno",
      bio: "Treinee"
  ),
  new Profile(
      photos: [
        "assets/coro.jpeg",
        "assets/coro2.jpeg",
      ],
      name: "Coró",
      bio: "Scroll Master"
  ),
  new Profile(
      photos: [
        "assets/maurim.jpeg",
        "assets/maurim2.jpeg",
      ],
      name: "Maurim",
      bio: "Flutter Master"
  ),
  new Profile(
      photos: [
        "assets/robson.jpeg",
      ],
      name: "Robson",
      bio: "K K K J"
  ),
  new Profile(
      photos: [
        "assets/rogerio.jpeg",
      ],
      name: "Rogério",
      bio: "Water box"
  ),
  new Profile(
      photos: [
        "assets/sergio.jpeg",
      ],
      name: "Sérgio",
      bio: "Incredible rosca"
  ),
  new Profile(
      photos: [
        "assets/tonhao.jpeg",
      ],
      name: "Tonhão",
      bio: "Opa!"
  ),
  new Profile(
      photos: [
        "assets/estagiario.jpeg",
      ],
      name: "Estagiário",
      bio: "Young stupid padawan"
  ),
];

class Profile {
  final List<String> photos;
  final String name;
  final String bio;

  Profile({this.photos, this.name, this.bio});
}