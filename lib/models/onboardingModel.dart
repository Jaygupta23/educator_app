class UnbordingContent {
  String title;
  String discription;
  String image;

  UnbordingContent(
      {required this.title, required this.image, required this.discription});
}

List<UnbordingContent> contents = [
  UnbordingContent(
      image: 'assets/images/onBoard1.png',
      title: 'Unlimited\nmovies, TV\nshows & more',
      discription: "Watch Reelies anywhere. Cancel at any\ntime"),
  UnbordingContent(
      image: 'assets/images/onBoard2.png',
      title: 'Watch movies\n TV, Virtual\nReality',
      discription: "Watch Reelies anywhere. Cancel at any\ntime "),
  UnbordingContent(
      image: 'assets/images/onBoard3.png',
      title: 'Watch movies\n TV, Virtual\nReality',
      discription: "Watch Reelies anywhere. Cancel at any\ntime"),
];
