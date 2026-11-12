// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ShopProfilesTable extends ShopProfiles
    with TableInfo<$ShopProfilesTable, ShopProfileRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ShopProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _addressLineMeta = const VerificationMeta(
    'addressLine',
  );
  @override
  late final GeneratedColumn<String> addressLine = GeneratedColumn<String>(
    'address_line',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cityMeta = const VerificationMeta('city');
  @override
  late final GeneratedColumn<String> city = GeneratedColumn<String>(
    'city',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _pincodeMeta = const VerificationMeta(
    'pincode',
  );
  @override
  late final GeneratedColumn<String> pincode = GeneratedColumn<String>(
    'pincode',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _stateCodeMeta = const VerificationMeta(
    'stateCode',
  );
  @override
  late final GeneratedColumn<String> stateCode = GeneratedColumn<String>(
    'state_code',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 2,
      maxTextLength: 2,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _gstinMeta = const VerificationMeta('gstin');
  @override
  late final GeneratedColumn<String> gstin = GeneratedColumn<String>(
    'gstin',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _logoPathMeta = const VerificationMeta(
    'logoPath',
  );
  @override
  late final GeneratedColumn<String> logoPath = GeneratedColumn<String>(
    'logo_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    phone,
    addressLine,
    city,
    pincode,
    stateCode,
    gstin,
    logoPath,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'shop_profiles';
  @override
  VerificationContext validateIntegrity(
    Insertable<ShopProfileRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    }
    if (data.containsKey('address_line')) {
      context.handle(
        _addressLineMeta,
        addressLine.isAcceptableOrUnknown(
          data['address_line']!,
          _addressLineMeta,
        ),
      );
    }
    if (data.containsKey('city')) {
      context.handle(
        _cityMeta,
        city.isAcceptableOrUnknown(data['city']!, _cityMeta),
      );
    }
    if (data.containsKey('pincode')) {
      context.handle(
        _pincodeMeta,
        pincode.isAcceptableOrUnknown(data['pincode']!, _pincodeMeta),
      );
    }
    if (data.containsKey('state_code')) {
      context.handle(
        _stateCodeMeta,
        stateCode.isAcceptableOrUnknown(data['state_code']!, _stateCodeMeta),
      );
    } else if (isInserting) {
      context.missing(_stateCodeMeta);
    }
    if (data.containsKey('gstin')) {
      context.handle(
        _gstinMeta,
        gstin.isAcceptableOrUnknown(data['gstin']!, _gstinMeta),
      );
    }
    if (data.containsKey('logo_path')) {
      context.handle(
        _logoPathMeta,
        logoPath.isAcceptableOrUnknown(data['logo_path']!, _logoPathMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ShopProfileRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ShopProfileRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      ),
      addressLine: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address_line'],
      ),
      city: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}city'],
      ),
      pincode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pincode'],
      ),
      stateCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}state_code'],
      )!,
      gstin: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}gstin'],
      ),
      logoPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}logo_path'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ShopProfilesTable createAlias(String alias) {
    return $ShopProfilesTable(attachedDatabase, alias);
  }
}

class ShopProfileRow extends DataClass implements Insertable<ShopProfileRow> {
  final int id;
  final String name;
  final String? phone;
  final String? addressLine;
  final String? city;
  final String? pincode;

  /// GST state code (`27` = Maharashtra). Drives CGST/SGST vs IGST later.
  final String stateCode;
  final String? gstin;

  /// Absolute path to the logo copied into the app's private storage.
  final String? logoPath;
  final DateTime createdAt;
  final DateTime updatedAt;
  const ShopProfileRow({
    required this.id,
    required this.name,
    this.phone,
    this.addressLine,
    this.city,
    this.pincode,
    required this.stateCode,
    this.gstin,
    this.logoPath,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    if (!nullToAbsent || addressLine != null) {
      map['address_line'] = Variable<String>(addressLine);
    }
    if (!nullToAbsent || city != null) {
      map['city'] = Variable<String>(city);
    }
    if (!nullToAbsent || pincode != null) {
      map['pincode'] = Variable<String>(pincode);
    }
    map['state_code'] = Variable<String>(stateCode);
    if (!nullToAbsent || gstin != null) {
      map['gstin'] = Variable<String>(gstin);
    }
    if (!nullToAbsent || logoPath != null) {
      map['logo_path'] = Variable<String>(logoPath);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ShopProfilesCompanion toCompanion(bool nullToAbsent) {
    return ShopProfilesCompanion(
      id: Value(id),
      name: Value(name),
      phone: phone == null && nullToAbsent
          ? const Value.absent()
          : Value(phone),
      addressLine: addressLine == null && nullToAbsent
          ? const Value.absent()
          : Value(addressLine),
      city: city == null && nullToAbsent ? const Value.absent() : Value(city),
      pincode: pincode == null && nullToAbsent
          ? const Value.absent()
          : Value(pincode),
      stateCode: Value(stateCode),
      gstin: gstin == null && nullToAbsent
          ? const Value.absent()
          : Value(gstin),
      logoPath: logoPath == null && nullToAbsent
          ? const Value.absent()
          : Value(logoPath),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory ShopProfileRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ShopProfileRow(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      phone: serializer.fromJson<String?>(json['phone']),
      addressLine: serializer.fromJson<String?>(json['addressLine']),
      city: serializer.fromJson<String?>(json['city']),
      pincode: serializer.fromJson<String?>(json['pincode']),
      stateCode: serializer.fromJson<String>(json['stateCode']),
      gstin: serializer.fromJson<String?>(json['gstin']),
      logoPath: serializer.fromJson<String?>(json['logoPath']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'phone': serializer.toJson<String?>(phone),
      'addressLine': serializer.toJson<String?>(addressLine),
      'city': serializer.toJson<String?>(city),
      'pincode': serializer.toJson<String?>(pincode),
      'stateCode': serializer.toJson<String>(stateCode),
      'gstin': serializer.toJson<String?>(gstin),
      'logoPath': serializer.toJson<String?>(logoPath),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ShopProfileRow copyWith({
    int? id,
    String? name,
    Value<String?> phone = const Value.absent(),
    Value<String?> addressLine = const Value.absent(),
    Value<String?> city = const Value.absent(),
    Value<String?> pincode = const Value.absent(),
    String? stateCode,
    Value<String?> gstin = const Value.absent(),
    Value<String?> logoPath = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => ShopProfileRow(
    id: id ?? this.id,
    name: name ?? this.name,
    phone: phone.present ? phone.value : this.phone,
    addressLine: addressLine.present ? addressLine.value : this.addressLine,
    city: city.present ? city.value : this.city,
    pincode: pincode.present ? pincode.value : this.pincode,
    stateCode: stateCode ?? this.stateCode,
    gstin: gstin.present ? gstin.value : this.gstin,
    logoPath: logoPath.present ? logoPath.value : this.logoPath,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  ShopProfileRow copyWithCompanion(ShopProfilesCompanion data) {
    return ShopProfileRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      phone: data.phone.present ? data.phone.value : this.phone,
      addressLine: data.addressLine.present
          ? data.addressLine.value
          : this.addressLine,
      city: data.city.present ? data.city.value : this.city,
      pincode: data.pincode.present ? data.pincode.value : this.pincode,
      stateCode: data.stateCode.present ? data.stateCode.value : this.stateCode,
      gstin: data.gstin.present ? data.gstin.value : this.gstin,
      logoPath: data.logoPath.present ? data.logoPath.value : this.logoPath,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ShopProfileRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('addressLine: $addressLine, ')
          ..write('city: $city, ')
          ..write('pincode: $pincode, ')
          ..write('stateCode: $stateCode, ')
          ..write('gstin: $gstin, ')
          ..write('logoPath: $logoPath, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    phone,
    addressLine,
    city,
    pincode,
    stateCode,
    gstin,
    logoPath,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ShopProfileRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.phone == this.phone &&
          other.addressLine == this.addressLine &&
          other.city == this.city &&
          other.pincode == this.pincode &&
          other.stateCode == this.stateCode &&
          other.gstin == this.gstin &&
          other.logoPath == this.logoPath &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ShopProfilesCompanion extends UpdateCompanion<ShopProfileRow> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> phone;
  final Value<String?> addressLine;
  final Value<String?> city;
  final Value<String?> pincode;
  final Value<String> stateCode;
  final Value<String?> gstin;
  final Value<String?> logoPath;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const ShopProfilesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.phone = const Value.absent(),
    this.addressLine = const Value.absent(),
    this.city = const Value.absent(),
    this.pincode = const Value.absent(),
    this.stateCode = const Value.absent(),
    this.gstin = const Value.absent(),
    this.logoPath = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  ShopProfilesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.phone = const Value.absent(),
    this.addressLine = const Value.absent(),
    this.city = const Value.absent(),
    this.pincode = const Value.absent(),
    required String stateCode,
    this.gstin = const Value.absent(),
    this.logoPath = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : name = Value(name),
       stateCode = Value(stateCode),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<ShopProfileRow> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? phone,
    Expression<String>? addressLine,
    Expression<String>? city,
    Expression<String>? pincode,
    Expression<String>? stateCode,
    Expression<String>? gstin,
    Expression<String>? logoPath,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (phone != null) 'phone': phone,
      if (addressLine != null) 'address_line': addressLine,
      if (city != null) 'city': city,
      if (pincode != null) 'pincode': pincode,
      if (stateCode != null) 'state_code': stateCode,
      if (gstin != null) 'gstin': gstin,
      if (logoPath != null) 'logo_path': logoPath,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  ShopProfilesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String?>? phone,
    Value<String?>? addressLine,
    Value<String?>? city,
    Value<String?>? pincode,
    Value<String>? stateCode,
    Value<String?>? gstin,
    Value<String?>? logoPath,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return ShopProfilesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      addressLine: addressLine ?? this.addressLine,
      city: city ?? this.city,
      pincode: pincode ?? this.pincode,
      stateCode: stateCode ?? this.stateCode,
      gstin: gstin ?? this.gstin,
      logoPath: logoPath ?? this.logoPath,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (addressLine.present) {
      map['address_line'] = Variable<String>(addressLine.value);
    }
    if (city.present) {
      map['city'] = Variable<String>(city.value);
    }
    if (pincode.present) {
      map['pincode'] = Variable<String>(pincode.value);
    }
    if (stateCode.present) {
      map['state_code'] = Variable<String>(stateCode.value);
    }
    if (gstin.present) {
      map['gstin'] = Variable<String>(gstin.value);
    }
    if (logoPath.present) {
      map['logo_path'] = Variable<String>(logoPath.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ShopProfilesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('addressLine: $addressLine, ')
          ..write('city: $city, ')
          ..write('pincode: $pincode, ')
          ..write('stateCode: $stateCode, ')
          ..write('gstin: $gstin, ')
          ..write('logoPath: $logoPath, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $ItemsTable extends Items with TableInfo<$ItemsTable, ItemRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 120,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _barcodeMeta = const VerificationMeta(
    'barcode',
  );
  @override
  late final GeneratedColumn<String> barcode = GeneratedColumn<String>(
    'barcode',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
    'unit',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pcs'),
  );
  static const VerificationMeta _salePricePaiseMeta = const VerificationMeta(
    'salePricePaise',
  );
  @override
  late final GeneratedColumn<int> salePricePaise = GeneratedColumn<int>(
    'sale_price_paise',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _mrpPaiseMeta = const VerificationMeta(
    'mrpPaise',
  );
  @override
  late final GeneratedColumn<int> mrpPaise = GeneratedColumn<int>(
    'mrp_paise',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _taxRateBpMeta = const VerificationMeta(
    'taxRateBp',
  );
  @override
  late final GeneratedColumn<int> taxRateBp = GeneratedColumn<int>(
    'tax_rate_bp',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _priceIncludesTaxMeta = const VerificationMeta(
    'priceIncludesTax',
  );
  @override
  late final GeneratedColumn<bool> priceIncludesTax = GeneratedColumn<bool>(
    'price_includes_tax',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("price_includes_tax" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _hsnMeta = const VerificationMeta('hsn');
  @override
  late final GeneratedColumn<String> hsn = GeneratedColumn<String>(
    'hsn',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    barcode,
    unit,
    salePricePaise,
    mrpPaise,
    taxRateBp,
    priceIncludesTax,
    hsn,
    isActive,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'items';
  @override
  VerificationContext validateIntegrity(
    Insertable<ItemRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('barcode')) {
      context.handle(
        _barcodeMeta,
        barcode.isAcceptableOrUnknown(data['barcode']!, _barcodeMeta),
      );
    }
    if (data.containsKey('unit')) {
      context.handle(
        _unitMeta,
        unit.isAcceptableOrUnknown(data['unit']!, _unitMeta),
      );
    }
    if (data.containsKey('sale_price_paise')) {
      context.handle(
        _salePricePaiseMeta,
        salePricePaise.isAcceptableOrUnknown(
          data['sale_price_paise']!,
          _salePricePaiseMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_salePricePaiseMeta);
    }
    if (data.containsKey('mrp_paise')) {
      context.handle(
        _mrpPaiseMeta,
        mrpPaise.isAcceptableOrUnknown(data['mrp_paise']!, _mrpPaiseMeta),
      );
    }
    if (data.containsKey('tax_rate_bp')) {
      context.handle(
        _taxRateBpMeta,
        taxRateBp.isAcceptableOrUnknown(data['tax_rate_bp']!, _taxRateBpMeta),
      );
    }
    if (data.containsKey('price_includes_tax')) {
      context.handle(
        _priceIncludesTaxMeta,
        priceIncludesTax.isAcceptableOrUnknown(
          data['price_includes_tax']!,
          _priceIncludesTaxMeta,
        ),
      );
    }
    if (data.containsKey('hsn')) {
      context.handle(
        _hsnMeta,
        hsn.isAcceptableOrUnknown(data['hsn']!, _hsnMeta),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ItemRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ItemRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      barcode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}barcode'],
      ),
      unit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit'],
      )!,
      salePricePaise: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sale_price_paise'],
      )!,
      mrpPaise: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}mrp_paise'],
      ),
      taxRateBp: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tax_rate_bp'],
      )!,
      priceIncludesTax: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}price_includes_tax'],
      )!,
      hsn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hsn'],
      ),
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ItemsTable createAlias(String alias) {
    return $ItemsTable(attachedDatabase, alias);
  }
}

class ItemRow extends DataClass implements Insertable<ItemRow> {
  final int id;
  final String name;

  /// Unique when set. Cleared when an item is deleted so it can be reused.
  final String? barcode;
  final String unit;
  final int salePricePaise;
  final int? mrpPaise;
  final int taxRateBp;
  final bool priceIncludesTax;
  final String? hsn;

  /// Deleted items are hidden, not removed: old bills still point at them.
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  const ItemRow({
    required this.id,
    required this.name,
    this.barcode,
    required this.unit,
    required this.salePricePaise,
    this.mrpPaise,
    required this.taxRateBp,
    required this.priceIncludesTax,
    this.hsn,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || barcode != null) {
      map['barcode'] = Variable<String>(barcode);
    }
    map['unit'] = Variable<String>(unit);
    map['sale_price_paise'] = Variable<int>(salePricePaise);
    if (!nullToAbsent || mrpPaise != null) {
      map['mrp_paise'] = Variable<int>(mrpPaise);
    }
    map['tax_rate_bp'] = Variable<int>(taxRateBp);
    map['price_includes_tax'] = Variable<bool>(priceIncludesTax);
    if (!nullToAbsent || hsn != null) {
      map['hsn'] = Variable<String>(hsn);
    }
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ItemsCompanion toCompanion(bool nullToAbsent) {
    return ItemsCompanion(
      id: Value(id),
      name: Value(name),
      barcode: barcode == null && nullToAbsent
          ? const Value.absent()
          : Value(barcode),
      unit: Value(unit),
      salePricePaise: Value(salePricePaise),
      mrpPaise: mrpPaise == null && nullToAbsent
          ? const Value.absent()
          : Value(mrpPaise),
      taxRateBp: Value(taxRateBp),
      priceIncludesTax: Value(priceIncludesTax),
      hsn: hsn == null && nullToAbsent ? const Value.absent() : Value(hsn),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory ItemRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ItemRow(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      barcode: serializer.fromJson<String?>(json['barcode']),
      unit: serializer.fromJson<String>(json['unit']),
      salePricePaise: serializer.fromJson<int>(json['salePricePaise']),
      mrpPaise: serializer.fromJson<int?>(json['mrpPaise']),
      taxRateBp: serializer.fromJson<int>(json['taxRateBp']),
      priceIncludesTax: serializer.fromJson<bool>(json['priceIncludesTax']),
      hsn: serializer.fromJson<String?>(json['hsn']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'barcode': serializer.toJson<String?>(barcode),
      'unit': serializer.toJson<String>(unit),
      'salePricePaise': serializer.toJson<int>(salePricePaise),
      'mrpPaise': serializer.toJson<int?>(mrpPaise),
      'taxRateBp': serializer.toJson<int>(taxRateBp),
      'priceIncludesTax': serializer.toJson<bool>(priceIncludesTax),
      'hsn': serializer.toJson<String?>(hsn),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ItemRow copyWith({
    int? id,
    String? name,
    Value<String?> barcode = const Value.absent(),
    String? unit,
    int? salePricePaise,
    Value<int?> mrpPaise = const Value.absent(),
    int? taxRateBp,
    bool? priceIncludesTax,
    Value<String?> hsn = const Value.absent(),
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => ItemRow(
    id: id ?? this.id,
    name: name ?? this.name,
    barcode: barcode.present ? barcode.value : this.barcode,
    unit: unit ?? this.unit,
    salePricePaise: salePricePaise ?? this.salePricePaise,
    mrpPaise: mrpPaise.present ? mrpPaise.value : this.mrpPaise,
    taxRateBp: taxRateBp ?? this.taxRateBp,
    priceIncludesTax: priceIncludesTax ?? this.priceIncludesTax,
    hsn: hsn.present ? hsn.value : this.hsn,
    isActive: isActive ?? this.isActive,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  ItemRow copyWithCompanion(ItemsCompanion data) {
    return ItemRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      barcode: data.barcode.present ? data.barcode.value : this.barcode,
      unit: data.unit.present ? data.unit.value : this.unit,
      salePricePaise: data.salePricePaise.present
          ? data.salePricePaise.value
          : this.salePricePaise,
      mrpPaise: data.mrpPaise.present ? data.mrpPaise.value : this.mrpPaise,
      taxRateBp: data.taxRateBp.present ? data.taxRateBp.value : this.taxRateBp,
      priceIncludesTax: data.priceIncludesTax.present
          ? data.priceIncludesTax.value
          : this.priceIncludesTax,
      hsn: data.hsn.present ? data.hsn.value : this.hsn,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ItemRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('barcode: $barcode, ')
          ..write('unit: $unit, ')
          ..write('salePricePaise: $salePricePaise, ')
          ..write('mrpPaise: $mrpPaise, ')
          ..write('taxRateBp: $taxRateBp, ')
          ..write('priceIncludesTax: $priceIncludesTax, ')
          ..write('hsn: $hsn, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    barcode,
    unit,
    salePricePaise,
    mrpPaise,
    taxRateBp,
    priceIncludesTax,
    hsn,
    isActive,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ItemRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.barcode == this.barcode &&
          other.unit == this.unit &&
          other.salePricePaise == this.salePricePaise &&
          other.mrpPaise == this.mrpPaise &&
          other.taxRateBp == this.taxRateBp &&
          other.priceIncludesTax == this.priceIncludesTax &&
          other.hsn == this.hsn &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ItemsCompanion extends UpdateCompanion<ItemRow> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> barcode;
  final Value<String> unit;
  final Value<int> salePricePaise;
  final Value<int?> mrpPaise;
  final Value<int> taxRateBp;
  final Value<bool> priceIncludesTax;
  final Value<String?> hsn;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const ItemsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.barcode = const Value.absent(),
    this.unit = const Value.absent(),
    this.salePricePaise = const Value.absent(),
    this.mrpPaise = const Value.absent(),
    this.taxRateBp = const Value.absent(),
    this.priceIncludesTax = const Value.absent(),
    this.hsn = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  ItemsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.barcode = const Value.absent(),
    this.unit = const Value.absent(),
    required int salePricePaise,
    this.mrpPaise = const Value.absent(),
    this.taxRateBp = const Value.absent(),
    this.priceIncludesTax = const Value.absent(),
    this.hsn = const Value.absent(),
    this.isActive = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : name = Value(name),
       salePricePaise = Value(salePricePaise),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<ItemRow> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? barcode,
    Expression<String>? unit,
    Expression<int>? salePricePaise,
    Expression<int>? mrpPaise,
    Expression<int>? taxRateBp,
    Expression<bool>? priceIncludesTax,
    Expression<String>? hsn,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (barcode != null) 'barcode': barcode,
      if (unit != null) 'unit': unit,
      if (salePricePaise != null) 'sale_price_paise': salePricePaise,
      if (mrpPaise != null) 'mrp_paise': mrpPaise,
      if (taxRateBp != null) 'tax_rate_bp': taxRateBp,
      if (priceIncludesTax != null) 'price_includes_tax': priceIncludesTax,
      if (hsn != null) 'hsn': hsn,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  ItemsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String?>? barcode,
    Value<String>? unit,
    Value<int>? salePricePaise,
    Value<int?>? mrpPaise,
    Value<int>? taxRateBp,
    Value<bool>? priceIncludesTax,
    Value<String?>? hsn,
    Value<bool>? isActive,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return ItemsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      barcode: barcode ?? this.barcode,
      unit: unit ?? this.unit,
      salePricePaise: salePricePaise ?? this.salePricePaise,
      mrpPaise: mrpPaise ?? this.mrpPaise,
      taxRateBp: taxRateBp ?? this.taxRateBp,
      priceIncludesTax: priceIncludesTax ?? this.priceIncludesTax,
      hsn: hsn ?? this.hsn,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (barcode.present) {
      map['barcode'] = Variable<String>(barcode.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (salePricePaise.present) {
      map['sale_price_paise'] = Variable<int>(salePricePaise.value);
    }
    if (mrpPaise.present) {
      map['mrp_paise'] = Variable<int>(mrpPaise.value);
    }
    if (taxRateBp.present) {
      map['tax_rate_bp'] = Variable<int>(taxRateBp.value);
    }
    if (priceIncludesTax.present) {
      map['price_includes_tax'] = Variable<bool>(priceIncludesTax.value);
    }
    if (hsn.present) {
      map['hsn'] = Variable<String>(hsn.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ItemsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('barcode: $barcode, ')
          ..write('unit: $unit, ')
          ..write('salePricePaise: $salePricePaise, ')
          ..write('mrpPaise: $mrpPaise, ')
          ..write('taxRateBp: $taxRateBp, ')
          ..write('priceIncludesTax: $priceIncludesTax, ')
          ..write('hsn: $hsn, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $BillsTable extends Bills with TableInfo<$BillsTable, BillRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BillsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _invoiceNoMeta = const VerificationMeta(
    'invoiceNo',
  );
  @override
  late final GeneratedColumn<String> invoiceNo = GeneratedColumn<String>(
    'invoice_no',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _fyStartMeta = const VerificationMeta(
    'fyStart',
  );
  @override
  late final GeneratedColumn<int> fyStart = GeneratedColumn<int>(
    'fy_start',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sequenceMeta = const VerificationMeta(
    'sequence',
  );
  @override
  late final GeneratedColumn<int> sequence = GeneratedColumn<int>(
    'sequence',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _billedAtMeta = const VerificationMeta(
    'billedAt',
  );
  @override
  late final GeneratedColumn<DateTime> billedAt = GeneratedColumn<DateTime>(
    'billed_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _customerNameMeta = const VerificationMeta(
    'customerName',
  );
  @override
  late final GeneratedColumn<String> customerName = GeneratedColumn<String>(
    'customer_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _customerPhoneMeta = const VerificationMeta(
    'customerPhone',
  );
  @override
  late final GeneratedColumn<String> customerPhone = GeneratedColumn<String>(
    'customer_phone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _itemsTotalPaiseMeta = const VerificationMeta(
    'itemsTotalPaise',
  );
  @override
  late final GeneratedColumn<int> itemsTotalPaise = GeneratedColumn<int>(
    'items_total_paise',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _billDiscountPaiseMeta = const VerificationMeta(
    'billDiscountPaise',
  );
  @override
  late final GeneratedColumn<int> billDiscountPaise = GeneratedColumn<int>(
    'bill_discount_paise',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _taxablePaiseMeta = const VerificationMeta(
    'taxablePaise',
  );
  @override
  late final GeneratedColumn<int> taxablePaise = GeneratedColumn<int>(
    'taxable_paise',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _taxPaiseMeta = const VerificationMeta(
    'taxPaise',
  );
  @override
  late final GeneratedColumn<int> taxPaise = GeneratedColumn<int>(
    'tax_paise',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _roundOffPaiseMeta = const VerificationMeta(
    'roundOffPaise',
  );
  @override
  late final GeneratedColumn<int> roundOffPaise = GeneratedColumn<int>(
    'round_off_paise',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _grandTotalPaiseMeta = const VerificationMeta(
    'grandTotalPaise',
  );
  @override
  late final GeneratedColumn<int> grandTotalPaise = GeneratedColumn<int>(
    'grand_total_paise',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _paymentModeMeta = const VerificationMeta(
    'paymentMode',
  );
  @override
  late final GeneratedColumn<String> paymentMode = GeneratedColumn<String>(
    'payment_mode',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('completed'),
  );
  static const VerificationMeta _cancelledAtMeta = const VerificationMeta(
    'cancelledAt',
  );
  @override
  late final GeneratedColumn<DateTime> cancelledAt = GeneratedColumn<DateTime>(
    'cancelled_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cancelReasonMeta = const VerificationMeta(
    'cancelReason',
  );
  @override
  late final GeneratedColumn<String> cancelReason = GeneratedColumn<String>(
    'cancel_reason',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    invoiceNo,
    fyStart,
    sequence,
    billedAt,
    customerName,
    customerPhone,
    itemsTotalPaise,
    billDiscountPaise,
    taxablePaise,
    taxPaise,
    roundOffPaise,
    grandTotalPaise,
    paymentMode,
    status,
    cancelledAt,
    cancelReason,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'bills';
  @override
  VerificationContext validateIntegrity(
    Insertable<BillRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('invoice_no')) {
      context.handle(
        _invoiceNoMeta,
        invoiceNo.isAcceptableOrUnknown(data['invoice_no']!, _invoiceNoMeta),
      );
    } else if (isInserting) {
      context.missing(_invoiceNoMeta);
    }
    if (data.containsKey('fy_start')) {
      context.handle(
        _fyStartMeta,
        fyStart.isAcceptableOrUnknown(data['fy_start']!, _fyStartMeta),
      );
    } else if (isInserting) {
      context.missing(_fyStartMeta);
    }
    if (data.containsKey('sequence')) {
      context.handle(
        _sequenceMeta,
        sequence.isAcceptableOrUnknown(data['sequence']!, _sequenceMeta),
      );
    } else if (isInserting) {
      context.missing(_sequenceMeta);
    }
    if (data.containsKey('billed_at')) {
      context.handle(
        _billedAtMeta,
        billedAt.isAcceptableOrUnknown(data['billed_at']!, _billedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_billedAtMeta);
    }
    if (data.containsKey('customer_name')) {
      context.handle(
        _customerNameMeta,
        customerName.isAcceptableOrUnknown(
          data['customer_name']!,
          _customerNameMeta,
        ),
      );
    }
    if (data.containsKey('customer_phone')) {
      context.handle(
        _customerPhoneMeta,
        customerPhone.isAcceptableOrUnknown(
          data['customer_phone']!,
          _customerPhoneMeta,
        ),
      );
    }
    if (data.containsKey('items_total_paise')) {
      context.handle(
        _itemsTotalPaiseMeta,
        itemsTotalPaise.isAcceptableOrUnknown(
          data['items_total_paise']!,
          _itemsTotalPaiseMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_itemsTotalPaiseMeta);
    }
    if (data.containsKey('bill_discount_paise')) {
      context.handle(
        _billDiscountPaiseMeta,
        billDiscountPaise.isAcceptableOrUnknown(
          data['bill_discount_paise']!,
          _billDiscountPaiseMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_billDiscountPaiseMeta);
    }
    if (data.containsKey('taxable_paise')) {
      context.handle(
        _taxablePaiseMeta,
        taxablePaise.isAcceptableOrUnknown(
          data['taxable_paise']!,
          _taxablePaiseMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_taxablePaiseMeta);
    }
    if (data.containsKey('tax_paise')) {
      context.handle(
        _taxPaiseMeta,
        taxPaise.isAcceptableOrUnknown(data['tax_paise']!, _taxPaiseMeta),
      );
    } else if (isInserting) {
      context.missing(_taxPaiseMeta);
    }
    if (data.containsKey('round_off_paise')) {
      context.handle(
        _roundOffPaiseMeta,
        roundOffPaise.isAcceptableOrUnknown(
          data['round_off_paise']!,
          _roundOffPaiseMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_roundOffPaiseMeta);
    }
    if (data.containsKey('grand_total_paise')) {
      context.handle(
        _grandTotalPaiseMeta,
        grandTotalPaise.isAcceptableOrUnknown(
          data['grand_total_paise']!,
          _grandTotalPaiseMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_grandTotalPaiseMeta);
    }
    if (data.containsKey('payment_mode')) {
      context.handle(
        _paymentModeMeta,
        paymentMode.isAcceptableOrUnknown(
          data['payment_mode']!,
          _paymentModeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_paymentModeMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('cancelled_at')) {
      context.handle(
        _cancelledAtMeta,
        cancelledAt.isAcceptableOrUnknown(
          data['cancelled_at']!,
          _cancelledAtMeta,
        ),
      );
    }
    if (data.containsKey('cancel_reason')) {
      context.handle(
        _cancelReasonMeta,
        cancelReason.isAcceptableOrUnknown(
          data['cancel_reason']!,
          _cancelReasonMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {fyStart, sequence},
  ];
  @override
  BillRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BillRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      invoiceNo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}invoice_no'],
      )!,
      fyStart: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}fy_start'],
      )!,
      sequence: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sequence'],
      )!,
      billedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}billed_at'],
      )!,
      customerName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}customer_name'],
      ),
      customerPhone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}customer_phone'],
      ),
      itemsTotalPaise: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}items_total_paise'],
      )!,
      billDiscountPaise: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}bill_discount_paise'],
      )!,
      taxablePaise: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}taxable_paise'],
      )!,
      taxPaise: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tax_paise'],
      )!,
      roundOffPaise: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}round_off_paise'],
      )!,
      grandTotalPaise: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}grand_total_paise'],
      )!,
      paymentMode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payment_mode'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      cancelledAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}cancelled_at'],
      ),
      cancelReason: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cancel_reason'],
      ),
    );
  }

  @override
  $BillsTable createAlias(String alias) {
    return $BillsTable(attachedDatabase, alias);
  }
}

class BillRow extends DataClass implements Insertable<BillRow> {
  final int id;
  final String invoiceNo;
  final int fyStart;
  final int sequence;
  final DateTime billedAt;
  final String? customerName;
  final String? customerPhone;
  final int itemsTotalPaise;
  final int billDiscountPaise;
  final int taxablePaise;
  final int taxPaise;
  final int roundOffPaise;
  final int grandTotalPaise;

  /// `cash`, `upi`, `card` or `credit`.
  final String paymentMode;

  /// `completed` or `cancelled`. Bills are never deleted.
  final String status;
  final DateTime? cancelledAt;
  final String? cancelReason;
  const BillRow({
    required this.id,
    required this.invoiceNo,
    required this.fyStart,
    required this.sequence,
    required this.billedAt,
    this.customerName,
    this.customerPhone,
    required this.itemsTotalPaise,
    required this.billDiscountPaise,
    required this.taxablePaise,
    required this.taxPaise,
    required this.roundOffPaise,
    required this.grandTotalPaise,
    required this.paymentMode,
    required this.status,
    this.cancelledAt,
    this.cancelReason,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['invoice_no'] = Variable<String>(invoiceNo);
    map['fy_start'] = Variable<int>(fyStart);
    map['sequence'] = Variable<int>(sequence);
    map['billed_at'] = Variable<DateTime>(billedAt);
    if (!nullToAbsent || customerName != null) {
      map['customer_name'] = Variable<String>(customerName);
    }
    if (!nullToAbsent || customerPhone != null) {
      map['customer_phone'] = Variable<String>(customerPhone);
    }
    map['items_total_paise'] = Variable<int>(itemsTotalPaise);
    map['bill_discount_paise'] = Variable<int>(billDiscountPaise);
    map['taxable_paise'] = Variable<int>(taxablePaise);
    map['tax_paise'] = Variable<int>(taxPaise);
    map['round_off_paise'] = Variable<int>(roundOffPaise);
    map['grand_total_paise'] = Variable<int>(grandTotalPaise);
    map['payment_mode'] = Variable<String>(paymentMode);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || cancelledAt != null) {
      map['cancelled_at'] = Variable<DateTime>(cancelledAt);
    }
    if (!nullToAbsent || cancelReason != null) {
      map['cancel_reason'] = Variable<String>(cancelReason);
    }
    return map;
  }

  BillsCompanion toCompanion(bool nullToAbsent) {
    return BillsCompanion(
      id: Value(id),
      invoiceNo: Value(invoiceNo),
      fyStart: Value(fyStart),
      sequence: Value(sequence),
      billedAt: Value(billedAt),
      customerName: customerName == null && nullToAbsent
          ? const Value.absent()
          : Value(customerName),
      customerPhone: customerPhone == null && nullToAbsent
          ? const Value.absent()
          : Value(customerPhone),
      itemsTotalPaise: Value(itemsTotalPaise),
      billDiscountPaise: Value(billDiscountPaise),
      taxablePaise: Value(taxablePaise),
      taxPaise: Value(taxPaise),
      roundOffPaise: Value(roundOffPaise),
      grandTotalPaise: Value(grandTotalPaise),
      paymentMode: Value(paymentMode),
      status: Value(status),
      cancelledAt: cancelledAt == null && nullToAbsent
          ? const Value.absent()
          : Value(cancelledAt),
      cancelReason: cancelReason == null && nullToAbsent
          ? const Value.absent()
          : Value(cancelReason),
    );
  }

  factory BillRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BillRow(
      id: serializer.fromJson<int>(json['id']),
      invoiceNo: serializer.fromJson<String>(json['invoiceNo']),
      fyStart: serializer.fromJson<int>(json['fyStart']),
      sequence: serializer.fromJson<int>(json['sequence']),
      billedAt: serializer.fromJson<DateTime>(json['billedAt']),
      customerName: serializer.fromJson<String?>(json['customerName']),
      customerPhone: serializer.fromJson<String?>(json['customerPhone']),
      itemsTotalPaise: serializer.fromJson<int>(json['itemsTotalPaise']),
      billDiscountPaise: serializer.fromJson<int>(json['billDiscountPaise']),
      taxablePaise: serializer.fromJson<int>(json['taxablePaise']),
      taxPaise: serializer.fromJson<int>(json['taxPaise']),
      roundOffPaise: serializer.fromJson<int>(json['roundOffPaise']),
      grandTotalPaise: serializer.fromJson<int>(json['grandTotalPaise']),
      paymentMode: serializer.fromJson<String>(json['paymentMode']),
      status: serializer.fromJson<String>(json['status']),
      cancelledAt: serializer.fromJson<DateTime?>(json['cancelledAt']),
      cancelReason: serializer.fromJson<String?>(json['cancelReason']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'invoiceNo': serializer.toJson<String>(invoiceNo),
      'fyStart': serializer.toJson<int>(fyStart),
      'sequence': serializer.toJson<int>(sequence),
      'billedAt': serializer.toJson<DateTime>(billedAt),
      'customerName': serializer.toJson<String?>(customerName),
      'customerPhone': serializer.toJson<String?>(customerPhone),
      'itemsTotalPaise': serializer.toJson<int>(itemsTotalPaise),
      'billDiscountPaise': serializer.toJson<int>(billDiscountPaise),
      'taxablePaise': serializer.toJson<int>(taxablePaise),
      'taxPaise': serializer.toJson<int>(taxPaise),
      'roundOffPaise': serializer.toJson<int>(roundOffPaise),
      'grandTotalPaise': serializer.toJson<int>(grandTotalPaise),
      'paymentMode': serializer.toJson<String>(paymentMode),
      'status': serializer.toJson<String>(status),
      'cancelledAt': serializer.toJson<DateTime?>(cancelledAt),
      'cancelReason': serializer.toJson<String?>(cancelReason),
    };
  }

  BillRow copyWith({
    int? id,
    String? invoiceNo,
    int? fyStart,
    int? sequence,
    DateTime? billedAt,
    Value<String?> customerName = const Value.absent(),
    Value<String?> customerPhone = const Value.absent(),
    int? itemsTotalPaise,
    int? billDiscountPaise,
    int? taxablePaise,
    int? taxPaise,
    int? roundOffPaise,
    int? grandTotalPaise,
    String? paymentMode,
    String? status,
    Value<DateTime?> cancelledAt = const Value.absent(),
    Value<String?> cancelReason = const Value.absent(),
  }) => BillRow(
    id: id ?? this.id,
    invoiceNo: invoiceNo ?? this.invoiceNo,
    fyStart: fyStart ?? this.fyStart,
    sequence: sequence ?? this.sequence,
    billedAt: billedAt ?? this.billedAt,
    customerName: customerName.present ? customerName.value : this.customerName,
    customerPhone: customerPhone.present
        ? customerPhone.value
        : this.customerPhone,
    itemsTotalPaise: itemsTotalPaise ?? this.itemsTotalPaise,
    billDiscountPaise: billDiscountPaise ?? this.billDiscountPaise,
    taxablePaise: taxablePaise ?? this.taxablePaise,
    taxPaise: taxPaise ?? this.taxPaise,
    roundOffPaise: roundOffPaise ?? this.roundOffPaise,
    grandTotalPaise: grandTotalPaise ?? this.grandTotalPaise,
    paymentMode: paymentMode ?? this.paymentMode,
    status: status ?? this.status,
    cancelledAt: cancelledAt.present ? cancelledAt.value : this.cancelledAt,
    cancelReason: cancelReason.present ? cancelReason.value : this.cancelReason,
  );
  BillRow copyWithCompanion(BillsCompanion data) {
    return BillRow(
      id: data.id.present ? data.id.value : this.id,
      invoiceNo: data.invoiceNo.present ? data.invoiceNo.value : this.invoiceNo,
      fyStart: data.fyStart.present ? data.fyStart.value : this.fyStart,
      sequence: data.sequence.present ? data.sequence.value : this.sequence,
      billedAt: data.billedAt.present ? data.billedAt.value : this.billedAt,
      customerName: data.customerName.present
          ? data.customerName.value
          : this.customerName,
      customerPhone: data.customerPhone.present
          ? data.customerPhone.value
          : this.customerPhone,
      itemsTotalPaise: data.itemsTotalPaise.present
          ? data.itemsTotalPaise.value
          : this.itemsTotalPaise,
      billDiscountPaise: data.billDiscountPaise.present
          ? data.billDiscountPaise.value
          : this.billDiscountPaise,
      taxablePaise: data.taxablePaise.present
          ? data.taxablePaise.value
          : this.taxablePaise,
      taxPaise: data.taxPaise.present ? data.taxPaise.value : this.taxPaise,
      roundOffPaise: data.roundOffPaise.present
          ? data.roundOffPaise.value
          : this.roundOffPaise,
      grandTotalPaise: data.grandTotalPaise.present
          ? data.grandTotalPaise.value
          : this.grandTotalPaise,
      paymentMode: data.paymentMode.present
          ? data.paymentMode.value
          : this.paymentMode,
      status: data.status.present ? data.status.value : this.status,
      cancelledAt: data.cancelledAt.present
          ? data.cancelledAt.value
          : this.cancelledAt,
      cancelReason: data.cancelReason.present
          ? data.cancelReason.value
          : this.cancelReason,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BillRow(')
          ..write('id: $id, ')
          ..write('invoiceNo: $invoiceNo, ')
          ..write('fyStart: $fyStart, ')
          ..write('sequence: $sequence, ')
          ..write('billedAt: $billedAt, ')
          ..write('customerName: $customerName, ')
          ..write('customerPhone: $customerPhone, ')
          ..write('itemsTotalPaise: $itemsTotalPaise, ')
          ..write('billDiscountPaise: $billDiscountPaise, ')
          ..write('taxablePaise: $taxablePaise, ')
          ..write('taxPaise: $taxPaise, ')
          ..write('roundOffPaise: $roundOffPaise, ')
          ..write('grandTotalPaise: $grandTotalPaise, ')
          ..write('paymentMode: $paymentMode, ')
          ..write('status: $status, ')
          ..write('cancelledAt: $cancelledAt, ')
          ..write('cancelReason: $cancelReason')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    invoiceNo,
    fyStart,
    sequence,
    billedAt,
    customerName,
    customerPhone,
    itemsTotalPaise,
    billDiscountPaise,
    taxablePaise,
    taxPaise,
    roundOffPaise,
    grandTotalPaise,
    paymentMode,
    status,
    cancelledAt,
    cancelReason,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BillRow &&
          other.id == this.id &&
          other.invoiceNo == this.invoiceNo &&
          other.fyStart == this.fyStart &&
          other.sequence == this.sequence &&
          other.billedAt == this.billedAt &&
          other.customerName == this.customerName &&
          other.customerPhone == this.customerPhone &&
          other.itemsTotalPaise == this.itemsTotalPaise &&
          other.billDiscountPaise == this.billDiscountPaise &&
          other.taxablePaise == this.taxablePaise &&
          other.taxPaise == this.taxPaise &&
          other.roundOffPaise == this.roundOffPaise &&
          other.grandTotalPaise == this.grandTotalPaise &&
          other.paymentMode == this.paymentMode &&
          other.status == this.status &&
          other.cancelledAt == this.cancelledAt &&
          other.cancelReason == this.cancelReason);
}

class BillsCompanion extends UpdateCompanion<BillRow> {
  final Value<int> id;
  final Value<String> invoiceNo;
  final Value<int> fyStart;
  final Value<int> sequence;
  final Value<DateTime> billedAt;
  final Value<String?> customerName;
  final Value<String?> customerPhone;
  final Value<int> itemsTotalPaise;
  final Value<int> billDiscountPaise;
  final Value<int> taxablePaise;
  final Value<int> taxPaise;
  final Value<int> roundOffPaise;
  final Value<int> grandTotalPaise;
  final Value<String> paymentMode;
  final Value<String> status;
  final Value<DateTime?> cancelledAt;
  final Value<String?> cancelReason;
  const BillsCompanion({
    this.id = const Value.absent(),
    this.invoiceNo = const Value.absent(),
    this.fyStart = const Value.absent(),
    this.sequence = const Value.absent(),
    this.billedAt = const Value.absent(),
    this.customerName = const Value.absent(),
    this.customerPhone = const Value.absent(),
    this.itemsTotalPaise = const Value.absent(),
    this.billDiscountPaise = const Value.absent(),
    this.taxablePaise = const Value.absent(),
    this.taxPaise = const Value.absent(),
    this.roundOffPaise = const Value.absent(),
    this.grandTotalPaise = const Value.absent(),
    this.paymentMode = const Value.absent(),
    this.status = const Value.absent(),
    this.cancelledAt = const Value.absent(),
    this.cancelReason = const Value.absent(),
  });
  BillsCompanion.insert({
    this.id = const Value.absent(),
    required String invoiceNo,
    required int fyStart,
    required int sequence,
    required DateTime billedAt,
    this.customerName = const Value.absent(),
    this.customerPhone = const Value.absent(),
    required int itemsTotalPaise,
    required int billDiscountPaise,
    required int taxablePaise,
    required int taxPaise,
    required int roundOffPaise,
    required int grandTotalPaise,
    required String paymentMode,
    this.status = const Value.absent(),
    this.cancelledAt = const Value.absent(),
    this.cancelReason = const Value.absent(),
  }) : invoiceNo = Value(invoiceNo),
       fyStart = Value(fyStart),
       sequence = Value(sequence),
       billedAt = Value(billedAt),
       itemsTotalPaise = Value(itemsTotalPaise),
       billDiscountPaise = Value(billDiscountPaise),
       taxablePaise = Value(taxablePaise),
       taxPaise = Value(taxPaise),
       roundOffPaise = Value(roundOffPaise),
       grandTotalPaise = Value(grandTotalPaise),
       paymentMode = Value(paymentMode);
  static Insertable<BillRow> custom({
    Expression<int>? id,
    Expression<String>? invoiceNo,
    Expression<int>? fyStart,
    Expression<int>? sequence,
    Expression<DateTime>? billedAt,
    Expression<String>? customerName,
    Expression<String>? customerPhone,
    Expression<int>? itemsTotalPaise,
    Expression<int>? billDiscountPaise,
    Expression<int>? taxablePaise,
    Expression<int>? taxPaise,
    Expression<int>? roundOffPaise,
    Expression<int>? grandTotalPaise,
    Expression<String>? paymentMode,
    Expression<String>? status,
    Expression<DateTime>? cancelledAt,
    Expression<String>? cancelReason,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (invoiceNo != null) 'invoice_no': invoiceNo,
      if (fyStart != null) 'fy_start': fyStart,
      if (sequence != null) 'sequence': sequence,
      if (billedAt != null) 'billed_at': billedAt,
      if (customerName != null) 'customer_name': customerName,
      if (customerPhone != null) 'customer_phone': customerPhone,
      if (itemsTotalPaise != null) 'items_total_paise': itemsTotalPaise,
      if (billDiscountPaise != null) 'bill_discount_paise': billDiscountPaise,
      if (taxablePaise != null) 'taxable_paise': taxablePaise,
      if (taxPaise != null) 'tax_paise': taxPaise,
      if (roundOffPaise != null) 'round_off_paise': roundOffPaise,
      if (grandTotalPaise != null) 'grand_total_paise': grandTotalPaise,
      if (paymentMode != null) 'payment_mode': paymentMode,
      if (status != null) 'status': status,
      if (cancelledAt != null) 'cancelled_at': cancelledAt,
      if (cancelReason != null) 'cancel_reason': cancelReason,
    });
  }

  BillsCompanion copyWith({
    Value<int>? id,
    Value<String>? invoiceNo,
    Value<int>? fyStart,
    Value<int>? sequence,
    Value<DateTime>? billedAt,
    Value<String?>? customerName,
    Value<String?>? customerPhone,
    Value<int>? itemsTotalPaise,
    Value<int>? billDiscountPaise,
    Value<int>? taxablePaise,
    Value<int>? taxPaise,
    Value<int>? roundOffPaise,
    Value<int>? grandTotalPaise,
    Value<String>? paymentMode,
    Value<String>? status,
    Value<DateTime?>? cancelledAt,
    Value<String?>? cancelReason,
  }) {
    return BillsCompanion(
      id: id ?? this.id,
      invoiceNo: invoiceNo ?? this.invoiceNo,
      fyStart: fyStart ?? this.fyStart,
      sequence: sequence ?? this.sequence,
      billedAt: billedAt ?? this.billedAt,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      itemsTotalPaise: itemsTotalPaise ?? this.itemsTotalPaise,
      billDiscountPaise: billDiscountPaise ?? this.billDiscountPaise,
      taxablePaise: taxablePaise ?? this.taxablePaise,
      taxPaise: taxPaise ?? this.taxPaise,
      roundOffPaise: roundOffPaise ?? this.roundOffPaise,
      grandTotalPaise: grandTotalPaise ?? this.grandTotalPaise,
      paymentMode: paymentMode ?? this.paymentMode,
      status: status ?? this.status,
      cancelledAt: cancelledAt ?? this.cancelledAt,
      cancelReason: cancelReason ?? this.cancelReason,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (invoiceNo.present) {
      map['invoice_no'] = Variable<String>(invoiceNo.value);
    }
    if (fyStart.present) {
      map['fy_start'] = Variable<int>(fyStart.value);
    }
    if (sequence.present) {
      map['sequence'] = Variable<int>(sequence.value);
    }
    if (billedAt.present) {
      map['billed_at'] = Variable<DateTime>(billedAt.value);
    }
    if (customerName.present) {
      map['customer_name'] = Variable<String>(customerName.value);
    }
    if (customerPhone.present) {
      map['customer_phone'] = Variable<String>(customerPhone.value);
    }
    if (itemsTotalPaise.present) {
      map['items_total_paise'] = Variable<int>(itemsTotalPaise.value);
    }
    if (billDiscountPaise.present) {
      map['bill_discount_paise'] = Variable<int>(billDiscountPaise.value);
    }
    if (taxablePaise.present) {
      map['taxable_paise'] = Variable<int>(taxablePaise.value);
    }
    if (taxPaise.present) {
      map['tax_paise'] = Variable<int>(taxPaise.value);
    }
    if (roundOffPaise.present) {
      map['round_off_paise'] = Variable<int>(roundOffPaise.value);
    }
    if (grandTotalPaise.present) {
      map['grand_total_paise'] = Variable<int>(grandTotalPaise.value);
    }
    if (paymentMode.present) {
      map['payment_mode'] = Variable<String>(paymentMode.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (cancelledAt.present) {
      map['cancelled_at'] = Variable<DateTime>(cancelledAt.value);
    }
    if (cancelReason.present) {
      map['cancel_reason'] = Variable<String>(cancelReason.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BillsCompanion(')
          ..write('id: $id, ')
          ..write('invoiceNo: $invoiceNo, ')
          ..write('fyStart: $fyStart, ')
          ..write('sequence: $sequence, ')
          ..write('billedAt: $billedAt, ')
          ..write('customerName: $customerName, ')
          ..write('customerPhone: $customerPhone, ')
          ..write('itemsTotalPaise: $itemsTotalPaise, ')
          ..write('billDiscountPaise: $billDiscountPaise, ')
          ..write('taxablePaise: $taxablePaise, ')
          ..write('taxPaise: $taxPaise, ')
          ..write('roundOffPaise: $roundOffPaise, ')
          ..write('grandTotalPaise: $grandTotalPaise, ')
          ..write('paymentMode: $paymentMode, ')
          ..write('status: $status, ')
          ..write('cancelledAt: $cancelledAt, ')
          ..write('cancelReason: $cancelReason')
          ..write(')'))
        .toString();
  }
}

class $BillLinesTable extends BillLines
    with TableInfo<$BillLinesTable, BillLineRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BillLinesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _billIdMeta = const VerificationMeta('billId');
  @override
  late final GeneratedColumn<int> billId = GeneratedColumn<int>(
    'bill_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES bills (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _itemIdMeta = const VerificationMeta('itemId');
  @override
  late final GeneratedColumn<int> itemId = GeneratedColumn<int>(
    'item_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES items (id)',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
    'unit',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hsnMeta = const VerificationMeta('hsn');
  @override
  late final GeneratedColumn<String> hsn = GeneratedColumn<String>(
    'hsn',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _quantityMilliMeta = const VerificationMeta(
    'quantityMilli',
  );
  @override
  late final GeneratedColumn<int> quantityMilli = GeneratedColumn<int>(
    'quantity_milli',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitPricePaiseMeta = const VerificationMeta(
    'unitPricePaise',
  );
  @override
  late final GeneratedColumn<int> unitPricePaise = GeneratedColumn<int>(
    'unit_price_paise',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _taxRateBpMeta = const VerificationMeta(
    'taxRateBp',
  );
  @override
  late final GeneratedColumn<int> taxRateBp = GeneratedColumn<int>(
    'tax_rate_bp',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _priceIncludesTaxMeta = const VerificationMeta(
    'priceIncludesTax',
  );
  @override
  late final GeneratedColumn<bool> priceIncludesTax = GeneratedColumn<bool>(
    'price_includes_tax',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("price_includes_tax" IN (0, 1))',
    ),
  );
  static const VerificationMeta _discountPaiseMeta = const VerificationMeta(
    'discountPaise',
  );
  @override
  late final GeneratedColumn<int> discountPaise = GeneratedColumn<int>(
    'discount_paise',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _billDiscountSharePaiseMeta =
      const VerificationMeta('billDiscountSharePaise');
  @override
  late final GeneratedColumn<int> billDiscountSharePaise = GeneratedColumn<int>(
    'bill_discount_share_paise',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _taxablePaiseMeta = const VerificationMeta(
    'taxablePaise',
  );
  @override
  late final GeneratedColumn<int> taxablePaise = GeneratedColumn<int>(
    'taxable_paise',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _taxPaiseMeta = const VerificationMeta(
    'taxPaise',
  );
  @override
  late final GeneratedColumn<int> taxPaise = GeneratedColumn<int>(
    'tax_paise',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalPaiseMeta = const VerificationMeta(
    'totalPaise',
  );
  @override
  late final GeneratedColumn<int> totalPaise = GeneratedColumn<int>(
    'total_paise',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    billId,
    position,
    itemId,
    name,
    unit,
    hsn,
    quantityMilli,
    unitPricePaise,
    taxRateBp,
    priceIncludesTax,
    discountPaise,
    billDiscountSharePaise,
    taxablePaise,
    taxPaise,
    totalPaise,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'bill_lines';
  @override
  VerificationContext validateIntegrity(
    Insertable<BillLineRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('bill_id')) {
      context.handle(
        _billIdMeta,
        billId.isAcceptableOrUnknown(data['bill_id']!, _billIdMeta),
      );
    } else if (isInserting) {
      context.missing(_billIdMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('item_id')) {
      context.handle(
        _itemIdMeta,
        itemId.isAcceptableOrUnknown(data['item_id']!, _itemIdMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('unit')) {
      context.handle(
        _unitMeta,
        unit.isAcceptableOrUnknown(data['unit']!, _unitMeta),
      );
    } else if (isInserting) {
      context.missing(_unitMeta);
    }
    if (data.containsKey('hsn')) {
      context.handle(
        _hsnMeta,
        hsn.isAcceptableOrUnknown(data['hsn']!, _hsnMeta),
      );
    }
    if (data.containsKey('quantity_milli')) {
      context.handle(
        _quantityMilliMeta,
        quantityMilli.isAcceptableOrUnknown(
          data['quantity_milli']!,
          _quantityMilliMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_quantityMilliMeta);
    }
    if (data.containsKey('unit_price_paise')) {
      context.handle(
        _unitPricePaiseMeta,
        unitPricePaise.isAcceptableOrUnknown(
          data['unit_price_paise']!,
          _unitPricePaiseMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_unitPricePaiseMeta);
    }
    if (data.containsKey('tax_rate_bp')) {
      context.handle(
        _taxRateBpMeta,
        taxRateBp.isAcceptableOrUnknown(data['tax_rate_bp']!, _taxRateBpMeta),
      );
    } else if (isInserting) {
      context.missing(_taxRateBpMeta);
    }
    if (data.containsKey('price_includes_tax')) {
      context.handle(
        _priceIncludesTaxMeta,
        priceIncludesTax.isAcceptableOrUnknown(
          data['price_includes_tax']!,
          _priceIncludesTaxMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_priceIncludesTaxMeta);
    }
    if (data.containsKey('discount_paise')) {
      context.handle(
        _discountPaiseMeta,
        discountPaise.isAcceptableOrUnknown(
          data['discount_paise']!,
          _discountPaiseMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_discountPaiseMeta);
    }
    if (data.containsKey('bill_discount_share_paise')) {
      context.handle(
        _billDiscountSharePaiseMeta,
        billDiscountSharePaise.isAcceptableOrUnknown(
          data['bill_discount_share_paise']!,
          _billDiscountSharePaiseMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_billDiscountSharePaiseMeta);
    }
    if (data.containsKey('taxable_paise')) {
      context.handle(
        _taxablePaiseMeta,
        taxablePaise.isAcceptableOrUnknown(
          data['taxable_paise']!,
          _taxablePaiseMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_taxablePaiseMeta);
    }
    if (data.containsKey('tax_paise')) {
      context.handle(
        _taxPaiseMeta,
        taxPaise.isAcceptableOrUnknown(data['tax_paise']!, _taxPaiseMeta),
      );
    } else if (isInserting) {
      context.missing(_taxPaiseMeta);
    }
    if (data.containsKey('total_paise')) {
      context.handle(
        _totalPaiseMeta,
        totalPaise.isAcceptableOrUnknown(data['total_paise']!, _totalPaiseMeta),
      );
    } else if (isInserting) {
      context.missing(_totalPaiseMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BillLineRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BillLineRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      billId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}bill_id'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
      itemId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}item_id'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      unit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit'],
      )!,
      hsn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hsn'],
      ),
      quantityMilli: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quantity_milli'],
      )!,
      unitPricePaise: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}unit_price_paise'],
      )!,
      taxRateBp: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tax_rate_bp'],
      )!,
      priceIncludesTax: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}price_includes_tax'],
      )!,
      discountPaise: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}discount_paise'],
      )!,
      billDiscountSharePaise: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}bill_discount_share_paise'],
      )!,
      taxablePaise: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}taxable_paise'],
      )!,
      taxPaise: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tax_paise'],
      )!,
      totalPaise: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_paise'],
      )!,
    );
  }

  @override
  $BillLinesTable createAlias(String alias) {
    return $BillLinesTable(attachedDatabase, alias);
  }
}

class BillLineRow extends DataClass implements Insertable<BillLineRow> {
  final int id;
  final int billId;
  final int position;

  /// Null for quick (unsaved) items.
  final int? itemId;
  final String name;
  final String unit;
  final String? hsn;
  final int quantityMilli;
  final int unitPricePaise;
  final int taxRateBp;
  final bool priceIncludesTax;
  final int discountPaise;
  final int billDiscountSharePaise;
  final int taxablePaise;
  final int taxPaise;
  final int totalPaise;
  const BillLineRow({
    required this.id,
    required this.billId,
    required this.position,
    this.itemId,
    required this.name,
    required this.unit,
    this.hsn,
    required this.quantityMilli,
    required this.unitPricePaise,
    required this.taxRateBp,
    required this.priceIncludesTax,
    required this.discountPaise,
    required this.billDiscountSharePaise,
    required this.taxablePaise,
    required this.taxPaise,
    required this.totalPaise,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['bill_id'] = Variable<int>(billId);
    map['position'] = Variable<int>(position);
    if (!nullToAbsent || itemId != null) {
      map['item_id'] = Variable<int>(itemId);
    }
    map['name'] = Variable<String>(name);
    map['unit'] = Variable<String>(unit);
    if (!nullToAbsent || hsn != null) {
      map['hsn'] = Variable<String>(hsn);
    }
    map['quantity_milli'] = Variable<int>(quantityMilli);
    map['unit_price_paise'] = Variable<int>(unitPricePaise);
    map['tax_rate_bp'] = Variable<int>(taxRateBp);
    map['price_includes_tax'] = Variable<bool>(priceIncludesTax);
    map['discount_paise'] = Variable<int>(discountPaise);
    map['bill_discount_share_paise'] = Variable<int>(billDiscountSharePaise);
    map['taxable_paise'] = Variable<int>(taxablePaise);
    map['tax_paise'] = Variable<int>(taxPaise);
    map['total_paise'] = Variable<int>(totalPaise);
    return map;
  }

  BillLinesCompanion toCompanion(bool nullToAbsent) {
    return BillLinesCompanion(
      id: Value(id),
      billId: Value(billId),
      position: Value(position),
      itemId: itemId == null && nullToAbsent
          ? const Value.absent()
          : Value(itemId),
      name: Value(name),
      unit: Value(unit),
      hsn: hsn == null && nullToAbsent ? const Value.absent() : Value(hsn),
      quantityMilli: Value(quantityMilli),
      unitPricePaise: Value(unitPricePaise),
      taxRateBp: Value(taxRateBp),
      priceIncludesTax: Value(priceIncludesTax),
      discountPaise: Value(discountPaise),
      billDiscountSharePaise: Value(billDiscountSharePaise),
      taxablePaise: Value(taxablePaise),
      taxPaise: Value(taxPaise),
      totalPaise: Value(totalPaise),
    );
  }

  factory BillLineRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BillLineRow(
      id: serializer.fromJson<int>(json['id']),
      billId: serializer.fromJson<int>(json['billId']),
      position: serializer.fromJson<int>(json['position']),
      itemId: serializer.fromJson<int?>(json['itemId']),
      name: serializer.fromJson<String>(json['name']),
      unit: serializer.fromJson<String>(json['unit']),
      hsn: serializer.fromJson<String?>(json['hsn']),
      quantityMilli: serializer.fromJson<int>(json['quantityMilli']),
      unitPricePaise: serializer.fromJson<int>(json['unitPricePaise']),
      taxRateBp: serializer.fromJson<int>(json['taxRateBp']),
      priceIncludesTax: serializer.fromJson<bool>(json['priceIncludesTax']),
      discountPaise: serializer.fromJson<int>(json['discountPaise']),
      billDiscountSharePaise: serializer.fromJson<int>(
        json['billDiscountSharePaise'],
      ),
      taxablePaise: serializer.fromJson<int>(json['taxablePaise']),
      taxPaise: serializer.fromJson<int>(json['taxPaise']),
      totalPaise: serializer.fromJson<int>(json['totalPaise']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'billId': serializer.toJson<int>(billId),
      'position': serializer.toJson<int>(position),
      'itemId': serializer.toJson<int?>(itemId),
      'name': serializer.toJson<String>(name),
      'unit': serializer.toJson<String>(unit),
      'hsn': serializer.toJson<String?>(hsn),
      'quantityMilli': serializer.toJson<int>(quantityMilli),
      'unitPricePaise': serializer.toJson<int>(unitPricePaise),
      'taxRateBp': serializer.toJson<int>(taxRateBp),
      'priceIncludesTax': serializer.toJson<bool>(priceIncludesTax),
      'discountPaise': serializer.toJson<int>(discountPaise),
      'billDiscountSharePaise': serializer.toJson<int>(billDiscountSharePaise),
      'taxablePaise': serializer.toJson<int>(taxablePaise),
      'taxPaise': serializer.toJson<int>(taxPaise),
      'totalPaise': serializer.toJson<int>(totalPaise),
    };
  }

  BillLineRow copyWith({
    int? id,
    int? billId,
    int? position,
    Value<int?> itemId = const Value.absent(),
    String? name,
    String? unit,
    Value<String?> hsn = const Value.absent(),
    int? quantityMilli,
    int? unitPricePaise,
    int? taxRateBp,
    bool? priceIncludesTax,
    int? discountPaise,
    int? billDiscountSharePaise,
    int? taxablePaise,
    int? taxPaise,
    int? totalPaise,
  }) => BillLineRow(
    id: id ?? this.id,
    billId: billId ?? this.billId,
    position: position ?? this.position,
    itemId: itemId.present ? itemId.value : this.itemId,
    name: name ?? this.name,
    unit: unit ?? this.unit,
    hsn: hsn.present ? hsn.value : this.hsn,
    quantityMilli: quantityMilli ?? this.quantityMilli,
    unitPricePaise: unitPricePaise ?? this.unitPricePaise,
    taxRateBp: taxRateBp ?? this.taxRateBp,
    priceIncludesTax: priceIncludesTax ?? this.priceIncludesTax,
    discountPaise: discountPaise ?? this.discountPaise,
    billDiscountSharePaise:
        billDiscountSharePaise ?? this.billDiscountSharePaise,
    taxablePaise: taxablePaise ?? this.taxablePaise,
    taxPaise: taxPaise ?? this.taxPaise,
    totalPaise: totalPaise ?? this.totalPaise,
  );
  BillLineRow copyWithCompanion(BillLinesCompanion data) {
    return BillLineRow(
      id: data.id.present ? data.id.value : this.id,
      billId: data.billId.present ? data.billId.value : this.billId,
      position: data.position.present ? data.position.value : this.position,
      itemId: data.itemId.present ? data.itemId.value : this.itemId,
      name: data.name.present ? data.name.value : this.name,
      unit: data.unit.present ? data.unit.value : this.unit,
      hsn: data.hsn.present ? data.hsn.value : this.hsn,
      quantityMilli: data.quantityMilli.present
          ? data.quantityMilli.value
          : this.quantityMilli,
      unitPricePaise: data.unitPricePaise.present
          ? data.unitPricePaise.value
          : this.unitPricePaise,
      taxRateBp: data.taxRateBp.present ? data.taxRateBp.value : this.taxRateBp,
      priceIncludesTax: data.priceIncludesTax.present
          ? data.priceIncludesTax.value
          : this.priceIncludesTax,
      discountPaise: data.discountPaise.present
          ? data.discountPaise.value
          : this.discountPaise,
      billDiscountSharePaise: data.billDiscountSharePaise.present
          ? data.billDiscountSharePaise.value
          : this.billDiscountSharePaise,
      taxablePaise: data.taxablePaise.present
          ? data.taxablePaise.value
          : this.taxablePaise,
      taxPaise: data.taxPaise.present ? data.taxPaise.value : this.taxPaise,
      totalPaise: data.totalPaise.present
          ? data.totalPaise.value
          : this.totalPaise,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BillLineRow(')
          ..write('id: $id, ')
          ..write('billId: $billId, ')
          ..write('position: $position, ')
          ..write('itemId: $itemId, ')
          ..write('name: $name, ')
          ..write('unit: $unit, ')
          ..write('hsn: $hsn, ')
          ..write('quantityMilli: $quantityMilli, ')
          ..write('unitPricePaise: $unitPricePaise, ')
          ..write('taxRateBp: $taxRateBp, ')
          ..write('priceIncludesTax: $priceIncludesTax, ')
          ..write('discountPaise: $discountPaise, ')
          ..write('billDiscountSharePaise: $billDiscountSharePaise, ')
          ..write('taxablePaise: $taxablePaise, ')
          ..write('taxPaise: $taxPaise, ')
          ..write('totalPaise: $totalPaise')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    billId,
    position,
    itemId,
    name,
    unit,
    hsn,
    quantityMilli,
    unitPricePaise,
    taxRateBp,
    priceIncludesTax,
    discountPaise,
    billDiscountSharePaise,
    taxablePaise,
    taxPaise,
    totalPaise,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BillLineRow &&
          other.id == this.id &&
          other.billId == this.billId &&
          other.position == this.position &&
          other.itemId == this.itemId &&
          other.name == this.name &&
          other.unit == this.unit &&
          other.hsn == this.hsn &&
          other.quantityMilli == this.quantityMilli &&
          other.unitPricePaise == this.unitPricePaise &&
          other.taxRateBp == this.taxRateBp &&
          other.priceIncludesTax == this.priceIncludesTax &&
          other.discountPaise == this.discountPaise &&
          other.billDiscountSharePaise == this.billDiscountSharePaise &&
          other.taxablePaise == this.taxablePaise &&
          other.taxPaise == this.taxPaise &&
          other.totalPaise == this.totalPaise);
}

class BillLinesCompanion extends UpdateCompanion<BillLineRow> {
  final Value<int> id;
  final Value<int> billId;
  final Value<int> position;
  final Value<int?> itemId;
  final Value<String> name;
  final Value<String> unit;
  final Value<String?> hsn;
  final Value<int> quantityMilli;
  final Value<int> unitPricePaise;
  final Value<int> taxRateBp;
  final Value<bool> priceIncludesTax;
  final Value<int> discountPaise;
  final Value<int> billDiscountSharePaise;
  final Value<int> taxablePaise;
  final Value<int> taxPaise;
  final Value<int> totalPaise;
  const BillLinesCompanion({
    this.id = const Value.absent(),
    this.billId = const Value.absent(),
    this.position = const Value.absent(),
    this.itemId = const Value.absent(),
    this.name = const Value.absent(),
    this.unit = const Value.absent(),
    this.hsn = const Value.absent(),
    this.quantityMilli = const Value.absent(),
    this.unitPricePaise = const Value.absent(),
    this.taxRateBp = const Value.absent(),
    this.priceIncludesTax = const Value.absent(),
    this.discountPaise = const Value.absent(),
    this.billDiscountSharePaise = const Value.absent(),
    this.taxablePaise = const Value.absent(),
    this.taxPaise = const Value.absent(),
    this.totalPaise = const Value.absent(),
  });
  BillLinesCompanion.insert({
    this.id = const Value.absent(),
    required int billId,
    required int position,
    this.itemId = const Value.absent(),
    required String name,
    required String unit,
    this.hsn = const Value.absent(),
    required int quantityMilli,
    required int unitPricePaise,
    required int taxRateBp,
    required bool priceIncludesTax,
    required int discountPaise,
    required int billDiscountSharePaise,
    required int taxablePaise,
    required int taxPaise,
    required int totalPaise,
  }) : billId = Value(billId),
       position = Value(position),
       name = Value(name),
       unit = Value(unit),
       quantityMilli = Value(quantityMilli),
       unitPricePaise = Value(unitPricePaise),
       taxRateBp = Value(taxRateBp),
       priceIncludesTax = Value(priceIncludesTax),
       discountPaise = Value(discountPaise),
       billDiscountSharePaise = Value(billDiscountSharePaise),
       taxablePaise = Value(taxablePaise),
       taxPaise = Value(taxPaise),
       totalPaise = Value(totalPaise);
  static Insertable<BillLineRow> custom({
    Expression<int>? id,
    Expression<int>? billId,
    Expression<int>? position,
    Expression<int>? itemId,
    Expression<String>? name,
    Expression<String>? unit,
    Expression<String>? hsn,
    Expression<int>? quantityMilli,
    Expression<int>? unitPricePaise,
    Expression<int>? taxRateBp,
    Expression<bool>? priceIncludesTax,
    Expression<int>? discountPaise,
    Expression<int>? billDiscountSharePaise,
    Expression<int>? taxablePaise,
    Expression<int>? taxPaise,
    Expression<int>? totalPaise,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (billId != null) 'bill_id': billId,
      if (position != null) 'position': position,
      if (itemId != null) 'item_id': itemId,
      if (name != null) 'name': name,
      if (unit != null) 'unit': unit,
      if (hsn != null) 'hsn': hsn,
      if (quantityMilli != null) 'quantity_milli': quantityMilli,
      if (unitPricePaise != null) 'unit_price_paise': unitPricePaise,
      if (taxRateBp != null) 'tax_rate_bp': taxRateBp,
      if (priceIncludesTax != null) 'price_includes_tax': priceIncludesTax,
      if (discountPaise != null) 'discount_paise': discountPaise,
      if (billDiscountSharePaise != null)
        'bill_discount_share_paise': billDiscountSharePaise,
      if (taxablePaise != null) 'taxable_paise': taxablePaise,
      if (taxPaise != null) 'tax_paise': taxPaise,
      if (totalPaise != null) 'total_paise': totalPaise,
    });
  }

  BillLinesCompanion copyWith({
    Value<int>? id,
    Value<int>? billId,
    Value<int>? position,
    Value<int?>? itemId,
    Value<String>? name,
    Value<String>? unit,
    Value<String?>? hsn,
    Value<int>? quantityMilli,
    Value<int>? unitPricePaise,
    Value<int>? taxRateBp,
    Value<bool>? priceIncludesTax,
    Value<int>? discountPaise,
    Value<int>? billDiscountSharePaise,
    Value<int>? taxablePaise,
    Value<int>? taxPaise,
    Value<int>? totalPaise,
  }) {
    return BillLinesCompanion(
      id: id ?? this.id,
      billId: billId ?? this.billId,
      position: position ?? this.position,
      itemId: itemId ?? this.itemId,
      name: name ?? this.name,
      unit: unit ?? this.unit,
      hsn: hsn ?? this.hsn,
      quantityMilli: quantityMilli ?? this.quantityMilli,
      unitPricePaise: unitPricePaise ?? this.unitPricePaise,
      taxRateBp: taxRateBp ?? this.taxRateBp,
      priceIncludesTax: priceIncludesTax ?? this.priceIncludesTax,
      discountPaise: discountPaise ?? this.discountPaise,
      billDiscountSharePaise:
          billDiscountSharePaise ?? this.billDiscountSharePaise,
      taxablePaise: taxablePaise ?? this.taxablePaise,
      taxPaise: taxPaise ?? this.taxPaise,
      totalPaise: totalPaise ?? this.totalPaise,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (billId.present) {
      map['bill_id'] = Variable<int>(billId.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (itemId.present) {
      map['item_id'] = Variable<int>(itemId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (hsn.present) {
      map['hsn'] = Variable<String>(hsn.value);
    }
    if (quantityMilli.present) {
      map['quantity_milli'] = Variable<int>(quantityMilli.value);
    }
    if (unitPricePaise.present) {
      map['unit_price_paise'] = Variable<int>(unitPricePaise.value);
    }
    if (taxRateBp.present) {
      map['tax_rate_bp'] = Variable<int>(taxRateBp.value);
    }
    if (priceIncludesTax.present) {
      map['price_includes_tax'] = Variable<bool>(priceIncludesTax.value);
    }
    if (discountPaise.present) {
      map['discount_paise'] = Variable<int>(discountPaise.value);
    }
    if (billDiscountSharePaise.present) {
      map['bill_discount_share_paise'] = Variable<int>(
        billDiscountSharePaise.value,
      );
    }
    if (taxablePaise.present) {
      map['taxable_paise'] = Variable<int>(taxablePaise.value);
    }
    if (taxPaise.present) {
      map['tax_paise'] = Variable<int>(taxPaise.value);
    }
    if (totalPaise.present) {
      map['total_paise'] = Variable<int>(totalPaise.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BillLinesCompanion(')
          ..write('id: $id, ')
          ..write('billId: $billId, ')
          ..write('position: $position, ')
          ..write('itemId: $itemId, ')
          ..write('name: $name, ')
          ..write('unit: $unit, ')
          ..write('hsn: $hsn, ')
          ..write('quantityMilli: $quantityMilli, ')
          ..write('unitPricePaise: $unitPricePaise, ')
          ..write('taxRateBp: $taxRateBp, ')
          ..write('priceIncludesTax: $priceIncludesTax, ')
          ..write('discountPaise: $discountPaise, ')
          ..write('billDiscountSharePaise: $billDiscountSharePaise, ')
          ..write('taxablePaise: $taxablePaise, ')
          ..write('taxPaise: $taxPaise, ')
          ..write('totalPaise: $totalPaise')
          ..write(')'))
        .toString();
  }
}

class $InvoiceCountersTable extends InvoiceCounters
    with TableInfo<$InvoiceCountersTable, InvoiceCounter> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InvoiceCountersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _fyStartMeta = const VerificationMeta(
    'fyStart',
  );
  @override
  late final GeneratedColumn<int> fyStart = GeneratedColumn<int>(
    'fy_start',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastSequenceMeta = const VerificationMeta(
    'lastSequence',
  );
  @override
  late final GeneratedColumn<int> lastSequence = GeneratedColumn<int>(
    'last_sequence',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [fyStart, lastSequence];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'invoice_counters';
  @override
  VerificationContext validateIntegrity(
    Insertable<InvoiceCounter> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('fy_start')) {
      context.handle(
        _fyStartMeta,
        fyStart.isAcceptableOrUnknown(data['fy_start']!, _fyStartMeta),
      );
    }
    if (data.containsKey('last_sequence')) {
      context.handle(
        _lastSequenceMeta,
        lastSequence.isAcceptableOrUnknown(
          data['last_sequence']!,
          _lastSequenceMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lastSequenceMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {fyStart};
  @override
  InvoiceCounter map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return InvoiceCounter(
      fyStart: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}fy_start'],
      )!,
      lastSequence: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_sequence'],
      )!,
    );
  }

  @override
  $InvoiceCountersTable createAlias(String alias) {
    return $InvoiceCountersTable(attachedDatabase, alias);
  }
}

class InvoiceCounter extends DataClass implements Insertable<InvoiceCounter> {
  final int fyStart;
  final int lastSequence;
  const InvoiceCounter({required this.fyStart, required this.lastSequence});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['fy_start'] = Variable<int>(fyStart);
    map['last_sequence'] = Variable<int>(lastSequence);
    return map;
  }

  InvoiceCountersCompanion toCompanion(bool nullToAbsent) {
    return InvoiceCountersCompanion(
      fyStart: Value(fyStart),
      lastSequence: Value(lastSequence),
    );
  }

  factory InvoiceCounter.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return InvoiceCounter(
      fyStart: serializer.fromJson<int>(json['fyStart']),
      lastSequence: serializer.fromJson<int>(json['lastSequence']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'fyStart': serializer.toJson<int>(fyStart),
      'lastSequence': serializer.toJson<int>(lastSequence),
    };
  }

  InvoiceCounter copyWith({int? fyStart, int? lastSequence}) => InvoiceCounter(
    fyStart: fyStart ?? this.fyStart,
    lastSequence: lastSequence ?? this.lastSequence,
  );
  InvoiceCounter copyWithCompanion(InvoiceCountersCompanion data) {
    return InvoiceCounter(
      fyStart: data.fyStart.present ? data.fyStart.value : this.fyStart,
      lastSequence: data.lastSequence.present
          ? data.lastSequence.value
          : this.lastSequence,
    );
  }

  @override
  String toString() {
    return (StringBuffer('InvoiceCounter(')
          ..write('fyStart: $fyStart, ')
          ..write('lastSequence: $lastSequence')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(fyStart, lastSequence);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InvoiceCounter &&
          other.fyStart == this.fyStart &&
          other.lastSequence == this.lastSequence);
}

class InvoiceCountersCompanion extends UpdateCompanion<InvoiceCounter> {
  final Value<int> fyStart;
  final Value<int> lastSequence;
  const InvoiceCountersCompanion({
    this.fyStart = const Value.absent(),
    this.lastSequence = const Value.absent(),
  });
  InvoiceCountersCompanion.insert({
    this.fyStart = const Value.absent(),
    required int lastSequence,
  }) : lastSequence = Value(lastSequence);
  static Insertable<InvoiceCounter> custom({
    Expression<int>? fyStart,
    Expression<int>? lastSequence,
  }) {
    return RawValuesInsertable({
      if (fyStart != null) 'fy_start': fyStart,
      if (lastSequence != null) 'last_sequence': lastSequence,
    });
  }

  InvoiceCountersCompanion copyWith({
    Value<int>? fyStart,
    Value<int>? lastSequence,
  }) {
    return InvoiceCountersCompanion(
      fyStart: fyStart ?? this.fyStart,
      lastSequence: lastSequence ?? this.lastSequence,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (fyStart.present) {
      map['fy_start'] = Variable<int>(fyStart.value);
    }
    if (lastSequence.present) {
      map['last_sequence'] = Variable<int>(lastSequence.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InvoiceCountersCompanion(')
          ..write('fyStart: $fyStart, ')
          ..write('lastSequence: $lastSequence')
          ..write(')'))
        .toString();
  }
}

class $AppSettingsTable extends AppSettings
    with TableInfo<$AppSettingsTable, SettingsRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _invoicePrefixMeta = const VerificationMeta(
    'invoicePrefix',
  );
  @override
  late final GeneratedColumn<String> invoicePrefix = GeneratedColumn<String>(
    'invoice_prefix',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('INV'),
  );
  static const VerificationMeta _roundToRupeeMeta = const VerificationMeta(
    'roundToRupee',
  );
  @override
  late final GeneratedColumn<bool> roundToRupee = GeneratedColumn<bool>(
    'round_to_rupee',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("round_to_rupee" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _upiIdMeta = const VerificationMeta('upiId');
  @override
  late final GeneratedColumn<String> upiId = GeneratedColumn<String>(
    'upi_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _receiptFooterMeta = const VerificationMeta(
    'receiptFooter',
  );
  @override
  late final GeneratedColumn<String> receiptFooter = GeneratedColumn<String>(
    'receipt_footer',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _printerAddressMeta = const VerificationMeta(
    'printerAddress',
  );
  @override
  late final GeneratedColumn<String> printerAddress = GeneratedColumn<String>(
    'printer_address',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _printerNameMeta = const VerificationMeta(
    'printerName',
  );
  @override
  late final GeneratedColumn<String> printerName = GeneratedColumn<String>(
    'printer_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _paperWidthMmMeta = const VerificationMeta(
    'paperWidthMm',
  );
  @override
  late final GeneratedColumn<int> paperWidthMm = GeneratedColumn<int>(
    'paper_width_mm',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(58),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    invoicePrefix,
    roundToRupee,
    upiId,
    receiptFooter,
    printerAddress,
    printerName,
    paperWidthMm,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<SettingsRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('invoice_prefix')) {
      context.handle(
        _invoicePrefixMeta,
        invoicePrefix.isAcceptableOrUnknown(
          data['invoice_prefix']!,
          _invoicePrefixMeta,
        ),
      );
    }
    if (data.containsKey('round_to_rupee')) {
      context.handle(
        _roundToRupeeMeta,
        roundToRupee.isAcceptableOrUnknown(
          data['round_to_rupee']!,
          _roundToRupeeMeta,
        ),
      );
    }
    if (data.containsKey('upi_id')) {
      context.handle(
        _upiIdMeta,
        upiId.isAcceptableOrUnknown(data['upi_id']!, _upiIdMeta),
      );
    }
    if (data.containsKey('receipt_footer')) {
      context.handle(
        _receiptFooterMeta,
        receiptFooter.isAcceptableOrUnknown(
          data['receipt_footer']!,
          _receiptFooterMeta,
        ),
      );
    }
    if (data.containsKey('printer_address')) {
      context.handle(
        _printerAddressMeta,
        printerAddress.isAcceptableOrUnknown(
          data['printer_address']!,
          _printerAddressMeta,
        ),
      );
    }
    if (data.containsKey('printer_name')) {
      context.handle(
        _printerNameMeta,
        printerName.isAcceptableOrUnknown(
          data['printer_name']!,
          _printerNameMeta,
        ),
      );
    }
    if (data.containsKey('paper_width_mm')) {
      context.handle(
        _paperWidthMmMeta,
        paperWidthMm.isAcceptableOrUnknown(
          data['paper_width_mm']!,
          _paperWidthMmMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SettingsRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SettingsRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      invoicePrefix: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}invoice_prefix'],
      )!,
      roundToRupee: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}round_to_rupee'],
      )!,
      upiId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}upi_id'],
      ),
      receiptFooter: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}receipt_footer'],
      ),
      printerAddress: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}printer_address'],
      ),
      printerName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}printer_name'],
      ),
      paperWidthMm: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}paper_width_mm'],
      )!,
    );
  }

  @override
  $AppSettingsTable createAlias(String alias) {
    return $AppSettingsTable(attachedDatabase, alias);
  }
}

class SettingsRow extends DataClass implements Insertable<SettingsRow> {
  final int id;
  final String invoicePrefix;
  final bool roundToRupee;
  final String? upiId;
  final String? receiptFooter;
  final String? printerAddress;
  final String? printerName;
  final int paperWidthMm;
  const SettingsRow({
    required this.id,
    required this.invoicePrefix,
    required this.roundToRupee,
    this.upiId,
    this.receiptFooter,
    this.printerAddress,
    this.printerName,
    required this.paperWidthMm,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['invoice_prefix'] = Variable<String>(invoicePrefix);
    map['round_to_rupee'] = Variable<bool>(roundToRupee);
    if (!nullToAbsent || upiId != null) {
      map['upi_id'] = Variable<String>(upiId);
    }
    if (!nullToAbsent || receiptFooter != null) {
      map['receipt_footer'] = Variable<String>(receiptFooter);
    }
    if (!nullToAbsent || printerAddress != null) {
      map['printer_address'] = Variable<String>(printerAddress);
    }
    if (!nullToAbsent || printerName != null) {
      map['printer_name'] = Variable<String>(printerName);
    }
    map['paper_width_mm'] = Variable<int>(paperWidthMm);
    return map;
  }

  AppSettingsCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsCompanion(
      id: Value(id),
      invoicePrefix: Value(invoicePrefix),
      roundToRupee: Value(roundToRupee),
      upiId: upiId == null && nullToAbsent
          ? const Value.absent()
          : Value(upiId),
      receiptFooter: receiptFooter == null && nullToAbsent
          ? const Value.absent()
          : Value(receiptFooter),
      printerAddress: printerAddress == null && nullToAbsent
          ? const Value.absent()
          : Value(printerAddress),
      printerName: printerName == null && nullToAbsent
          ? const Value.absent()
          : Value(printerName),
      paperWidthMm: Value(paperWidthMm),
    );
  }

  factory SettingsRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SettingsRow(
      id: serializer.fromJson<int>(json['id']),
      invoicePrefix: serializer.fromJson<String>(json['invoicePrefix']),
      roundToRupee: serializer.fromJson<bool>(json['roundToRupee']),
      upiId: serializer.fromJson<String?>(json['upiId']),
      receiptFooter: serializer.fromJson<String?>(json['receiptFooter']),
      printerAddress: serializer.fromJson<String?>(json['printerAddress']),
      printerName: serializer.fromJson<String?>(json['printerName']),
      paperWidthMm: serializer.fromJson<int>(json['paperWidthMm']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'invoicePrefix': serializer.toJson<String>(invoicePrefix),
      'roundToRupee': serializer.toJson<bool>(roundToRupee),
      'upiId': serializer.toJson<String?>(upiId),
      'receiptFooter': serializer.toJson<String?>(receiptFooter),
      'printerAddress': serializer.toJson<String?>(printerAddress),
      'printerName': serializer.toJson<String?>(printerName),
      'paperWidthMm': serializer.toJson<int>(paperWidthMm),
    };
  }

  SettingsRow copyWith({
    int? id,
    String? invoicePrefix,
    bool? roundToRupee,
    Value<String?> upiId = const Value.absent(),
    Value<String?> receiptFooter = const Value.absent(),
    Value<String?> printerAddress = const Value.absent(),
    Value<String?> printerName = const Value.absent(),
    int? paperWidthMm,
  }) => SettingsRow(
    id: id ?? this.id,
    invoicePrefix: invoicePrefix ?? this.invoicePrefix,
    roundToRupee: roundToRupee ?? this.roundToRupee,
    upiId: upiId.present ? upiId.value : this.upiId,
    receiptFooter: receiptFooter.present
        ? receiptFooter.value
        : this.receiptFooter,
    printerAddress: printerAddress.present
        ? printerAddress.value
        : this.printerAddress,
    printerName: printerName.present ? printerName.value : this.printerName,
    paperWidthMm: paperWidthMm ?? this.paperWidthMm,
  );
  SettingsRow copyWithCompanion(AppSettingsCompanion data) {
    return SettingsRow(
      id: data.id.present ? data.id.value : this.id,
      invoicePrefix: data.invoicePrefix.present
          ? data.invoicePrefix.value
          : this.invoicePrefix,
      roundToRupee: data.roundToRupee.present
          ? data.roundToRupee.value
          : this.roundToRupee,
      upiId: data.upiId.present ? data.upiId.value : this.upiId,
      receiptFooter: data.receiptFooter.present
          ? data.receiptFooter.value
          : this.receiptFooter,
      printerAddress: data.printerAddress.present
          ? data.printerAddress.value
          : this.printerAddress,
      printerName: data.printerName.present
          ? data.printerName.value
          : this.printerName,
      paperWidthMm: data.paperWidthMm.present
          ? data.paperWidthMm.value
          : this.paperWidthMm,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SettingsRow(')
          ..write('id: $id, ')
          ..write('invoicePrefix: $invoicePrefix, ')
          ..write('roundToRupee: $roundToRupee, ')
          ..write('upiId: $upiId, ')
          ..write('receiptFooter: $receiptFooter, ')
          ..write('printerAddress: $printerAddress, ')
          ..write('printerName: $printerName, ')
          ..write('paperWidthMm: $paperWidthMm')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    invoicePrefix,
    roundToRupee,
    upiId,
    receiptFooter,
    printerAddress,
    printerName,
    paperWidthMm,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SettingsRow &&
          other.id == this.id &&
          other.invoicePrefix == this.invoicePrefix &&
          other.roundToRupee == this.roundToRupee &&
          other.upiId == this.upiId &&
          other.receiptFooter == this.receiptFooter &&
          other.printerAddress == this.printerAddress &&
          other.printerName == this.printerName &&
          other.paperWidthMm == this.paperWidthMm);
}

class AppSettingsCompanion extends UpdateCompanion<SettingsRow> {
  final Value<int> id;
  final Value<String> invoicePrefix;
  final Value<bool> roundToRupee;
  final Value<String?> upiId;
  final Value<String?> receiptFooter;
  final Value<String?> printerAddress;
  final Value<String?> printerName;
  final Value<int> paperWidthMm;
  const AppSettingsCompanion({
    this.id = const Value.absent(),
    this.invoicePrefix = const Value.absent(),
    this.roundToRupee = const Value.absent(),
    this.upiId = const Value.absent(),
    this.receiptFooter = const Value.absent(),
    this.printerAddress = const Value.absent(),
    this.printerName = const Value.absent(),
    this.paperWidthMm = const Value.absent(),
  });
  AppSettingsCompanion.insert({
    this.id = const Value.absent(),
    this.invoicePrefix = const Value.absent(),
    this.roundToRupee = const Value.absent(),
    this.upiId = const Value.absent(),
    this.receiptFooter = const Value.absent(),
    this.printerAddress = const Value.absent(),
    this.printerName = const Value.absent(),
    this.paperWidthMm = const Value.absent(),
  });
  static Insertable<SettingsRow> custom({
    Expression<int>? id,
    Expression<String>? invoicePrefix,
    Expression<bool>? roundToRupee,
    Expression<String>? upiId,
    Expression<String>? receiptFooter,
    Expression<String>? printerAddress,
    Expression<String>? printerName,
    Expression<int>? paperWidthMm,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (invoicePrefix != null) 'invoice_prefix': invoicePrefix,
      if (roundToRupee != null) 'round_to_rupee': roundToRupee,
      if (upiId != null) 'upi_id': upiId,
      if (receiptFooter != null) 'receipt_footer': receiptFooter,
      if (printerAddress != null) 'printer_address': printerAddress,
      if (printerName != null) 'printer_name': printerName,
      if (paperWidthMm != null) 'paper_width_mm': paperWidthMm,
    });
  }

  AppSettingsCompanion copyWith({
    Value<int>? id,
    Value<String>? invoicePrefix,
    Value<bool>? roundToRupee,
    Value<String?>? upiId,
    Value<String?>? receiptFooter,
    Value<String?>? printerAddress,
    Value<String?>? printerName,
    Value<int>? paperWidthMm,
  }) {
    return AppSettingsCompanion(
      id: id ?? this.id,
      invoicePrefix: invoicePrefix ?? this.invoicePrefix,
      roundToRupee: roundToRupee ?? this.roundToRupee,
      upiId: upiId ?? this.upiId,
      receiptFooter: receiptFooter ?? this.receiptFooter,
      printerAddress: printerAddress ?? this.printerAddress,
      printerName: printerName ?? this.printerName,
      paperWidthMm: paperWidthMm ?? this.paperWidthMm,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (invoicePrefix.present) {
      map['invoice_prefix'] = Variable<String>(invoicePrefix.value);
    }
    if (roundToRupee.present) {
      map['round_to_rupee'] = Variable<bool>(roundToRupee.value);
    }
    if (upiId.present) {
      map['upi_id'] = Variable<String>(upiId.value);
    }
    if (receiptFooter.present) {
      map['receipt_footer'] = Variable<String>(receiptFooter.value);
    }
    if (printerAddress.present) {
      map['printer_address'] = Variable<String>(printerAddress.value);
    }
    if (printerName.present) {
      map['printer_name'] = Variable<String>(printerName.value);
    }
    if (paperWidthMm.present) {
      map['paper_width_mm'] = Variable<int>(paperWidthMm.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsCompanion(')
          ..write('id: $id, ')
          ..write('invoicePrefix: $invoicePrefix, ')
          ..write('roundToRupee: $roundToRupee, ')
          ..write('upiId: $upiId, ')
          ..write('receiptFooter: $receiptFooter, ')
          ..write('printerAddress: $printerAddress, ')
          ..write('printerName: $printerName, ')
          ..write('paperWidthMm: $paperWidthMm')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ShopProfilesTable shopProfiles = $ShopProfilesTable(this);
  late final $ItemsTable items = $ItemsTable(this);
  late final $BillsTable bills = $BillsTable(this);
  late final $BillLinesTable billLines = $BillLinesTable(this);
  late final $InvoiceCountersTable invoiceCounters = $InvoiceCountersTable(
    this,
  );
  late final $AppSettingsTable appSettings = $AppSettingsTable(this);
  late final Index itemsName = Index(
    'items_name',
    'CREATE INDEX items_name ON items (name)',
  );
  late final Index billsBilledAt = Index(
    'bills_billed_at',
    'CREATE INDEX bills_billed_at ON bills (billed_at)',
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    shopProfiles,
    items,
    bills,
    billLines,
    invoiceCounters,
    appSettings,
    itemsName,
    billsBilledAt,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'bills',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('bill_lines', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$ShopProfilesTableCreateCompanionBuilder =
    ShopProfilesCompanion Function({
      Value<int> id,
      required String name,
      Value<String?> phone,
      Value<String?> addressLine,
      Value<String?> city,
      Value<String?> pincode,
      required String stateCode,
      Value<String?> gstin,
      Value<String?> logoPath,
      required DateTime createdAt,
      required DateTime updatedAt,
    });
typedef $$ShopProfilesTableUpdateCompanionBuilder =
    ShopProfilesCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String?> phone,
      Value<String?> addressLine,
      Value<String?> city,
      Value<String?> pincode,
      Value<String> stateCode,
      Value<String?> gstin,
      Value<String?> logoPath,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

class $$ShopProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $ShopProfilesTable> {
  $$ShopProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get addressLine => $composableBuilder(
    column: $table.addressLine,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get city => $composableBuilder(
    column: $table.city,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pincode => $composableBuilder(
    column: $table.pincode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get stateCode => $composableBuilder(
    column: $table.stateCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get gstin => $composableBuilder(
    column: $table.gstin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get logoPath => $composableBuilder(
    column: $table.logoPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ShopProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $ShopProfilesTable> {
  $$ShopProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get addressLine => $composableBuilder(
    column: $table.addressLine,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get city => $composableBuilder(
    column: $table.city,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pincode => $composableBuilder(
    column: $table.pincode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get stateCode => $composableBuilder(
    column: $table.stateCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get gstin => $composableBuilder(
    column: $table.gstin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get logoPath => $composableBuilder(
    column: $table.logoPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ShopProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ShopProfilesTable> {
  $$ShopProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get addressLine => $composableBuilder(
    column: $table.addressLine,
    builder: (column) => column,
  );

  GeneratedColumn<String> get city =>
      $composableBuilder(column: $table.city, builder: (column) => column);

  GeneratedColumn<String> get pincode =>
      $composableBuilder(column: $table.pincode, builder: (column) => column);

  GeneratedColumn<String> get stateCode =>
      $composableBuilder(column: $table.stateCode, builder: (column) => column);

  GeneratedColumn<String> get gstin =>
      $composableBuilder(column: $table.gstin, builder: (column) => column);

  GeneratedColumn<String> get logoPath =>
      $composableBuilder(column: $table.logoPath, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$ShopProfilesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ShopProfilesTable,
          ShopProfileRow,
          $$ShopProfilesTableFilterComposer,
          $$ShopProfilesTableOrderingComposer,
          $$ShopProfilesTableAnnotationComposer,
          $$ShopProfilesTableCreateCompanionBuilder,
          $$ShopProfilesTableUpdateCompanionBuilder,
          (
            ShopProfileRow,
            BaseReferences<_$AppDatabase, $ShopProfilesTable, ShopProfileRow>,
          ),
          ShopProfileRow,
          PrefetchHooks Function()
        > {
  $$ShopProfilesTableTableManager(_$AppDatabase db, $ShopProfilesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ShopProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ShopProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ShopProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> addressLine = const Value.absent(),
                Value<String?> city = const Value.absent(),
                Value<String?> pincode = const Value.absent(),
                Value<String> stateCode = const Value.absent(),
                Value<String?> gstin = const Value.absent(),
                Value<String?> logoPath = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => ShopProfilesCompanion(
                id: id,
                name: name,
                phone: phone,
                addressLine: addressLine,
                city: city,
                pincode: pincode,
                stateCode: stateCode,
                gstin: gstin,
                logoPath: logoPath,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String?> phone = const Value.absent(),
                Value<String?> addressLine = const Value.absent(),
                Value<String?> city = const Value.absent(),
                Value<String?> pincode = const Value.absent(),
                required String stateCode,
                Value<String?> gstin = const Value.absent(),
                Value<String?> logoPath = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
              }) => ShopProfilesCompanion.insert(
                id: id,
                name: name,
                phone: phone,
                addressLine: addressLine,
                city: city,
                pincode: pincode,
                stateCode: stateCode,
                gstin: gstin,
                logoPath: logoPath,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ShopProfilesTable, ShopProfileRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $ShopProfilesTable,
                    ShopProfileRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ShopProfilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ShopProfilesTable,
      ShopProfileRow,
      $$ShopProfilesTableFilterComposer,
      $$ShopProfilesTableOrderingComposer,
      $$ShopProfilesTableAnnotationComposer,
      $$ShopProfilesTableCreateCompanionBuilder,
      $$ShopProfilesTableUpdateCompanionBuilder,
      (
        ShopProfileRow,
        BaseReferences<_$AppDatabase, $ShopProfilesTable, ShopProfileRow>,
      ),
      ShopProfileRow,
      PrefetchHooks Function()
    >;
typedef $$ItemsTableCreateCompanionBuilder = ItemsCompanion Function({
  Value<int> id,
  required String name,
  Value<String?> barcode,
  Value<String> unit,
  required int salePricePaise,
  Value<int?> mrpPaise,
  Value<int> taxRateBp,
  Value<bool> priceIncludesTax,
  Value<String?> hsn,
  Value<bool> isActive,
  required DateTime createdAt,
  required DateTime updatedAt,
});
typedef $$ItemsTableUpdateCompanionBuilder = ItemsCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String?> barcode,
  Value<String> unit,
  Value<int> salePricePaise,
  Value<int?> mrpPaise,
  Value<int> taxRateBp,
  Value<bool> priceIncludesTax,
  Value<String?> hsn,
  Value<bool> isActive,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

final class $$ItemsTableReferences
    extends BaseReferences<_$AppDatabase, $ItemsTable, ItemRow> {
  $$ItemsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$BillLinesTable, List<BillLineRow>>
  _billLinesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.billLines,
    aliasName: 'items__id__bill_lines__item_id',
  );

  $$BillLinesTableProcessedTableManager get billLinesRefs {
    final manager = $$BillLinesTableTableManager(
      $_db,
      $_db.billLines,
    ).filter((f) => f.itemId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_billLinesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ItemsTableFilterComposer extends Composer<_$AppDatabase, $ItemsTable> {
  $$ItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get barcode => $composableBuilder(
    column: $table.barcode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get salePricePaise => $composableBuilder(
    column: $table.salePricePaise,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get mrpPaise => $composableBuilder(
    column: $table.mrpPaise,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get taxRateBp => $composableBuilder(
    column: $table.taxRateBp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get priceIncludesTax => $composableBuilder(
    column: $table.priceIncludesTax,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hsn => $composableBuilder(
    column: $table.hsn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> billLinesRefs(
    Expression<bool> Function($$BillLinesTableFilterComposer f) f,
  ) {
    final $$BillLinesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.billLines,
      getReferencedColumn: (t) => t.itemId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BillLinesTableFilterComposer(
            $db: $db,
            $table: $db.billLines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $ItemsTable> {
  $$ItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get barcode => $composableBuilder(
    column: $table.barcode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get salePricePaise => $composableBuilder(
    column: $table.salePricePaise,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get mrpPaise => $composableBuilder(
    column: $table.mrpPaise,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get taxRateBp => $composableBuilder(
    column: $table.taxRateBp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get priceIncludesTax => $composableBuilder(
    column: $table.priceIncludesTax,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hsn => $composableBuilder(
    column: $table.hsn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ItemsTable> {
  $$ItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get barcode =>
      $composableBuilder(column: $table.barcode, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<int> get salePricePaise => $composableBuilder(
    column: $table.salePricePaise,
    builder: (column) => column,
  );

  GeneratedColumn<int> get mrpPaise =>
      $composableBuilder(column: $table.mrpPaise, builder: (column) => column);

  GeneratedColumn<int> get taxRateBp =>
      $composableBuilder(column: $table.taxRateBp, builder: (column) => column);

  GeneratedColumn<bool> get priceIncludesTax => $composableBuilder(
    column: $table.priceIncludesTax,
    builder: (column) => column,
  );

  GeneratedColumn<String> get hsn =>
      $composableBuilder(column: $table.hsn, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> billLinesRefs<T extends Object>(
    Expression<T> Function($$BillLinesTableAnnotationComposer a) f,
  ) {
    final $$BillLinesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.billLines,
      getReferencedColumn: (t) => t.itemId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BillLinesTableAnnotationComposer(
            $db: $db,
            $table: $db.billLines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ItemsTable,
          ItemRow,
          $$ItemsTableFilterComposer,
          $$ItemsTableOrderingComposer,
          $$ItemsTableAnnotationComposer,
          $$ItemsTableCreateCompanionBuilder,
          $$ItemsTableUpdateCompanionBuilder,
          (ItemRow, $$ItemsTableReferences),
          ItemRow,
          PrefetchHooks Function({bool billLinesRefs})
        > {
  $$ItemsTableTableManager(_$AppDatabase db, $ItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> barcode = const Value.absent(),
                Value<String> unit = const Value.absent(),
                Value<int> salePricePaise = const Value.absent(),
                Value<int?> mrpPaise = const Value.absent(),
                Value<int> taxRateBp = const Value.absent(),
                Value<bool> priceIncludesTax = const Value.absent(),
                Value<String?> hsn = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => ItemsCompanion(
                id: id,
                name: name,
                barcode: barcode,
                unit: unit,
                salePricePaise: salePricePaise,
                mrpPaise: mrpPaise,
                taxRateBp: taxRateBp,
                priceIncludesTax: priceIncludesTax,
                hsn: hsn,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String?> barcode = const Value.absent(),
                Value<String> unit = const Value.absent(),
                required int salePricePaise,
                Value<int?> mrpPaise = const Value.absent(),
                Value<int> taxRateBp = const Value.absent(),
                Value<bool> priceIncludesTax = const Value.absent(),
                Value<String?> hsn = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
              }) => ItemsCompanion.insert(
                id: id,
                name: name,
                barcode: barcode,
                unit: unit,
                salePricePaise: salePricePaise,
                mrpPaise: mrpPaise,
                taxRateBp: taxRateBp,
                priceIncludesTax: priceIncludesTax,
                hsn: hsn,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ItemsTable, ItemRow>(table),
                  $$ItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({billLinesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (billLinesRefs) db.billLines],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (billLinesRefs)
                    await $_getPrefetchedDataByColumns<
                      ItemRow,
                      $ItemsTable,
                      BillLineRow,
                      $BillLinesTable
                    >(
                      currentTable: table,
                      referencedTable: $$ItemsTableReferences
                          ._billLinesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$ItemsTableReferences(db, table, p0).billLinesRefs,
                      currentColumn: 'id',
                      referencedColumn: 'item_id',
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$ItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ItemsTable,
      ItemRow,
      $$ItemsTableFilterComposer,
      $$ItemsTableOrderingComposer,
      $$ItemsTableAnnotationComposer,
      $$ItemsTableCreateCompanionBuilder,
      $$ItemsTableUpdateCompanionBuilder,
      (ItemRow, $$ItemsTableReferences),
      ItemRow,
      PrefetchHooks Function({bool billLinesRefs})
    >;
typedef $$BillsTableCreateCompanionBuilder = BillsCompanion Function({
  Value<int> id,
  required String invoiceNo,
  required int fyStart,
  required int sequence,
  required DateTime billedAt,
  Value<String?> customerName,
  Value<String?> customerPhone,
  required int itemsTotalPaise,
  required int billDiscountPaise,
  required int taxablePaise,
  required int taxPaise,
  required int roundOffPaise,
  required int grandTotalPaise,
  required String paymentMode,
  Value<String> status,
  Value<DateTime?> cancelledAt,
  Value<String?> cancelReason,
});
typedef $$BillsTableUpdateCompanionBuilder = BillsCompanion Function({
  Value<int> id,
  Value<String> invoiceNo,
  Value<int> fyStart,
  Value<int> sequence,
  Value<DateTime> billedAt,
  Value<String?> customerName,
  Value<String?> customerPhone,
  Value<int> itemsTotalPaise,
  Value<int> billDiscountPaise,
  Value<int> taxablePaise,
  Value<int> taxPaise,
  Value<int> roundOffPaise,
  Value<int> grandTotalPaise,
  Value<String> paymentMode,
  Value<String> status,
  Value<DateTime?> cancelledAt,
  Value<String?> cancelReason,
});

final class $$BillsTableReferences
    extends BaseReferences<_$AppDatabase, $BillsTable, BillRow> {
  $$BillsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$BillLinesTable, List<BillLineRow>>
  _billLinesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.billLines,
    aliasName: 'bills__id__bill_lines__bill_id',
  );

  $$BillLinesTableProcessedTableManager get billLinesRefs {
    final manager = $$BillLinesTableTableManager(
      $_db,
      $_db.billLines,
    ).filter((f) => f.billId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_billLinesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$BillsTableFilterComposer extends Composer<_$AppDatabase, $BillsTable> {
  $$BillsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get invoiceNo => $composableBuilder(
    column: $table.invoiceNo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get fyStart => $composableBuilder(
    column: $table.fyStart,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sequence => $composableBuilder(
    column: $table.sequence,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get billedAt => $composableBuilder(
    column: $table.billedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get customerName => $composableBuilder(
    column: $table.customerName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get customerPhone => $composableBuilder(
    column: $table.customerPhone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get itemsTotalPaise => $composableBuilder(
    column: $table.itemsTotalPaise,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get billDiscountPaise => $composableBuilder(
    column: $table.billDiscountPaise,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get taxablePaise => $composableBuilder(
    column: $table.taxablePaise,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get taxPaise => $composableBuilder(
    column: $table.taxPaise,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get roundOffPaise => $composableBuilder(
    column: $table.roundOffPaise,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get grandTotalPaise => $composableBuilder(
    column: $table.grandTotalPaise,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get paymentMode => $composableBuilder(
    column: $table.paymentMode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get cancelledAt => $composableBuilder(
    column: $table.cancelledAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cancelReason => $composableBuilder(
    column: $table.cancelReason,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> billLinesRefs(
    Expression<bool> Function($$BillLinesTableFilterComposer f) f,
  ) {
    final $$BillLinesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.billLines,
      getReferencedColumn: (t) => t.billId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BillLinesTableFilterComposer(
            $db: $db,
            $table: $db.billLines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$BillsTableOrderingComposer
    extends Composer<_$AppDatabase, $BillsTable> {
  $$BillsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get invoiceNo => $composableBuilder(
    column: $table.invoiceNo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get fyStart => $composableBuilder(
    column: $table.fyStart,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sequence => $composableBuilder(
    column: $table.sequence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get billedAt => $composableBuilder(
    column: $table.billedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get customerName => $composableBuilder(
    column: $table.customerName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get customerPhone => $composableBuilder(
    column: $table.customerPhone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get itemsTotalPaise => $composableBuilder(
    column: $table.itemsTotalPaise,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get billDiscountPaise => $composableBuilder(
    column: $table.billDiscountPaise,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get taxablePaise => $composableBuilder(
    column: $table.taxablePaise,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get taxPaise => $composableBuilder(
    column: $table.taxPaise,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get roundOffPaise => $composableBuilder(
    column: $table.roundOffPaise,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get grandTotalPaise => $composableBuilder(
    column: $table.grandTotalPaise,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get paymentMode => $composableBuilder(
    column: $table.paymentMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get cancelledAt => $composableBuilder(
    column: $table.cancelledAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cancelReason => $composableBuilder(
    column: $table.cancelReason,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BillsTableAnnotationComposer
    extends Composer<_$AppDatabase, $BillsTable> {
  $$BillsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get invoiceNo =>
      $composableBuilder(column: $table.invoiceNo, builder: (column) => column);

  GeneratedColumn<int> get fyStart =>
      $composableBuilder(column: $table.fyStart, builder: (column) => column);

  GeneratedColumn<int> get sequence =>
      $composableBuilder(column: $table.sequence, builder: (column) => column);

  GeneratedColumn<DateTime> get billedAt =>
      $composableBuilder(column: $table.billedAt, builder: (column) => column);

  GeneratedColumn<String> get customerName => $composableBuilder(
    column: $table.customerName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get customerPhone => $composableBuilder(
    column: $table.customerPhone,
    builder: (column) => column,
  );

  GeneratedColumn<int> get itemsTotalPaise => $composableBuilder(
    column: $table.itemsTotalPaise,
    builder: (column) => column,
  );

  GeneratedColumn<int> get billDiscountPaise => $composableBuilder(
    column: $table.billDiscountPaise,
    builder: (column) => column,
  );

  GeneratedColumn<int> get taxablePaise => $composableBuilder(
    column: $table.taxablePaise,
    builder: (column) => column,
  );

  GeneratedColumn<int> get taxPaise =>
      $composableBuilder(column: $table.taxPaise, builder: (column) => column);

  GeneratedColumn<int> get roundOffPaise => $composableBuilder(
    column: $table.roundOffPaise,
    builder: (column) => column,
  );

  GeneratedColumn<int> get grandTotalPaise => $composableBuilder(
    column: $table.grandTotalPaise,
    builder: (column) => column,
  );

  GeneratedColumn<String> get paymentMode => $composableBuilder(
    column: $table.paymentMode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get cancelledAt => $composableBuilder(
    column: $table.cancelledAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get cancelReason => $composableBuilder(
    column: $table.cancelReason,
    builder: (column) => column,
  );

  Expression<T> billLinesRefs<T extends Object>(
    Expression<T> Function($$BillLinesTableAnnotationComposer a) f,
  ) {
    final $$BillLinesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.billLines,
      getReferencedColumn: (t) => t.billId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BillLinesTableAnnotationComposer(
            $db: $db,
            $table: $db.billLines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$BillsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BillsTable,
          BillRow,
          $$BillsTableFilterComposer,
          $$BillsTableOrderingComposer,
          $$BillsTableAnnotationComposer,
          $$BillsTableCreateCompanionBuilder,
          $$BillsTableUpdateCompanionBuilder,
          (BillRow, $$BillsTableReferences),
          BillRow,
          PrefetchHooks Function({bool billLinesRefs})
        > {
  $$BillsTableTableManager(_$AppDatabase db, $BillsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BillsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BillsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BillsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> invoiceNo = const Value.absent(),
                Value<int> fyStart = const Value.absent(),
                Value<int> sequence = const Value.absent(),
                Value<DateTime> billedAt = const Value.absent(),
                Value<String?> customerName = const Value.absent(),
                Value<String?> customerPhone = const Value.absent(),
                Value<int> itemsTotalPaise = const Value.absent(),
                Value<int> billDiscountPaise = const Value.absent(),
                Value<int> taxablePaise = const Value.absent(),
                Value<int> taxPaise = const Value.absent(),
                Value<int> roundOffPaise = const Value.absent(),
                Value<int> grandTotalPaise = const Value.absent(),
                Value<String> paymentMode = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime?> cancelledAt = const Value.absent(),
                Value<String?> cancelReason = const Value.absent(),
              }) => BillsCompanion(
                id: id,
                invoiceNo: invoiceNo,
                fyStart: fyStart,
                sequence: sequence,
                billedAt: billedAt,
                customerName: customerName,
                customerPhone: customerPhone,
                itemsTotalPaise: itemsTotalPaise,
                billDiscountPaise: billDiscountPaise,
                taxablePaise: taxablePaise,
                taxPaise: taxPaise,
                roundOffPaise: roundOffPaise,
                grandTotalPaise: grandTotalPaise,
                paymentMode: paymentMode,
                status: status,
                cancelledAt: cancelledAt,
                cancelReason: cancelReason,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String invoiceNo,
                required int fyStart,
                required int sequence,
                required DateTime billedAt,
                Value<String?> customerName = const Value.absent(),
                Value<String?> customerPhone = const Value.absent(),
                required int itemsTotalPaise,
                required int billDiscountPaise,
                required int taxablePaise,
                required int taxPaise,
                required int roundOffPaise,
                required int grandTotalPaise,
                required String paymentMode,
                Value<String> status = const Value.absent(),
                Value<DateTime?> cancelledAt = const Value.absent(),
                Value<String?> cancelReason = const Value.absent(),
              }) => BillsCompanion.insert(
                id: id,
                invoiceNo: invoiceNo,
                fyStart: fyStart,
                sequence: sequence,
                billedAt: billedAt,
                customerName: customerName,
                customerPhone: customerPhone,
                itemsTotalPaise: itemsTotalPaise,
                billDiscountPaise: billDiscountPaise,
                taxablePaise: taxablePaise,
                taxPaise: taxPaise,
                roundOffPaise: roundOffPaise,
                grandTotalPaise: grandTotalPaise,
                paymentMode: paymentMode,
                status: status,
                cancelledAt: cancelledAt,
                cancelReason: cancelReason,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$BillsTable, BillRow>(table),
                  $$BillsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({billLinesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (billLinesRefs) db.billLines],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (billLinesRefs)
                    await $_getPrefetchedDataByColumns<
                      BillRow,
                      $BillsTable,
                      BillLineRow,
                      $BillLinesTable
                    >(
                      currentTable: table,
                      referencedTable: $$BillsTableReferences
                          ._billLinesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$BillsTableReferences(db, table, p0).billLinesRefs,
                      currentColumn: 'id',
                      referencedColumn: 'bill_id',
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$BillsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BillsTable,
      BillRow,
      $$BillsTableFilterComposer,
      $$BillsTableOrderingComposer,
      $$BillsTableAnnotationComposer,
      $$BillsTableCreateCompanionBuilder,
      $$BillsTableUpdateCompanionBuilder,
      (BillRow, $$BillsTableReferences),
      BillRow,
      PrefetchHooks Function({bool billLinesRefs})
    >;
typedef $$BillLinesTableCreateCompanionBuilder = BillLinesCompanion Function({
  Value<int> id,
  required int billId,
  required int position,
  Value<int?> itemId,
  required String name,
  required String unit,
  Value<String?> hsn,
  required int quantityMilli,
  required int unitPricePaise,
  required int taxRateBp,
  required bool priceIncludesTax,
  required int discountPaise,
  required int billDiscountSharePaise,
  required int taxablePaise,
  required int taxPaise,
  required int totalPaise,
});
typedef $$BillLinesTableUpdateCompanionBuilder = BillLinesCompanion Function({
  Value<int> id,
  Value<int> billId,
  Value<int> position,
  Value<int?> itemId,
  Value<String> name,
  Value<String> unit,
  Value<String?> hsn,
  Value<int> quantityMilli,
  Value<int> unitPricePaise,
  Value<int> taxRateBp,
  Value<bool> priceIncludesTax,
  Value<int> discountPaise,
  Value<int> billDiscountSharePaise,
  Value<int> taxablePaise,
  Value<int> taxPaise,
  Value<int> totalPaise,
});

final class $$BillLinesTableReferences
    extends BaseReferences<_$AppDatabase, $BillLinesTable, BillLineRow> {
  $$BillLinesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $BillsTable _billIdTable(_$AppDatabase db) =>
      db.bills.createAlias('bill_lines__bill_id__bills__id');

  $$BillsTableProcessedTableManager get billId {
    final $_column = $_itemColumn<int>('bill_id')!;

    final manager = $$BillsTableTableManager(
      $_db,
      $_db.bills,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_billIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ItemsTable _itemIdTable(_$AppDatabase db) =>
      db.items.createAlias('bill_lines__item_id__items__id');

  $$ItemsTableProcessedTableManager? get itemId {
    final $_column = $_itemColumn<int>('item_id');
    if ($_column == null) return null;
    final manager = $$ItemsTableTableManager(
      $_db,
      $_db.items,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_itemIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$BillLinesTableFilterComposer
    extends Composer<_$AppDatabase, $BillLinesTable> {
  $$BillLinesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hsn => $composableBuilder(
    column: $table.hsn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quantityMilli => $composableBuilder(
    column: $table.quantityMilli,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get unitPricePaise => $composableBuilder(
    column: $table.unitPricePaise,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get taxRateBp => $composableBuilder(
    column: $table.taxRateBp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get priceIncludesTax => $composableBuilder(
    column: $table.priceIncludesTax,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get discountPaise => $composableBuilder(
    column: $table.discountPaise,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get billDiscountSharePaise => $composableBuilder(
    column: $table.billDiscountSharePaise,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get taxablePaise => $composableBuilder(
    column: $table.taxablePaise,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get taxPaise => $composableBuilder(
    column: $table.taxPaise,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalPaise => $composableBuilder(
    column: $table.totalPaise,
    builder: (column) => ColumnFilters(column),
  );

  $$BillsTableFilterComposer get billId {
    final $$BillsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.billId,
      referencedTable: $db.bills,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BillsTableFilterComposer(
            $db: $db,
            $table: $db.bills,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ItemsTableFilterComposer get itemId {
    final $$ItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.itemId,
      referencedTable: $db.items,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemsTableFilterComposer(
            $db: $db,
            $table: $db.items,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BillLinesTableOrderingComposer
    extends Composer<_$AppDatabase, $BillLinesTable> {
  $$BillLinesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hsn => $composableBuilder(
    column: $table.hsn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quantityMilli => $composableBuilder(
    column: $table.quantityMilli,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get unitPricePaise => $composableBuilder(
    column: $table.unitPricePaise,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get taxRateBp => $composableBuilder(
    column: $table.taxRateBp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get priceIncludesTax => $composableBuilder(
    column: $table.priceIncludesTax,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get discountPaise => $composableBuilder(
    column: $table.discountPaise,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get billDiscountSharePaise => $composableBuilder(
    column: $table.billDiscountSharePaise,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get taxablePaise => $composableBuilder(
    column: $table.taxablePaise,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get taxPaise => $composableBuilder(
    column: $table.taxPaise,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalPaise => $composableBuilder(
    column: $table.totalPaise,
    builder: (column) => ColumnOrderings(column),
  );

  $$BillsTableOrderingComposer get billId {
    final $$BillsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.billId,
      referencedTable: $db.bills,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BillsTableOrderingComposer(
            $db: $db,
            $table: $db.bills,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ItemsTableOrderingComposer get itemId {
    final $$ItemsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.itemId,
      referencedTable: $db.items,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemsTableOrderingComposer(
            $db: $db,
            $table: $db.items,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BillLinesTableAnnotationComposer
    extends Composer<_$AppDatabase, $BillLinesTable> {
  $$BillLinesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<String> get hsn =>
      $composableBuilder(column: $table.hsn, builder: (column) => column);

  GeneratedColumn<int> get quantityMilli => $composableBuilder(
    column: $table.quantityMilli,
    builder: (column) => column,
  );

  GeneratedColumn<int> get unitPricePaise => $composableBuilder(
    column: $table.unitPricePaise,
    builder: (column) => column,
  );

  GeneratedColumn<int> get taxRateBp =>
      $composableBuilder(column: $table.taxRateBp, builder: (column) => column);

  GeneratedColumn<bool> get priceIncludesTax => $composableBuilder(
    column: $table.priceIncludesTax,
    builder: (column) => column,
  );

  GeneratedColumn<int> get discountPaise => $composableBuilder(
    column: $table.discountPaise,
    builder: (column) => column,
  );

  GeneratedColumn<int> get billDiscountSharePaise => $composableBuilder(
    column: $table.billDiscountSharePaise,
    builder: (column) => column,
  );

  GeneratedColumn<int> get taxablePaise => $composableBuilder(
    column: $table.taxablePaise,
    builder: (column) => column,
  );

  GeneratedColumn<int> get taxPaise =>
      $composableBuilder(column: $table.taxPaise, builder: (column) => column);

  GeneratedColumn<int> get totalPaise => $composableBuilder(
    column: $table.totalPaise,
    builder: (column) => column,
  );

  $$BillsTableAnnotationComposer get billId {
    final $$BillsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.billId,
      referencedTable: $db.bills,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BillsTableAnnotationComposer(
            $db: $db,
            $table: $db.bills,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ItemsTableAnnotationComposer get itemId {
    final $$ItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.itemId,
      referencedTable: $db.items,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.items,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BillLinesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BillLinesTable,
          BillLineRow,
          $$BillLinesTableFilterComposer,
          $$BillLinesTableOrderingComposer,
          $$BillLinesTableAnnotationComposer,
          $$BillLinesTableCreateCompanionBuilder,
          $$BillLinesTableUpdateCompanionBuilder,
          (BillLineRow, $$BillLinesTableReferences),
          BillLineRow,
          PrefetchHooks Function({bool billId, bool itemId})
        > {
  $$BillLinesTableTableManager(_$AppDatabase db, $BillLinesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BillLinesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BillLinesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BillLinesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> billId = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<int?> itemId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> unit = const Value.absent(),
                Value<String?> hsn = const Value.absent(),
                Value<int> quantityMilli = const Value.absent(),
                Value<int> unitPricePaise = const Value.absent(),
                Value<int> taxRateBp = const Value.absent(),
                Value<bool> priceIncludesTax = const Value.absent(),
                Value<int> discountPaise = const Value.absent(),
                Value<int> billDiscountSharePaise = const Value.absent(),
                Value<int> taxablePaise = const Value.absent(),
                Value<int> taxPaise = const Value.absent(),
                Value<int> totalPaise = const Value.absent(),
              }) => BillLinesCompanion(
                id: id,
                billId: billId,
                position: position,
                itemId: itemId,
                name: name,
                unit: unit,
                hsn: hsn,
                quantityMilli: quantityMilli,
                unitPricePaise: unitPricePaise,
                taxRateBp: taxRateBp,
                priceIncludesTax: priceIncludesTax,
                discountPaise: discountPaise,
                billDiscountSharePaise: billDiscountSharePaise,
                taxablePaise: taxablePaise,
                taxPaise: taxPaise,
                totalPaise: totalPaise,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int billId,
                required int position,
                Value<int?> itemId = const Value.absent(),
                required String name,
                required String unit,
                Value<String?> hsn = const Value.absent(),
                required int quantityMilli,
                required int unitPricePaise,
                required int taxRateBp,
                required bool priceIncludesTax,
                required int discountPaise,
                required int billDiscountSharePaise,
                required int taxablePaise,
                required int taxPaise,
                required int totalPaise,
              }) => BillLinesCompanion.insert(
                id: id,
                billId: billId,
                position: position,
                itemId: itemId,
                name: name,
                unit: unit,
                hsn: hsn,
                quantityMilli: quantityMilli,
                unitPricePaise: unitPricePaise,
                taxRateBp: taxRateBp,
                priceIncludesTax: priceIncludesTax,
                discountPaise: discountPaise,
                billDiscountSharePaise: billDiscountSharePaise,
                taxablePaise: taxablePaise,
                taxPaise: taxPaise,
                totalPaise: totalPaise,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$BillLinesTable, BillLineRow>(table),
                  $$BillLinesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({billId = false, itemId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (billId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.billId,
                        referencedTable: $$BillLinesTableReferences
                            ._billIdTable(db),
                        referencedColumn: $$BillLinesTableReferences
                            ._billIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (itemId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.itemId,
                        referencedTable: $$BillLinesTableReferences
                            ._itemIdTable(db),
                        referencedColumn: $$BillLinesTableReferences
                            ._itemIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$BillLinesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BillLinesTable,
      BillLineRow,
      $$BillLinesTableFilterComposer,
      $$BillLinesTableOrderingComposer,
      $$BillLinesTableAnnotationComposer,
      $$BillLinesTableCreateCompanionBuilder,
      $$BillLinesTableUpdateCompanionBuilder,
      (BillLineRow, $$BillLinesTableReferences),
      BillLineRow,
      PrefetchHooks Function({bool billId, bool itemId})
    >;
typedef $$InvoiceCountersTableCreateCompanionBuilder =
    InvoiceCountersCompanion Function({
      Value<int> fyStart,
      required int lastSequence,
    });
typedef $$InvoiceCountersTableUpdateCompanionBuilder =
    InvoiceCountersCompanion Function({
      Value<int> fyStart,
      Value<int> lastSequence,
    });

class $$InvoiceCountersTableFilterComposer
    extends Composer<_$AppDatabase, $InvoiceCountersTable> {
  $$InvoiceCountersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get fyStart => $composableBuilder(
    column: $table.fyStart,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lastSequence => $composableBuilder(
    column: $table.lastSequence,
    builder: (column) => ColumnFilters(column),
  );
}

class $$InvoiceCountersTableOrderingComposer
    extends Composer<_$AppDatabase, $InvoiceCountersTable> {
  $$InvoiceCountersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get fyStart => $composableBuilder(
    column: $table.fyStart,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lastSequence => $composableBuilder(
    column: $table.lastSequence,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$InvoiceCountersTableAnnotationComposer
    extends Composer<_$AppDatabase, $InvoiceCountersTable> {
  $$InvoiceCountersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get fyStart =>
      $composableBuilder(column: $table.fyStart, builder: (column) => column);

  GeneratedColumn<int> get lastSequence => $composableBuilder(
    column: $table.lastSequence,
    builder: (column) => column,
  );
}

class $$InvoiceCountersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $InvoiceCountersTable,
          InvoiceCounter,
          $$InvoiceCountersTableFilterComposer,
          $$InvoiceCountersTableOrderingComposer,
          $$InvoiceCountersTableAnnotationComposer,
          $$InvoiceCountersTableCreateCompanionBuilder,
          $$InvoiceCountersTableUpdateCompanionBuilder,
          (
            InvoiceCounter,
            BaseReferences<
              _$AppDatabase,
              $InvoiceCountersTable,
              InvoiceCounter
            >,
          ),
          InvoiceCounter,
          PrefetchHooks Function()
        > {
  $$InvoiceCountersTableTableManager(
    _$AppDatabase db,
    $InvoiceCountersTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InvoiceCountersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InvoiceCountersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$InvoiceCountersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> fyStart = const Value.absent(),
                Value<int> lastSequence = const Value.absent(),
              }) => InvoiceCountersCompanion(
                fyStart: fyStart,
                lastSequence: lastSequence,
              ),
          createCompanionCallback:
              ({
                Value<int> fyStart = const Value.absent(),
                required int lastSequence,
              }) => InvoiceCountersCompanion.insert(
                fyStart: fyStart,
                lastSequence: lastSequence,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$InvoiceCountersTable, InvoiceCounter>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $InvoiceCountersTable,
                    InvoiceCounter
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$InvoiceCountersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $InvoiceCountersTable,
      InvoiceCounter,
      $$InvoiceCountersTableFilterComposer,
      $$InvoiceCountersTableOrderingComposer,
      $$InvoiceCountersTableAnnotationComposer,
      $$InvoiceCountersTableCreateCompanionBuilder,
      $$InvoiceCountersTableUpdateCompanionBuilder,
      (
        InvoiceCounter,
        BaseReferences<_$AppDatabase, $InvoiceCountersTable, InvoiceCounter>,
      ),
      InvoiceCounter,
      PrefetchHooks Function()
    >;
typedef $$AppSettingsTableCreateCompanionBuilder =
    AppSettingsCompanion Function({
      Value<int> id,
      Value<String> invoicePrefix,
      Value<bool> roundToRupee,
      Value<String?> upiId,
      Value<String?> receiptFooter,
      Value<String?> printerAddress,
      Value<String?> printerName,
      Value<int> paperWidthMm,
    });
typedef $$AppSettingsTableUpdateCompanionBuilder =
    AppSettingsCompanion Function({
      Value<int> id,
      Value<String> invoicePrefix,
      Value<bool> roundToRupee,
      Value<String?> upiId,
      Value<String?> receiptFooter,
      Value<String?> printerAddress,
      Value<String?> printerName,
      Value<int> paperWidthMm,
    });

class $$AppSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get invoicePrefix => $composableBuilder(
    column: $table.invoicePrefix,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get roundToRupee => $composableBuilder(
    column: $table.roundToRupee,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get upiId => $composableBuilder(
    column: $table.upiId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get receiptFooter => $composableBuilder(
    column: $table.receiptFooter,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get printerAddress => $composableBuilder(
    column: $table.printerAddress,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get printerName => $composableBuilder(
    column: $table.printerName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get paperWidthMm => $composableBuilder(
    column: $table.paperWidthMm,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get invoicePrefix => $composableBuilder(
    column: $table.invoicePrefix,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get roundToRupee => $composableBuilder(
    column: $table.roundToRupee,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get upiId => $composableBuilder(
    column: $table.upiId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get receiptFooter => $composableBuilder(
    column: $table.receiptFooter,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get printerAddress => $composableBuilder(
    column: $table.printerAddress,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get printerName => $composableBuilder(
    column: $table.printerName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get paperWidthMm => $composableBuilder(
    column: $table.paperWidthMm,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get invoicePrefix => $composableBuilder(
    column: $table.invoicePrefix,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get roundToRupee => $composableBuilder(
    column: $table.roundToRupee,
    builder: (column) => column,
  );

  GeneratedColumn<String> get upiId =>
      $composableBuilder(column: $table.upiId, builder: (column) => column);

  GeneratedColumn<String> get receiptFooter => $composableBuilder(
    column: $table.receiptFooter,
    builder: (column) => column,
  );

  GeneratedColumn<String> get printerAddress => $composableBuilder(
    column: $table.printerAddress,
    builder: (column) => column,
  );

  GeneratedColumn<String> get printerName => $composableBuilder(
    column: $table.printerName,
    builder: (column) => column,
  );

  GeneratedColumn<int> get paperWidthMm => $composableBuilder(
    column: $table.paperWidthMm,
    builder: (column) => column,
  );
}

class $$AppSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppSettingsTable,
          SettingsRow,
          $$AppSettingsTableFilterComposer,
          $$AppSettingsTableOrderingComposer,
          $$AppSettingsTableAnnotationComposer,
          $$AppSettingsTableCreateCompanionBuilder,
          $$AppSettingsTableUpdateCompanionBuilder,
          (
            SettingsRow,
            BaseReferences<_$AppDatabase, $AppSettingsTable, SettingsRow>,
          ),
          SettingsRow,
          PrefetchHooks Function()
        > {
  $$AppSettingsTableTableManager(_$AppDatabase db, $AppSettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> invoicePrefix = const Value.absent(),
                Value<bool> roundToRupee = const Value.absent(),
                Value<String?> upiId = const Value.absent(),
                Value<String?> receiptFooter = const Value.absent(),
                Value<String?> printerAddress = const Value.absent(),
                Value<String?> printerName = const Value.absent(),
                Value<int> paperWidthMm = const Value.absent(),
              }) => AppSettingsCompanion(
                id: id,
                invoicePrefix: invoicePrefix,
                roundToRupee: roundToRupee,
                upiId: upiId,
                receiptFooter: receiptFooter,
                printerAddress: printerAddress,
                printerName: printerName,
                paperWidthMm: paperWidthMm,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> invoicePrefix = const Value.absent(),
                Value<bool> roundToRupee = const Value.absent(),
                Value<String?> upiId = const Value.absent(),
                Value<String?> receiptFooter = const Value.absent(),
                Value<String?> printerAddress = const Value.absent(),
                Value<String?> printerName = const Value.absent(),
                Value<int> paperWidthMm = const Value.absent(),
              }) => AppSettingsCompanion.insert(
                id: id,
                invoicePrefix: invoicePrefix,
                roundToRupee: roundToRupee,
                upiId: upiId,
                receiptFooter: receiptFooter,
                printerAddress: printerAddress,
                printerName: printerName,
                paperWidthMm: paperWidthMm,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AppSettingsTable, SettingsRow>(table),
                  BaseReferences<_$AppDatabase, $AppSettingsTable, SettingsRow>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppSettingsTable,
      SettingsRow,
      $$AppSettingsTableFilterComposer,
      $$AppSettingsTableOrderingComposer,
      $$AppSettingsTableAnnotationComposer,
      $$AppSettingsTableCreateCompanionBuilder,
      $$AppSettingsTableUpdateCompanionBuilder,
      (
        SettingsRow,
        BaseReferences<_$AppDatabase, $AppSettingsTable, SettingsRow>,
      ),
      SettingsRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ShopProfilesTableTableManager get shopProfiles =>
      $$ShopProfilesTableTableManager(_db, _db.shopProfiles);
  $$ItemsTableTableManager get items =>
      $$ItemsTableTableManager(_db, _db.items);
  $$BillsTableTableManager get bills =>
      $$BillsTableTableManager(_db, _db.bills);
  $$BillLinesTableTableManager get billLines =>
      $$BillLinesTableTableManager(_db, _db.billLines);
  $$InvoiceCountersTableTableManager get invoiceCounters =>
      $$InvoiceCountersTableTableManager(_db, _db.invoiceCounters);
  $$AppSettingsTableTableManager get appSettings =>
      $$AppSettingsTableTableManager(_db, _db.appSettings);
}
