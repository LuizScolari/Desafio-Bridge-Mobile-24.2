final _numberPattern = RegExp(r'\B(?=(\d{3})+(?!\d))');

String formatNumber(int number) {
  return number.toString().replaceAll(_numberPattern, '.');
}
