final List<Profile> demoProfiles = [
  new Profile(
    photos: [
      "assets/joao.jpeg",
    ],
    name: "João",
    bio: "Software Engineer"
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
      bio: "Treinee"
  ),
];

class Profile {
  final List<String> photos;
  final String name;
  final String bio;

  Profile({this.photos, this.name, this.bio});
}