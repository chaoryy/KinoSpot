enum Genre {
  ACTION,
  COMEDY,
  DRAMA,
  SCIFI,
  FANTASY,
  HORROR,
  THRILLER,
  ROMANCE,
  ADVENTURE;

  static Genre fromJson(String value) {
    return Genre.values.firstWhere(
        (e) => e.name.toLowerCase() == value.toLowerCase(),
    );
  }
}