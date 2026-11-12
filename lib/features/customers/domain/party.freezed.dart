// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'party.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Party {

 String get name; int? get id; String? get phone; String? get addressLine; String? get gstin; String? get notes;/// GST state code (place of supply). Filled from the GSTIN if given.
 String? get stateCode; PartyType get type;/// What they owe the shop (+), or an advance the shop holds (−).
/// Read-only here: only the party ledger changes it.
 Money get balance;
/// Create a copy of Party
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PartyCopyWith<Party> get copyWith => _$PartyCopyWithImpl<Party>(this as Party, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Party;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Party&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.phone, _this.phone) || other.phone == _this.phone)&&(identical(other.addressLine, _this.addressLine) || other.addressLine == _this.addressLine)&&(identical(other.gstin, _this.gstin) || other.gstin == _this.gstin)&&(identical(other.notes, _this.notes) || other.notes == _this.notes)&&(identical(other.stateCode, _this.stateCode) || other.stateCode == _this.stateCode)&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.balance, _this.balance) || other.balance == _this.balance));
}


@override
int get hashCode {
  final _this = this as Party;
  return Object.hash(runtimeType,_this.name,_this.id,_this.phone,_this.addressLine,_this.gstin,_this.notes,_this.stateCode,_this.type,_this.balance);
}

@override
String toString() {
  final _this = this as Party;
  return 'Party(name: ${_this.name}, id: ${_this.id}, phone: ${_this.phone}, addressLine: ${_this.addressLine}, gstin: ${_this.gstin}, notes: ${_this.notes}, stateCode: ${_this.stateCode}, type: ${_this.type}, balance: ${_this.balance})';
}


}

/// @nodoc
abstract mixin class $PartyCopyWith<$Res>  {
  factory $PartyCopyWith(Party value, $Res Function(Party) _then) = _$PartyCopyWithImpl;
@useResult
$Res call({
 String name, int? id, String? phone, String? addressLine, String? gstin, String? notes, String? stateCode, PartyType type, Money balance
});




}
/// @nodoc
class _$PartyCopyWithImpl<$Res>
    implements $PartyCopyWith<$Res> {
  _$PartyCopyWithImpl(this._self, this._then);

  final Party _self;
  final $Res Function(Party) _then;

/// Create a copy of Party
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? id = freezed,Object? phone = freezed,Object? addressLine = freezed,Object? gstin = freezed,Object? notes = freezed,Object? stateCode = freezed,Object? type = null,Object? balance = null,}) {
  return _then(Party(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,addressLine: freezed == addressLine ? _self.addressLine : addressLine // ignore: cast_nullable_to_non_nullable
as String?,gstin: freezed == gstin ? _self.gstin : gstin // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,stateCode: freezed == stateCode ? _self.stateCode : stateCode // ignore: cast_nullable_to_non_nullable
as String?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as PartyType,balance: null == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as Money,
  ));
}

}


/// Adds pattern-matching-related methods to [Party].
extension PartyPatterns on Party {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Party value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Party() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Party value)  $default,){
final _that = this;
switch (_that) {
case _Party():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Party value)?  $default,){
final _that = this;
switch (_that) {
case _Party() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  int? id,  String? phone,  String? addressLine,  String? gstin,  String? notes,  String? stateCode,  PartyType type,  Money balance)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Party() when $default != null:
return $default(_that.name,_that.id,_that.phone,_that.addressLine,_that.gstin,_that.notes,_that.stateCode,_that.type,_that.balance);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  int? id,  String? phone,  String? addressLine,  String? gstin,  String? notes,  String? stateCode,  PartyType type,  Money balance)  $default,) {final _that = this;
switch (_that) {
case _Party():
return $default(_that.name,_that.id,_that.phone,_that.addressLine,_that.gstin,_that.notes,_that.stateCode,_that.type,_that.balance);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  int? id,  String? phone,  String? addressLine,  String? gstin,  String? notes,  String? stateCode,  PartyType type,  Money balance)?  $default,) {final _that = this;
switch (_that) {
case _Party() when $default != null:
return $default(_that.name,_that.id,_that.phone,_that.addressLine,_that.gstin,_that.notes,_that.stateCode,_that.type,_that.balance);case _:
  return null;

}
}

}

/// @nodoc


class _Party extends Party {
  const _Party({required this.name, this.id, this.phone, this.addressLine, this.gstin, this.notes, this.stateCode, this.type = PartyType.customer, this.balance = Money.zero}): super._();
  

@override final  String name;
@override final  int? id;
@override final  String? phone;
@override final  String? addressLine;
@override final  String? gstin;
@override final  String? notes;
/// GST state code (place of supply). Filled from the GSTIN if given.
@override final  String? stateCode;
@override@JsonKey() final  PartyType type;
/// What they owe the shop (+), or an advance the shop holds (−).
/// Read-only here: only the party ledger changes it.
@override@JsonKey() final  Money balance;

/// Create a copy of Party
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PartyCopyWith<_Party> get copyWith => __$PartyCopyWithImpl<_Party>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Party&&(identical(other.name, name) || other.name == name)&&(identical(other.id, id) || other.id == id)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.addressLine, addressLine) || other.addressLine == addressLine)&&(identical(other.gstin, gstin) || other.gstin == gstin)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.stateCode, stateCode) || other.stateCode == stateCode)&&(identical(other.type, type) || other.type == type)&&(identical(other.balance, balance) || other.balance == balance));
}


@override
int get hashCode {
    return Object.hash(runtimeType,name,id,phone,addressLine,gstin,notes,stateCode,type,balance);
}

@override
String toString() {
    return 'Party(name: $name, id: $id, phone: $phone, addressLine: $addressLine, gstin: $gstin, notes: $notes, stateCode: $stateCode, type: $type, balance: $balance)';
}


}

/// @nodoc
abstract mixin class _$PartyCopyWith<$Res> implements $PartyCopyWith<$Res> {
  factory _$PartyCopyWith(_Party value, $Res Function(_Party) _then) = __$PartyCopyWithImpl;
@override @useResult
$Res call({
 String name, int? id, String? phone, String? addressLine, String? gstin, String? notes, String? stateCode, PartyType type, Money balance
});




}
/// @nodoc
class __$PartyCopyWithImpl<$Res>
    implements _$PartyCopyWith<$Res> {
  __$PartyCopyWithImpl(this._self, this._then);

  final _Party _self;
  final $Res Function(_Party) _then;

/// Create a copy of Party
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? id = freezed,Object? phone = freezed,Object? addressLine = freezed,Object? gstin = freezed,Object? notes = freezed,Object? stateCode = freezed,Object? type = null,Object? balance = null,}) {
  return _then(_Party(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,addressLine: freezed == addressLine ? _self.addressLine : addressLine // ignore: cast_nullable_to_non_nullable
as String?,gstin: freezed == gstin ? _self.gstin : gstin // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,stateCode: freezed == stateCode ? _self.stateCode : stateCode // ignore: cast_nullable_to_non_nullable
as String?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as PartyType,balance: null == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as Money,
  ));
}


}

// dart format on
