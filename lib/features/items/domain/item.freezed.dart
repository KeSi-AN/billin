// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Item {

 String get name; Money get salePrice;/// `null` until saved.
 int? get id; String? get barcode; String get unit; Money? get mrp; TaxRate get taxRate;/// MRP-style pricing (GST included in the price), the usual retail case.
 bool get priceIncludesTax; String? get hsn;
/// Create a copy of Item
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ItemCopyWith<Item> get copyWith => _$ItemCopyWithImpl<Item>(this as Item, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Item;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Item&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.salePrice, _this.salePrice) || other.salePrice == _this.salePrice)&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.barcode, _this.barcode) || other.barcode == _this.barcode)&&(identical(other.unit, _this.unit) || other.unit == _this.unit)&&(identical(other.mrp, _this.mrp) || other.mrp == _this.mrp)&&(identical(other.taxRate, _this.taxRate) || other.taxRate == _this.taxRate)&&(identical(other.priceIncludesTax, _this.priceIncludesTax) || other.priceIncludesTax == _this.priceIncludesTax)&&(identical(other.hsn, _this.hsn) || other.hsn == _this.hsn));
}


@override
int get hashCode {
  final _this = this as Item;
  return Object.hash(runtimeType,_this.name,_this.salePrice,_this.id,_this.barcode,_this.unit,_this.mrp,_this.taxRate,_this.priceIncludesTax,_this.hsn);
}

@override
String toString() {
  final _this = this as Item;
  return 'Item(name: ${_this.name}, salePrice: ${_this.salePrice}, id: ${_this.id}, barcode: ${_this.barcode}, unit: ${_this.unit}, mrp: ${_this.mrp}, taxRate: ${_this.taxRate}, priceIncludesTax: ${_this.priceIncludesTax}, hsn: ${_this.hsn})';
}


}

/// @nodoc
abstract mixin class $ItemCopyWith<$Res>  {
  factory $ItemCopyWith(Item value, $Res Function(Item) _then) = _$ItemCopyWithImpl;
@useResult
$Res call({
 String name, Money salePrice, int? id, String? barcode, String unit, Money? mrp, TaxRate taxRate, bool priceIncludesTax, String? hsn
});




}
/// @nodoc
class _$ItemCopyWithImpl<$Res>
    implements $ItemCopyWith<$Res> {
  _$ItemCopyWithImpl(this._self, this._then);

  final Item _self;
  final $Res Function(Item) _then;

/// Create a copy of Item
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? salePrice = null,Object? id = freezed,Object? barcode = freezed,Object? unit = null,Object? mrp = freezed,Object? taxRate = null,Object? priceIncludesTax = null,Object? hsn = freezed,}) {
  return _then(Item(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,salePrice: null == salePrice ? _self.salePrice : salePrice // ignore: cast_nullable_to_non_nullable
as Money,id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,barcode: freezed == barcode ? _self.barcode : barcode // ignore: cast_nullable_to_non_nullable
as String?,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String,mrp: freezed == mrp ? _self.mrp : mrp // ignore: cast_nullable_to_non_nullable
as Money?,taxRate: null == taxRate ? _self.taxRate : taxRate // ignore: cast_nullable_to_non_nullable
as TaxRate,priceIncludesTax: null == priceIncludesTax ? _self.priceIncludesTax : priceIncludesTax // ignore: cast_nullable_to_non_nullable
as bool,hsn: freezed == hsn ? _self.hsn : hsn // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Item].
extension ItemPatterns on Item {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Item value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Item() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Item value)  $default,){
final _that = this;
switch (_that) {
case _Item():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Item value)?  $default,){
final _that = this;
switch (_that) {
case _Item() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  Money salePrice,  int? id,  String? barcode,  String unit,  Money? mrp,  TaxRate taxRate,  bool priceIncludesTax,  String? hsn)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Item() when $default != null:
return $default(_that.name,_that.salePrice,_that.id,_that.barcode,_that.unit,_that.mrp,_that.taxRate,_that.priceIncludesTax,_that.hsn);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  Money salePrice,  int? id,  String? barcode,  String unit,  Money? mrp,  TaxRate taxRate,  bool priceIncludesTax,  String? hsn)  $default,) {final _that = this;
switch (_that) {
case _Item():
return $default(_that.name,_that.salePrice,_that.id,_that.barcode,_that.unit,_that.mrp,_that.taxRate,_that.priceIncludesTax,_that.hsn);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  Money salePrice,  int? id,  String? barcode,  String unit,  Money? mrp,  TaxRate taxRate,  bool priceIncludesTax,  String? hsn)?  $default,) {final _that = this;
switch (_that) {
case _Item() when $default != null:
return $default(_that.name,_that.salePrice,_that.id,_that.barcode,_that.unit,_that.mrp,_that.taxRate,_that.priceIncludesTax,_that.hsn);case _:
  return null;

}
}

}

/// @nodoc


class _Item implements Item {
  const _Item({required this.name, required this.salePrice, this.id, this.barcode, this.unit = 'pcs', this.mrp, this.taxRate = TaxRate.zero, this.priceIncludesTax = true, this.hsn});
  

@override final  String name;
@override final  Money salePrice;
/// `null` until saved.
@override final  int? id;
@override final  String? barcode;
@override@JsonKey() final  String unit;
@override final  Money? mrp;
@override@JsonKey() final  TaxRate taxRate;
/// MRP-style pricing (GST included in the price), the usual retail case.
@override@JsonKey() final  bool priceIncludesTax;
@override final  String? hsn;

/// Create a copy of Item
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ItemCopyWith<_Item> get copyWith => __$ItemCopyWithImpl<_Item>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Item&&(identical(other.name, name) || other.name == name)&&(identical(other.salePrice, salePrice) || other.salePrice == salePrice)&&(identical(other.id, id) || other.id == id)&&(identical(other.barcode, barcode) || other.barcode == barcode)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.mrp, mrp) || other.mrp == mrp)&&(identical(other.taxRate, taxRate) || other.taxRate == taxRate)&&(identical(other.priceIncludesTax, priceIncludesTax) || other.priceIncludesTax == priceIncludesTax)&&(identical(other.hsn, hsn) || other.hsn == hsn));
}


@override
int get hashCode {
    return Object.hash(runtimeType,name,salePrice,id,barcode,unit,mrp,taxRate,priceIncludesTax,hsn);
}

@override
String toString() {
    return 'Item(name: $name, salePrice: $salePrice, id: $id, barcode: $barcode, unit: $unit, mrp: $mrp, taxRate: $taxRate, priceIncludesTax: $priceIncludesTax, hsn: $hsn)';
}


}

/// @nodoc
abstract mixin class _$ItemCopyWith<$Res> implements $ItemCopyWith<$Res> {
  factory _$ItemCopyWith(_Item value, $Res Function(_Item) _then) = __$ItemCopyWithImpl;
@override @useResult
$Res call({
 String name, Money salePrice, int? id, String? barcode, String unit, Money? mrp, TaxRate taxRate, bool priceIncludesTax, String? hsn
});




}
/// @nodoc
class __$ItemCopyWithImpl<$Res>
    implements _$ItemCopyWith<$Res> {
  __$ItemCopyWithImpl(this._self, this._then);

  final _Item _self;
  final $Res Function(_Item) _then;

/// Create a copy of Item
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? salePrice = null,Object? id = freezed,Object? barcode = freezed,Object? unit = null,Object? mrp = freezed,Object? taxRate = null,Object? priceIncludesTax = null,Object? hsn = freezed,}) {
  return _then(_Item(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,salePrice: null == salePrice ? _self.salePrice : salePrice // ignore: cast_nullable_to_non_nullable
as Money,id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,barcode: freezed == barcode ? _self.barcode : barcode // ignore: cast_nullable_to_non_nullable
as String?,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String,mrp: freezed == mrp ? _self.mrp : mrp // ignore: cast_nullable_to_non_nullable
as Money?,taxRate: null == taxRate ? _self.taxRate : taxRate // ignore: cast_nullable_to_non_nullable
as TaxRate,priceIncludesTax: null == priceIncludesTax ? _self.priceIncludesTax : priceIncludesTax // ignore: cast_nullable_to_non_nullable
as bool,hsn: freezed == hsn ? _self.hsn : hsn // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
