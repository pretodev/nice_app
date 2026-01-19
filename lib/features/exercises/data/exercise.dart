class Exercise {
  final String name;
  final List<String> muscles;

  const Exercise({required this.name, required this.muscles});

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      name: json['name'] as String,
      muscles: (json['muscles'] as List<dynamic>).cast<String>(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'muscles': muscles};
  }

  @override
  String toString() => 'Exercise(name: $name, muscles: $muscles)';
}
