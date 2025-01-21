class Example {
  String? _toGoWith;
  String? _code;
  String? _example;

  Example();

  factory Example.fromJson(Map<String, dynamic> json) {
    return Example()
      .._example = json['example']
      .._toGoWith = json['toGoWith']
      .._code = json['code'];
  }

  String? get example => _example;

  set example(String? value) {
    _example = value;
  }

  String? get toGoWith => _toGoWith;

  set toGoWith(String? value) {
    _toGoWith = value;
  }

  String? get code => _code;

  set code(String? value) {
    _code = value;
  }
}
