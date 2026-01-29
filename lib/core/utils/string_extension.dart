extension StringCasingExtension on String {
  String get capitalize {
    if (isEmpty) return "";
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }

  // Bonus: Capitalize every word (Title Case)
  String get capitalizeFirstofEach => split(" ")
      .map((str) => str.capitalize)
      .join(" ");
}