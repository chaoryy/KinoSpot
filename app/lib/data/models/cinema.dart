class Cinema {
  final int id;
  final String name;
  final String address;

  const Cinema({
    required this.id,
    required this.name,
    required this.address
  });

  factory Cinema.fromJson(Map<String, dynamic> json) {
    return Cinema(
        id: json['id'] as int,
        name: json['name'] as String,
        address: json['address'] as String,
    );
  }
}