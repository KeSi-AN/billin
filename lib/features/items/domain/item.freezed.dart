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
 bool get priceIncludesTax; String? get hsn;/// Off: unlimited stock, nothing is counted.
 bool get trackStock;/// Current stock in base units. Read-only here: only the stock ledger
/// changes it (saving an item never touches stock).
 Quantity get stock;/// Alert when stock falls to this level or below.
 Quantity? get lowStock; int? get categoryId; String? get imagePath;/// Stock kept in batches with expiry; sales use the earliest expiry.
 bool get tracksBatches;/// Optional second selling unit, e.g. `box` holding 12 `pcs`.
 String? get altUnit; Quantity? get altUnitFactor; Money? get altUnitPrice;/// Cost per base unit before GST; purchases keep it up to date.
 Money? get costPrice;
/// Create a copy of Item
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ItemCopyWith<Item> get copyWith => _$ItemCopyWithImpl<Item>(this as Item, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Item;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Item&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.salePrice, _this.salePrice) || other.salePrice == _this.salePrice)&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.barcode, _this.barcode) || other.barcode == _this.barcode)&&(identical(other.unit, _this.unit) || other.unit == _this.unit)&&(identical(other.mrp, _this.mrp) || other.mrp == _this.mrp)&&(identical(other.taxRate, _this.taxRate) || other.taxRate == _this.taxRate)&&(identical(other.priceIncludesTax, _this.priceIncludesTax) || other.priceIncludesTax == _this.priceIncludesTax)&&(identical(other.hsn, _this.hsn) || other.hsn == _this.hsn)&&(identical(other.trackStock, _this.trackStock) || other.trackStock == _this.trackStock)&&(identical(other.stock, _this.stock) || other.stock == _this.stock)&&(identical(other.lowStock, _this.lowStock) || other.lowStock == _this.lowStock)&&(identical(other.categoryId, _this.categoryId) || other.categoryId == _this.categoryId)&&(identical(other.imagePath, _this.imagePath) || other.imagePath == _this.imagePath)&&(identical(other.tracksBatches, _this.tracksBatches) || other.tracksBatches == _this.tracksBatches)&&(identical(other.altUnit, _this.altUnit) || other.altUnit == _this.altUnit)&&(identical(other.altUnitFactor, _this.altUnitFactor) || other.altUnitFactor == _this.altUnitFactor)&&(identical(other.altUnitPrice, _this.altUnitPrice) || other.altUnitPrice == _this.altUnitPrice)&&(identical(other.costPrice, _this.costPrice) || other.costPrice == _this.costPrice));
}


@override
int get hashCode {
  final _this = this as Item;
  return Object.hashAll([runtimeType,_this.name,_this.salePrice,_this.id,_this.barcode,_this.unit,_this.mrp,_this.taxRate,_this.priceIncludesTax,_this.hsn,_this.trackStock,_this.stock,_this.lowStock,_this.categoryId,_this.imagePath,_this.tracksBatches,_this.altUnit,_this.altUnitFactor,_this.altUnitPrice,_this.costPrice]);
}

@override
String toString() {
  final _this = this as Item;
  return 'Item(name: ${_this.name}, salePrice: ${_this.salePrice}, id: ${_this.id}, barcode: ${_this.barcode}, unit: ${_this.unit}, mrp: ${_this.mrp}, taxRate: ${_this.taxRate}, priceIncludesTax: ${_this.priceIncludesTax}, hsn: ${_this.hsn}, trackStock: ${_this.trackStock}, stock: ${_this.stock}, lowStock: ${_this.lowStock}, categoryId: ${_this.categoryId}, imagePath: ${_this.imagePath}, tracksBatches: ${_this.tracksBatches}, altUnit: ${_this.altUnit}, altUnitFactor: ${_this.altUnitFactor}, altUnitPrice: ${_this.altUnitPrice}, costPrice: ${_this.costPrice})';
}


}

/// @nodoc
abstract mixin class $ItemCopyWith<$Res>  {
  factory $ItemCopyWith(Item value, $Res Function(Item) _then) = _$ItemCopyWithImpl;
@useResult
$Res call({
 String name, Money salePrice, int? id, String? barcode, String unit, Money? mrp, TaxRate taxRate, bool priceIncludesTax, String? hsn, bool trackStock, Quantity stock, Quantity? lowStock, int? categoryId, String? imagePath, bool tracksBatches, String? altUnit, Quantity? altUnitFactor, Money? altUnitPrice, Money? costPrice
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
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? salePrice = null,Object? id = freezed,Object? barcode = freezed,Object? unit = null,Object? mrp = freezed,Object? taxRate = null,Object? priceIncludesTax = null,Object? hsn = freezed,Object? trackStock = null,Object? stock = null,Object? lowStock = freezed,Object? categoryId = freezed,Object? imagePath = freezed,Object? tracksBatches = null,Object? altUnit = freezed,Object? altUnitFactor = freezed,Object? altUnitPrice = freezed,Object? costPrice = freezed,}) {
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
as String?,trackStock: null == trackStock ? _self.trackStock : trackStock // ignore: cast_nullable_to_non_nullable
as bool,stock: null == stock ? _self.stock : stock // ignore: cast_nullable_to_non_nullable
as Quantity,lowStock: freezed == lowStock ? _self.lowStock : lowStock // ignore: cast_nullable_to_non_nullable
as Quantity?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int?,imagePath: freezed == imagePath ? _self.imagePath : imagePath // ignore: cast_nullable_to_non_nullable
as String?,tracksBatches: null == tracksBatches ? _self.tracksBatches : tracksBatches // ignore: cast_nullable_to_non_nullable
as bool,altUnit: freezed == altUnit ? _self.altUnit : altUnit // ignore: cast_nullable_to_non_nullable
as String?,altUnitFactor: freezed == altUnitFactor ? _self.altUnitFactor : altUnitFactor // ignore: cast_nullable_to_non_nullable
as Quantity?,altUnitPrice: freezed == altUnitPrice ? _self.altUnitPrice : altUnitPrice // ignore: cast_nullable_to_non_nullable
as Money?,costPrice: freezed == costPrice ? _self.costPrice : costPrice // ignore: cast_nullable_to_non_nullable
as Money?,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  Money salePrice,  int? id,  String? barcode,  String unit,  Money? mrp,  TaxRate taxRate,  bool priceIncludesTax,  String? hsn,  bool trackStock,  Quantity stock,  Quantity? lowStock,  int? categoryId,  String? imagePath,  bool tracksBatches,  String? altUnit,  Quantity? altUnitFactor,  Money? altUnitPrice,  Money? costPrice)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Item() when $default != null:
return $default(_that.name,_that.salePrice,_that.id,_that.barcode,_that.unit,_that.mrp,_that.taxRate,_that.priceIncludesTax,_that.hsn,_that.trackStock,_that.stock,_that.lowStock,_that.categoryId,_that.imagePath,_that.tracksBatches,_that.altUnit,_that.altUnitFactor,_that.altUnitPrice,_that.costPrice);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  Money salePrice,  int? id,  String? barcode,  String unit,  Money? mrp,  TaxRate taxRate,  bool priceIncludesTax,  String? hsn,  bool trackStock,  Quantity stock,  Quantity? lowStock,  int? categoryId,  String? imagePath,  bool tracksBatches,  String? altUnit,  Quantity? altUnitFactor,  Money? altUnitPrice,  Money? costPrice)  $default,) {final _that = this;
switch (_that) {
case _Item():
return $default(_that.name,_that.salePrice,_that.id,_that.barcode,_that.unit,_that.mrp,_that.taxRate,_that.priceIncludesTax,_that.hsn,_that.trackStock,_that.stock,_that.lowStock,_that.categoryId,_that.imagePath,_that.tracksBatches,_that.altUnit,_that.altUnitFactor,_that.altUnitPrice,_that.costPrice);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  Money salePrice,  int? id,  String? barcode,  String unit,  Money? mrp,  TaxRate taxRate,  bool priceIncludesTax,  String? hsn,  bool trackStock,  Quantity stock,  Quantity? lowStock,  int? categoryId,  String? imagePath,  bool tracksBatches,  String? altUnit,  Quantity? altUnitFactor,  Money? altUnitPrice,  Money? costPrice)?  $default,) {final _that = this;
switch (_that) {
case _Item() when $default != null:
return $default(_that.name,_that.salePrice,_that.id,_that.barcode,_that.unit,_that.mrp,_that.taxRate,_that.priceIncludesTax,_that.hsn,_that.trackStock,_that.stock,_that.lowStock,_that.categoryId,_that.imagePath,_that.tracksBatches,_that.altUnit,_that.altUnitFactor,_that.altUnitPrice,_that.costPrice);case _:
  return null;

}
}

}

/// @nodoc


class _Item extends Item {
  const _Item({required this.name, required this.salePrice, this.id, this.barcode, this.unit = 'pcs', this.mrp, this.taxRate = TaxRate.zero, this.priceIncludesTax = true, this.hsn, this.trackStock = false, this.stock = Quantity.zero, this.lowStock, this.categoryId, this.imagePath, this.tracksBatches = false, this.altUnit, this.altUnitFactor, this.altUnitPrice, this.costPrice}): super._();
  

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
/// Off: unlimited stock, nothing is counted.
@override@JsonKey() final  bool trackStock;
/// Current stock in base units. Read-only here: only the stock ledger
/// changes it (saving an item never touches stock).
@override@JsonKey() final  Quantity stock;
/// Alert when stock falls to this level or below.
@override final  Quantity? lowStock;
@override final  int? categoryId;
@override final  String? imagePath;
/// Stock kept in batches with expiry; sales use the earliest expiry.
@override@JsonKey() final  bool tracksBatches;
/// Optional second selling unit, e.g. `box` holding 12 `pcs`.
@override final  String? altUnit;
@override final  Quantity? altUnitFactor;
@override final  Money? altUnitPrice;
/// Cost per base unit before GST; purchases keep it up to date.
@override final  Money? costPrice;

/// Create a copy of Item
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ItemCopyWith<_Item> get copyWith => __$ItemCopyWithImpl<_Item>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Item&&(identical(other.name, name) || other.name == name)&&(identical(other.salePrice, salePrice) || other.salePrice == salePrice)&&(identical(other.id, id) || other.id == id)&&(identical(other.barcode, barcode) || other.barcode == barcode)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.mrp, mrp) || other.mrp == mrp)&&(identical(other.taxRate, taxRate) || other.taxRate == taxRate)&&(identical(other.priceIncludesTax, priceIncludesTax) || other.priceIncludesTax == priceIncludesTax)&&(identical(other.hsn, hsn) || other.hsn == hsn)&&(identical(other.trackStock, trackStock) || other.trackStock == trackStock)&&(identical(other.stock, stock) || other.stock == stock)&&(identical(other.lowStock, lowStock) || other.lowStock == lowStock)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.imagePath, imagePath) || other.imagePath == imagePath)&&(identical(other.tracksBatches, tracksBatches) || other.tracksBatches == tracksBatches)&&(identical(other.altUnit, altUnit) || other.altUnit == altUnit)&&(identical(other.altUnitFactor, altUnitFactor) || other.altUnitFactor == altUnitFactor)&&(identical(other.altUnitPrice, altUnitPrice) || other.altUnitPrice == altUnitPrice)&&(identical(other.costPrice, costPrice) || other.costPrice == costPrice));
}


@override
int get hashCode {
    return Object.hashAll([runtimeType,name,salePrice,id,barcode,unit,mrp,taxRate,priceIncludesTax,hsn,trackStock,stock,lowStock,categoryId,imagePath,tracksBatches,altUnit,altUnitFactor,altUnitPrice,costPrice]);
}

@override
String toString() {
    return 'Item(name: $name, salePrice: $salePrice, id: $id, barcode: $barcode, unit: $unit, mrp: $mrp, taxRate: $taxRate, priceIncludesTax: $priceIncludesTax, hsn: $hsn, trackStock: $trackStock, stock: $stock, lowStock: $lowStock, categoryId: $categoryId, imagePath: $imagePath, tracksBatches: $tracksBatches, altUnit: $altUnit, altUnitFactor: $altUnitFactor, altUnitPrice: $altUnitPrice, costPrice: $costPrice)';
}


}

/// @nodoc
abstract mixin class _$ItemCopyWith<$Res> implements $ItemCopyWith<$Res> {
  factory _$ItemCopyWith(_Item value, $Res Function(_Item) _then) = __$ItemCopyWithImpl;
@override @useResult
$Res call({
 String name, Money salePrice, int? id, String? barcode, String unit, Money? mrp, TaxRate taxRate, bool priceIncludesTax, String? hsn, bool trackStock, Quantity stock, Quantity? lowStock, int? categoryId, String? imagePath, bool tracksBatches, String? altUnit, Quantity? altUnitFactor, Money? altUnitPrice, Money? costPrice
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
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? salePrice = null,Object? id = freezed,Object? barcode = freezed,Object? unit = null,Object? mrp = freezed,Object? taxRate = null,Object? priceIncludesTax = null,Object? hsn = freezed,Object? trackStock = null,Object? stock = null,Object? lowStock = freezed,Object? categoryId = freezed,Object? imagePath = freezed,Object? tracksBatches = null,Object? altUnit = freezed,Object? altUnitFactor = freezed,Object? altUnitPrice = freezed,Object? costPrice = freezed,}) {
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
as String?,trackStock: null == trackStock ? _self.trackStock : trackStock // ignore: cast_nullable_to_non_nullable
as bool,stock: null == stock ? _self.stock : stock // ignore: cast_nullable_to_non_nullable
as Quantity,lowStock: freezed == lowStock ? _self.lowStock : lowStock // ignore: cast_nullable_to_non_nullable
as Quantity?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int?,imagePath: freezed == imagePath ? _self.imagePath : imagePath // ignore: cast_nullable_to_non_nullable
as String?,tracksBatches: null == tracksBatches ? _self.tracksBatches : tracksBatches // ignore: cast_nullable_to_non_nullable
as bool,altUnit: freezed == altUnit ? _self.altUnit : altUnit // ignore: cast_nullable_to_non_nullable
as String?,altUnitFactor: freezed == altUnitFactor ? _self.altUnitFactor : altUnitFactor // ignore: cast_nullable_to_non_nullable
as Quantity?,altUnitPrice: freezed == altUnitPrice ? _self.altUnitPrice : altUnitPrice // ignore: cast_nullable_to_non_nullable
as Money?,costPrice: freezed == costPrice ? _self.costPrice : costPrice // ignore: cast_nullable_to_non_nullable
as Money?,
  ));
}


}

// dart format on
