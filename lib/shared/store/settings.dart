class SettingsValue {
  int gap = 0;
  int padding = 0;

  SettingsValue({required this.gap, required this.padding});

  static SettingsValue fromMap(Map data) {
    return SettingsValue(
      gap: data['gap'] ?? 0.0,
      padding: data['padding'] ?? 0.0,
    );
  }

  Map toMap() {
    return {
      'padding': padding,
      'gap': gap,
    };
  }
}
