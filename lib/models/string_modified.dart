extension StringExtension on String {
    String sentenceCase() {
      return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
    }
}