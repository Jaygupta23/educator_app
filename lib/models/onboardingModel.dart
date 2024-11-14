class UnbordingContent {
  String title;
  String discription;
  String image;

  UnbordingContent(
      {required this.title, required this.image, required this.discription});
}

List<UnbordingContent> contents = [
  UnbordingContent(
      image: 'assets/images/e3.png',
      title: 'Unlimited\ncourses, shorts\nlearning & more',
      discription: "Watch Edureelies anywhere. Cancel at any\ntime"),
  UnbordingContent(
      image: 'assets/images/e2.png',
      title: 'Watch shorts\n new thoughts, ideas\ncreativity',
      discription: "Watch Edreelies anywhere. Cancel at any\ntime "),
  UnbordingContent(
      image: 'assets/images/e4.png',
      title: 'Watch shorts\n new thoughts, ideas\ncreativity',
      discription: "Watch Edureelies anywhere. Cancel at any\ntime"),
];
