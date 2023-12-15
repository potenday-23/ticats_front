extension OrdinalDate on DateTime {
  String toOrdinalDate() {
    final day = this.day;

    String suffix = 'TH';
    final int digit = day % 10;

    if ((digit > 0 && digit < 4) && (day < 11 || day > 13)) {
      suffix = ['ST', 'ND', 'RD'][digit - 1];
    }
    return '$day$suffix';
  }
}
