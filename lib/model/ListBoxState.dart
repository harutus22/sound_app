class ListBoxState{
  final String title;
  final String image;
  bool value;

  ListBoxState(
  {
    required this.title,
    required this.image,
    this.value = false
  });
}