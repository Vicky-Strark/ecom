import 'package:hive/hive.dart';

part 'profile_model.g.dart'; // This file will be generated

@HiveType(typeId: 5)
class ProfileModel {
  @HiveField(0)
  Address? address;

  @HiveField(1)
  int? id;

  @HiveField(2)
  String? email;

  @HiveField(3)
  String? username;

  @HiveField(4)
  String? password;

  @HiveField(5)
  Name? name;

  @HiveField(6)
  String? phone;

  @HiveField(7)
  int? iV;

  ProfileModel({
    this.address,
    this.id,
    this.email,
    this.username,
    this.password,
    this.name,
    this.phone,
    this.iV,
  });

  ProfileModel.fromJson(Map<String, dynamic> json) {
    address = json['address'] != null ? Address.fromJson(json['address']) : null;
    id = json['id'];
    email = json['email'];
    username = json['username'];
    password = json['password'];
    name = json['name'] != null ? Name.fromJson(json['name']) : null;
    phone = json['phone'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (address != null) {
      data['address'] = address!.toJson();
    }
    data['id'] = id;
    data['email'] = email;
    data['username'] = username;
    data['password'] = password;
    if (name != null) {
      data['name'] = name!.toJson();
    }
    data['phone'] = phone;
    data['__v'] = iV;
    return data;
  }
}

@HiveType(typeId: 6)
class Address {
  @HiveField(0)
  Geolocation? geolocation;

  @HiveField(1)
  String? city;

  @HiveField(2)
  String? street;

  @HiveField(3)
  int? number;

  @HiveField(4)
  String? zipcode;

  Address({
    this.geolocation,
    this.city,
    this.street,
    this.number,
    this.zipcode,
  });

  Address.fromJson(Map<String, dynamic> json) {
    geolocation = json['geolocation'] != null
        ? Geolocation.fromJson(json['geolocation'])
        : null;
    city = json['city'];
    street = json['street'];
    number = json['number'];
    zipcode = json['zipcode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (geolocation != null) {
      data['geolocation'] = geolocation!.toJson();
    }
    data['city'] = city;
    data['street'] = street;
    data['number'] = number;
    data['zipcode'] = zipcode;
    return data;
  }
}

@HiveType(typeId: 7)
class Geolocation {
  @HiveField(0)
  String? lat;

  @HiveField(1)
  String? long;

  Geolocation({this.lat, this.long});

  Geolocation.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    long = json['long'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['lat'] = lat;
    data['long'] = long;
    return data;
  }
}

@HiveType(typeId: 8)
class Name {
  @HiveField(0)
  String? firstname;

  @HiveField(1)
  String? lastname;

  Name({this.firstname, this.lastname});

  Name.fromJson(Map<String, dynamic> json) {
    firstname = json['firstname'];
    lastname = json['lastname'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['firstname'] = firstname;
    data['lastname'] = lastname;
    return data;
  }
}