// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shop_profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ShopProfile {

 String get name;/// GST state code, e.g. `27` for Maharashtra.
 String get stateCode; String? get phone; String? get addressLine; String? get city; String? get pincode; String? get gstin; String? get logoPath;
/// Create a copy of ShopProfile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ShopProfileCopyWith<ShopProfile> get copyWith => _$ShopProfileCopyWithImpl<ShopProfile>(this as ShopProfile, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ShopProfile;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ShopProfile&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.stateCode, _this.stateCode) || other.stateCode == _this.stateCode)&&(identical(other.phone, _this.phone) || other.phone == _this.phone)&&(identical(other.addressLine, _this.addressLine) || other.addressLine == _this.addressLine)&&(identical(other.city, _this.city) || other.city == _this.city)&&(identical(other.pincode, _this.pincode) || other.pincode == _this.pincode)&&(identical(other.gstin, _this.gstin) || other.gstin == _this.gstin)&&(identical(other.logoPath, _this.logoPath) || other.logoPath == _this.logoPath));
}


@override
int get hashCode {
  final _this = this as ShopProfile;
  return Object.hash(runtimeType,_this.name,_this.stateCode,_this.phone,_this.addressLine,_this.city,_this.pincode,_this.gstin,_this.logoPath);
}

@override
String toString() {
  final _this = this as ShopProfile;
  return 'ShopProfile(name: ${_this.name}, stateCode: ${_this.stateCode}, phone: ${_this.phone}, addressLine: ${_this.addressLine}, city: ${_this.city}, pincode: ${_this.pincode}, gstin: ${_this.gstin}, logoPath: ${_this.logoPath})';
}


}

/// @nodoc
abstract mixin class $ShopProfileCopyWith<$Res>  {
  factory $ShopProfileCopyWith(ShopProfile value, $Res Function(ShopProfile) _then) = _$ShopProfileCopyWithImpl;
@useResult
$Res call({
 String name, String stateCode, String? phone, String? addressLine, String? city, String? pincode, String? gstin, String? logoPath
});




}
/// @nodoc
class _$ShopProfileCopyWithImpl<$Res>
    implements $ShopProfileCopyWith<$Res> {
  _$ShopProfileCopyWithImpl(this._self, this._then);

  final ShopProfile _self;
  final $Res Function(ShopProfile) _then;

/// Create a copy of ShopProfile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? stateCode = null,Object? phone = freezed,Object? addressLine = freezed,Object? city = freezed,Object? pincode = freezed,Object? gstin = freezed,Object? logoPath = freezed,}) {
  return _then(ShopProfile(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,stateCode: null == stateCode ? _self.stateCode : stateCode // ignore: cast_nullable_to_non_nullable
as String,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,addressLine: freezed == addressLine ? _self.addressLine : addressLine // ignore: cast_nullable_to_non_nullable
as String?,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,pincode: freezed == pincode ? _self.pincode : pincode // ignore: cast_nullable_to_non_nullable
as String?,gstin: freezed == gstin ? _self.gstin : gstin // ignore: cast_nullable_to_non_nullable
as String?,logoPath: freezed == logoPath ? _self.logoPath : logoPath // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ShopProfile].
extension ShopProfilePatterns on ShopProfile {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ShopProfile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ShopProfile() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ShopProfile value)  $default,){
final _that = this;
switch (_that) {
case _ShopProfile():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ShopProfile value)?  $default,){
final _that = this;
switch (_that) {
case _ShopProfile() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String stateCode,  String? phone,  String? addressLine,  String? city,  String? pincode,  String? gstin,  String? logoPath)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ShopProfile() when $default != null:
return $default(_that.name,_that.stateCode,_that.phone,_that.addressLine,_that.city,_that.pincode,_that.gstin,_that.logoPath);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String stateCode,  String? phone,  String? addressLine,  String? city,  String? pincode,  String? gstin,  String? logoPath)  $default,) {final _that = this;
switch (_that) {
case _ShopProfile():
return $default(_that.name,_that.stateCode,_that.phone,_that.addressLine,_that.city,_that.pincode,_that.gstin,_that.logoPath);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String stateCode,  String? phone,  String? addressLine,  String? city,  String? pincode,  String? gstin,  String? logoPath)?  $default,) {final _that = this;
switch (_that) {
case _ShopProfile() when $default != null:
return $default(_that.name,_that.stateCode,_that.phone,_that.addressLine,_that.city,_that.pincode,_that.gstin,_that.logoPath);case _:
  return null;

}
}

}

/// @nodoc


class _ShopProfile implements ShopProfile {
  const _ShopProfile({required this.name, required this.stateCode, this.phone, this.addressLine, this.city, this.pincode, this.gstin, this.logoPath});
  

@override final  String name;
/// GST state code, e.g. `27` for Maharashtra.
@override final  String stateCode;
@override final  String? phone;
@override final  String? addressLine;
@override final  String? city;
@override final  String? pincode;
@override final  String? gstin;
@override final  String? logoPath;

/// Create a copy of ShopProfile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ShopProfileCopyWith<_ShopProfile> get copyWith => __$ShopProfileCopyWithImpl<_ShopProfile>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ShopProfile&&(identical(other.name, name) || other.name == name)&&(identical(other.stateCode, stateCode) || other.stateCode == stateCode)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.addressLine, addressLine) || other.addressLine == addressLine)&&(identical(other.city, city) || other.city == city)&&(identical(other.pincode, pincode) || other.pincode == pincode)&&(identical(other.gstin, gstin) || other.gstin == gstin)&&(identical(other.logoPath, logoPath) || other.logoPath == logoPath));
}


@override
int get hashCode {
    return Object.hash(runtimeType,name,stateCode,phone,addressLine,city,pincode,gstin,logoPath);
}

@override
String toString() {
    return 'ShopProfile(name: $name, stateCode: $stateCode, phone: $phone, addressLine: $addressLine, city: $city, pincode: $pincode, gstin: $gstin, logoPath: $logoPath)';
}


}

/// @nodoc
abstract mixin class _$ShopProfileCopyWith<$Res> implements $ShopProfileCopyWith<$Res> {
  factory _$ShopProfileCopyWith(_ShopProfile value, $Res Function(_ShopProfile) _then) = __$ShopProfileCopyWithImpl;
@override @useResult
$Res call({
 String name, String stateCode, String? phone, String? addressLine, String? city, String? pincode, String? gstin, String? logoPath
});




}
/// @nodoc
class __$ShopProfileCopyWithImpl<$Res>
    implements _$ShopProfileCopyWith<$Res> {
  __$ShopProfileCopyWithImpl(this._self, this._then);

  final _ShopProfile _self;
  final $Res Function(_ShopProfile) _then;

/// Create a copy of ShopProfile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? stateCode = null,Object? phone = freezed,Object? addressLine = freezed,Object? city = freezed,Object? pincode = freezed,Object? gstin = freezed,Object? logoPath = freezed,}) {
  return _then(_ShopProfile(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,stateCode: null == stateCode ? _self.stateCode : stateCode // ignore: cast_nullable_to_non_nullable
as String,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,addressLine: freezed == addressLine ? _self.addressLine : addressLine // ignore: cast_nullable_to_non_nullable
as String?,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,pincode: freezed == pincode ? _self.pincode : pincode // ignore: cast_nullable_to_non_nullable
as String?,gstin: freezed == gstin ? _self.gstin : gstin // ignore: cast_nullable_to_non_nullable
as String?,logoPath: freezed == logoPath ? _self.logoPath : logoPath // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
