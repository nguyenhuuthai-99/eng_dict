class Example {
  String? _toGoWith;
  String? _example;

  Example();

  factory Example.fromJson(Map<String, dynamic> json) {
    return Example()
      .._example = json['example']
      .._toGoWith = json['toGoWith'];
  }

  String? get example => _example;

  set example(String? value) {
    _example = value;
  }

  String? get toGoWith => _toGoWith;

  set toGoWith(String? value) {
    _toGoWith = value;
  }
}
