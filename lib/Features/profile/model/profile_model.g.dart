// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProfileModelAdapter extends TypeAdapter<ProfileModel> {
  @override
  final int typeId = 5;

  @override
  ProfileModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProfileModel(
      address: fields[0] as Address?,
      id: fields[1] as int?,
      email: fields[2] as String?,
      username: fields[3] as String?,
      password: fields[4] as String?,
      name: fields[5] as Name?,
      phone: fields[6] as String?,
      iV: fields[7] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, ProfileModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.address)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.username)
      ..writeByte(4)
      ..write(obj.password)
      ..writeByte(5)
      ..write(obj.name)
      ..writeByte(6)
      ..write(obj.phone)
      ..writeByte(7)
      ..write(obj.iV);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProfileModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AddressAdapter extends TypeAdapter<Address> {
  @override
  final int typeId = 6;

  @override
  Address read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Address(
      geolocation: fields[0] as Geolocation?,
      city: fields[1] as String?,
      street: fields[2] as String?,
      number: fields[3] as int?,
      zipcode: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Address obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.geolocation)
      ..writeByte(1)
      ..write(obj.city)
      ..writeByte(2)
      ..write(obj.street)
      ..writeByte(3)
      ..write(obj.number)
      ..writeByte(4)
      ..write(obj.zipcode);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AddressAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class GeolocationAdapter extends TypeAdapter<Geolocation> {
  @override
  final int typeId = 7;

  @override
  Geolocation read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Geolocation(
      lat: fields[0] as String?,
      long: fields[1] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Geolocation obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.lat)
      ..writeByte(1)
      ..write(obj.long);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GeolocationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class NameAdapter extends TypeAdapter<Name> {
  @override
  final int typeId = 8;

  @override
  Name read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Name(
      firstname: fields[0] as String?,
      lastname: fields[1] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Name obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.firstname)
      ..writeByte(1)
      ..write(obj.lastname);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NameAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
