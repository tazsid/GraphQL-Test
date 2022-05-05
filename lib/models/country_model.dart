class Countries {
  String? code;
  String? name;
  String? native;
  String? phone;
  String? currency;

  Countries({this.code, this.name, this.native, this.phone, this.currency});

  Countries.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    name = json['name'];
    native = json['native'];
    phone = json['phone'];
    currency = json['currency'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['name'] = name;
    data['native'] = native;
    data['phone'] = phone;
    data['currency'] = currency;
    return data;
  }
}
