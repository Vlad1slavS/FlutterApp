class SumResult {
  final int sum;
  final bool ignoredWords;
  SumResult(this.sum, this.ignoredWords);
}

class NumberSummer {
  /// Суммирует числа из текста до первого встреченного отрицательного числа.
  /// Если встречаются нечисловые токены, они игнорируются, а флаг ignoredWords устанавливается в true.
  static SumResult sumNumbers(String text) {
    int sum = 0;
    bool ignoredWords = false;
    final tokens = text.split(RegExp(r'\s+'));
    for (final token in tokens) {
      if (token.isEmpty) continue;
      try {
        final number = int.parse(token);
        if (number < 0) break;
        sum += number;
      } catch (e) {
        // Если токен не является числом, отмечаем, что были слова
        ignoredWords = true;
        continue;
      }
    }
    return SumResult(sum, ignoredWords);
  }
}
