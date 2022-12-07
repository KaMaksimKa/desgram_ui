class DateTimeHelper {
  static String getRuShortMonth(int numberMonth) {
    switch (numberMonth) {
      case 1:
        return "янв.";
      case 2:
        return "февр.";
      case 3:
        return "март";
      case 4:
        return "апр.";
      case 5:
        return "май";
      case 6:
        return "июнь";
      case 7:
        return "июль";
      case 8:
        return "авг.";
      case 9:
        return "сент.";
      case 10:
        return "окт.";
      case 11:
        return "нояб.";
      case 12:
        return "дек.";
    }
    return "";
  }

  static String convertDateToRusFormat(DateTime datetime) {
    return "${datetime.day} ${getRuShortMonth(datetime.month)} ${datetime.year} г.";
  }
}
