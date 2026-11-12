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

  String get russianName {
    switch (this) {
      case Genre.ACTION: return 'Боевик';
      case Genre.COMEDY: return 'Комедия';
      case Genre.DRAMA: return 'Драма';
      case Genre.SCIFI: return 'Научная фантастика';
      case Genre.FANTASY: return 'Фантастика';
      case Genre.HORROR: return 'Хоррор';
      case Genre.THRILLER: return 'Триллер';
      case Genre.ROMANCE: return 'Романтика';
      case Genre.ADVENTURE: return 'Приключения';
    }
  }

  static Genre fromJson(String value) {
    return Genre.values.firstWhere(
          (e) => e.name.toLowerCase() == value.toLowerCase(),
      orElse: () => Genre.ACTION,
    );
  }
}