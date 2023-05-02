class Country {
  const Country({required this.code, required this.name});

  /// Country Name
  final String name;

  /// 2 letter Country Code, i.e ZA
  final String code;

  $toMap() => {"name": name, "code": code};

  String get flag {
    return code.toUpperCase().replaceAllMapped(RegExp(r'[A-Z]'),
        (match) => String.fromCharCode(match.group(0)!.codeUnitAt(0) + 127397));
  }

  @override
  String toString() {
    return '"name": $name, "code": $code';
  }
}
