// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AppSettingsData {

 String get invoicePrefix; bool get roundToRupee;/// Shop's UPI ID (e.g. `shop@okaxis`). Enables a pay-by-UPI QR on bills.
 String? get upiId; String? get receiptFooter; String? get printerAddress; String? get printerName; PaperWidth get paperWidth;
/// Create a copy of AppSettingsData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppSettingsDataCopyWith<AppSettingsData> get copyWith => _$AppSettingsDataCopyWithImpl<AppSettingsData>(this as AppSettingsData, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as AppSettingsData;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppSettingsData&&(identical(other.invoicePrefix, _this.invoicePrefix) || other.invoicePrefix == _this.invoicePrefix)&&(identical(other.roundToRupee, _this.roundToRupee) || other.roundToRupee == _this.roundToRupee)&&(identical(other.upiId, _this.upiId) || other.upiId == _this.upiId)&&(identical(other.receiptFooter, _this.receiptFooter) || other.receiptFooter == _this.receiptFooter)&&(identical(other.printerAddress, _this.printerAddress) || other.printerAddress == _this.printerAddress)&&(identical(other.printerName, _this.printerName) || other.printerName == _this.printerName)&&(identical(other.paperWidth, _this.paperWidth) || other.paperWidth == _this.paperWidth));
}


@override
int get hashCode {
  final _this = this as AppSettingsData;
  return Object.hash(runtimeType,_this.invoicePrefix,_this.roundToRupee,_this.upiId,_this.receiptFooter,_this.printerAddress,_this.printerName,_this.paperWidth);
}

@override
String toString() {
  final _this = this as AppSettingsData;
  return 'AppSettingsData(invoicePrefix: ${_this.invoicePrefix}, roundToRupee: ${_this.roundToRupee}, upiId: ${_this.upiId}, receiptFooter: ${_this.receiptFooter}, printerAddress: ${_this.printerAddress}, printerName: ${_this.printerName}, paperWidth: ${_this.paperWidth})';
}


}

/// @nodoc
abstract mixin class $AppSettingsDataCopyWith<$Res>  {
  factory $AppSettingsDataCopyWith(AppSettingsData value, $Res Function(AppSettingsData) _then) = _$AppSettingsDataCopyWithImpl;
@useResult
$Res call({
 String invoicePrefix, bool roundToRupee, String? upiId, String? receiptFooter, String? printerAddress, String? printerName, PaperWidth paperWidth
});




}
/// @nodoc
class _$AppSettingsDataCopyWithImpl<$Res>
    implements $AppSettingsDataCopyWith<$Res> {
  _$AppSettingsDataCopyWithImpl(this._self, this._then);

  final AppSettingsData _self;
  final $Res Function(AppSettingsData) _then;

/// Create a copy of AppSettingsData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? invoicePrefix = null,Object? roundToRupee = null,Object? upiId = freezed,Object? receiptFooter = freezed,Object? printerAddress = freezed,Object? printerName = freezed,Object? paperWidth = null,}) {
  return _then(AppSettingsData(
invoicePrefix: null == invoicePrefix ? _self.invoicePrefix : invoicePrefix // ignore: cast_nullable_to_non_nullable
as String,roundToRupee: null == roundToRupee ? _self.roundToRupee : roundToRupee // ignore: cast_nullable_to_non_nullable
as bool,upiId: freezed == upiId ? _self.upiId : upiId // ignore: cast_nullable_to_non_nullable
as String?,receiptFooter: freezed == receiptFooter ? _self.receiptFooter : receiptFooter // ignore: cast_nullable_to_non_nullable
as String?,printerAddress: freezed == printerAddress ? _self.printerAddress : printerAddress // ignore: cast_nullable_to_non_nullable
as String?,printerName: freezed == printerName ? _self.printerName : printerName // ignore: cast_nullable_to_non_nullable
as String?,paperWidth: null == paperWidth ? _self.paperWidth : paperWidth // ignore: cast_nullable_to_non_nullable
as PaperWidth,
  ));
}

}


/// Adds pattern-matching-related methods to [AppSettingsData].
extension AppSettingsDataPatterns on AppSettingsData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppSettingsData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppSettingsData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppSettingsData value)  $default,){
final _that = this;
switch (_that) {
case _AppSettingsData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppSettingsData value)?  $default,){
final _that = this;
switch (_that) {
case _AppSettingsData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String invoicePrefix,  bool roundToRupee,  String? upiId,  String? receiptFooter,  String? printerAddress,  String? printerName,  PaperWidth paperWidth)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppSettingsData() when $default != null:
return $default(_that.invoicePrefix,_that.roundToRupee,_that.upiId,_that.receiptFooter,_that.printerAddress,_that.printerName,_that.paperWidth);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String invoicePrefix,  bool roundToRupee,  String? upiId,  String? receiptFooter,  String? printerAddress,  String? printerName,  PaperWidth paperWidth)  $default,) {final _that = this;
switch (_that) {
case _AppSettingsData():
return $default(_that.invoicePrefix,_that.roundToRupee,_that.upiId,_that.receiptFooter,_that.printerAddress,_that.printerName,_that.paperWidth);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String invoicePrefix,  bool roundToRupee,  String? upiId,  String? receiptFooter,  String? printerAddress,  String? printerName,  PaperWidth paperWidth)?  $default,) {final _that = this;
switch (_that) {
case _AppSettingsData() when $default != null:
return $default(_that.invoicePrefix,_that.roundToRupee,_that.upiId,_that.receiptFooter,_that.printerAddress,_that.printerName,_that.paperWidth);case _:
  return null;

}
}

}

/// @nodoc


class _AppSettingsData implements AppSettingsData {
  const _AppSettingsData({this.invoicePrefix = InvoiceNumber.defaultPrefix, this.roundToRupee = true, this.upiId, this.receiptFooter, this.printerAddress, this.printerName, this.paperWidth = PaperWidth.mm58});
  

@override@JsonKey() final  String invoicePrefix;
@override@JsonKey() final  bool roundToRupee;
/// Shop's UPI ID (e.g. `shop@okaxis`). Enables a pay-by-UPI QR on bills.
@override final  String? upiId;
@override final  String? receiptFooter;
@override final  String? printerAddress;
@override final  String? printerName;
@override@JsonKey() final  PaperWidth paperWidth;

/// Create a copy of AppSettingsData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppSettingsDataCopyWith<_AppSettingsData> get copyWith => __$AppSettingsDataCopyWithImpl<_AppSettingsData>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppSettingsData&&(identical(other.invoicePrefix, invoicePrefix) || other.invoicePrefix == invoicePrefix)&&(identical(other.roundToRupee, roundToRupee) || other.roundToRupee == roundToRupee)&&(identical(other.upiId, upiId) || other.upiId == upiId)&&(identical(other.receiptFooter, receiptFooter) || other.receiptFooter == receiptFooter)&&(identical(other.printerAddress, printerAddress) || other.printerAddress == printerAddress)&&(identical(other.printerName, printerName) || other.printerName == printerName)&&(identical(other.paperWidth, paperWidth) || other.paperWidth == paperWidth));
}


@override
int get hashCode {
    return Object.hash(runtimeType,invoicePrefix,roundToRupee,upiId,receiptFooter,printerAddress,printerName,paperWidth);
}

@override
String toString() {
    return 'AppSettingsData(invoicePrefix: $invoicePrefix, roundToRupee: $roundToRupee, upiId: $upiId, receiptFooter: $receiptFooter, printerAddress: $printerAddress, printerName: $printerName, paperWidth: $paperWidth)';
}


}

/// @nodoc
abstract mixin class _$AppSettingsDataCopyWith<$Res> implements $AppSettingsDataCopyWith<$Res> {
  factory _$AppSettingsDataCopyWith(_AppSettingsData value, $Res Function(_AppSettingsData) _then) = __$AppSettingsDataCopyWithImpl;
@override @useResult
$Res call({
 String invoicePrefix, bool roundToRupee, String? upiId, String? receiptFooter, String? printerAddress, String? printerName, PaperWidth paperWidth
});




}
/// @nodoc
class __$AppSettingsDataCopyWithImpl<$Res>
    implements _$AppSettingsDataCopyWith<$Res> {
  __$AppSettingsDataCopyWithImpl(this._self, this._then);

  final _AppSettingsData _self;
  final $Res Function(_AppSettingsData) _then;

/// Create a copy of AppSettingsData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? invoicePrefix = null,Object? roundToRupee = null,Object? upiId = freezed,Object? receiptFooter = freezed,Object? printerAddress = freezed,Object? printerName = freezed,Object? paperWidth = null,}) {
  return _then(_AppSettingsData(
invoicePrefix: null == invoicePrefix ? _self.invoicePrefix : invoicePrefix // ignore: cast_nullable_to_non_nullable
as String,roundToRupee: null == roundToRupee ? _self.roundToRupee : roundToRupee // ignore: cast_nullable_to_non_nullable
as bool,upiId: freezed == upiId ? _self.upiId : upiId // ignore: cast_nullable_to_non_nullable
as String?,receiptFooter: freezed == receiptFooter ? _self.receiptFooter : receiptFooter // ignore: cast_nullable_to_non_nullable
as String?,printerAddress: freezed == printerAddress ? _self.printerAddress : printerAddress // ignore: cast_nullable_to_non_nullable
as String?,printerName: freezed == printerName ? _self.printerName : printerName // ignore: cast_nullable_to_non_nullable
as String?,paperWidth: null == paperWidth ? _self.paperWidth : paperWidth // ignore: cast_nullable_to_non_nullable
as PaperWidth,
  ));
}


}

// dart format on
