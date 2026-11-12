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

class $CategoriesTable extends Categories
    with TableInfo<$CategoriesTable, CategoryRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriesTable(this.attachedDatabase, [this._alias]);
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
      maxTextLength: 60,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _parentIdMeta = const VerificationMeta(
    'parentId',
  );
  @override
  late final GeneratedColumn<int> parentId = GeneratedColumn<int>(
    'parent_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES categories (id)',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, parentId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<CategoryRow> instance, {
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
    if (data.containsKey('parent_id')) {
      context.handle(
        _parentIdMeta,
        parentId.isAcceptableOrUnknown(data['parent_id']!, _parentIdMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CategoryRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CategoryRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      parentId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}parent_id'],
      ),
    );
  }

  @override
  $CategoriesTable createAlias(String alias) {
    return $CategoriesTable(attachedDatabase, alias);
  }
}

class CategoryRow extends DataClass implements Insertable<CategoryRow> {
  final int id;
  final String name;
  final int? parentId;
  const CategoryRow({required this.id, required this.name, this.parentId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || parentId != null) {
      map['parent_id'] = Variable<int>(parentId);
    }
    return map;
  }

  CategoriesCompanion toCompanion(bool nullToAbsent) {
    return CategoriesCompanion(
      id: Value(id),
      name: Value(name),
      parentId: parentId == null && nullToAbsent
          ? const Value.absent()
          : Value(parentId),
    );
  }

  factory CategoryRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CategoryRow(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      parentId: serializer.fromJson<int?>(json['parentId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'parentId': serializer.toJson<int?>(parentId),
    };
  }

  CategoryRow copyWith({
    int? id,
    String? name,
    Value<int?> parentId = const Value.absent(),
  }) => CategoryRow(
    id: id ?? this.id,
    name: name ?? this.name,
    parentId: parentId.present ? parentId.value : this.parentId,
  );
  CategoryRow copyWithCompanion(CategoriesCompanion data) {
    return CategoryRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      parentId: data.parentId.present ? data.parentId.value : this.parentId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CategoryRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('parentId: $parentId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, parentId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CategoryRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.parentId == this.parentId);
}

class CategoriesCompanion extends UpdateCompanion<CategoryRow> {
  final Value<int> id;
  final Value<String> name;
  final Value<int?> parentId;
  const CategoriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.parentId = const Value.absent(),
  });
  CategoriesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.parentId = const Value.absent(),
  }) : name = Value(name);
  static Insertable<CategoryRow> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? parentId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (parentId != null) 'parent_id': parentId,
    });
  }

  CategoriesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<int?>? parentId,
  }) {
    return CategoriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      parentId: parentId ?? this.parentId,
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
    if (parentId.present) {
      map['parent_id'] = Variable<int>(parentId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('parentId: $parentId')
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
  static const VerificationMeta _trackStockMeta = const VerificationMeta(
    'trackStock',
  );
  @override
  late final GeneratedColumn<bool> trackStock = GeneratedColumn<bool>(
    'track_stock',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("track_stock" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _stockMilliMeta = const VerificationMeta(
    'stockMilli',
  );
  @override
  late final GeneratedColumn<int> stockMilli = GeneratedColumn<int>(
    'stock_milli',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lowStockMilliMeta = const VerificationMeta(
    'lowStockMilli',
  );
  @override
  late final GeneratedColumn<int> lowStockMilli = GeneratedColumn<int>(
    'low_stock_milli',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
    'category_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES categories (id)',
    ),
  );
  static const VerificationMeta _imagePathMeta = const VerificationMeta(
    'imagePath',
  );
  @override
  late final GeneratedColumn<String> imagePath = GeneratedColumn<String>(
    'image_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _tracksBatchesMeta = const VerificationMeta(
    'tracksBatches',
  );
  @override
  late final GeneratedColumn<bool> tracksBatches = GeneratedColumn<bool>(
    'tracks_batches',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("tracks_batches" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _altUnitMeta = const VerificationMeta(
    'altUnit',
  );
  @override
  late final GeneratedColumn<String> altUnit = GeneratedColumn<String>(
    'alt_unit',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _altUnitFactorMilliMeta =
      const VerificationMeta('altUnitFactorMilli');
  @override
  late final GeneratedColumn<int> altUnitFactorMilli = GeneratedColumn<int>(
    'alt_unit_factor_milli',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _altUnitPricePaiseMeta = const VerificationMeta(
    'altUnitPricePaise',
  );
  @override
  late final GeneratedColumn<int> altUnitPricePaise = GeneratedColumn<int>(
    'alt_unit_price_paise',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _costPricePaiseMeta = const VerificationMeta(
    'costPricePaise',
  );
  @override
  late final GeneratedColumn<int> costPricePaise = GeneratedColumn<int>(
    'cost_price_paise',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
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
    trackStock,
    stockMilli,
    lowStockMilli,
    categoryId,
    imagePath,
    tracksBatches,
    altUnit,
    altUnitFactorMilli,
    altUnitPricePaise,
    costPricePaise,
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
    if (data.containsKey('track_stock')) {
      context.handle(
        _trackStockMeta,
        trackStock.isAcceptableOrUnknown(data['track_stock']!, _trackStockMeta),
      );
    }
    if (data.containsKey('stock_milli')) {
      context.handle(
        _stockMilliMeta,
        stockMilli.isAcceptableOrUnknown(data['stock_milli']!, _stockMilliMeta),
      );
    }
    if (data.containsKey('low_stock_milli')) {
      context.handle(
        _lowStockMilliMeta,
        lowStockMilli.isAcceptableOrUnknown(
          data['low_stock_milli']!,
          _lowStockMilliMeta,
        ),
      );
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    }
    if (data.containsKey('image_path')) {
      context.handle(
        _imagePathMeta,
        imagePath.isAcceptableOrUnknown(data['image_path']!, _imagePathMeta),
      );
    }
    if (data.containsKey('tracks_batches')) {
      context.handle(
        _tracksBatchesMeta,
        tracksBatches.isAcceptableOrUnknown(
          data['tracks_batches']!,
          _tracksBatchesMeta,
        ),
      );
    }
    if (data.containsKey('alt_unit')) {
      context.handle(
        _altUnitMeta,
        altUnit.isAcceptableOrUnknown(data['alt_unit']!, _altUnitMeta),
      );
    }
    if (data.containsKey('alt_unit_factor_milli')) {
      context.handle(
        _altUnitFactorMilliMeta,
        altUnitFactorMilli.isAcceptableOrUnknown(
          data['alt_unit_factor_milli']!,
          _altUnitFactorMilliMeta,
        ),
      );
    }
    if (data.containsKey('alt_unit_price_paise')) {
      context.handle(
        _altUnitPricePaiseMeta,
        altUnitPricePaise.isAcceptableOrUnknown(
          data['alt_unit_price_paise']!,
          _altUnitPricePaiseMeta,
        ),
      );
    }
    if (data.containsKey('cost_price_paise')) {
      context.handle(
        _costPricePaiseMeta,
        costPricePaise.isAcceptableOrUnknown(
          data['cost_price_paise']!,
          _costPricePaiseMeta,
        ),
      );
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
      trackStock: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}track_stock'],
      )!,
      stockMilli: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}stock_milli'],
      )!,
      lowStockMilli: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}low_stock_milli'],
      ),
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}category_id'],
      ),
      imagePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_path'],
      ),
      tracksBatches: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}tracks_batches'],
      )!,
      altUnit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}alt_unit'],
      ),
      altUnitFactorMilli: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}alt_unit_factor_milli'],
      ),
      altUnitPricePaise: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}alt_unit_price_paise'],
      ),
      costPricePaise: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cost_price_paise'],
      ),
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

  /// Off: unlimited stock, nothing is counted.
  final bool trackStock;

  /// Cached sum of this item's stock movements, in base units. The ledger
  /// (StockMovements) is the truth; this is kept in step in the same
  /// transaction so lists don't have to add up history.
  final int stockMilli;
  final int? lowStockMilli;
  final int? categoryId;
  final String? imagePath;

  /// Stock is held in batches with expiry dates; sales take the batch that
  /// expires first (FEFO).
  final bool tracksBatches;

  /// A second selling unit, e.g. `box` = 12 × `pcs`.
  final String? altUnit;
  final int? altUnitFactorMilli;
  final int? altUnitPricePaise;

  /// Latest cost per base unit, before GST (input tax is claimed back).
  /// Updated by purchases; used for profit.
  final int? costPricePaise;
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
    required this.trackStock,
    required this.stockMilli,
    this.lowStockMilli,
    this.categoryId,
    this.imagePath,
    required this.tracksBatches,
    this.altUnit,
    this.altUnitFactorMilli,
    this.altUnitPricePaise,
    this.costPricePaise,
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
    map['track_stock'] = Variable<bool>(trackStock);
    map['stock_milli'] = Variable<int>(stockMilli);
    if (!nullToAbsent || lowStockMilli != null) {
      map['low_stock_milli'] = Variable<int>(lowStockMilli);
    }
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<int>(categoryId);
    }
    if (!nullToAbsent || imagePath != null) {
      map['image_path'] = Variable<String>(imagePath);
    }
    map['tracks_batches'] = Variable<bool>(tracksBatches);
    if (!nullToAbsent || altUnit != null) {
      map['alt_unit'] = Variable<String>(altUnit);
    }
    if (!nullToAbsent || altUnitFactorMilli != null) {
      map['alt_unit_factor_milli'] = Variable<int>(altUnitFactorMilli);
    }
    if (!nullToAbsent || altUnitPricePaise != null) {
      map['alt_unit_price_paise'] = Variable<int>(altUnitPricePaise);
    }
    if (!nullToAbsent || costPricePaise != null) {
      map['cost_price_paise'] = Variable<int>(costPricePaise);
    }
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
      trackStock: Value(trackStock),
      stockMilli: Value(stockMilli),
      lowStockMilli: lowStockMilli == null && nullToAbsent
          ? const Value.absent()
          : Value(lowStockMilli),
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
      imagePath: imagePath == null && nullToAbsent
          ? const Value.absent()
          : Value(imagePath),
      tracksBatches: Value(tracksBatches),
      altUnit: altUnit == null && nullToAbsent
          ? const Value.absent()
          : Value(altUnit),
      altUnitFactorMilli: altUnitFactorMilli == null && nullToAbsent
          ? const Value.absent()
          : Value(altUnitFactorMilli),
      altUnitPricePaise: altUnitPricePaise == null && nullToAbsent
          ? const Value.absent()
          : Value(altUnitPricePaise),
      costPricePaise: costPricePaise == null && nullToAbsent
          ? const Value.absent()
          : Value(costPricePaise),
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
      trackStock: serializer.fromJson<bool>(json['trackStock']),
      stockMilli: serializer.fromJson<int>(json['stockMilli']),
      lowStockMilli: serializer.fromJson<int?>(json['lowStockMilli']),
      categoryId: serializer.fromJson<int?>(json['categoryId']),
      imagePath: serializer.fromJson<String?>(json['imagePath']),
      tracksBatches: serializer.fromJson<bool>(json['tracksBatches']),
      altUnit: serializer.fromJson<String?>(json['altUnit']),
      altUnitFactorMilli: serializer.fromJson<int?>(json['altUnitFactorMilli']),
      altUnitPricePaise: serializer.fromJson<int?>(json['altUnitPricePaise']),
      costPricePaise: serializer.fromJson<int?>(json['costPricePaise']),
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
      'trackStock': serializer.toJson<bool>(trackStock),
      'stockMilli': serializer.toJson<int>(stockMilli),
      'lowStockMilli': serializer.toJson<int?>(lowStockMilli),
      'categoryId': serializer.toJson<int?>(categoryId),
      'imagePath': serializer.toJson<String?>(imagePath),
      'tracksBatches': serializer.toJson<bool>(tracksBatches),
      'altUnit': serializer.toJson<String?>(altUnit),
      'altUnitFactorMilli': serializer.toJson<int?>(altUnitFactorMilli),
      'altUnitPricePaise': serializer.toJson<int?>(altUnitPricePaise),
      'costPricePaise': serializer.toJson<int?>(costPricePaise),
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
    bool? trackStock,
    int? stockMilli,
    Value<int?> lowStockMilli = const Value.absent(),
    Value<int?> categoryId = const Value.absent(),
    Value<String?> imagePath = const Value.absent(),
    bool? tracksBatches,
    Value<String?> altUnit = const Value.absent(),
    Value<int?> altUnitFactorMilli = const Value.absent(),
    Value<int?> altUnitPricePaise = const Value.absent(),
    Value<int?> costPricePaise = const Value.absent(),
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
    trackStock: trackStock ?? this.trackStock,
    stockMilli: stockMilli ?? this.stockMilli,
    lowStockMilli: lowStockMilli.present
        ? lowStockMilli.value
        : this.lowStockMilli,
    categoryId: categoryId.present ? categoryId.value : this.categoryId,
    imagePath: imagePath.present ? imagePath.value : this.imagePath,
    tracksBatches: tracksBatches ?? this.tracksBatches,
    altUnit: altUnit.present ? altUnit.value : this.altUnit,
    altUnitFactorMilli: altUnitFactorMilli.present
        ? altUnitFactorMilli.value
        : this.altUnitFactorMilli,
    altUnitPricePaise: altUnitPricePaise.present
        ? altUnitPricePaise.value
        : this.altUnitPricePaise,
    costPricePaise: costPricePaise.present
        ? costPricePaise.value
        : this.costPricePaise,
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
      trackStock: data.trackStock.present
          ? data.trackStock.value
          : this.trackStock,
      stockMilli: data.stockMilli.present
          ? data.stockMilli.value
          : this.stockMilli,
      lowStockMilli: data.lowStockMilli.present
          ? data.lowStockMilli.value
          : this.lowStockMilli,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      imagePath: data.imagePath.present ? data.imagePath.value : this.imagePath,
      tracksBatches: data.tracksBatches.present
          ? data.tracksBatches.value
          : this.tracksBatches,
      altUnit: data.altUnit.present ? data.altUnit.value : this.altUnit,
      altUnitFactorMilli: data.altUnitFactorMilli.present
          ? data.altUnitFactorMilli.value
          : this.altUnitFactorMilli,
      altUnitPricePaise: data.altUnitPricePaise.present
          ? data.altUnitPricePaise.value
          : this.altUnitPricePaise,
      costPricePaise: data.costPricePaise.present
          ? data.costPricePaise.value
          : this.costPricePaise,
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
          ..write('updatedAt: $updatedAt, ')
          ..write('trackStock: $trackStock, ')
          ..write('stockMilli: $stockMilli, ')
          ..write('lowStockMilli: $lowStockMilli, ')
          ..write('categoryId: $categoryId, ')
          ..write('imagePath: $imagePath, ')
          ..write('tracksBatches: $tracksBatches, ')
          ..write('altUnit: $altUnit, ')
          ..write('altUnitFactorMilli: $altUnitFactorMilli, ')
          ..write('altUnitPricePaise: $altUnitPricePaise, ')
          ..write('costPricePaise: $costPricePaise')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
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
    trackStock,
    stockMilli,
    lowStockMilli,
    categoryId,
    imagePath,
    tracksBatches,
    altUnit,
    altUnitFactorMilli,
    altUnitPricePaise,
    costPricePaise,
  ]);
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
          other.updatedAt == this.updatedAt &&
          other.trackStock == this.trackStock &&
          other.stockMilli == this.stockMilli &&
          other.lowStockMilli == this.lowStockMilli &&
          other.categoryId == this.categoryId &&
          other.imagePath == this.imagePath &&
          other.tracksBatches == this.tracksBatches &&
          other.altUnit == this.altUnit &&
          other.altUnitFactorMilli == this.altUnitFactorMilli &&
          other.altUnitPricePaise == this.altUnitPricePaise &&
          other.costPricePaise == this.costPricePaise);
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
  final Value<bool> trackStock;
  final Value<int> stockMilli;
  final Value<int?> lowStockMilli;
  final Value<int?> categoryId;
  final Value<String?> imagePath;
  final Value<bool> tracksBatches;
  final Value<String?> altUnit;
  final Value<int?> altUnitFactorMilli;
  final Value<int?> altUnitPricePaise;
  final Value<int?> costPricePaise;
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
    this.trackStock = const Value.absent(),
    this.stockMilli = const Value.absent(),
    this.lowStockMilli = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.imagePath = const Value.absent(),
    this.tracksBatches = const Value.absent(),
    this.altUnit = const Value.absent(),
    this.altUnitFactorMilli = const Value.absent(),
    this.altUnitPricePaise = const Value.absent(),
    this.costPricePaise = const Value.absent(),
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
    this.trackStock = const Value.absent(),
    this.stockMilli = const Value.absent(),
    this.lowStockMilli = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.imagePath = const Value.absent(),
    this.tracksBatches = const Value.absent(),
    this.altUnit = const Value.absent(),
    this.altUnitFactorMilli = const Value.absent(),
    this.altUnitPricePaise = const Value.absent(),
    this.costPricePaise = const Value.absent(),
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
    Expression<bool>? trackStock,
    Expression<int>? stockMilli,
    Expression<int>? lowStockMilli,
    Expression<int>? categoryId,
    Expression<String>? imagePath,
    Expression<bool>? tracksBatches,
    Expression<String>? altUnit,
    Expression<int>? altUnitFactorMilli,
    Expression<int>? altUnitPricePaise,
    Expression<int>? costPricePaise,
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
      if (trackStock != null) 'track_stock': trackStock,
      if (stockMilli != null) 'stock_milli': stockMilli,
      if (lowStockMilli != null) 'low_stock_milli': lowStockMilli,
      if (categoryId != null) 'category_id': categoryId,
      if (imagePath != null) 'image_path': imagePath,
      if (tracksBatches != null) 'tracks_batches': tracksBatches,
      if (altUnit != null) 'alt_unit': altUnit,
      if (altUnitFactorMilli != null)
        'alt_unit_factor_milli': altUnitFactorMilli,
      if (altUnitPricePaise != null) 'alt_unit_price_paise': altUnitPricePaise,
      if (costPricePaise != null) 'cost_price_paise': costPricePaise,
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
    Value<bool>? trackStock,
    Value<int>? stockMilli,
    Value<int?>? lowStockMilli,
    Value<int?>? categoryId,
    Value<String?>? imagePath,
    Value<bool>? tracksBatches,
    Value<String?>? altUnit,
    Value<int?>? altUnitFactorMilli,
    Value<int?>? altUnitPricePaise,
    Value<int?>? costPricePaise,
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
      trackStock: trackStock ?? this.trackStock,
      stockMilli: stockMilli ?? this.stockMilli,
      lowStockMilli: lowStockMilli ?? this.lowStockMilli,
      categoryId: categoryId ?? this.categoryId,
      imagePath: imagePath ?? this.imagePath,
      tracksBatches: tracksBatches ?? this.tracksBatches,
      altUnit: altUnit ?? this.altUnit,
      altUnitFactorMilli: altUnitFactorMilli ?? this.altUnitFactorMilli,
      altUnitPricePaise: altUnitPricePaise ?? this.altUnitPricePaise,
      costPricePaise: costPricePaise ?? this.costPricePaise,
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
    if (trackStock.present) {
      map['track_stock'] = Variable<bool>(trackStock.value);
    }
    if (stockMilli.present) {
      map['stock_milli'] = Variable<int>(stockMilli.value);
    }
    if (lowStockMilli.present) {
      map['low_stock_milli'] = Variable<int>(lowStockMilli.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (imagePath.present) {
      map['image_path'] = Variable<String>(imagePath.value);
    }
    if (tracksBatches.present) {
      map['tracks_batches'] = Variable<bool>(tracksBatches.value);
    }
    if (altUnit.present) {
      map['alt_unit'] = Variable<String>(altUnit.value);
    }
    if (altUnitFactorMilli.present) {
      map['alt_unit_factor_milli'] = Variable<int>(altUnitFactorMilli.value);
    }
    if (altUnitPricePaise.present) {
      map['alt_unit_price_paise'] = Variable<int>(altUnitPricePaise.value);
    }
    if (costPricePaise.present) {
      map['cost_price_paise'] = Variable<int>(costPricePaise.value);
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
          ..write('updatedAt: $updatedAt, ')
          ..write('trackStock: $trackStock, ')
          ..write('stockMilli: $stockMilli, ')
          ..write('lowStockMilli: $lowStockMilli, ')
          ..write('categoryId: $categoryId, ')
          ..write('imagePath: $imagePath, ')
          ..write('tracksBatches: $tracksBatches, ')
          ..write('altUnit: $altUnit, ')
          ..write('altUnitFactorMilli: $altUnitFactorMilli, ')
          ..write('altUnitPricePaise: $altUnitPricePaise, ')
          ..write('costPricePaise: $costPricePaise')
          ..write(')'))
        .toString();
  }
}

class $PartiesTable extends Parties with TableInfo<$PartiesTable, PartyRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PartiesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('customer'),
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
  static const VerificationMeta _gstinMeta = const VerificationMeta('gstin');
  @override
  late final GeneratedColumn<String> gstin = GeneratedColumn<String>(
    'gstin',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
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
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _balancePaiseMeta = const VerificationMeta(
    'balancePaise',
  );
  @override
  late final GeneratedColumn<int> balancePaise = GeneratedColumn<int>(
    'balance_paise',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
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
    type,
    name,
    phone,
    addressLine,
    gstin,
    notes,
    stateCode,
    balancePaise,
    isActive,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'parties';
  @override
  VerificationContext validateIntegrity(
    Insertable<PartyRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
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
    if (data.containsKey('gstin')) {
      context.handle(
        _gstinMeta,
        gstin.isAcceptableOrUnknown(data['gstin']!, _gstinMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('state_code')) {
      context.handle(
        _stateCodeMeta,
        stateCode.isAcceptableOrUnknown(data['state_code']!, _stateCodeMeta),
      );
    }
    if (data.containsKey('balance_paise')) {
      context.handle(
        _balancePaiseMeta,
        balancePaise.isAcceptableOrUnknown(
          data['balance_paise']!,
          _balancePaiseMeta,
        ),
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
  PartyRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PartyRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
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
      gstin: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}gstin'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      stateCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}state_code'],
      ),
      balancePaise: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}balance_paise'],
      )!,
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
  $PartiesTable createAlias(String alias) {
    return $PartiesTable(attachedDatabase, alias);
  }
}

class PartyRow extends DataClass implements Insertable<PartyRow> {
  final int id;

  /// `customer` or `supplier`.
  final String type;
  final String name;
  final String? phone;
  final String? addressLine;
  final String? gstin;
  final String? notes;

  /// GST state code, for place of supply (IGST vs CGST+SGST). Phase 4.
  final String? stateCode;

  /// Cached sum of this party's ledger: what they owe the shop (positive)
  /// or the shop owes them (negative, an advance). Written only by the
  /// party ledger, in the same transaction as the entry.
  final int balancePaise;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  const PartyRow({
    required this.id,
    required this.type,
    required this.name,
    this.phone,
    this.addressLine,
    this.gstin,
    this.notes,
    this.stateCode,
    required this.balancePaise,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['type'] = Variable<String>(type);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    if (!nullToAbsent || addressLine != null) {
      map['address_line'] = Variable<String>(addressLine);
    }
    if (!nullToAbsent || gstin != null) {
      map['gstin'] = Variable<String>(gstin);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || stateCode != null) {
      map['state_code'] = Variable<String>(stateCode);
    }
    map['balance_paise'] = Variable<int>(balancePaise);
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  PartiesCompanion toCompanion(bool nullToAbsent) {
    return PartiesCompanion(
      id: Value(id),
      type: Value(type),
      name: Value(name),
      phone: phone == null && nullToAbsent
          ? const Value.absent()
          : Value(phone),
      addressLine: addressLine == null && nullToAbsent
          ? const Value.absent()
          : Value(addressLine),
      gstin: gstin == null && nullToAbsent
          ? const Value.absent()
          : Value(gstin),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      stateCode: stateCode == null && nullToAbsent
          ? const Value.absent()
          : Value(stateCode),
      balancePaise: Value(balancePaise),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory PartyRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PartyRow(
      id: serializer.fromJson<int>(json['id']),
      type: serializer.fromJson<String>(json['type']),
      name: serializer.fromJson<String>(json['name']),
      phone: serializer.fromJson<String?>(json['phone']),
      addressLine: serializer.fromJson<String?>(json['addressLine']),
      gstin: serializer.fromJson<String?>(json['gstin']),
      notes: serializer.fromJson<String?>(json['notes']),
      stateCode: serializer.fromJson<String?>(json['stateCode']),
      balancePaise: serializer.fromJson<int>(json['balancePaise']),
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
      'type': serializer.toJson<String>(type),
      'name': serializer.toJson<String>(name),
      'phone': serializer.toJson<String?>(phone),
      'addressLine': serializer.toJson<String?>(addressLine),
      'gstin': serializer.toJson<String?>(gstin),
      'notes': serializer.toJson<String?>(notes),
      'stateCode': serializer.toJson<String?>(stateCode),
      'balancePaise': serializer.toJson<int>(balancePaise),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  PartyRow copyWith({
    int? id,
    String? type,
    String? name,
    Value<String?> phone = const Value.absent(),
    Value<String?> addressLine = const Value.absent(),
    Value<String?> gstin = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    Value<String?> stateCode = const Value.absent(),
    int? balancePaise,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => PartyRow(
    id: id ?? this.id,
    type: type ?? this.type,
    name: name ?? this.name,
    phone: phone.present ? phone.value : this.phone,
    addressLine: addressLine.present ? addressLine.value : this.addressLine,
    gstin: gstin.present ? gstin.value : this.gstin,
    notes: notes.present ? notes.value : this.notes,
    stateCode: stateCode.present ? stateCode.value : this.stateCode,
    balancePaise: balancePaise ?? this.balancePaise,
    isActive: isActive ?? this.isActive,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  PartyRow copyWithCompanion(PartiesCompanion data) {
    return PartyRow(
      id: data.id.present ? data.id.value : this.id,
      type: data.type.present ? data.type.value : this.type,
      name: data.name.present ? data.name.value : this.name,
      phone: data.phone.present ? data.phone.value : this.phone,
      addressLine: data.addressLine.present
          ? data.addressLine.value
          : this.addressLine,
      gstin: data.gstin.present ? data.gstin.value : this.gstin,
      notes: data.notes.present ? data.notes.value : this.notes,
      stateCode: data.stateCode.present ? data.stateCode.value : this.stateCode,
      balancePaise: data.balancePaise.present
          ? data.balancePaise.value
          : this.balancePaise,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PartyRow(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('addressLine: $addressLine, ')
          ..write('gstin: $gstin, ')
          ..write('notes: $notes, ')
          ..write('stateCode: $stateCode, ')
          ..write('balancePaise: $balancePaise, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    type,
    name,
    phone,
    addressLine,
    gstin,
    notes,
    stateCode,
    balancePaise,
    isActive,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PartyRow &&
          other.id == this.id &&
          other.type == this.type &&
          other.name == this.name &&
          other.phone == this.phone &&
          other.addressLine == this.addressLine &&
          other.gstin == this.gstin &&
          other.notes == this.notes &&
          other.stateCode == this.stateCode &&
          other.balancePaise == this.balancePaise &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class PartiesCompanion extends UpdateCompanion<PartyRow> {
  final Value<int> id;
  final Value<String> type;
  final Value<String> name;
  final Value<String?> phone;
  final Value<String?> addressLine;
  final Value<String?> gstin;
  final Value<String?> notes;
  final Value<String?> stateCode;
  final Value<int> balancePaise;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const PartiesCompanion({
    this.id = const Value.absent(),
    this.type = const Value.absent(),
    this.name = const Value.absent(),
    this.phone = const Value.absent(),
    this.addressLine = const Value.absent(),
    this.gstin = const Value.absent(),
    this.notes = const Value.absent(),
    this.stateCode = const Value.absent(),
    this.balancePaise = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  PartiesCompanion.insert({
    this.id = const Value.absent(),
    this.type = const Value.absent(),
    required String name,
    this.phone = const Value.absent(),
    this.addressLine = const Value.absent(),
    this.gstin = const Value.absent(),
    this.notes = const Value.absent(),
    this.stateCode = const Value.absent(),
    this.balancePaise = const Value.absent(),
    this.isActive = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : name = Value(name),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<PartyRow> custom({
    Expression<int>? id,
    Expression<String>? type,
    Expression<String>? name,
    Expression<String>? phone,
    Expression<String>? addressLine,
    Expression<String>? gstin,
    Expression<String>? notes,
    Expression<String>? stateCode,
    Expression<int>? balancePaise,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (type != null) 'type': type,
      if (name != null) 'name': name,
      if (phone != null) 'phone': phone,
      if (addressLine != null) 'address_line': addressLine,
      if (gstin != null) 'gstin': gstin,
      if (notes != null) 'notes': notes,
      if (stateCode != null) 'state_code': stateCode,
      if (balancePaise != null) 'balance_paise': balancePaise,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  PartiesCompanion copyWith({
    Value<int>? id,
    Value<String>? type,
    Value<String>? name,
    Value<String?>? phone,
    Value<String?>? addressLine,
    Value<String?>? gstin,
    Value<String?>? notes,
    Value<String?>? stateCode,
    Value<int>? balancePaise,
    Value<bool>? isActive,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return PartiesCompanion(
      id: id ?? this.id,
      type: type ?? this.type,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      addressLine: addressLine ?? this.addressLine,
      gstin: gstin ?? this.gstin,
      notes: notes ?? this.notes,
      stateCode: stateCode ?? this.stateCode,
      balancePaise: balancePaise ?? this.balancePaise,
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
    if (type.present) {
      map['type'] = Variable<String>(type.value);
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
    if (gstin.present) {
      map['gstin'] = Variable<String>(gstin.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (stateCode.present) {
      map['state_code'] = Variable<String>(stateCode.value);
    }
    if (balancePaise.present) {
      map['balance_paise'] = Variable<int>(balancePaise.value);
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
    return (StringBuffer('PartiesCompanion(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('addressLine: $addressLine, ')
          ..write('gstin: $gstin, ')
          ..write('notes: $notes, ')
          ..write('stateCode: $stateCode, ')
          ..write('balancePaise: $balancePaise, ')
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
  static const VerificationMeta _partyIdMeta = const VerificationMeta(
    'partyId',
  );
  @override
  late final GeneratedColumn<int> partyId = GeneratedColumn<int>(
    'party_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES parties (id)',
    ),
  );
  static const VerificationMeta _duePaiseMeta = const VerificationMeta(
    'duePaise',
  );
  @override
  late final GeneratedColumn<int> duePaise = GeneratedColumn<int>(
    'due_paise',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _interStateMeta = const VerificationMeta(
    'interState',
  );
  @override
  late final GeneratedColumn<bool> interState = GeneratedColumn<bool>(
    'inter_state',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("inter_state" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _placeOfSupplyMeta = const VerificationMeta(
    'placeOfSupply',
  );
  @override
  late final GeneratedColumn<String> placeOfSupply = GeneratedColumn<String>(
    'place_of_supply',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _buyerGstinMeta = const VerificationMeta(
    'buyerGstin',
  );
  @override
  late final GeneratedColumn<String> buyerGstin = GeneratedColumn<String>(
    'buyer_gstin',
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
    partyId,
    duePaise,
    interState,
    placeOfSupply,
    buyerGstin,
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
    if (data.containsKey('party_id')) {
      context.handle(
        _partyIdMeta,
        partyId.isAcceptableOrUnknown(data['party_id']!, _partyIdMeta),
      );
    }
    if (data.containsKey('due_paise')) {
      context.handle(
        _duePaiseMeta,
        duePaise.isAcceptableOrUnknown(data['due_paise']!, _duePaiseMeta),
      );
    }
    if (data.containsKey('inter_state')) {
      context.handle(
        _interStateMeta,
        interState.isAcceptableOrUnknown(data['inter_state']!, _interStateMeta),
      );
    }
    if (data.containsKey('place_of_supply')) {
      context.handle(
        _placeOfSupplyMeta,
        placeOfSupply.isAcceptableOrUnknown(
          data['place_of_supply']!,
          _placeOfSupplyMeta,
        ),
      );
    }
    if (data.containsKey('buyer_gstin')) {
      context.handle(
        _buyerGstinMeta,
        buyerGstin.isAcceptableOrUnknown(data['buyer_gstin']!, _buyerGstinMeta),
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
      partyId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}party_id'],
      ),
      duePaise: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}due_paise'],
      )!,
      interState: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}inter_state'],
      )!,
      placeOfSupply: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}place_of_supply'],
      ),
      buyerGstin: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}buyer_gstin'],
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

  /// The customer, when one was chosen (always for credit sales).
  final int? partyId;

  /// Part of the total left to pay later (credit). 0 for paid bills.
  final int duePaise;

  /// Customer's state differs from the shop's: IGST instead of CGST+SGST.
  final bool interState;

  /// Place of supply (GST state code) when it isn't the shop's state.
  final String? placeOfSupply;

  /// Buyer's GSTIN: makes this a B2B invoice.
  final String? buyerGstin;
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
    this.partyId,
    required this.duePaise,
    required this.interState,
    this.placeOfSupply,
    this.buyerGstin,
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
    if (!nullToAbsent || partyId != null) {
      map['party_id'] = Variable<int>(partyId);
    }
    map['due_paise'] = Variable<int>(duePaise);
    map['inter_state'] = Variable<bool>(interState);
    if (!nullToAbsent || placeOfSupply != null) {
      map['place_of_supply'] = Variable<String>(placeOfSupply);
    }
    if (!nullToAbsent || buyerGstin != null) {
      map['buyer_gstin'] = Variable<String>(buyerGstin);
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
      partyId: partyId == null && nullToAbsent
          ? const Value.absent()
          : Value(partyId),
      duePaise: Value(duePaise),
      interState: Value(interState),
      placeOfSupply: placeOfSupply == null && nullToAbsent
          ? const Value.absent()
          : Value(placeOfSupply),
      buyerGstin: buyerGstin == null && nullToAbsent
          ? const Value.absent()
          : Value(buyerGstin),
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
      partyId: serializer.fromJson<int?>(json['partyId']),
      duePaise: serializer.fromJson<int>(json['duePaise']),
      interState: serializer.fromJson<bool>(json['interState']),
      placeOfSupply: serializer.fromJson<String?>(json['placeOfSupply']),
      buyerGstin: serializer.fromJson<String?>(json['buyerGstin']),
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
      'partyId': serializer.toJson<int?>(partyId),
      'duePaise': serializer.toJson<int>(duePaise),
      'interState': serializer.toJson<bool>(interState),
      'placeOfSupply': serializer.toJson<String?>(placeOfSupply),
      'buyerGstin': serializer.toJson<String?>(buyerGstin),
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
    Value<int?> partyId = const Value.absent(),
    int? duePaise,
    bool? interState,
    Value<String?> placeOfSupply = const Value.absent(),
    Value<String?> buyerGstin = const Value.absent(),
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
    partyId: partyId.present ? partyId.value : this.partyId,
    duePaise: duePaise ?? this.duePaise,
    interState: interState ?? this.interState,
    placeOfSupply: placeOfSupply.present
        ? placeOfSupply.value
        : this.placeOfSupply,
    buyerGstin: buyerGstin.present ? buyerGstin.value : this.buyerGstin,
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
      partyId: data.partyId.present ? data.partyId.value : this.partyId,
      duePaise: data.duePaise.present ? data.duePaise.value : this.duePaise,
      interState: data.interState.present
          ? data.interState.value
          : this.interState,
      placeOfSupply: data.placeOfSupply.present
          ? data.placeOfSupply.value
          : this.placeOfSupply,
      buyerGstin: data.buyerGstin.present
          ? data.buyerGstin.value
          : this.buyerGstin,
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
          ..write('cancelReason: $cancelReason, ')
          ..write('partyId: $partyId, ')
          ..write('duePaise: $duePaise, ')
          ..write('interState: $interState, ')
          ..write('placeOfSupply: $placeOfSupply, ')
          ..write('buyerGstin: $buyerGstin')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
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
    partyId,
    duePaise,
    interState,
    placeOfSupply,
    buyerGstin,
  ]);
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
          other.cancelReason == this.cancelReason &&
          other.partyId == this.partyId &&
          other.duePaise == this.duePaise &&
          other.interState == this.interState &&
          other.placeOfSupply == this.placeOfSupply &&
          other.buyerGstin == this.buyerGstin);
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
  final Value<int?> partyId;
  final Value<int> duePaise;
  final Value<bool> interState;
  final Value<String?> placeOfSupply;
  final Value<String?> buyerGstin;
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
    this.partyId = const Value.absent(),
    this.duePaise = const Value.absent(),
    this.interState = const Value.absent(),
    this.placeOfSupply = const Value.absent(),
    this.buyerGstin = const Value.absent(),
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
    this.partyId = const Value.absent(),
    this.duePaise = const Value.absent(),
    this.interState = const Value.absent(),
    this.placeOfSupply = const Value.absent(),
    this.buyerGstin = const Value.absent(),
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
    Expression<int>? partyId,
    Expression<int>? duePaise,
    Expression<bool>? interState,
    Expression<String>? placeOfSupply,
    Expression<String>? buyerGstin,
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
      if (partyId != null) 'party_id': partyId,
      if (duePaise != null) 'due_paise': duePaise,
      if (interState != null) 'inter_state': interState,
      if (placeOfSupply != null) 'place_of_supply': placeOfSupply,
      if (buyerGstin != null) 'buyer_gstin': buyerGstin,
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
    Value<int?>? partyId,
    Value<int>? duePaise,
    Value<bool>? interState,
    Value<String?>? placeOfSupply,
    Value<String?>? buyerGstin,
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
      partyId: partyId ?? this.partyId,
      duePaise: duePaise ?? this.duePaise,
      interState: interState ?? this.interState,
      placeOfSupply: placeOfSupply ?? this.placeOfSupply,
      buyerGstin: buyerGstin ?? this.buyerGstin,
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
    if (partyId.present) {
      map['party_id'] = Variable<int>(partyId.value);
    }
    if (duePaise.present) {
      map['due_paise'] = Variable<int>(duePaise.value);
    }
    if (interState.present) {
      map['inter_state'] = Variable<bool>(interState.value);
    }
    if (placeOfSupply.present) {
      map['place_of_supply'] = Variable<String>(placeOfSupply.value);
    }
    if (buyerGstin.present) {
      map['buyer_gstin'] = Variable<String>(buyerGstin.value);
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
          ..write('cancelReason: $cancelReason, ')
          ..write('partyId: $partyId, ')
          ..write('duePaise: $duePaise, ')
          ..write('interState: $interState, ')
          ..write('placeOfSupply: $placeOfSupply, ')
          ..write('buyerGstin: $buyerGstin')
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
  static const VerificationMeta _unitFactorMilliMeta = const VerificationMeta(
    'unitFactorMilli',
  );
  @override
  late final GeneratedColumn<int> unitFactorMilli = GeneratedColumn<int>(
    'unit_factor_milli',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1000),
  );
  static const VerificationMeta _costPaiseMeta = const VerificationMeta(
    'costPaise',
  );
  @override
  late final GeneratedColumn<int> costPaise = GeneratedColumn<int>(
    'cost_paise',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _returnedMilliMeta = const VerificationMeta(
    'returnedMilli',
  );
  @override
  late final GeneratedColumn<int> returnedMilli = GeneratedColumn<int>(
    'returned_milli',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
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
    unitFactorMilli,
    costPaise,
    returnedMilli,
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
    if (data.containsKey('unit_factor_milli')) {
      context.handle(
        _unitFactorMilliMeta,
        unitFactorMilli.isAcceptableOrUnknown(
          data['unit_factor_milli']!,
          _unitFactorMilliMeta,
        ),
      );
    }
    if (data.containsKey('cost_paise')) {
      context.handle(
        _costPaiseMeta,
        costPaise.isAcceptableOrUnknown(data['cost_paise']!, _costPaiseMeta),
      );
    }
    if (data.containsKey('returned_milli')) {
      context.handle(
        _returnedMilliMeta,
        returnedMilli.isAcceptableOrUnknown(
          data['returned_milli']!,
          _returnedMilliMeta,
        ),
      );
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
      unitFactorMilli: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}unit_factor_milli'],
      )!,
      costPaise: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cost_paise'],
      ),
      returnedMilli: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}returned_milli'],
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

  /// Base units per sold unit: 1000 normally, 12000 when a "box" of 12 pcs
  /// was sold. Stock moved = quantity × factor.
  final int unitFactorMilli;

  /// Cost of what this line sold (before GST), for profit. Null when the
  /// item had no cost price.
  final int? costPaise;

  /// How much of [quantityMilli] has been returned on credit notes.
  final int returnedMilli;
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
    required this.unitFactorMilli,
    this.costPaise,
    required this.returnedMilli,
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
    map['unit_factor_milli'] = Variable<int>(unitFactorMilli);
    if (!nullToAbsent || costPaise != null) {
      map['cost_paise'] = Variable<int>(costPaise);
    }
    map['returned_milli'] = Variable<int>(returnedMilli);
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
      unitFactorMilli: Value(unitFactorMilli),
      costPaise: costPaise == null && nullToAbsent
          ? const Value.absent()
          : Value(costPaise),
      returnedMilli: Value(returnedMilli),
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
      unitFactorMilli: serializer.fromJson<int>(json['unitFactorMilli']),
      costPaise: serializer.fromJson<int?>(json['costPaise']),
      returnedMilli: serializer.fromJson<int>(json['returnedMilli']),
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
      'unitFactorMilli': serializer.toJson<int>(unitFactorMilli),
      'costPaise': serializer.toJson<int?>(costPaise),
      'returnedMilli': serializer.toJson<int>(returnedMilli),
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
    int? unitFactorMilli,
    Value<int?> costPaise = const Value.absent(),
    int? returnedMilli,
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
    unitFactorMilli: unitFactorMilli ?? this.unitFactorMilli,
    costPaise: costPaise.present ? costPaise.value : this.costPaise,
    returnedMilli: returnedMilli ?? this.returnedMilli,
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
      unitFactorMilli: data.unitFactorMilli.present
          ? data.unitFactorMilli.value
          : this.unitFactorMilli,
      costPaise: data.costPaise.present ? data.costPaise.value : this.costPaise,
      returnedMilli: data.returnedMilli.present
          ? data.returnedMilli.value
          : this.returnedMilli,
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
          ..write('totalPaise: $totalPaise, ')
          ..write('unitFactorMilli: $unitFactorMilli, ')
          ..write('costPaise: $costPaise, ')
          ..write('returnedMilli: $returnedMilli')
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
    unitFactorMilli,
    costPaise,
    returnedMilli,
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
          other.totalPaise == this.totalPaise &&
          other.unitFactorMilli == this.unitFactorMilli &&
          other.costPaise == this.costPaise &&
          other.returnedMilli == this.returnedMilli);
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
  final Value<int> unitFactorMilli;
  final Value<int?> costPaise;
  final Value<int> returnedMilli;
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
    this.unitFactorMilli = const Value.absent(),
    this.costPaise = const Value.absent(),
    this.returnedMilli = const Value.absent(),
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
    this.unitFactorMilli = const Value.absent(),
    this.costPaise = const Value.absent(),
    this.returnedMilli = const Value.absent(),
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
    Expression<int>? unitFactorMilli,
    Expression<int>? costPaise,
    Expression<int>? returnedMilli,
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
      if (unitFactorMilli != null) 'unit_factor_milli': unitFactorMilli,
      if (costPaise != null) 'cost_paise': costPaise,
      if (returnedMilli != null) 'returned_milli': returnedMilli,
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
    Value<int>? unitFactorMilli,
    Value<int?>? costPaise,
    Value<int>? returnedMilli,
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
      unitFactorMilli: unitFactorMilli ?? this.unitFactorMilli,
      costPaise: costPaise ?? this.costPaise,
      returnedMilli: returnedMilli ?? this.returnedMilli,
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
    if (unitFactorMilli.present) {
      map['unit_factor_milli'] = Variable<int>(unitFactorMilli.value);
    }
    if (costPaise.present) {
      map['cost_paise'] = Variable<int>(costPaise.value);
    }
    if (returnedMilli.present) {
      map['returned_milli'] = Variable<int>(returnedMilli.value);
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
          ..write('totalPaise: $totalPaise, ')
          ..write('unitFactorMilli: $unitFactorMilli, ')
          ..write('costPaise: $costPaise, ')
          ..write('returnedMilli: $returnedMilli')
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

class $ItemBatchesTable extends ItemBatches
    with TableInfo<$ItemBatchesTable, BatchRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ItemBatchesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _itemIdMeta = const VerificationMeta('itemId');
  @override
  late final GeneratedColumn<int> itemId = GeneratedColumn<int>(
    'item_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES items (id)',
    ),
  );
  static const VerificationMeta _batchNoMeta = const VerificationMeta(
    'batchNo',
  );
  @override
  late final GeneratedColumn<String> batchNo = GeneratedColumn<String>(
    'batch_no',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _expiryMeta = const VerificationMeta('expiry');
  @override
  late final GeneratedColumn<DateTime> expiry = GeneratedColumn<DateTime>(
    'expiry',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
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
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
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
  @override
  List<GeneratedColumn> get $columns => [
    id,
    itemId,
    batchNo,
    expiry,
    quantityMilli,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'item_batches';
  @override
  VerificationContext validateIntegrity(
    Insertable<BatchRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('item_id')) {
      context.handle(
        _itemIdMeta,
        itemId.isAcceptableOrUnknown(data['item_id']!, _itemIdMeta),
      );
    } else if (isInserting) {
      context.missing(_itemIdMeta);
    }
    if (data.containsKey('batch_no')) {
      context.handle(
        _batchNoMeta,
        batchNo.isAcceptableOrUnknown(data['batch_no']!, _batchNoMeta),
      );
    } else if (isInserting) {
      context.missing(_batchNoMeta);
    }
    if (data.containsKey('expiry')) {
      context.handle(
        _expiryMeta,
        expiry.isAcceptableOrUnknown(data['expiry']!, _expiryMeta),
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
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {itemId, batchNo},
  ];
  @override
  BatchRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BatchRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      itemId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}item_id'],
      )!,
      batchNo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}batch_no'],
      )!,
      expiry: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}expiry'],
      ),
      quantityMilli: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quantity_milli'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ItemBatchesTable createAlias(String alias) {
    return $ItemBatchesTable(attachedDatabase, alias);
  }
}

class BatchRow extends DataClass implements Insertable<BatchRow> {
  final int id;
  final int itemId;
  final String batchNo;
  final DateTime? expiry;
  final int quantityMilli;
  final DateTime createdAt;
  const BatchRow({
    required this.id,
    required this.itemId,
    required this.batchNo,
    this.expiry,
    required this.quantityMilli,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['item_id'] = Variable<int>(itemId);
    map['batch_no'] = Variable<String>(batchNo);
    if (!nullToAbsent || expiry != null) {
      map['expiry'] = Variable<DateTime>(expiry);
    }
    map['quantity_milli'] = Variable<int>(quantityMilli);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ItemBatchesCompanion toCompanion(bool nullToAbsent) {
    return ItemBatchesCompanion(
      id: Value(id),
      itemId: Value(itemId),
      batchNo: Value(batchNo),
      expiry: expiry == null && nullToAbsent
          ? const Value.absent()
          : Value(expiry),
      quantityMilli: Value(quantityMilli),
      createdAt: Value(createdAt),
    );
  }

  factory BatchRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BatchRow(
      id: serializer.fromJson<int>(json['id']),
      itemId: serializer.fromJson<int>(json['itemId']),
      batchNo: serializer.fromJson<String>(json['batchNo']),
      expiry: serializer.fromJson<DateTime?>(json['expiry']),
      quantityMilli: serializer.fromJson<int>(json['quantityMilli']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'itemId': serializer.toJson<int>(itemId),
      'batchNo': serializer.toJson<String>(batchNo),
      'expiry': serializer.toJson<DateTime?>(expiry),
      'quantityMilli': serializer.toJson<int>(quantityMilli),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  BatchRow copyWith({
    int? id,
    int? itemId,
    String? batchNo,
    Value<DateTime?> expiry = const Value.absent(),
    int? quantityMilli,
    DateTime? createdAt,
  }) => BatchRow(
    id: id ?? this.id,
    itemId: itemId ?? this.itemId,
    batchNo: batchNo ?? this.batchNo,
    expiry: expiry.present ? expiry.value : this.expiry,
    quantityMilli: quantityMilli ?? this.quantityMilli,
    createdAt: createdAt ?? this.createdAt,
  );
  BatchRow copyWithCompanion(ItemBatchesCompanion data) {
    return BatchRow(
      id: data.id.present ? data.id.value : this.id,
      itemId: data.itemId.present ? data.itemId.value : this.itemId,
      batchNo: data.batchNo.present ? data.batchNo.value : this.batchNo,
      expiry: data.expiry.present ? data.expiry.value : this.expiry,
      quantityMilli: data.quantityMilli.present
          ? data.quantityMilli.value
          : this.quantityMilli,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BatchRow(')
          ..write('id: $id, ')
          ..write('itemId: $itemId, ')
          ..write('batchNo: $batchNo, ')
          ..write('expiry: $expiry, ')
          ..write('quantityMilli: $quantityMilli, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, itemId, batchNo, expiry, quantityMilli, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BatchRow &&
          other.id == this.id &&
          other.itemId == this.itemId &&
          other.batchNo == this.batchNo &&
          other.expiry == this.expiry &&
          other.quantityMilli == this.quantityMilli &&
          other.createdAt == this.createdAt);
}

class ItemBatchesCompanion extends UpdateCompanion<BatchRow> {
  final Value<int> id;
  final Value<int> itemId;
  final Value<String> batchNo;
  final Value<DateTime?> expiry;
  final Value<int> quantityMilli;
  final Value<DateTime> createdAt;
  const ItemBatchesCompanion({
    this.id = const Value.absent(),
    this.itemId = const Value.absent(),
    this.batchNo = const Value.absent(),
    this.expiry = const Value.absent(),
    this.quantityMilli = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  ItemBatchesCompanion.insert({
    this.id = const Value.absent(),
    required int itemId,
    required String batchNo,
    this.expiry = const Value.absent(),
    this.quantityMilli = const Value.absent(),
    required DateTime createdAt,
  }) : itemId = Value(itemId),
       batchNo = Value(batchNo),
       createdAt = Value(createdAt);
  static Insertable<BatchRow> custom({
    Expression<int>? id,
    Expression<int>? itemId,
    Expression<String>? batchNo,
    Expression<DateTime>? expiry,
    Expression<int>? quantityMilli,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (itemId != null) 'item_id': itemId,
      if (batchNo != null) 'batch_no': batchNo,
      if (expiry != null) 'expiry': expiry,
      if (quantityMilli != null) 'quantity_milli': quantityMilli,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  ItemBatchesCompanion copyWith({
    Value<int>? id,
    Value<int>? itemId,
    Value<String>? batchNo,
    Value<DateTime?>? expiry,
    Value<int>? quantityMilli,
    Value<DateTime>? createdAt,
  }) {
    return ItemBatchesCompanion(
      id: id ?? this.id,
      itemId: itemId ?? this.itemId,
      batchNo: batchNo ?? this.batchNo,
      expiry: expiry ?? this.expiry,
      quantityMilli: quantityMilli ?? this.quantityMilli,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (itemId.present) {
      map['item_id'] = Variable<int>(itemId.value);
    }
    if (batchNo.present) {
      map['batch_no'] = Variable<String>(batchNo.value);
    }
    if (expiry.present) {
      map['expiry'] = Variable<DateTime>(expiry.value);
    }
    if (quantityMilli.present) {
      map['quantity_milli'] = Variable<int>(quantityMilli.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ItemBatchesCompanion(')
          ..write('id: $id, ')
          ..write('itemId: $itemId, ')
          ..write('batchNo: $batchNo, ')
          ..write('expiry: $expiry, ')
          ..write('quantityMilli: $quantityMilli, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $StockMovementsTable extends StockMovements
    with TableInfo<$StockMovementsTable, MovementRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StockMovementsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _itemIdMeta = const VerificationMeta('itemId');
  @override
  late final GeneratedColumn<int> itemId = GeneratedColumn<int>(
    'item_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES items (id)',
    ),
  );
  static const VerificationMeta _batchIdMeta = const VerificationMeta(
    'batchId',
  );
  @override
  late final GeneratedColumn<int> batchId = GeneratedColumn<int>(
    'batch_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES item_batches (id)',
    ),
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
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _billIdMeta = const VerificationMeta('billId');
  @override
  late final GeneratedColumn<int> billId = GeneratedColumn<int>(
    'bill_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES bills (id)',
    ),
  );
  static const VerificationMeta _balanceAfterMilliMeta = const VerificationMeta(
    'balanceAfterMilli',
  );
  @override
  late final GeneratedColumn<int> balanceAfterMilli = GeneratedColumn<int>(
    'balance_after_milli',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _atMeta = const VerificationMeta('at');
  @override
  late final GeneratedColumn<DateTime> at = GeneratedColumn<DateTime>(
    'at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    itemId,
    batchId,
    quantityMilli,
    type,
    note,
    billId,
    balanceAfterMilli,
    at,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'stock_movements';
  @override
  VerificationContext validateIntegrity(
    Insertable<MovementRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('item_id')) {
      context.handle(
        _itemIdMeta,
        itemId.isAcceptableOrUnknown(data['item_id']!, _itemIdMeta),
      );
    } else if (isInserting) {
      context.missing(_itemIdMeta);
    }
    if (data.containsKey('batch_id')) {
      context.handle(
        _batchIdMeta,
        batchId.isAcceptableOrUnknown(data['batch_id']!, _batchIdMeta),
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
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('bill_id')) {
      context.handle(
        _billIdMeta,
        billId.isAcceptableOrUnknown(data['bill_id']!, _billIdMeta),
      );
    }
    if (data.containsKey('balance_after_milli')) {
      context.handle(
        _balanceAfterMilliMeta,
        balanceAfterMilli.isAcceptableOrUnknown(
          data['balance_after_milli']!,
          _balanceAfterMilliMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_balanceAfterMilliMeta);
    }
    if (data.containsKey('at')) {
      context.handle(_atMeta, at.isAcceptableOrUnknown(data['at']!, _atMeta));
    } else if (isInserting) {
      context.missing(_atMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MovementRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MovementRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      itemId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}item_id'],
      )!,
      batchId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}batch_id'],
      ),
      quantityMilli: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quantity_milli'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      billId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}bill_id'],
      ),
      balanceAfterMilli: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}balance_after_milli'],
      )!,
      at: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}at'],
      )!,
    );
  }

  @override
  $StockMovementsTable createAlias(String alias) {
    return $StockMovementsTable(attachedDatabase, alias);
  }
}

class MovementRow extends DataClass implements Insertable<MovementRow> {
  final int id;
  final int itemId;
  final int? batchId;

  /// Signed, in base units: + stock in, − stock out.
  final int quantityMilli;

  /// `opening`, `stockIn`, `sale`, `cancel`, `adjust`.
  final String type;
  final String? note;
  final int? billId;

  /// Item stock right after this movement.
  final int balanceAfterMilli;
  final DateTime at;
  const MovementRow({
    required this.id,
    required this.itemId,
    this.batchId,
    required this.quantityMilli,
    required this.type,
    this.note,
    this.billId,
    required this.balanceAfterMilli,
    required this.at,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['item_id'] = Variable<int>(itemId);
    if (!nullToAbsent || batchId != null) {
      map['batch_id'] = Variable<int>(batchId);
    }
    map['quantity_milli'] = Variable<int>(quantityMilli);
    map['type'] = Variable<String>(type);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    if (!nullToAbsent || billId != null) {
      map['bill_id'] = Variable<int>(billId);
    }
    map['balance_after_milli'] = Variable<int>(balanceAfterMilli);
    map['at'] = Variable<DateTime>(at);
    return map;
  }

  StockMovementsCompanion toCompanion(bool nullToAbsent) {
    return StockMovementsCompanion(
      id: Value(id),
      itemId: Value(itemId),
      batchId: batchId == null && nullToAbsent
          ? const Value.absent()
          : Value(batchId),
      quantityMilli: Value(quantityMilli),
      type: Value(type),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      billId: billId == null && nullToAbsent
          ? const Value.absent()
          : Value(billId),
      balanceAfterMilli: Value(balanceAfterMilli),
      at: Value(at),
    );
  }

  factory MovementRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MovementRow(
      id: serializer.fromJson<int>(json['id']),
      itemId: serializer.fromJson<int>(json['itemId']),
      batchId: serializer.fromJson<int?>(json['batchId']),
      quantityMilli: serializer.fromJson<int>(json['quantityMilli']),
      type: serializer.fromJson<String>(json['type']),
      note: serializer.fromJson<String?>(json['note']),
      billId: serializer.fromJson<int?>(json['billId']),
      balanceAfterMilli: serializer.fromJson<int>(json['balanceAfterMilli']),
      at: serializer.fromJson<DateTime>(json['at']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'itemId': serializer.toJson<int>(itemId),
      'batchId': serializer.toJson<int?>(batchId),
      'quantityMilli': serializer.toJson<int>(quantityMilli),
      'type': serializer.toJson<String>(type),
      'note': serializer.toJson<String?>(note),
      'billId': serializer.toJson<int?>(billId),
      'balanceAfterMilli': serializer.toJson<int>(balanceAfterMilli),
      'at': serializer.toJson<DateTime>(at),
    };
  }

  MovementRow copyWith({
    int? id,
    int? itemId,
    Value<int?> batchId = const Value.absent(),
    int? quantityMilli,
    String? type,
    Value<String?> note = const Value.absent(),
    Value<int?> billId = const Value.absent(),
    int? balanceAfterMilli,
    DateTime? at,
  }) => MovementRow(
    id: id ?? this.id,
    itemId: itemId ?? this.itemId,
    batchId: batchId.present ? batchId.value : this.batchId,
    quantityMilli: quantityMilli ?? this.quantityMilli,
    type: type ?? this.type,
    note: note.present ? note.value : this.note,
    billId: billId.present ? billId.value : this.billId,
    balanceAfterMilli: balanceAfterMilli ?? this.balanceAfterMilli,
    at: at ?? this.at,
  );
  MovementRow copyWithCompanion(StockMovementsCompanion data) {
    return MovementRow(
      id: data.id.present ? data.id.value : this.id,
      itemId: data.itemId.present ? data.itemId.value : this.itemId,
      batchId: data.batchId.present ? data.batchId.value : this.batchId,
      quantityMilli: data.quantityMilli.present
          ? data.quantityMilli.value
          : this.quantityMilli,
      type: data.type.present ? data.type.value : this.type,
      note: data.note.present ? data.note.value : this.note,
      billId: data.billId.present ? data.billId.value : this.billId,
      balanceAfterMilli: data.balanceAfterMilli.present
          ? data.balanceAfterMilli.value
          : this.balanceAfterMilli,
      at: data.at.present ? data.at.value : this.at,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MovementRow(')
          ..write('id: $id, ')
          ..write('itemId: $itemId, ')
          ..write('batchId: $batchId, ')
          ..write('quantityMilli: $quantityMilli, ')
          ..write('type: $type, ')
          ..write('note: $note, ')
          ..write('billId: $billId, ')
          ..write('balanceAfterMilli: $balanceAfterMilli, ')
          ..write('at: $at')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    itemId,
    batchId,
    quantityMilli,
    type,
    note,
    billId,
    balanceAfterMilli,
    at,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MovementRow &&
          other.id == this.id &&
          other.itemId == this.itemId &&
          other.batchId == this.batchId &&
          other.quantityMilli == this.quantityMilli &&
          other.type == this.type &&
          other.note == this.note &&
          other.billId == this.billId &&
          other.balanceAfterMilli == this.balanceAfterMilli &&
          other.at == this.at);
}

class StockMovementsCompanion extends UpdateCompanion<MovementRow> {
  final Value<int> id;
  final Value<int> itemId;
  final Value<int?> batchId;
  final Value<int> quantityMilli;
  final Value<String> type;
  final Value<String?> note;
  final Value<int?> billId;
  final Value<int> balanceAfterMilli;
  final Value<DateTime> at;
  const StockMovementsCompanion({
    this.id = const Value.absent(),
    this.itemId = const Value.absent(),
    this.batchId = const Value.absent(),
    this.quantityMilli = const Value.absent(),
    this.type = const Value.absent(),
    this.note = const Value.absent(),
    this.billId = const Value.absent(),
    this.balanceAfterMilli = const Value.absent(),
    this.at = const Value.absent(),
  });
  StockMovementsCompanion.insert({
    this.id = const Value.absent(),
    required int itemId,
    this.batchId = const Value.absent(),
    required int quantityMilli,
    required String type,
    this.note = const Value.absent(),
    this.billId = const Value.absent(),
    required int balanceAfterMilli,
    required DateTime at,
  }) : itemId = Value(itemId),
       quantityMilli = Value(quantityMilli),
       type = Value(type),
       balanceAfterMilli = Value(balanceAfterMilli),
       at = Value(at);
  static Insertable<MovementRow> custom({
    Expression<int>? id,
    Expression<int>? itemId,
    Expression<int>? batchId,
    Expression<int>? quantityMilli,
    Expression<String>? type,
    Expression<String>? note,
    Expression<int>? billId,
    Expression<int>? balanceAfterMilli,
    Expression<DateTime>? at,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (itemId != null) 'item_id': itemId,
      if (batchId != null) 'batch_id': batchId,
      if (quantityMilli != null) 'quantity_milli': quantityMilli,
      if (type != null) 'type': type,
      if (note != null) 'note': note,
      if (billId != null) 'bill_id': billId,
      if (balanceAfterMilli != null) 'balance_after_milli': balanceAfterMilli,
      if (at != null) 'at': at,
    });
  }

  StockMovementsCompanion copyWith({
    Value<int>? id,
    Value<int>? itemId,
    Value<int?>? batchId,
    Value<int>? quantityMilli,
    Value<String>? type,
    Value<String?>? note,
    Value<int?>? billId,
    Value<int>? balanceAfterMilli,
    Value<DateTime>? at,
  }) {
    return StockMovementsCompanion(
      id: id ?? this.id,
      itemId: itemId ?? this.itemId,
      batchId: batchId ?? this.batchId,
      quantityMilli: quantityMilli ?? this.quantityMilli,
      type: type ?? this.type,
      note: note ?? this.note,
      billId: billId ?? this.billId,
      balanceAfterMilli: balanceAfterMilli ?? this.balanceAfterMilli,
      at: at ?? this.at,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (itemId.present) {
      map['item_id'] = Variable<int>(itemId.value);
    }
    if (batchId.present) {
      map['batch_id'] = Variable<int>(batchId.value);
    }
    if (quantityMilli.present) {
      map['quantity_milli'] = Variable<int>(quantityMilli.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (billId.present) {
      map['bill_id'] = Variable<int>(billId.value);
    }
    if (balanceAfterMilli.present) {
      map['balance_after_milli'] = Variable<int>(balanceAfterMilli.value);
    }
    if (at.present) {
      map['at'] = Variable<DateTime>(at.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StockMovementsCompanion(')
          ..write('id: $id, ')
          ..write('itemId: $itemId, ')
          ..write('batchId: $batchId, ')
          ..write('quantityMilli: $quantityMilli, ')
          ..write('type: $type, ')
          ..write('note: $note, ')
          ..write('billId: $billId, ')
          ..write('balanceAfterMilli: $balanceAfterMilli, ')
          ..write('at: $at')
          ..write(')'))
        .toString();
  }
}

class $PartyEntriesTable extends PartyEntries
    with TableInfo<$PartyEntriesTable, PartyEntryRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PartyEntriesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _partyIdMeta = const VerificationMeta(
    'partyId',
  );
  @override
  late final GeneratedColumn<int> partyId = GeneratedColumn<int>(
    'party_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES parties (id)',
    ),
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountPaiseMeta = const VerificationMeta(
    'amountPaise',
  );
  @override
  late final GeneratedColumn<int> amountPaise = GeneratedColumn<int>(
    'amount_paise',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _billIdMeta = const VerificationMeta('billId');
  @override
  late final GeneratedColumn<int> billId = GeneratedColumn<int>(
    'bill_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES bills (id)',
    ),
  );
  static const VerificationMeta _paymentModeMeta = const VerificationMeta(
    'paymentMode',
  );
  @override
  late final GeneratedColumn<String> paymentMode = GeneratedColumn<String>(
    'payment_mode',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _balanceAfterPaiseMeta = const VerificationMeta(
    'balanceAfterPaise',
  );
  @override
  late final GeneratedColumn<int> balanceAfterPaise = GeneratedColumn<int>(
    'balance_after_paise',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _atMeta = const VerificationMeta('at');
  @override
  late final GeneratedColumn<DateTime> at = GeneratedColumn<DateTime>(
    'at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    partyId,
    type,
    amountPaise,
    billId,
    paymentMode,
    note,
    balanceAfterPaise,
    at,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'party_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<PartyEntryRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('party_id')) {
      context.handle(
        _partyIdMeta,
        partyId.isAcceptableOrUnknown(data['party_id']!, _partyIdMeta),
      );
    } else if (isInserting) {
      context.missing(_partyIdMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('amount_paise')) {
      context.handle(
        _amountPaiseMeta,
        amountPaise.isAcceptableOrUnknown(
          data['amount_paise']!,
          _amountPaiseMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountPaiseMeta);
    }
    if (data.containsKey('bill_id')) {
      context.handle(
        _billIdMeta,
        billId.isAcceptableOrUnknown(data['bill_id']!, _billIdMeta),
      );
    }
    if (data.containsKey('payment_mode')) {
      context.handle(
        _paymentModeMeta,
        paymentMode.isAcceptableOrUnknown(
          data['payment_mode']!,
          _paymentModeMeta,
        ),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('balance_after_paise')) {
      context.handle(
        _balanceAfterPaiseMeta,
        balanceAfterPaise.isAcceptableOrUnknown(
          data['balance_after_paise']!,
          _balanceAfterPaiseMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_balanceAfterPaiseMeta);
    }
    if (data.containsKey('at')) {
      context.handle(_atMeta, at.isAcceptableOrUnknown(data['at']!, _atMeta));
    } else if (isInserting) {
      context.missing(_atMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PartyEntryRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PartyEntryRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      partyId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}party_id'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      amountPaise: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_paise'],
      )!,
      billId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}bill_id'],
      ),
      paymentMode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payment_mode'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      balanceAfterPaise: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}balance_after_paise'],
      )!,
      at: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}at'],
      )!,
    );
  }

  @override
  $PartyEntriesTable createAlias(String alias) {
    return $PartyEntriesTable(attachedDatabase, alias);
  }
}

class PartyEntryRow extends DataClass implements Insertable<PartyEntryRow> {
  final int id;
  final int partyId;

  /// `opening`, `sale`, `payment`, `cancel`, `adjust`.
  final String type;

  /// Signed: + they owe more (credit sale), − they paid.
  final int amountPaise;
  final int? billId;

  /// For payments: `cash`, `upi`, `card`.
  final String? paymentMode;
  final String? note;
  final int balanceAfterPaise;
  final DateTime at;
  const PartyEntryRow({
    required this.id,
    required this.partyId,
    required this.type,
    required this.amountPaise,
    this.billId,
    this.paymentMode,
    this.note,
    required this.balanceAfterPaise,
    required this.at,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['party_id'] = Variable<int>(partyId);
    map['type'] = Variable<String>(type);
    map['amount_paise'] = Variable<int>(amountPaise);
    if (!nullToAbsent || billId != null) {
      map['bill_id'] = Variable<int>(billId);
    }
    if (!nullToAbsent || paymentMode != null) {
      map['payment_mode'] = Variable<String>(paymentMode);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['balance_after_paise'] = Variable<int>(balanceAfterPaise);
    map['at'] = Variable<DateTime>(at);
    return map;
  }

  PartyEntriesCompanion toCompanion(bool nullToAbsent) {
    return PartyEntriesCompanion(
      id: Value(id),
      partyId: Value(partyId),
      type: Value(type),
      amountPaise: Value(amountPaise),
      billId: billId == null && nullToAbsent
          ? const Value.absent()
          : Value(billId),
      paymentMode: paymentMode == null && nullToAbsent
          ? const Value.absent()
          : Value(paymentMode),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      balanceAfterPaise: Value(balanceAfterPaise),
      at: Value(at),
    );
  }

  factory PartyEntryRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PartyEntryRow(
      id: serializer.fromJson<int>(json['id']),
      partyId: serializer.fromJson<int>(json['partyId']),
      type: serializer.fromJson<String>(json['type']),
      amountPaise: serializer.fromJson<int>(json['amountPaise']),
      billId: serializer.fromJson<int?>(json['billId']),
      paymentMode: serializer.fromJson<String?>(json['paymentMode']),
      note: serializer.fromJson<String?>(json['note']),
      balanceAfterPaise: serializer.fromJson<int>(json['balanceAfterPaise']),
      at: serializer.fromJson<DateTime>(json['at']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'partyId': serializer.toJson<int>(partyId),
      'type': serializer.toJson<String>(type),
      'amountPaise': serializer.toJson<int>(amountPaise),
      'billId': serializer.toJson<int?>(billId),
      'paymentMode': serializer.toJson<String?>(paymentMode),
      'note': serializer.toJson<String?>(note),
      'balanceAfterPaise': serializer.toJson<int>(balanceAfterPaise),
      'at': serializer.toJson<DateTime>(at),
    };
  }

  PartyEntryRow copyWith({
    int? id,
    int? partyId,
    String? type,
    int? amountPaise,
    Value<int?> billId = const Value.absent(),
    Value<String?> paymentMode = const Value.absent(),
    Value<String?> note = const Value.absent(),
    int? balanceAfterPaise,
    DateTime? at,
  }) => PartyEntryRow(
    id: id ?? this.id,
    partyId: partyId ?? this.partyId,
    type: type ?? this.type,
    amountPaise: amountPaise ?? this.amountPaise,
    billId: billId.present ? billId.value : this.billId,
    paymentMode: paymentMode.present ? paymentMode.value : this.paymentMode,
    note: note.present ? note.value : this.note,
    balanceAfterPaise: balanceAfterPaise ?? this.balanceAfterPaise,
    at: at ?? this.at,
  );
  PartyEntryRow copyWithCompanion(PartyEntriesCompanion data) {
    return PartyEntryRow(
      id: data.id.present ? data.id.value : this.id,
      partyId: data.partyId.present ? data.partyId.value : this.partyId,
      type: data.type.present ? data.type.value : this.type,
      amountPaise: data.amountPaise.present
          ? data.amountPaise.value
          : this.amountPaise,
      billId: data.billId.present ? data.billId.value : this.billId,
      paymentMode: data.paymentMode.present
          ? data.paymentMode.value
          : this.paymentMode,
      note: data.note.present ? data.note.value : this.note,
      balanceAfterPaise: data.balanceAfterPaise.present
          ? data.balanceAfterPaise.value
          : this.balanceAfterPaise,
      at: data.at.present ? data.at.value : this.at,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PartyEntryRow(')
          ..write('id: $id, ')
          ..write('partyId: $partyId, ')
          ..write('type: $type, ')
          ..write('amountPaise: $amountPaise, ')
          ..write('billId: $billId, ')
          ..write('paymentMode: $paymentMode, ')
          ..write('note: $note, ')
          ..write('balanceAfterPaise: $balanceAfterPaise, ')
          ..write('at: $at')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    partyId,
    type,
    amountPaise,
    billId,
    paymentMode,
    note,
    balanceAfterPaise,
    at,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PartyEntryRow &&
          other.id == this.id &&
          other.partyId == this.partyId &&
          other.type == this.type &&
          other.amountPaise == this.amountPaise &&
          other.billId == this.billId &&
          other.paymentMode == this.paymentMode &&
          other.note == this.note &&
          other.balanceAfterPaise == this.balanceAfterPaise &&
          other.at == this.at);
}

class PartyEntriesCompanion extends UpdateCompanion<PartyEntryRow> {
  final Value<int> id;
  final Value<int> partyId;
  final Value<String> type;
  final Value<int> amountPaise;
  final Value<int?> billId;
  final Value<String?> paymentMode;
  final Value<String?> note;
  final Value<int> balanceAfterPaise;
  final Value<DateTime> at;
  const PartyEntriesCompanion({
    this.id = const Value.absent(),
    this.partyId = const Value.absent(),
    this.type = const Value.absent(),
    this.amountPaise = const Value.absent(),
    this.billId = const Value.absent(),
    this.paymentMode = const Value.absent(),
    this.note = const Value.absent(),
    this.balanceAfterPaise = const Value.absent(),
    this.at = const Value.absent(),
  });
  PartyEntriesCompanion.insert({
    this.id = const Value.absent(),
    required int partyId,
    required String type,
    required int amountPaise,
    this.billId = const Value.absent(),
    this.paymentMode = const Value.absent(),
    this.note = const Value.absent(),
    required int balanceAfterPaise,
    required DateTime at,
  }) : partyId = Value(partyId),
       type = Value(type),
       amountPaise = Value(amountPaise),
       balanceAfterPaise = Value(balanceAfterPaise),
       at = Value(at);
  static Insertable<PartyEntryRow> custom({
    Expression<int>? id,
    Expression<int>? partyId,
    Expression<String>? type,
    Expression<int>? amountPaise,
    Expression<int>? billId,
    Expression<String>? paymentMode,
    Expression<String>? note,
    Expression<int>? balanceAfterPaise,
    Expression<DateTime>? at,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (partyId != null) 'party_id': partyId,
      if (type != null) 'type': type,
      if (amountPaise != null) 'amount_paise': amountPaise,
      if (billId != null) 'bill_id': billId,
      if (paymentMode != null) 'payment_mode': paymentMode,
      if (note != null) 'note': note,
      if (balanceAfterPaise != null) 'balance_after_paise': balanceAfterPaise,
      if (at != null) 'at': at,
    });
  }

  PartyEntriesCompanion copyWith({
    Value<int>? id,
    Value<int>? partyId,
    Value<String>? type,
    Value<int>? amountPaise,
    Value<int?>? billId,
    Value<String?>? paymentMode,
    Value<String?>? note,
    Value<int>? balanceAfterPaise,
    Value<DateTime>? at,
  }) {
    return PartyEntriesCompanion(
      id: id ?? this.id,
      partyId: partyId ?? this.partyId,
      type: type ?? this.type,
      amountPaise: amountPaise ?? this.amountPaise,
      billId: billId ?? this.billId,
      paymentMode: paymentMode ?? this.paymentMode,
      note: note ?? this.note,
      balanceAfterPaise: balanceAfterPaise ?? this.balanceAfterPaise,
      at: at ?? this.at,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (partyId.present) {
      map['party_id'] = Variable<int>(partyId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (amountPaise.present) {
      map['amount_paise'] = Variable<int>(amountPaise.value);
    }
    if (billId.present) {
      map['bill_id'] = Variable<int>(billId.value);
    }
    if (paymentMode.present) {
      map['payment_mode'] = Variable<String>(paymentMode.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (balanceAfterPaise.present) {
      map['balance_after_paise'] = Variable<int>(balanceAfterPaise.value);
    }
    if (at.present) {
      map['at'] = Variable<DateTime>(at.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PartyEntriesCompanion(')
          ..write('id: $id, ')
          ..write('partyId: $partyId, ')
          ..write('type: $type, ')
          ..write('amountPaise: $amountPaise, ')
          ..write('billId: $billId, ')
          ..write('paymentMode: $paymentMode, ')
          ..write('note: $note, ')
          ..write('balanceAfterPaise: $balanceAfterPaise, ')
          ..write('at: $at')
          ..write(')'))
        .toString();
  }
}

class $PurchasesTable extends Purchases
    with TableInfo<$PurchasesTable, PurchaseRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PurchasesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _partyIdMeta = const VerificationMeta(
    'partyId',
  );
  @override
  late final GeneratedColumn<int> partyId = GeneratedColumn<int>(
    'party_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES parties (id)',
    ),
  );
  static const VerificationMeta _supplierNameMeta = const VerificationMeta(
    'supplierName',
  );
  @override
  late final GeneratedColumn<String> supplierName = GeneratedColumn<String>(
    'supplier_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _supplierGstinMeta = const VerificationMeta(
    'supplierGstin',
  );
  @override
  late final GeneratedColumn<String> supplierGstin = GeneratedColumn<String>(
    'supplier_gstin',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _supplierInvoiceNoMeta = const VerificationMeta(
    'supplierInvoiceNo',
  );
  @override
  late final GeneratedColumn<String> supplierInvoiceNo =
      GeneratedColumn<String>(
        'supplier_invoice_no',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _purchasedAtMeta = const VerificationMeta(
    'purchasedAt',
  );
  @override
  late final GeneratedColumn<DateTime> purchasedAt = GeneratedColumn<DateTime>(
    'purchased_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _interStateMeta = const VerificationMeta(
    'interState',
  );
  @override
  late final GeneratedColumn<bool> interState = GeneratedColumn<bool>(
    'inter_state',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("inter_state" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
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
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
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
  static const VerificationMeta _duePaiseMeta = const VerificationMeta(
    'duePaise',
  );
  @override
  late final GeneratedColumn<int> duePaise = GeneratedColumn<int>(
    'due_paise',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
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
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
  @override
  List<GeneratedColumn> get $columns => [
    id,
    partyId,
    supplierName,
    supplierGstin,
    supplierInvoiceNo,
    purchasedAt,
    interState,
    taxablePaise,
    taxPaise,
    roundOffPaise,
    totalPaise,
    duePaise,
    paymentMode,
    note,
    status,
    cancelledAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'purchases';
  @override
  VerificationContext validateIntegrity(
    Insertable<PurchaseRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('party_id')) {
      context.handle(
        _partyIdMeta,
        partyId.isAcceptableOrUnknown(data['party_id']!, _partyIdMeta),
      );
    }
    if (data.containsKey('supplier_name')) {
      context.handle(
        _supplierNameMeta,
        supplierName.isAcceptableOrUnknown(
          data['supplier_name']!,
          _supplierNameMeta,
        ),
      );
    }
    if (data.containsKey('supplier_gstin')) {
      context.handle(
        _supplierGstinMeta,
        supplierGstin.isAcceptableOrUnknown(
          data['supplier_gstin']!,
          _supplierGstinMeta,
        ),
      );
    }
    if (data.containsKey('supplier_invoice_no')) {
      context.handle(
        _supplierInvoiceNoMeta,
        supplierInvoiceNo.isAcceptableOrUnknown(
          data['supplier_invoice_no']!,
          _supplierInvoiceNoMeta,
        ),
      );
    }
    if (data.containsKey('purchased_at')) {
      context.handle(
        _purchasedAtMeta,
        purchasedAt.isAcceptableOrUnknown(
          data['purchased_at']!,
          _purchasedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_purchasedAtMeta);
    }
    if (data.containsKey('inter_state')) {
      context.handle(
        _interStateMeta,
        interState.isAcceptableOrUnknown(data['inter_state']!, _interStateMeta),
      );
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
    }
    if (data.containsKey('total_paise')) {
      context.handle(
        _totalPaiseMeta,
        totalPaise.isAcceptableOrUnknown(data['total_paise']!, _totalPaiseMeta),
      );
    } else if (isInserting) {
      context.missing(_totalPaiseMeta);
    }
    if (data.containsKey('due_paise')) {
      context.handle(
        _duePaiseMeta,
        duePaise.isAcceptableOrUnknown(data['due_paise']!, _duePaiseMeta),
      );
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
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
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
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PurchaseRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PurchaseRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      partyId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}party_id'],
      ),
      supplierName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}supplier_name'],
      ),
      supplierGstin: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}supplier_gstin'],
      ),
      supplierInvoiceNo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}supplier_invoice_no'],
      ),
      purchasedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}purchased_at'],
      )!,
      interState: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}inter_state'],
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
      totalPaise: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_paise'],
      )!,
      duePaise: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}due_paise'],
      )!,
      paymentMode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payment_mode'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      cancelledAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}cancelled_at'],
      ),
    );
  }

  @override
  $PurchasesTable createAlias(String alias) {
    return $PurchasesTable(attachedDatabase, alias);
  }
}

class PurchaseRow extends DataClass implements Insertable<PurchaseRow> {
  final int id;
  final int? partyId;
  final String? supplierName;
  final String? supplierGstin;

  /// The supplier's own bill number.
  final String? supplierInvoiceNo;
  final DateTime purchasedAt;
  final bool interState;
  final int taxablePaise;
  final int taxPaise;
  final int roundOffPaise;
  final int totalPaise;

  /// Left to pay the supplier.
  final int duePaise;
  final String paymentMode;
  final String? note;
  final String status;
  final DateTime? cancelledAt;
  const PurchaseRow({
    required this.id,
    this.partyId,
    this.supplierName,
    this.supplierGstin,
    this.supplierInvoiceNo,
    required this.purchasedAt,
    required this.interState,
    required this.taxablePaise,
    required this.taxPaise,
    required this.roundOffPaise,
    required this.totalPaise,
    required this.duePaise,
    required this.paymentMode,
    this.note,
    required this.status,
    this.cancelledAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || partyId != null) {
      map['party_id'] = Variable<int>(partyId);
    }
    if (!nullToAbsent || supplierName != null) {
      map['supplier_name'] = Variable<String>(supplierName);
    }
    if (!nullToAbsent || supplierGstin != null) {
      map['supplier_gstin'] = Variable<String>(supplierGstin);
    }
    if (!nullToAbsent || supplierInvoiceNo != null) {
      map['supplier_invoice_no'] = Variable<String>(supplierInvoiceNo);
    }
    map['purchased_at'] = Variable<DateTime>(purchasedAt);
    map['inter_state'] = Variable<bool>(interState);
    map['taxable_paise'] = Variable<int>(taxablePaise);
    map['tax_paise'] = Variable<int>(taxPaise);
    map['round_off_paise'] = Variable<int>(roundOffPaise);
    map['total_paise'] = Variable<int>(totalPaise);
    map['due_paise'] = Variable<int>(duePaise);
    map['payment_mode'] = Variable<String>(paymentMode);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || cancelledAt != null) {
      map['cancelled_at'] = Variable<DateTime>(cancelledAt);
    }
    return map;
  }

  PurchasesCompanion toCompanion(bool nullToAbsent) {
    return PurchasesCompanion(
      id: Value(id),
      partyId: partyId == null && nullToAbsent
          ? const Value.absent()
          : Value(partyId),
      supplierName: supplierName == null && nullToAbsent
          ? const Value.absent()
          : Value(supplierName),
      supplierGstin: supplierGstin == null && nullToAbsent
          ? const Value.absent()
          : Value(supplierGstin),
      supplierInvoiceNo: supplierInvoiceNo == null && nullToAbsent
          ? const Value.absent()
          : Value(supplierInvoiceNo),
      purchasedAt: Value(purchasedAt),
      interState: Value(interState),
      taxablePaise: Value(taxablePaise),
      taxPaise: Value(taxPaise),
      roundOffPaise: Value(roundOffPaise),
      totalPaise: Value(totalPaise),
      duePaise: Value(duePaise),
      paymentMode: Value(paymentMode),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      status: Value(status),
      cancelledAt: cancelledAt == null && nullToAbsent
          ? const Value.absent()
          : Value(cancelledAt),
    );
  }

  factory PurchaseRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PurchaseRow(
      id: serializer.fromJson<int>(json['id']),
      partyId: serializer.fromJson<int?>(json['partyId']),
      supplierName: serializer.fromJson<String?>(json['supplierName']),
      supplierGstin: serializer.fromJson<String?>(json['supplierGstin']),
      supplierInvoiceNo: serializer.fromJson<String?>(
        json['supplierInvoiceNo'],
      ),
      purchasedAt: serializer.fromJson<DateTime>(json['purchasedAt']),
      interState: serializer.fromJson<bool>(json['interState']),
      taxablePaise: serializer.fromJson<int>(json['taxablePaise']),
      taxPaise: serializer.fromJson<int>(json['taxPaise']),
      roundOffPaise: serializer.fromJson<int>(json['roundOffPaise']),
      totalPaise: serializer.fromJson<int>(json['totalPaise']),
      duePaise: serializer.fromJson<int>(json['duePaise']),
      paymentMode: serializer.fromJson<String>(json['paymentMode']),
      note: serializer.fromJson<String?>(json['note']),
      status: serializer.fromJson<String>(json['status']),
      cancelledAt: serializer.fromJson<DateTime?>(json['cancelledAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'partyId': serializer.toJson<int?>(partyId),
      'supplierName': serializer.toJson<String?>(supplierName),
      'supplierGstin': serializer.toJson<String?>(supplierGstin),
      'supplierInvoiceNo': serializer.toJson<String?>(supplierInvoiceNo),
      'purchasedAt': serializer.toJson<DateTime>(purchasedAt),
      'interState': serializer.toJson<bool>(interState),
      'taxablePaise': serializer.toJson<int>(taxablePaise),
      'taxPaise': serializer.toJson<int>(taxPaise),
      'roundOffPaise': serializer.toJson<int>(roundOffPaise),
      'totalPaise': serializer.toJson<int>(totalPaise),
      'duePaise': serializer.toJson<int>(duePaise),
      'paymentMode': serializer.toJson<String>(paymentMode),
      'note': serializer.toJson<String?>(note),
      'status': serializer.toJson<String>(status),
      'cancelledAt': serializer.toJson<DateTime?>(cancelledAt),
    };
  }

  PurchaseRow copyWith({
    int? id,
    Value<int?> partyId = const Value.absent(),
    Value<String?> supplierName = const Value.absent(),
    Value<String?> supplierGstin = const Value.absent(),
    Value<String?> supplierInvoiceNo = const Value.absent(),
    DateTime? purchasedAt,
    bool? interState,
    int? taxablePaise,
    int? taxPaise,
    int? roundOffPaise,
    int? totalPaise,
    int? duePaise,
    String? paymentMode,
    Value<String?> note = const Value.absent(),
    String? status,
    Value<DateTime?> cancelledAt = const Value.absent(),
  }) => PurchaseRow(
    id: id ?? this.id,
    partyId: partyId.present ? partyId.value : this.partyId,
    supplierName: supplierName.present ? supplierName.value : this.supplierName,
    supplierGstin: supplierGstin.present
        ? supplierGstin.value
        : this.supplierGstin,
    supplierInvoiceNo: supplierInvoiceNo.present
        ? supplierInvoiceNo.value
        : this.supplierInvoiceNo,
    purchasedAt: purchasedAt ?? this.purchasedAt,
    interState: interState ?? this.interState,
    taxablePaise: taxablePaise ?? this.taxablePaise,
    taxPaise: taxPaise ?? this.taxPaise,
    roundOffPaise: roundOffPaise ?? this.roundOffPaise,
    totalPaise: totalPaise ?? this.totalPaise,
    duePaise: duePaise ?? this.duePaise,
    paymentMode: paymentMode ?? this.paymentMode,
    note: note.present ? note.value : this.note,
    status: status ?? this.status,
    cancelledAt: cancelledAt.present ? cancelledAt.value : this.cancelledAt,
  );
  PurchaseRow copyWithCompanion(PurchasesCompanion data) {
    return PurchaseRow(
      id: data.id.present ? data.id.value : this.id,
      partyId: data.partyId.present ? data.partyId.value : this.partyId,
      supplierName: data.supplierName.present
          ? data.supplierName.value
          : this.supplierName,
      supplierGstin: data.supplierGstin.present
          ? data.supplierGstin.value
          : this.supplierGstin,
      supplierInvoiceNo: data.supplierInvoiceNo.present
          ? data.supplierInvoiceNo.value
          : this.supplierInvoiceNo,
      purchasedAt: data.purchasedAt.present
          ? data.purchasedAt.value
          : this.purchasedAt,
      interState: data.interState.present
          ? data.interState.value
          : this.interState,
      taxablePaise: data.taxablePaise.present
          ? data.taxablePaise.value
          : this.taxablePaise,
      taxPaise: data.taxPaise.present ? data.taxPaise.value : this.taxPaise,
      roundOffPaise: data.roundOffPaise.present
          ? data.roundOffPaise.value
          : this.roundOffPaise,
      totalPaise: data.totalPaise.present
          ? data.totalPaise.value
          : this.totalPaise,
      duePaise: data.duePaise.present ? data.duePaise.value : this.duePaise,
      paymentMode: data.paymentMode.present
          ? data.paymentMode.value
          : this.paymentMode,
      note: data.note.present ? data.note.value : this.note,
      status: data.status.present ? data.status.value : this.status,
      cancelledAt: data.cancelledAt.present
          ? data.cancelledAt.value
          : this.cancelledAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PurchaseRow(')
          ..write('id: $id, ')
          ..write('partyId: $partyId, ')
          ..write('supplierName: $supplierName, ')
          ..write('supplierGstin: $supplierGstin, ')
          ..write('supplierInvoiceNo: $supplierInvoiceNo, ')
          ..write('purchasedAt: $purchasedAt, ')
          ..write('interState: $interState, ')
          ..write('taxablePaise: $taxablePaise, ')
          ..write('taxPaise: $taxPaise, ')
          ..write('roundOffPaise: $roundOffPaise, ')
          ..write('totalPaise: $totalPaise, ')
          ..write('duePaise: $duePaise, ')
          ..write('paymentMode: $paymentMode, ')
          ..write('note: $note, ')
          ..write('status: $status, ')
          ..write('cancelledAt: $cancelledAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    partyId,
    supplierName,
    supplierGstin,
    supplierInvoiceNo,
    purchasedAt,
    interState,
    taxablePaise,
    taxPaise,
    roundOffPaise,
    totalPaise,
    duePaise,
    paymentMode,
    note,
    status,
    cancelledAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PurchaseRow &&
          other.id == this.id &&
          other.partyId == this.partyId &&
          other.supplierName == this.supplierName &&
          other.supplierGstin == this.supplierGstin &&
          other.supplierInvoiceNo == this.supplierInvoiceNo &&
          other.purchasedAt == this.purchasedAt &&
          other.interState == this.interState &&
          other.taxablePaise == this.taxablePaise &&
          other.taxPaise == this.taxPaise &&
          other.roundOffPaise == this.roundOffPaise &&
          other.totalPaise == this.totalPaise &&
          other.duePaise == this.duePaise &&
          other.paymentMode == this.paymentMode &&
          other.note == this.note &&
          other.status == this.status &&
          other.cancelledAt == this.cancelledAt);
}

class PurchasesCompanion extends UpdateCompanion<PurchaseRow> {
  final Value<int> id;
  final Value<int?> partyId;
  final Value<String?> supplierName;
  final Value<String?> supplierGstin;
  final Value<String?> supplierInvoiceNo;
  final Value<DateTime> purchasedAt;
  final Value<bool> interState;
  final Value<int> taxablePaise;
  final Value<int> taxPaise;
  final Value<int> roundOffPaise;
  final Value<int> totalPaise;
  final Value<int> duePaise;
  final Value<String> paymentMode;
  final Value<String?> note;
  final Value<String> status;
  final Value<DateTime?> cancelledAt;
  const PurchasesCompanion({
    this.id = const Value.absent(),
    this.partyId = const Value.absent(),
    this.supplierName = const Value.absent(),
    this.supplierGstin = const Value.absent(),
    this.supplierInvoiceNo = const Value.absent(),
    this.purchasedAt = const Value.absent(),
    this.interState = const Value.absent(),
    this.taxablePaise = const Value.absent(),
    this.taxPaise = const Value.absent(),
    this.roundOffPaise = const Value.absent(),
    this.totalPaise = const Value.absent(),
    this.duePaise = const Value.absent(),
    this.paymentMode = const Value.absent(),
    this.note = const Value.absent(),
    this.status = const Value.absent(),
    this.cancelledAt = const Value.absent(),
  });
  PurchasesCompanion.insert({
    this.id = const Value.absent(),
    this.partyId = const Value.absent(),
    this.supplierName = const Value.absent(),
    this.supplierGstin = const Value.absent(),
    this.supplierInvoiceNo = const Value.absent(),
    required DateTime purchasedAt,
    this.interState = const Value.absent(),
    required int taxablePaise,
    required int taxPaise,
    this.roundOffPaise = const Value.absent(),
    required int totalPaise,
    this.duePaise = const Value.absent(),
    required String paymentMode,
    this.note = const Value.absent(),
    this.status = const Value.absent(),
    this.cancelledAt = const Value.absent(),
  }) : purchasedAt = Value(purchasedAt),
       taxablePaise = Value(taxablePaise),
       taxPaise = Value(taxPaise),
       totalPaise = Value(totalPaise),
       paymentMode = Value(paymentMode);
  static Insertable<PurchaseRow> custom({
    Expression<int>? id,
    Expression<int>? partyId,
    Expression<String>? supplierName,
    Expression<String>? supplierGstin,
    Expression<String>? supplierInvoiceNo,
    Expression<DateTime>? purchasedAt,
    Expression<bool>? interState,
    Expression<int>? taxablePaise,
    Expression<int>? taxPaise,
    Expression<int>? roundOffPaise,
    Expression<int>? totalPaise,
    Expression<int>? duePaise,
    Expression<String>? paymentMode,
    Expression<String>? note,
    Expression<String>? status,
    Expression<DateTime>? cancelledAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (partyId != null) 'party_id': partyId,
      if (supplierName != null) 'supplier_name': supplierName,
      if (supplierGstin != null) 'supplier_gstin': supplierGstin,
      if (supplierInvoiceNo != null) 'supplier_invoice_no': supplierInvoiceNo,
      if (purchasedAt != null) 'purchased_at': purchasedAt,
      if (interState != null) 'inter_state': interState,
      if (taxablePaise != null) 'taxable_paise': taxablePaise,
      if (taxPaise != null) 'tax_paise': taxPaise,
      if (roundOffPaise != null) 'round_off_paise': roundOffPaise,
      if (totalPaise != null) 'total_paise': totalPaise,
      if (duePaise != null) 'due_paise': duePaise,
      if (paymentMode != null) 'payment_mode': paymentMode,
      if (note != null) 'note': note,
      if (status != null) 'status': status,
      if (cancelledAt != null) 'cancelled_at': cancelledAt,
    });
  }

  PurchasesCompanion copyWith({
    Value<int>? id,
    Value<int?>? partyId,
    Value<String?>? supplierName,
    Value<String?>? supplierGstin,
    Value<String?>? supplierInvoiceNo,
    Value<DateTime>? purchasedAt,
    Value<bool>? interState,
    Value<int>? taxablePaise,
    Value<int>? taxPaise,
    Value<int>? roundOffPaise,
    Value<int>? totalPaise,
    Value<int>? duePaise,
    Value<String>? paymentMode,
    Value<String?>? note,
    Value<String>? status,
    Value<DateTime?>? cancelledAt,
  }) {
    return PurchasesCompanion(
      id: id ?? this.id,
      partyId: partyId ?? this.partyId,
      supplierName: supplierName ?? this.supplierName,
      supplierGstin: supplierGstin ?? this.supplierGstin,
      supplierInvoiceNo: supplierInvoiceNo ?? this.supplierInvoiceNo,
      purchasedAt: purchasedAt ?? this.purchasedAt,
      interState: interState ?? this.interState,
      taxablePaise: taxablePaise ?? this.taxablePaise,
      taxPaise: taxPaise ?? this.taxPaise,
      roundOffPaise: roundOffPaise ?? this.roundOffPaise,
      totalPaise: totalPaise ?? this.totalPaise,
      duePaise: duePaise ?? this.duePaise,
      paymentMode: paymentMode ?? this.paymentMode,
      note: note ?? this.note,
      status: status ?? this.status,
      cancelledAt: cancelledAt ?? this.cancelledAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (partyId.present) {
      map['party_id'] = Variable<int>(partyId.value);
    }
    if (supplierName.present) {
      map['supplier_name'] = Variable<String>(supplierName.value);
    }
    if (supplierGstin.present) {
      map['supplier_gstin'] = Variable<String>(supplierGstin.value);
    }
    if (supplierInvoiceNo.present) {
      map['supplier_invoice_no'] = Variable<String>(supplierInvoiceNo.value);
    }
    if (purchasedAt.present) {
      map['purchased_at'] = Variable<DateTime>(purchasedAt.value);
    }
    if (interState.present) {
      map['inter_state'] = Variable<bool>(interState.value);
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
    if (totalPaise.present) {
      map['total_paise'] = Variable<int>(totalPaise.value);
    }
    if (duePaise.present) {
      map['due_paise'] = Variable<int>(duePaise.value);
    }
    if (paymentMode.present) {
      map['payment_mode'] = Variable<String>(paymentMode.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (cancelledAt.present) {
      map['cancelled_at'] = Variable<DateTime>(cancelledAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PurchasesCompanion(')
          ..write('id: $id, ')
          ..write('partyId: $partyId, ')
          ..write('supplierName: $supplierName, ')
          ..write('supplierGstin: $supplierGstin, ')
          ..write('supplierInvoiceNo: $supplierInvoiceNo, ')
          ..write('purchasedAt: $purchasedAt, ')
          ..write('interState: $interState, ')
          ..write('taxablePaise: $taxablePaise, ')
          ..write('taxPaise: $taxPaise, ')
          ..write('roundOffPaise: $roundOffPaise, ')
          ..write('totalPaise: $totalPaise, ')
          ..write('duePaise: $duePaise, ')
          ..write('paymentMode: $paymentMode, ')
          ..write('note: $note, ')
          ..write('status: $status, ')
          ..write('cancelledAt: $cancelledAt')
          ..write(')'))
        .toString();
  }
}

class $PurchaseLinesTable extends PurchaseLines
    with TableInfo<$PurchaseLinesTable, PurchaseLineRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PurchaseLinesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _purchaseIdMeta = const VerificationMeta(
    'purchaseId',
  );
  @override
  late final GeneratedColumn<int> purchaseId = GeneratedColumn<int>(
    'purchase_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES purchases (id) ON DELETE CASCADE',
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
  static const VerificationMeta _unitCostPaiseMeta = const VerificationMeta(
    'unitCostPaise',
  );
  @override
  late final GeneratedColumn<int> unitCostPaise = GeneratedColumn<int>(
    'unit_cost_paise',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _costIncludesTaxMeta = const VerificationMeta(
    'costIncludesTax',
  );
  @override
  late final GeneratedColumn<bool> costIncludesTax = GeneratedColumn<bool>(
    'cost_includes_tax',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("cost_includes_tax" IN (0, 1))',
    ),
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
  static const VerificationMeta _batchNoMeta = const VerificationMeta(
    'batchNo',
  );
  @override
  late final GeneratedColumn<String> batchNo = GeneratedColumn<String>(
    'batch_no',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _expiryMeta = const VerificationMeta('expiry');
  @override
  late final GeneratedColumn<DateTime> expiry = GeneratedColumn<DateTime>(
    'expiry',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    purchaseId,
    position,
    itemId,
    name,
    unit,
    hsn,
    quantityMilli,
    unitCostPaise,
    costIncludesTax,
    taxRateBp,
    taxablePaise,
    taxPaise,
    totalPaise,
    batchNo,
    expiry,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'purchase_lines';
  @override
  VerificationContext validateIntegrity(
    Insertable<PurchaseLineRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('purchase_id')) {
      context.handle(
        _purchaseIdMeta,
        purchaseId.isAcceptableOrUnknown(data['purchase_id']!, _purchaseIdMeta),
      );
    } else if (isInserting) {
      context.missing(_purchaseIdMeta);
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
    if (data.containsKey('unit_cost_paise')) {
      context.handle(
        _unitCostPaiseMeta,
        unitCostPaise.isAcceptableOrUnknown(
          data['unit_cost_paise']!,
          _unitCostPaiseMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_unitCostPaiseMeta);
    }
    if (data.containsKey('cost_includes_tax')) {
      context.handle(
        _costIncludesTaxMeta,
        costIncludesTax.isAcceptableOrUnknown(
          data['cost_includes_tax']!,
          _costIncludesTaxMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_costIncludesTaxMeta);
    }
    if (data.containsKey('tax_rate_bp')) {
      context.handle(
        _taxRateBpMeta,
        taxRateBp.isAcceptableOrUnknown(data['tax_rate_bp']!, _taxRateBpMeta),
      );
    } else if (isInserting) {
      context.missing(_taxRateBpMeta);
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
    if (data.containsKey('batch_no')) {
      context.handle(
        _batchNoMeta,
        batchNo.isAcceptableOrUnknown(data['batch_no']!, _batchNoMeta),
      );
    }
    if (data.containsKey('expiry')) {
      context.handle(
        _expiryMeta,
        expiry.isAcceptableOrUnknown(data['expiry']!, _expiryMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PurchaseLineRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PurchaseLineRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      purchaseId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}purchase_id'],
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
      unitCostPaise: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}unit_cost_paise'],
      )!,
      costIncludesTax: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}cost_includes_tax'],
      )!,
      taxRateBp: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tax_rate_bp'],
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
      batchNo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}batch_no'],
      ),
      expiry: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}expiry'],
      ),
    );
  }

  @override
  $PurchaseLinesTable createAlias(String alias) {
    return $PurchaseLinesTable(attachedDatabase, alias);
  }
}

class PurchaseLineRow extends DataClass implements Insertable<PurchaseLineRow> {
  final int id;
  final int purchaseId;
  final int position;
  final int? itemId;
  final String name;
  final String unit;
  final String? hsn;

  /// In the item's base unit.
  final int quantityMilli;
  final int unitCostPaise;
  final bool costIncludesTax;
  final int taxRateBp;
  final int taxablePaise;
  final int taxPaise;
  final int totalPaise;
  final String? batchNo;
  final DateTime? expiry;
  const PurchaseLineRow({
    required this.id,
    required this.purchaseId,
    required this.position,
    this.itemId,
    required this.name,
    required this.unit,
    this.hsn,
    required this.quantityMilli,
    required this.unitCostPaise,
    required this.costIncludesTax,
    required this.taxRateBp,
    required this.taxablePaise,
    required this.taxPaise,
    required this.totalPaise,
    this.batchNo,
    this.expiry,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['purchase_id'] = Variable<int>(purchaseId);
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
    map['unit_cost_paise'] = Variable<int>(unitCostPaise);
    map['cost_includes_tax'] = Variable<bool>(costIncludesTax);
    map['tax_rate_bp'] = Variable<int>(taxRateBp);
    map['taxable_paise'] = Variable<int>(taxablePaise);
    map['tax_paise'] = Variable<int>(taxPaise);
    map['total_paise'] = Variable<int>(totalPaise);
    if (!nullToAbsent || batchNo != null) {
      map['batch_no'] = Variable<String>(batchNo);
    }
    if (!nullToAbsent || expiry != null) {
      map['expiry'] = Variable<DateTime>(expiry);
    }
    return map;
  }

  PurchaseLinesCompanion toCompanion(bool nullToAbsent) {
    return PurchaseLinesCompanion(
      id: Value(id),
      purchaseId: Value(purchaseId),
      position: Value(position),
      itemId: itemId == null && nullToAbsent
          ? const Value.absent()
          : Value(itemId),
      name: Value(name),
      unit: Value(unit),
      hsn: hsn == null && nullToAbsent ? const Value.absent() : Value(hsn),
      quantityMilli: Value(quantityMilli),
      unitCostPaise: Value(unitCostPaise),
      costIncludesTax: Value(costIncludesTax),
      taxRateBp: Value(taxRateBp),
      taxablePaise: Value(taxablePaise),
      taxPaise: Value(taxPaise),
      totalPaise: Value(totalPaise),
      batchNo: batchNo == null && nullToAbsent
          ? const Value.absent()
          : Value(batchNo),
      expiry: expiry == null && nullToAbsent
          ? const Value.absent()
          : Value(expiry),
    );
  }

  factory PurchaseLineRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PurchaseLineRow(
      id: serializer.fromJson<int>(json['id']),
      purchaseId: serializer.fromJson<int>(json['purchaseId']),
      position: serializer.fromJson<int>(json['position']),
      itemId: serializer.fromJson<int?>(json['itemId']),
      name: serializer.fromJson<String>(json['name']),
      unit: serializer.fromJson<String>(json['unit']),
      hsn: serializer.fromJson<String?>(json['hsn']),
      quantityMilli: serializer.fromJson<int>(json['quantityMilli']),
      unitCostPaise: serializer.fromJson<int>(json['unitCostPaise']),
      costIncludesTax: serializer.fromJson<bool>(json['costIncludesTax']),
      taxRateBp: serializer.fromJson<int>(json['taxRateBp']),
      taxablePaise: serializer.fromJson<int>(json['taxablePaise']),
      taxPaise: serializer.fromJson<int>(json['taxPaise']),
      totalPaise: serializer.fromJson<int>(json['totalPaise']),
      batchNo: serializer.fromJson<String?>(json['batchNo']),
      expiry: serializer.fromJson<DateTime?>(json['expiry']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'purchaseId': serializer.toJson<int>(purchaseId),
      'position': serializer.toJson<int>(position),
      'itemId': serializer.toJson<int?>(itemId),
      'name': serializer.toJson<String>(name),
      'unit': serializer.toJson<String>(unit),
      'hsn': serializer.toJson<String?>(hsn),
      'quantityMilli': serializer.toJson<int>(quantityMilli),
      'unitCostPaise': serializer.toJson<int>(unitCostPaise),
      'costIncludesTax': serializer.toJson<bool>(costIncludesTax),
      'taxRateBp': serializer.toJson<int>(taxRateBp),
      'taxablePaise': serializer.toJson<int>(taxablePaise),
      'taxPaise': serializer.toJson<int>(taxPaise),
      'totalPaise': serializer.toJson<int>(totalPaise),
      'batchNo': serializer.toJson<String?>(batchNo),
      'expiry': serializer.toJson<DateTime?>(expiry),
    };
  }

  PurchaseLineRow copyWith({
    int? id,
    int? purchaseId,
    int? position,
    Value<int?> itemId = const Value.absent(),
    String? name,
    String? unit,
    Value<String?> hsn = const Value.absent(),
    int? quantityMilli,
    int? unitCostPaise,
    bool? costIncludesTax,
    int? taxRateBp,
    int? taxablePaise,
    int? taxPaise,
    int? totalPaise,
    Value<String?> batchNo = const Value.absent(),
    Value<DateTime?> expiry = const Value.absent(),
  }) => PurchaseLineRow(
    id: id ?? this.id,
    purchaseId: purchaseId ?? this.purchaseId,
    position: position ?? this.position,
    itemId: itemId.present ? itemId.value : this.itemId,
    name: name ?? this.name,
    unit: unit ?? this.unit,
    hsn: hsn.present ? hsn.value : this.hsn,
    quantityMilli: quantityMilli ?? this.quantityMilli,
    unitCostPaise: unitCostPaise ?? this.unitCostPaise,
    costIncludesTax: costIncludesTax ?? this.costIncludesTax,
    taxRateBp: taxRateBp ?? this.taxRateBp,
    taxablePaise: taxablePaise ?? this.taxablePaise,
    taxPaise: taxPaise ?? this.taxPaise,
    totalPaise: totalPaise ?? this.totalPaise,
    batchNo: batchNo.present ? batchNo.value : this.batchNo,
    expiry: expiry.present ? expiry.value : this.expiry,
  );
  PurchaseLineRow copyWithCompanion(PurchaseLinesCompanion data) {
    return PurchaseLineRow(
      id: data.id.present ? data.id.value : this.id,
      purchaseId: data.purchaseId.present
          ? data.purchaseId.value
          : this.purchaseId,
      position: data.position.present ? data.position.value : this.position,
      itemId: data.itemId.present ? data.itemId.value : this.itemId,
      name: data.name.present ? data.name.value : this.name,
      unit: data.unit.present ? data.unit.value : this.unit,
      hsn: data.hsn.present ? data.hsn.value : this.hsn,
      quantityMilli: data.quantityMilli.present
          ? data.quantityMilli.value
          : this.quantityMilli,
      unitCostPaise: data.unitCostPaise.present
          ? data.unitCostPaise.value
          : this.unitCostPaise,
      costIncludesTax: data.costIncludesTax.present
          ? data.costIncludesTax.value
          : this.costIncludesTax,
      taxRateBp: data.taxRateBp.present ? data.taxRateBp.value : this.taxRateBp,
      taxablePaise: data.taxablePaise.present
          ? data.taxablePaise.value
          : this.taxablePaise,
      taxPaise: data.taxPaise.present ? data.taxPaise.value : this.taxPaise,
      totalPaise: data.totalPaise.present
          ? data.totalPaise.value
          : this.totalPaise,
      batchNo: data.batchNo.present ? data.batchNo.value : this.batchNo,
      expiry: data.expiry.present ? data.expiry.value : this.expiry,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PurchaseLineRow(')
          ..write('id: $id, ')
          ..write('purchaseId: $purchaseId, ')
          ..write('position: $position, ')
          ..write('itemId: $itemId, ')
          ..write('name: $name, ')
          ..write('unit: $unit, ')
          ..write('hsn: $hsn, ')
          ..write('quantityMilli: $quantityMilli, ')
          ..write('unitCostPaise: $unitCostPaise, ')
          ..write('costIncludesTax: $costIncludesTax, ')
          ..write('taxRateBp: $taxRateBp, ')
          ..write('taxablePaise: $taxablePaise, ')
          ..write('taxPaise: $taxPaise, ')
          ..write('totalPaise: $totalPaise, ')
          ..write('batchNo: $batchNo, ')
          ..write('expiry: $expiry')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    purchaseId,
    position,
    itemId,
    name,
    unit,
    hsn,
    quantityMilli,
    unitCostPaise,
    costIncludesTax,
    taxRateBp,
    taxablePaise,
    taxPaise,
    totalPaise,
    batchNo,
    expiry,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PurchaseLineRow &&
          other.id == this.id &&
          other.purchaseId == this.purchaseId &&
          other.position == this.position &&
          other.itemId == this.itemId &&
          other.name == this.name &&
          other.unit == this.unit &&
          other.hsn == this.hsn &&
          other.quantityMilli == this.quantityMilli &&
          other.unitCostPaise == this.unitCostPaise &&
          other.costIncludesTax == this.costIncludesTax &&
          other.taxRateBp == this.taxRateBp &&
          other.taxablePaise == this.taxablePaise &&
          other.taxPaise == this.taxPaise &&
          other.totalPaise == this.totalPaise &&
          other.batchNo == this.batchNo &&
          other.expiry == this.expiry);
}

class PurchaseLinesCompanion extends UpdateCompanion<PurchaseLineRow> {
  final Value<int> id;
  final Value<int> purchaseId;
  final Value<int> position;
  final Value<int?> itemId;
  final Value<String> name;
  final Value<String> unit;
  final Value<String?> hsn;
  final Value<int> quantityMilli;
  final Value<int> unitCostPaise;
  final Value<bool> costIncludesTax;
  final Value<int> taxRateBp;
  final Value<int> taxablePaise;
  final Value<int> taxPaise;
  final Value<int> totalPaise;
  final Value<String?> batchNo;
  final Value<DateTime?> expiry;
  const PurchaseLinesCompanion({
    this.id = const Value.absent(),
    this.purchaseId = const Value.absent(),
    this.position = const Value.absent(),
    this.itemId = const Value.absent(),
    this.name = const Value.absent(),
    this.unit = const Value.absent(),
    this.hsn = const Value.absent(),
    this.quantityMilli = const Value.absent(),
    this.unitCostPaise = const Value.absent(),
    this.costIncludesTax = const Value.absent(),
    this.taxRateBp = const Value.absent(),
    this.taxablePaise = const Value.absent(),
    this.taxPaise = const Value.absent(),
    this.totalPaise = const Value.absent(),
    this.batchNo = const Value.absent(),
    this.expiry = const Value.absent(),
  });
  PurchaseLinesCompanion.insert({
    this.id = const Value.absent(),
    required int purchaseId,
    required int position,
    this.itemId = const Value.absent(),
    required String name,
    required String unit,
    this.hsn = const Value.absent(),
    required int quantityMilli,
    required int unitCostPaise,
    required bool costIncludesTax,
    required int taxRateBp,
    required int taxablePaise,
    required int taxPaise,
    required int totalPaise,
    this.batchNo = const Value.absent(),
    this.expiry = const Value.absent(),
  }) : purchaseId = Value(purchaseId),
       position = Value(position),
       name = Value(name),
       unit = Value(unit),
       quantityMilli = Value(quantityMilli),
       unitCostPaise = Value(unitCostPaise),
       costIncludesTax = Value(costIncludesTax),
       taxRateBp = Value(taxRateBp),
       taxablePaise = Value(taxablePaise),
       taxPaise = Value(taxPaise),
       totalPaise = Value(totalPaise);
  static Insertable<PurchaseLineRow> custom({
    Expression<int>? id,
    Expression<int>? purchaseId,
    Expression<int>? position,
    Expression<int>? itemId,
    Expression<String>? name,
    Expression<String>? unit,
    Expression<String>? hsn,
    Expression<int>? quantityMilli,
    Expression<int>? unitCostPaise,
    Expression<bool>? costIncludesTax,
    Expression<int>? taxRateBp,
    Expression<int>? taxablePaise,
    Expression<int>? taxPaise,
    Expression<int>? totalPaise,
    Expression<String>? batchNo,
    Expression<DateTime>? expiry,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (purchaseId != null) 'purchase_id': purchaseId,
      if (position != null) 'position': position,
      if (itemId != null) 'item_id': itemId,
      if (name != null) 'name': name,
      if (unit != null) 'unit': unit,
      if (hsn != null) 'hsn': hsn,
      if (quantityMilli != null) 'quantity_milli': quantityMilli,
      if (unitCostPaise != null) 'unit_cost_paise': unitCostPaise,
      if (costIncludesTax != null) 'cost_includes_tax': costIncludesTax,
      if (taxRateBp != null) 'tax_rate_bp': taxRateBp,
      if (taxablePaise != null) 'taxable_paise': taxablePaise,
      if (taxPaise != null) 'tax_paise': taxPaise,
      if (totalPaise != null) 'total_paise': totalPaise,
      if (batchNo != null) 'batch_no': batchNo,
      if (expiry != null) 'expiry': expiry,
    });
  }

  PurchaseLinesCompanion copyWith({
    Value<int>? id,
    Value<int>? purchaseId,
    Value<int>? position,
    Value<int?>? itemId,
    Value<String>? name,
    Value<String>? unit,
    Value<String?>? hsn,
    Value<int>? quantityMilli,
    Value<int>? unitCostPaise,
    Value<bool>? costIncludesTax,
    Value<int>? taxRateBp,
    Value<int>? taxablePaise,
    Value<int>? taxPaise,
    Value<int>? totalPaise,
    Value<String?>? batchNo,
    Value<DateTime?>? expiry,
  }) {
    return PurchaseLinesCompanion(
      id: id ?? this.id,
      purchaseId: purchaseId ?? this.purchaseId,
      position: position ?? this.position,
      itemId: itemId ?? this.itemId,
      name: name ?? this.name,
      unit: unit ?? this.unit,
      hsn: hsn ?? this.hsn,
      quantityMilli: quantityMilli ?? this.quantityMilli,
      unitCostPaise: unitCostPaise ?? this.unitCostPaise,
      costIncludesTax: costIncludesTax ?? this.costIncludesTax,
      taxRateBp: taxRateBp ?? this.taxRateBp,
      taxablePaise: taxablePaise ?? this.taxablePaise,
      taxPaise: taxPaise ?? this.taxPaise,
      totalPaise: totalPaise ?? this.totalPaise,
      batchNo: batchNo ?? this.batchNo,
      expiry: expiry ?? this.expiry,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (purchaseId.present) {
      map['purchase_id'] = Variable<int>(purchaseId.value);
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
    if (unitCostPaise.present) {
      map['unit_cost_paise'] = Variable<int>(unitCostPaise.value);
    }
    if (costIncludesTax.present) {
      map['cost_includes_tax'] = Variable<bool>(costIncludesTax.value);
    }
    if (taxRateBp.present) {
      map['tax_rate_bp'] = Variable<int>(taxRateBp.value);
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
    if (batchNo.present) {
      map['batch_no'] = Variable<String>(batchNo.value);
    }
    if (expiry.present) {
      map['expiry'] = Variable<DateTime>(expiry.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PurchaseLinesCompanion(')
          ..write('id: $id, ')
          ..write('purchaseId: $purchaseId, ')
          ..write('position: $position, ')
          ..write('itemId: $itemId, ')
          ..write('name: $name, ')
          ..write('unit: $unit, ')
          ..write('hsn: $hsn, ')
          ..write('quantityMilli: $quantityMilli, ')
          ..write('unitCostPaise: $unitCostPaise, ')
          ..write('costIncludesTax: $costIncludesTax, ')
          ..write('taxRateBp: $taxRateBp, ')
          ..write('taxablePaise: $taxablePaise, ')
          ..write('taxPaise: $taxPaise, ')
          ..write('totalPaise: $totalPaise, ')
          ..write('batchNo: $batchNo, ')
          ..write('expiry: $expiry')
          ..write(')'))
        .toString();
  }
}

class $ExpensesTable extends Expenses
    with TableInfo<$ExpensesTable, ExpenseRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExpensesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _spentAtMeta = const VerificationMeta(
    'spentAt',
  );
  @override
  late final GeneratedColumn<DateTime> spentAt = GeneratedColumn<DateTime>(
    'spent_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountPaiseMeta = const VerificationMeta(
    'amountPaise',
  );
  @override
  late final GeneratedColumn<int> amountPaise = GeneratedColumn<int>(
    'amount_paise',
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
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    spentAt,
    category,
    amountPaise,
    paymentMode,
    note,
    isDeleted,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'expenses';
  @override
  VerificationContext validateIntegrity(
    Insertable<ExpenseRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('spent_at')) {
      context.handle(
        _spentAtMeta,
        spentAt.isAcceptableOrUnknown(data['spent_at']!, _spentAtMeta),
      );
    } else if (isInserting) {
      context.missing(_spentAtMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('amount_paise')) {
      context.handle(
        _amountPaiseMeta,
        amountPaise.isAcceptableOrUnknown(
          data['amount_paise']!,
          _amountPaiseMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountPaiseMeta);
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
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ExpenseRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExpenseRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      spentAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}spent_at'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      amountPaise: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_paise'],
      )!,
      paymentMode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payment_mode'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
    );
  }

  @override
  $ExpensesTable createAlias(String alias) {
    return $ExpensesTable(attachedDatabase, alias);
  }
}

class ExpenseRow extends DataClass implements Insertable<ExpenseRow> {
  final int id;
  final DateTime spentAt;
  final String category;
  final int amountPaise;
  final String paymentMode;
  final String? note;
  final bool isDeleted;
  const ExpenseRow({
    required this.id,
    required this.spentAt,
    required this.category,
    required this.amountPaise,
    required this.paymentMode,
    this.note,
    required this.isDeleted,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['spent_at'] = Variable<DateTime>(spentAt);
    map['category'] = Variable<String>(category);
    map['amount_paise'] = Variable<int>(amountPaise);
    map['payment_mode'] = Variable<String>(paymentMode);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['is_deleted'] = Variable<bool>(isDeleted);
    return map;
  }

  ExpensesCompanion toCompanion(bool nullToAbsent) {
    return ExpensesCompanion(
      id: Value(id),
      spentAt: Value(spentAt),
      category: Value(category),
      amountPaise: Value(amountPaise),
      paymentMode: Value(paymentMode),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      isDeleted: Value(isDeleted),
    );
  }

  factory ExpenseRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExpenseRow(
      id: serializer.fromJson<int>(json['id']),
      spentAt: serializer.fromJson<DateTime>(json['spentAt']),
      category: serializer.fromJson<String>(json['category']),
      amountPaise: serializer.fromJson<int>(json['amountPaise']),
      paymentMode: serializer.fromJson<String>(json['paymentMode']),
      note: serializer.fromJson<String?>(json['note']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'spentAt': serializer.toJson<DateTime>(spentAt),
      'category': serializer.toJson<String>(category),
      'amountPaise': serializer.toJson<int>(amountPaise),
      'paymentMode': serializer.toJson<String>(paymentMode),
      'note': serializer.toJson<String?>(note),
      'isDeleted': serializer.toJson<bool>(isDeleted),
    };
  }

  ExpenseRow copyWith({
    int? id,
    DateTime? spentAt,
    String? category,
    int? amountPaise,
    String? paymentMode,
    Value<String?> note = const Value.absent(),
    bool? isDeleted,
  }) => ExpenseRow(
    id: id ?? this.id,
    spentAt: spentAt ?? this.spentAt,
    category: category ?? this.category,
    amountPaise: amountPaise ?? this.amountPaise,
    paymentMode: paymentMode ?? this.paymentMode,
    note: note.present ? note.value : this.note,
    isDeleted: isDeleted ?? this.isDeleted,
  );
  ExpenseRow copyWithCompanion(ExpensesCompanion data) {
    return ExpenseRow(
      id: data.id.present ? data.id.value : this.id,
      spentAt: data.spentAt.present ? data.spentAt.value : this.spentAt,
      category: data.category.present ? data.category.value : this.category,
      amountPaise: data.amountPaise.present
          ? data.amountPaise.value
          : this.amountPaise,
      paymentMode: data.paymentMode.present
          ? data.paymentMode.value
          : this.paymentMode,
      note: data.note.present ? data.note.value : this.note,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExpenseRow(')
          ..write('id: $id, ')
          ..write('spentAt: $spentAt, ')
          ..write('category: $category, ')
          ..write('amountPaise: $amountPaise, ')
          ..write('paymentMode: $paymentMode, ')
          ..write('note: $note, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    spentAt,
    category,
    amountPaise,
    paymentMode,
    note,
    isDeleted,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExpenseRow &&
          other.id == this.id &&
          other.spentAt == this.spentAt &&
          other.category == this.category &&
          other.amountPaise == this.amountPaise &&
          other.paymentMode == this.paymentMode &&
          other.note == this.note &&
          other.isDeleted == this.isDeleted);
}

class ExpensesCompanion extends UpdateCompanion<ExpenseRow> {
  final Value<int> id;
  final Value<DateTime> spentAt;
  final Value<String> category;
  final Value<int> amountPaise;
  final Value<String> paymentMode;
  final Value<String?> note;
  final Value<bool> isDeleted;
  const ExpensesCompanion({
    this.id = const Value.absent(),
    this.spentAt = const Value.absent(),
    this.category = const Value.absent(),
    this.amountPaise = const Value.absent(),
    this.paymentMode = const Value.absent(),
    this.note = const Value.absent(),
    this.isDeleted = const Value.absent(),
  });
  ExpensesCompanion.insert({
    this.id = const Value.absent(),
    required DateTime spentAt,
    required String category,
    required int amountPaise,
    required String paymentMode,
    this.note = const Value.absent(),
    this.isDeleted = const Value.absent(),
  }) : spentAt = Value(spentAt),
       category = Value(category),
       amountPaise = Value(amountPaise),
       paymentMode = Value(paymentMode);
  static Insertable<ExpenseRow> custom({
    Expression<int>? id,
    Expression<DateTime>? spentAt,
    Expression<String>? category,
    Expression<int>? amountPaise,
    Expression<String>? paymentMode,
    Expression<String>? note,
    Expression<bool>? isDeleted,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (spentAt != null) 'spent_at': spentAt,
      if (category != null) 'category': category,
      if (amountPaise != null) 'amount_paise': amountPaise,
      if (paymentMode != null) 'payment_mode': paymentMode,
      if (note != null) 'note': note,
      if (isDeleted != null) 'is_deleted': isDeleted,
    });
  }

  ExpensesCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? spentAt,
    Value<String>? category,
    Value<int>? amountPaise,
    Value<String>? paymentMode,
    Value<String?>? note,
    Value<bool>? isDeleted,
  }) {
    return ExpensesCompanion(
      id: id ?? this.id,
      spentAt: spentAt ?? this.spentAt,
      category: category ?? this.category,
      amountPaise: amountPaise ?? this.amountPaise,
      paymentMode: paymentMode ?? this.paymentMode,
      note: note ?? this.note,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (spentAt.present) {
      map['spent_at'] = Variable<DateTime>(spentAt.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (amountPaise.present) {
      map['amount_paise'] = Variable<int>(amountPaise.value);
    }
    if (paymentMode.present) {
      map['payment_mode'] = Variable<String>(paymentMode.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExpensesCompanion(')
          ..write('id: $id, ')
          ..write('spentAt: $spentAt, ')
          ..write('category: $category, ')
          ..write('amountPaise: $amountPaise, ')
          ..write('paymentMode: $paymentMode, ')
          ..write('note: $note, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }
}

class $CreditNotesTable extends CreditNotes
    with TableInfo<$CreditNotesTable, CreditNoteRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CreditNotesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _noteNoMeta = const VerificationMeta('noteNo');
  @override
  late final GeneratedColumn<String> noteNo = GeneratedColumn<String>(
    'note_no',
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
  static const VerificationMeta _billIdMeta = const VerificationMeta('billId');
  @override
  late final GeneratedColumn<int> billId = GeneratedColumn<int>(
    'bill_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES bills (id)',
    ),
  );
  static const VerificationMeta _issuedAtMeta = const VerificationMeta(
    'issuedAt',
  );
  @override
  late final GeneratedColumn<DateTime> issuedAt = GeneratedColumn<DateTime>(
    'issued_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _reasonMeta = const VerificationMeta('reason');
  @override
  late final GeneratedColumn<String> reason = GeneratedColumn<String>(
    'reason',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
  static const VerificationMeta _refundModeMeta = const VerificationMeta(
    'refundMode',
  );
  @override
  late final GeneratedColumn<String> refundMode = GeneratedColumn<String>(
    'refund_mode',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    noteNo,
    fyStart,
    sequence,
    billId,
    issuedAt,
    reason,
    taxablePaise,
    taxPaise,
    totalPaise,
    refundMode,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'credit_notes';
  @override
  VerificationContext validateIntegrity(
    Insertable<CreditNoteRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('note_no')) {
      context.handle(
        _noteNoMeta,
        noteNo.isAcceptableOrUnknown(data['note_no']!, _noteNoMeta),
      );
    } else if (isInserting) {
      context.missing(_noteNoMeta);
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
    if (data.containsKey('bill_id')) {
      context.handle(
        _billIdMeta,
        billId.isAcceptableOrUnknown(data['bill_id']!, _billIdMeta),
      );
    } else if (isInserting) {
      context.missing(_billIdMeta);
    }
    if (data.containsKey('issued_at')) {
      context.handle(
        _issuedAtMeta,
        issuedAt.isAcceptableOrUnknown(data['issued_at']!, _issuedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_issuedAtMeta);
    }
    if (data.containsKey('reason')) {
      context.handle(
        _reasonMeta,
        reason.isAcceptableOrUnknown(data['reason']!, _reasonMeta),
      );
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
    if (data.containsKey('refund_mode')) {
      context.handle(
        _refundModeMeta,
        refundMode.isAcceptableOrUnknown(data['refund_mode']!, _refundModeMeta),
      );
    } else if (isInserting) {
      context.missing(_refundModeMeta);
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
  CreditNoteRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CreditNoteRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      noteNo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note_no'],
      )!,
      fyStart: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}fy_start'],
      )!,
      sequence: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sequence'],
      )!,
      billId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}bill_id'],
      )!,
      issuedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}issued_at'],
      )!,
      reason: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reason'],
      ),
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
      refundMode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}refund_mode'],
      )!,
    );
  }

  @override
  $CreditNotesTable createAlias(String alias) {
    return $CreditNotesTable(attachedDatabase, alias);
  }
}

class CreditNoteRow extends DataClass implements Insertable<CreditNoteRow> {
  final int id;
  final String noteNo;
  final int fyStart;
  final int sequence;
  final int billId;
  final DateTime issuedAt;
  final String? reason;
  final int taxablePaise;
  final int taxPaise;
  final int totalPaise;

  /// How the money went back: `cash`/`upi`/`card` refund, or `credit`
  /// (taken off the customer's dues).
  final String refundMode;
  const CreditNoteRow({
    required this.id,
    required this.noteNo,
    required this.fyStart,
    required this.sequence,
    required this.billId,
    required this.issuedAt,
    this.reason,
    required this.taxablePaise,
    required this.taxPaise,
    required this.totalPaise,
    required this.refundMode,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['note_no'] = Variable<String>(noteNo);
    map['fy_start'] = Variable<int>(fyStart);
    map['sequence'] = Variable<int>(sequence);
    map['bill_id'] = Variable<int>(billId);
    map['issued_at'] = Variable<DateTime>(issuedAt);
    if (!nullToAbsent || reason != null) {
      map['reason'] = Variable<String>(reason);
    }
    map['taxable_paise'] = Variable<int>(taxablePaise);
    map['tax_paise'] = Variable<int>(taxPaise);
    map['total_paise'] = Variable<int>(totalPaise);
    map['refund_mode'] = Variable<String>(refundMode);
    return map;
  }

  CreditNotesCompanion toCompanion(bool nullToAbsent) {
    return CreditNotesCompanion(
      id: Value(id),
      noteNo: Value(noteNo),
      fyStart: Value(fyStart),
      sequence: Value(sequence),
      billId: Value(billId),
      issuedAt: Value(issuedAt),
      reason: reason == null && nullToAbsent
          ? const Value.absent()
          : Value(reason),
      taxablePaise: Value(taxablePaise),
      taxPaise: Value(taxPaise),
      totalPaise: Value(totalPaise),
      refundMode: Value(refundMode),
    );
  }

  factory CreditNoteRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CreditNoteRow(
      id: serializer.fromJson<int>(json['id']),
      noteNo: serializer.fromJson<String>(json['noteNo']),
      fyStart: serializer.fromJson<int>(json['fyStart']),
      sequence: serializer.fromJson<int>(json['sequence']),
      billId: serializer.fromJson<int>(json['billId']),
      issuedAt: serializer.fromJson<DateTime>(json['issuedAt']),
      reason: serializer.fromJson<String?>(json['reason']),
      taxablePaise: serializer.fromJson<int>(json['taxablePaise']),
      taxPaise: serializer.fromJson<int>(json['taxPaise']),
      totalPaise: serializer.fromJson<int>(json['totalPaise']),
      refundMode: serializer.fromJson<String>(json['refundMode']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'noteNo': serializer.toJson<String>(noteNo),
      'fyStart': serializer.toJson<int>(fyStart),
      'sequence': serializer.toJson<int>(sequence),
      'billId': serializer.toJson<int>(billId),
      'issuedAt': serializer.toJson<DateTime>(issuedAt),
      'reason': serializer.toJson<String?>(reason),
      'taxablePaise': serializer.toJson<int>(taxablePaise),
      'taxPaise': serializer.toJson<int>(taxPaise),
      'totalPaise': serializer.toJson<int>(totalPaise),
      'refundMode': serializer.toJson<String>(refundMode),
    };
  }

  CreditNoteRow copyWith({
    int? id,
    String? noteNo,
    int? fyStart,
    int? sequence,
    int? billId,
    DateTime? issuedAt,
    Value<String?> reason = const Value.absent(),
    int? taxablePaise,
    int? taxPaise,
    int? totalPaise,
    String? refundMode,
  }) => CreditNoteRow(
    id: id ?? this.id,
    noteNo: noteNo ?? this.noteNo,
    fyStart: fyStart ?? this.fyStart,
    sequence: sequence ?? this.sequence,
    billId: billId ?? this.billId,
    issuedAt: issuedAt ?? this.issuedAt,
    reason: reason.present ? reason.value : this.reason,
    taxablePaise: taxablePaise ?? this.taxablePaise,
    taxPaise: taxPaise ?? this.taxPaise,
    totalPaise: totalPaise ?? this.totalPaise,
    refundMode: refundMode ?? this.refundMode,
  );
  CreditNoteRow copyWithCompanion(CreditNotesCompanion data) {
    return CreditNoteRow(
      id: data.id.present ? data.id.value : this.id,
      noteNo: data.noteNo.present ? data.noteNo.value : this.noteNo,
      fyStart: data.fyStart.present ? data.fyStart.value : this.fyStart,
      sequence: data.sequence.present ? data.sequence.value : this.sequence,
      billId: data.billId.present ? data.billId.value : this.billId,
      issuedAt: data.issuedAt.present ? data.issuedAt.value : this.issuedAt,
      reason: data.reason.present ? data.reason.value : this.reason,
      taxablePaise: data.taxablePaise.present
          ? data.taxablePaise.value
          : this.taxablePaise,
      taxPaise: data.taxPaise.present ? data.taxPaise.value : this.taxPaise,
      totalPaise: data.totalPaise.present
          ? data.totalPaise.value
          : this.totalPaise,
      refundMode: data.refundMode.present
          ? data.refundMode.value
          : this.refundMode,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CreditNoteRow(')
          ..write('id: $id, ')
          ..write('noteNo: $noteNo, ')
          ..write('fyStart: $fyStart, ')
          ..write('sequence: $sequence, ')
          ..write('billId: $billId, ')
          ..write('issuedAt: $issuedAt, ')
          ..write('reason: $reason, ')
          ..write('taxablePaise: $taxablePaise, ')
          ..write('taxPaise: $taxPaise, ')
          ..write('totalPaise: $totalPaise, ')
          ..write('refundMode: $refundMode')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    noteNo,
    fyStart,
    sequence,
    billId,
    issuedAt,
    reason,
    taxablePaise,
    taxPaise,
    totalPaise,
    refundMode,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CreditNoteRow &&
          other.id == this.id &&
          other.noteNo == this.noteNo &&
          other.fyStart == this.fyStart &&
          other.sequence == this.sequence &&
          other.billId == this.billId &&
          other.issuedAt == this.issuedAt &&
          other.reason == this.reason &&
          other.taxablePaise == this.taxablePaise &&
          other.taxPaise == this.taxPaise &&
          other.totalPaise == this.totalPaise &&
          other.refundMode == this.refundMode);
}

class CreditNotesCompanion extends UpdateCompanion<CreditNoteRow> {
  final Value<int> id;
  final Value<String> noteNo;
  final Value<int> fyStart;
  final Value<int> sequence;
  final Value<int> billId;
  final Value<DateTime> issuedAt;
  final Value<String?> reason;
  final Value<int> taxablePaise;
  final Value<int> taxPaise;
  final Value<int> totalPaise;
  final Value<String> refundMode;
  const CreditNotesCompanion({
    this.id = const Value.absent(),
    this.noteNo = const Value.absent(),
    this.fyStart = const Value.absent(),
    this.sequence = const Value.absent(),
    this.billId = const Value.absent(),
    this.issuedAt = const Value.absent(),
    this.reason = const Value.absent(),
    this.taxablePaise = const Value.absent(),
    this.taxPaise = const Value.absent(),
    this.totalPaise = const Value.absent(),
    this.refundMode = const Value.absent(),
  });
  CreditNotesCompanion.insert({
    this.id = const Value.absent(),
    required String noteNo,
    required int fyStart,
    required int sequence,
    required int billId,
    required DateTime issuedAt,
    this.reason = const Value.absent(),
    required int taxablePaise,
    required int taxPaise,
    required int totalPaise,
    required String refundMode,
  }) : noteNo = Value(noteNo),
       fyStart = Value(fyStart),
       sequence = Value(sequence),
       billId = Value(billId),
       issuedAt = Value(issuedAt),
       taxablePaise = Value(taxablePaise),
       taxPaise = Value(taxPaise),
       totalPaise = Value(totalPaise),
       refundMode = Value(refundMode);
  static Insertable<CreditNoteRow> custom({
    Expression<int>? id,
    Expression<String>? noteNo,
    Expression<int>? fyStart,
    Expression<int>? sequence,
    Expression<int>? billId,
    Expression<DateTime>? issuedAt,
    Expression<String>? reason,
    Expression<int>? taxablePaise,
    Expression<int>? taxPaise,
    Expression<int>? totalPaise,
    Expression<String>? refundMode,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (noteNo != null) 'note_no': noteNo,
      if (fyStart != null) 'fy_start': fyStart,
      if (sequence != null) 'sequence': sequence,
      if (billId != null) 'bill_id': billId,
      if (issuedAt != null) 'issued_at': issuedAt,
      if (reason != null) 'reason': reason,
      if (taxablePaise != null) 'taxable_paise': taxablePaise,
      if (taxPaise != null) 'tax_paise': taxPaise,
      if (totalPaise != null) 'total_paise': totalPaise,
      if (refundMode != null) 'refund_mode': refundMode,
    });
  }

  CreditNotesCompanion copyWith({
    Value<int>? id,
    Value<String>? noteNo,
    Value<int>? fyStart,
    Value<int>? sequence,
    Value<int>? billId,
    Value<DateTime>? issuedAt,
    Value<String?>? reason,
    Value<int>? taxablePaise,
    Value<int>? taxPaise,
    Value<int>? totalPaise,
    Value<String>? refundMode,
  }) {
    return CreditNotesCompanion(
      id: id ?? this.id,
      noteNo: noteNo ?? this.noteNo,
      fyStart: fyStart ?? this.fyStart,
      sequence: sequence ?? this.sequence,
      billId: billId ?? this.billId,
      issuedAt: issuedAt ?? this.issuedAt,
      reason: reason ?? this.reason,
      taxablePaise: taxablePaise ?? this.taxablePaise,
      taxPaise: taxPaise ?? this.taxPaise,
      totalPaise: totalPaise ?? this.totalPaise,
      refundMode: refundMode ?? this.refundMode,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (noteNo.present) {
      map['note_no'] = Variable<String>(noteNo.value);
    }
    if (fyStart.present) {
      map['fy_start'] = Variable<int>(fyStart.value);
    }
    if (sequence.present) {
      map['sequence'] = Variable<int>(sequence.value);
    }
    if (billId.present) {
      map['bill_id'] = Variable<int>(billId.value);
    }
    if (issuedAt.present) {
      map['issued_at'] = Variable<DateTime>(issuedAt.value);
    }
    if (reason.present) {
      map['reason'] = Variable<String>(reason.value);
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
    if (refundMode.present) {
      map['refund_mode'] = Variable<String>(refundMode.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CreditNotesCompanion(')
          ..write('id: $id, ')
          ..write('noteNo: $noteNo, ')
          ..write('fyStart: $fyStart, ')
          ..write('sequence: $sequence, ')
          ..write('billId: $billId, ')
          ..write('issuedAt: $issuedAt, ')
          ..write('reason: $reason, ')
          ..write('taxablePaise: $taxablePaise, ')
          ..write('taxPaise: $taxPaise, ')
          ..write('totalPaise: $totalPaise, ')
          ..write('refundMode: $refundMode')
          ..write(')'))
        .toString();
  }
}

class $CreditNoteLinesTable extends CreditNoteLines
    with TableInfo<$CreditNoteLinesTable, CreditNoteLineRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CreditNoteLinesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _creditNoteIdMeta = const VerificationMeta(
    'creditNoteId',
  );
  @override
  late final GeneratedColumn<int> creditNoteId = GeneratedColumn<int>(
    'credit_note_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES credit_notes (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _billLineIdMeta = const VerificationMeta(
    'billLineId',
  );
  @override
  late final GeneratedColumn<int> billLineId = GeneratedColumn<int>(
    'bill_line_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES bill_lines (id)',
    ),
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
    creditNoteId,
    billLineId,
    quantityMilli,
    taxablePaise,
    taxPaise,
    totalPaise,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'credit_note_lines';
  @override
  VerificationContext validateIntegrity(
    Insertable<CreditNoteLineRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('credit_note_id')) {
      context.handle(
        _creditNoteIdMeta,
        creditNoteId.isAcceptableOrUnknown(
          data['credit_note_id']!,
          _creditNoteIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_creditNoteIdMeta);
    }
    if (data.containsKey('bill_line_id')) {
      context.handle(
        _billLineIdMeta,
        billLineId.isAcceptableOrUnknown(
          data['bill_line_id']!,
          _billLineIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_billLineIdMeta);
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
  CreditNoteLineRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CreditNoteLineRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      creditNoteId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}credit_note_id'],
      )!,
      billLineId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}bill_line_id'],
      )!,
      quantityMilli: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quantity_milli'],
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
  $CreditNoteLinesTable createAlias(String alias) {
    return $CreditNoteLinesTable(attachedDatabase, alias);
  }
}

class CreditNoteLineRow extends DataClass
    implements Insertable<CreditNoteLineRow> {
  final int id;
  final int creditNoteId;
  final int billLineId;
  final int quantityMilli;
  final int taxablePaise;
  final int taxPaise;
  final int totalPaise;
  const CreditNoteLineRow({
    required this.id,
    required this.creditNoteId,
    required this.billLineId,
    required this.quantityMilli,
    required this.taxablePaise,
    required this.taxPaise,
    required this.totalPaise,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['credit_note_id'] = Variable<int>(creditNoteId);
    map['bill_line_id'] = Variable<int>(billLineId);
    map['quantity_milli'] = Variable<int>(quantityMilli);
    map['taxable_paise'] = Variable<int>(taxablePaise);
    map['tax_paise'] = Variable<int>(taxPaise);
    map['total_paise'] = Variable<int>(totalPaise);
    return map;
  }

  CreditNoteLinesCompanion toCompanion(bool nullToAbsent) {
    return CreditNoteLinesCompanion(
      id: Value(id),
      creditNoteId: Value(creditNoteId),
      billLineId: Value(billLineId),
      quantityMilli: Value(quantityMilli),
      taxablePaise: Value(taxablePaise),
      taxPaise: Value(taxPaise),
      totalPaise: Value(totalPaise),
    );
  }

  factory CreditNoteLineRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CreditNoteLineRow(
      id: serializer.fromJson<int>(json['id']),
      creditNoteId: serializer.fromJson<int>(json['creditNoteId']),
      billLineId: serializer.fromJson<int>(json['billLineId']),
      quantityMilli: serializer.fromJson<int>(json['quantityMilli']),
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
      'creditNoteId': serializer.toJson<int>(creditNoteId),
      'billLineId': serializer.toJson<int>(billLineId),
      'quantityMilli': serializer.toJson<int>(quantityMilli),
      'taxablePaise': serializer.toJson<int>(taxablePaise),
      'taxPaise': serializer.toJson<int>(taxPaise),
      'totalPaise': serializer.toJson<int>(totalPaise),
    };
  }

  CreditNoteLineRow copyWith({
    int? id,
    int? creditNoteId,
    int? billLineId,
    int? quantityMilli,
    int? taxablePaise,
    int? taxPaise,
    int? totalPaise,
  }) => CreditNoteLineRow(
    id: id ?? this.id,
    creditNoteId: creditNoteId ?? this.creditNoteId,
    billLineId: billLineId ?? this.billLineId,
    quantityMilli: quantityMilli ?? this.quantityMilli,
    taxablePaise: taxablePaise ?? this.taxablePaise,
    taxPaise: taxPaise ?? this.taxPaise,
    totalPaise: totalPaise ?? this.totalPaise,
  );
  CreditNoteLineRow copyWithCompanion(CreditNoteLinesCompanion data) {
    return CreditNoteLineRow(
      id: data.id.present ? data.id.value : this.id,
      creditNoteId: data.creditNoteId.present
          ? data.creditNoteId.value
          : this.creditNoteId,
      billLineId: data.billLineId.present
          ? data.billLineId.value
          : this.billLineId,
      quantityMilli: data.quantityMilli.present
          ? data.quantityMilli.value
          : this.quantityMilli,
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
    return (StringBuffer('CreditNoteLineRow(')
          ..write('id: $id, ')
          ..write('creditNoteId: $creditNoteId, ')
          ..write('billLineId: $billLineId, ')
          ..write('quantityMilli: $quantityMilli, ')
          ..write('taxablePaise: $taxablePaise, ')
          ..write('taxPaise: $taxPaise, ')
          ..write('totalPaise: $totalPaise')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    creditNoteId,
    billLineId,
    quantityMilli,
    taxablePaise,
    taxPaise,
    totalPaise,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CreditNoteLineRow &&
          other.id == this.id &&
          other.creditNoteId == this.creditNoteId &&
          other.billLineId == this.billLineId &&
          other.quantityMilli == this.quantityMilli &&
          other.taxablePaise == this.taxablePaise &&
          other.taxPaise == this.taxPaise &&
          other.totalPaise == this.totalPaise);
}

class CreditNoteLinesCompanion extends UpdateCompanion<CreditNoteLineRow> {
  final Value<int> id;
  final Value<int> creditNoteId;
  final Value<int> billLineId;
  final Value<int> quantityMilli;
  final Value<int> taxablePaise;
  final Value<int> taxPaise;
  final Value<int> totalPaise;
  const CreditNoteLinesCompanion({
    this.id = const Value.absent(),
    this.creditNoteId = const Value.absent(),
    this.billLineId = const Value.absent(),
    this.quantityMilli = const Value.absent(),
    this.taxablePaise = const Value.absent(),
    this.taxPaise = const Value.absent(),
    this.totalPaise = const Value.absent(),
  });
  CreditNoteLinesCompanion.insert({
    this.id = const Value.absent(),
    required int creditNoteId,
    required int billLineId,
    required int quantityMilli,
    required int taxablePaise,
    required int taxPaise,
    required int totalPaise,
  }) : creditNoteId = Value(creditNoteId),
       billLineId = Value(billLineId),
       quantityMilli = Value(quantityMilli),
       taxablePaise = Value(taxablePaise),
       taxPaise = Value(taxPaise),
       totalPaise = Value(totalPaise);
  static Insertable<CreditNoteLineRow> custom({
    Expression<int>? id,
    Expression<int>? creditNoteId,
    Expression<int>? billLineId,
    Expression<int>? quantityMilli,
    Expression<int>? taxablePaise,
    Expression<int>? taxPaise,
    Expression<int>? totalPaise,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (creditNoteId != null) 'credit_note_id': creditNoteId,
      if (billLineId != null) 'bill_line_id': billLineId,
      if (quantityMilli != null) 'quantity_milli': quantityMilli,
      if (taxablePaise != null) 'taxable_paise': taxablePaise,
      if (taxPaise != null) 'tax_paise': taxPaise,
      if (totalPaise != null) 'total_paise': totalPaise,
    });
  }

  CreditNoteLinesCompanion copyWith({
    Value<int>? id,
    Value<int>? creditNoteId,
    Value<int>? billLineId,
    Value<int>? quantityMilli,
    Value<int>? taxablePaise,
    Value<int>? taxPaise,
    Value<int>? totalPaise,
  }) {
    return CreditNoteLinesCompanion(
      id: id ?? this.id,
      creditNoteId: creditNoteId ?? this.creditNoteId,
      billLineId: billLineId ?? this.billLineId,
      quantityMilli: quantityMilli ?? this.quantityMilli,
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
    if (creditNoteId.present) {
      map['credit_note_id'] = Variable<int>(creditNoteId.value);
    }
    if (billLineId.present) {
      map['bill_line_id'] = Variable<int>(billLineId.value);
    }
    if (quantityMilli.present) {
      map['quantity_milli'] = Variable<int>(quantityMilli.value);
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
    return (StringBuffer('CreditNoteLinesCompanion(')
          ..write('id: $id, ')
          ..write('creditNoteId: $creditNoteId, ')
          ..write('billLineId: $billLineId, ')
          ..write('quantityMilli: $quantityMilli, ')
          ..write('taxablePaise: $taxablePaise, ')
          ..write('taxPaise: $taxPaise, ')
          ..write('totalPaise: $totalPaise')
          ..write(')'))
        .toString();
  }
}

class $CreditNoteCountersTable extends CreditNoteCounters
    with TableInfo<$CreditNoteCountersTable, CreditNoteCounter> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CreditNoteCountersTable(this.attachedDatabase, [this._alias]);
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
  static const String $name = 'credit_note_counters';
  @override
  VerificationContext validateIntegrity(
    Insertable<CreditNoteCounter> instance, {
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
  CreditNoteCounter map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CreditNoteCounter(
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
  $CreditNoteCountersTable createAlias(String alias) {
    return $CreditNoteCountersTable(attachedDatabase, alias);
  }
}

class CreditNoteCounter extends DataClass
    implements Insertable<CreditNoteCounter> {
  final int fyStart;
  final int lastSequence;
  const CreditNoteCounter({required this.fyStart, required this.lastSequence});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['fy_start'] = Variable<int>(fyStart);
    map['last_sequence'] = Variable<int>(lastSequence);
    return map;
  }

  CreditNoteCountersCompanion toCompanion(bool nullToAbsent) {
    return CreditNoteCountersCompanion(
      fyStart: Value(fyStart),
      lastSequence: Value(lastSequence),
    );
  }

  factory CreditNoteCounter.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CreditNoteCounter(
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

  CreditNoteCounter copyWith({int? fyStart, int? lastSequence}) =>
      CreditNoteCounter(
        fyStart: fyStart ?? this.fyStart,
        lastSequence: lastSequence ?? this.lastSequence,
      );
  CreditNoteCounter copyWithCompanion(CreditNoteCountersCompanion data) {
    return CreditNoteCounter(
      fyStart: data.fyStart.present ? data.fyStart.value : this.fyStart,
      lastSequence: data.lastSequence.present
          ? data.lastSequence.value
          : this.lastSequence,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CreditNoteCounter(')
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
      (other is CreditNoteCounter &&
          other.fyStart == this.fyStart &&
          other.lastSequence == this.lastSequence);
}

class CreditNoteCountersCompanion extends UpdateCompanion<CreditNoteCounter> {
  final Value<int> fyStart;
  final Value<int> lastSequence;
  const CreditNoteCountersCompanion({
    this.fyStart = const Value.absent(),
    this.lastSequence = const Value.absent(),
  });
  CreditNoteCountersCompanion.insert({
    this.fyStart = const Value.absent(),
    required int lastSequence,
  }) : lastSequence = Value(lastSequence);
  static Insertable<CreditNoteCounter> custom({
    Expression<int>? fyStart,
    Expression<int>? lastSequence,
  }) {
    return RawValuesInsertable({
      if (fyStart != null) 'fy_start': fyStart,
      if (lastSequence != null) 'last_sequence': lastSequence,
    });
  }

  CreditNoteCountersCompanion copyWith({
    Value<int>? fyStart,
    Value<int>? lastSequence,
  }) {
    return CreditNoteCountersCompanion(
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
    return (StringBuffer('CreditNoteCountersCompanion(')
          ..write('fyStart: $fyStart, ')
          ..write('lastSequence: $lastSequence')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ShopProfilesTable shopProfiles = $ShopProfilesTable(this);
  late final $CategoriesTable categories = $CategoriesTable(this);
  late final $ItemsTable items = $ItemsTable(this);
  late final $PartiesTable parties = $PartiesTable(this);
  late final $BillsTable bills = $BillsTable(this);
  late final $BillLinesTable billLines = $BillLinesTable(this);
  late final $InvoiceCountersTable invoiceCounters = $InvoiceCountersTable(
    this,
  );
  late final $AppSettingsTable appSettings = $AppSettingsTable(this);
  late final $ItemBatchesTable itemBatches = $ItemBatchesTable(this);
  late final $StockMovementsTable stockMovements = $StockMovementsTable(this);
  late final $PartyEntriesTable partyEntries = $PartyEntriesTable(this);
  late final $PurchasesTable purchases = $PurchasesTable(this);
  late final $PurchaseLinesTable purchaseLines = $PurchaseLinesTable(this);
  late final $ExpensesTable expenses = $ExpensesTable(this);
  late final $CreditNotesTable creditNotes = $CreditNotesTable(this);
  late final $CreditNoteLinesTable creditNoteLines = $CreditNoteLinesTable(
    this,
  );
  late final $CreditNoteCountersTable creditNoteCounters =
      $CreditNoteCountersTable(this);
  late final Index itemsName = Index(
    'items_name',
    'CREATE INDEX items_name ON items (name)',
  );
  late final Index billsBilledAt = Index(
    'bills_billed_at',
    'CREATE INDEX bills_billed_at ON bills (billed_at)',
  );
  late final Index movementsItem = Index(
    'movements_item',
    'CREATE INDEX movements_item ON stock_movements (item_id, at)',
  );
  late final Index partiesName = Index(
    'parties_name',
    'CREATE INDEX parties_name ON parties (name)',
  );
  late final Index partyEntriesParty = Index(
    'party_entries_party',
    'CREATE INDEX party_entries_party ON party_entries (party_id, at)',
  );
  late final Index purchasesDate = Index(
    'purchases_date',
    'CREATE INDEX purchases_date ON purchases (purchased_at)',
  );
  late final Index expensesDate = Index(
    'expenses_date',
    'CREATE INDEX expenses_date ON expenses (spent_at)',
  );
  late final Index creditNotesDate = Index(
    'credit_notes_date',
    'CREATE INDEX credit_notes_date ON credit_notes (issued_at)',
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    shopProfiles,
    categories,
    items,
    parties,
    bills,
    billLines,
    invoiceCounters,
    appSettings,
    itemBatches,
    stockMovements,
    partyEntries,
    purchases,
    purchaseLines,
    expenses,
    creditNotes,
    creditNoteLines,
    creditNoteCounters,
    itemsName,
    billsBilledAt,
    movementsItem,
    partiesName,
    partyEntriesParty,
    purchasesDate,
    expensesDate,
    creditNotesDate,
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
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'purchases',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('purchase_lines', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'credit_notes',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('credit_note_lines', kind: UpdateKind.delete)],
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
typedef $$CategoriesTableCreateCompanionBuilder = CategoriesCompanion Function({
  Value<int> id,
  required String name,
  Value<int?> parentId,
});
typedef $$CategoriesTableUpdateCompanionBuilder = CategoriesCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<int?> parentId,
});

final class $$CategoriesTableReferences
    extends BaseReferences<_$AppDatabase, $CategoriesTable, CategoryRow> {
  $$CategoriesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CategoriesTable _parentIdTable(_$AppDatabase db) =>
      db.categories.createAlias('categories__parent_id__categories__id');

  $$CategoriesTableProcessedTableManager? get parentId {
    final $_column = $_itemColumn<int>('parent_id');
    if ($_column == null) return null;
    final manager = $$CategoriesTableTableManager(
      $_db,
      $_db.categories,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_parentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$ItemsTable, List<ItemRow>> _itemsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.items,
    aliasName: 'categories__id__items__category_id',
  );

  $$ItemsTableProcessedTableManager get itemsRefs {
    final manager = $$ItemsTableTableManager(
      $_db,
      $_db.items,
    ).filter((f) => f.categoryId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_itemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableFilterComposer({
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

  $$CategoriesTableFilterComposer get parentId {
    final $$CategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.parentId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableFilterComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> itemsRefs(
    Expression<bool> Function($$ItemsTableFilterComposer f) f,
  ) {
    final $$ItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.items,
      getReferencedColumn: (t) => t.categoryId,
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
    return f(composer);
  }
}

class $$CategoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableOrderingComposer({
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

  $$CategoriesTableOrderingComposer get parentId {
    final $$CategoriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.parentId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableOrderingComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CategoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableAnnotationComposer({
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

  $$CategoriesTableAnnotationComposer get parentId {
    final $$CategoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.parentId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> itemsRefs<T extends Object>(
    Expression<T> Function($$ItemsTableAnnotationComposer a) f,
  ) {
    final $$ItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.items,
      getReferencedColumn: (t) => t.categoryId,
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
    return f(composer);
  }
}

class $$CategoriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CategoriesTable,
          CategoryRow,
          $$CategoriesTableFilterComposer,
          $$CategoriesTableOrderingComposer,
          $$CategoriesTableAnnotationComposer,
          $$CategoriesTableCreateCompanionBuilder,
          $$CategoriesTableUpdateCompanionBuilder,
          (CategoryRow, $$CategoriesTableReferences),
          CategoryRow,
          PrefetchHooks Function({bool parentId, bool itemsRefs})
        > {
  $$CategoriesTableTableManager(_$AppDatabase db, $CategoriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CategoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<int?> parentId = const Value.absent(),
          }) => CategoriesCompanion(id: id, name: name, parentId: parentId),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<int?> parentId = const Value.absent(),
              }) => CategoriesCompanion.insert(
                id: id,
                name: name,
                parentId: parentId,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CategoriesTable, CategoryRow>(table),
                  $$CategoriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({parentId = false, itemsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (itemsRefs) db.items],
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
                    if (parentId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.parentId,
                        referencedTable: $$CategoriesTableReferences
                            ._parentIdTable(db),
                        referencedColumn: $$CategoriesTableReferences
                            ._parentIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (itemsRefs)
                    await $_getPrefetchedDataByColumns<
                      CategoryRow,
                      $CategoriesTable,
                      ItemRow,
                      $ItemsTable
                    >(
                      currentTable: table,
                      referencedTable: $$CategoriesTableReferences
                          ._itemsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$CategoriesTableReferences(db, table, p0).itemsRefs,
                      currentColumn: 'id',
                      referencedColumn: 'category_id',
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$CategoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CategoriesTable,
      CategoryRow,
      $$CategoriesTableFilterComposer,
      $$CategoriesTableOrderingComposer,
      $$CategoriesTableAnnotationComposer,
      $$CategoriesTableCreateCompanionBuilder,
      $$CategoriesTableUpdateCompanionBuilder,
      (CategoryRow, $$CategoriesTableReferences),
      CategoryRow,
      PrefetchHooks Function({bool parentId, bool itemsRefs})
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
  Value<bool> trackStock,
  Value<int> stockMilli,
  Value<int?> lowStockMilli,
  Value<int?> categoryId,
  Value<String?> imagePath,
  Value<bool> tracksBatches,
  Value<String?> altUnit,
  Value<int?> altUnitFactorMilli,
  Value<int?> altUnitPricePaise,
  Value<int?> costPricePaise,
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
  Value<bool> trackStock,
  Value<int> stockMilli,
  Value<int?> lowStockMilli,
  Value<int?> categoryId,
  Value<String?> imagePath,
  Value<bool> tracksBatches,
  Value<String?> altUnit,
  Value<int?> altUnitFactorMilli,
  Value<int?> altUnitPricePaise,
  Value<int?> costPricePaise,
});

final class $$ItemsTableReferences
    extends BaseReferences<_$AppDatabase, $ItemsTable, ItemRow> {
  $$ItemsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CategoriesTable _categoryIdTable(_$AppDatabase db) =>
      db.categories.createAlias('items__category_id__categories__id');

  $$CategoriesTableProcessedTableManager? get categoryId {
    final $_column = $_itemColumn<int>('category_id');
    if ($_column == null) return null;
    final manager = $$CategoriesTableTableManager(
      $_db,
      $_db.categories,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

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

  static MultiTypedResultKey<$ItemBatchesTable, List<BatchRow>>
  _itemBatchesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.itemBatches,
    aliasName: 'items__id__item_batches__item_id',
  );

  $$ItemBatchesTableProcessedTableManager get itemBatchesRefs {
    final manager = $$ItemBatchesTableTableManager(
      $_db,
      $_db.itemBatches,
    ).filter((f) => f.itemId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_itemBatchesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$StockMovementsTable, List<MovementRow>>
  _stockMovementsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.stockMovements,
    aliasName: 'items__id__stock_movements__item_id',
  );

  $$StockMovementsTableProcessedTableManager get stockMovementsRefs {
    final manager = $$StockMovementsTableTableManager(
      $_db,
      $_db.stockMovements,
    ).filter((f) => f.itemId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_stockMovementsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$PurchaseLinesTable, List<PurchaseLineRow>>
  _purchaseLinesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.purchaseLines,
    aliasName: 'items__id__purchase_lines__item_id',
  );

  $$PurchaseLinesTableProcessedTableManager get purchaseLinesRefs {
    final manager = $$PurchaseLinesTableTableManager(
      $_db,
      $_db.purchaseLines,
    ).filter((f) => f.itemId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_purchaseLinesRefsTable($_db));
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

  ColumnFilters<bool> get trackStock => $composableBuilder(
    column: $table.trackStock,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get stockMilli => $composableBuilder(
    column: $table.stockMilli,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lowStockMilli => $composableBuilder(
    column: $table.lowStockMilli,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imagePath => $composableBuilder(
    column: $table.imagePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get tracksBatches => $composableBuilder(
    column: $table.tracksBatches,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get altUnit => $composableBuilder(
    column: $table.altUnit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get altUnitFactorMilli => $composableBuilder(
    column: $table.altUnitFactorMilli,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get altUnitPricePaise => $composableBuilder(
    column: $table.altUnitPricePaise,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get costPricePaise => $composableBuilder(
    column: $table.costPricePaise,
    builder: (column) => ColumnFilters(column),
  );

  $$CategoriesTableFilterComposer get categoryId {
    final $$CategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableFilterComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

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

  Expression<bool> itemBatchesRefs(
    Expression<bool> Function($$ItemBatchesTableFilterComposer f) f,
  ) {
    final $$ItemBatchesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.itemBatches,
      getReferencedColumn: (t) => t.itemId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemBatchesTableFilterComposer(
            $db: $db,
            $table: $db.itemBatches,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> stockMovementsRefs(
    Expression<bool> Function($$StockMovementsTableFilterComposer f) f,
  ) {
    final $$StockMovementsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.stockMovements,
      getReferencedColumn: (t) => t.itemId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StockMovementsTableFilterComposer(
            $db: $db,
            $table: $db.stockMovements,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> purchaseLinesRefs(
    Expression<bool> Function($$PurchaseLinesTableFilterComposer f) f,
  ) {
    final $$PurchaseLinesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.purchaseLines,
      getReferencedColumn: (t) => t.itemId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PurchaseLinesTableFilterComposer(
            $db: $db,
            $table: $db.purchaseLines,
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

  ColumnOrderings<bool> get trackStock => $composableBuilder(
    column: $table.trackStock,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get stockMilli => $composableBuilder(
    column: $table.stockMilli,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lowStockMilli => $composableBuilder(
    column: $table.lowStockMilli,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imagePath => $composableBuilder(
    column: $table.imagePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get tracksBatches => $composableBuilder(
    column: $table.tracksBatches,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get altUnit => $composableBuilder(
    column: $table.altUnit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get altUnitFactorMilli => $composableBuilder(
    column: $table.altUnitFactorMilli,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get altUnitPricePaise => $composableBuilder(
    column: $table.altUnitPricePaise,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get costPricePaise => $composableBuilder(
    column: $table.costPricePaise,
    builder: (column) => ColumnOrderings(column),
  );

  $$CategoriesTableOrderingComposer get categoryId {
    final $$CategoriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableOrderingComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
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

  GeneratedColumn<bool> get trackStock => $composableBuilder(
    column: $table.trackStock,
    builder: (column) => column,
  );

  GeneratedColumn<int> get stockMilli => $composableBuilder(
    column: $table.stockMilli,
    builder: (column) => column,
  );

  GeneratedColumn<int> get lowStockMilli => $composableBuilder(
    column: $table.lowStockMilli,
    builder: (column) => column,
  );

  GeneratedColumn<String> get imagePath =>
      $composableBuilder(column: $table.imagePath, builder: (column) => column);

  GeneratedColumn<bool> get tracksBatches => $composableBuilder(
    column: $table.tracksBatches,
    builder: (column) => column,
  );

  GeneratedColumn<String> get altUnit =>
      $composableBuilder(column: $table.altUnit, builder: (column) => column);

  GeneratedColumn<int> get altUnitFactorMilli => $composableBuilder(
    column: $table.altUnitFactorMilli,
    builder: (column) => column,
  );

  GeneratedColumn<int> get altUnitPricePaise => $composableBuilder(
    column: $table.altUnitPricePaise,
    builder: (column) => column,
  );

  GeneratedColumn<int> get costPricePaise => $composableBuilder(
    column: $table.costPricePaise,
    builder: (column) => column,
  );

  $$CategoriesTableAnnotationComposer get categoryId {
    final $$CategoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

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

  Expression<T> itemBatchesRefs<T extends Object>(
    Expression<T> Function($$ItemBatchesTableAnnotationComposer a) f,
  ) {
    final $$ItemBatchesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.itemBatches,
      getReferencedColumn: (t) => t.itemId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemBatchesTableAnnotationComposer(
            $db: $db,
            $table: $db.itemBatches,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> stockMovementsRefs<T extends Object>(
    Expression<T> Function($$StockMovementsTableAnnotationComposer a) f,
  ) {
    final $$StockMovementsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.stockMovements,
      getReferencedColumn: (t) => t.itemId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StockMovementsTableAnnotationComposer(
            $db: $db,
            $table: $db.stockMovements,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> purchaseLinesRefs<T extends Object>(
    Expression<T> Function($$PurchaseLinesTableAnnotationComposer a) f,
  ) {
    final $$PurchaseLinesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.purchaseLines,
      getReferencedColumn: (t) => t.itemId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PurchaseLinesTableAnnotationComposer(
            $db: $db,
            $table: $db.purchaseLines,
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
          PrefetchHooks Function({
            bool categoryId,
            bool billLinesRefs,
            bool itemBatchesRefs,
            bool stockMovementsRefs,
            bool purchaseLinesRefs,
          })
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
                Value<bool> trackStock = const Value.absent(),
                Value<int> stockMilli = const Value.absent(),
                Value<int?> lowStockMilli = const Value.absent(),
                Value<int?> categoryId = const Value.absent(),
                Value<String?> imagePath = const Value.absent(),
                Value<bool> tracksBatches = const Value.absent(),
                Value<String?> altUnit = const Value.absent(),
                Value<int?> altUnitFactorMilli = const Value.absent(),
                Value<int?> altUnitPricePaise = const Value.absent(),
                Value<int?> costPricePaise = const Value.absent(),
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
                trackStock: trackStock,
                stockMilli: stockMilli,
                lowStockMilli: lowStockMilli,
                categoryId: categoryId,
                imagePath: imagePath,
                tracksBatches: tracksBatches,
                altUnit: altUnit,
                altUnitFactorMilli: altUnitFactorMilli,
                altUnitPricePaise: altUnitPricePaise,
                costPricePaise: costPricePaise,
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
                Value<bool> trackStock = const Value.absent(),
                Value<int> stockMilli = const Value.absent(),
                Value<int?> lowStockMilli = const Value.absent(),
                Value<int?> categoryId = const Value.absent(),
                Value<String?> imagePath = const Value.absent(),
                Value<bool> tracksBatches = const Value.absent(),
                Value<String?> altUnit = const Value.absent(),
                Value<int?> altUnitFactorMilli = const Value.absent(),
                Value<int?> altUnitPricePaise = const Value.absent(),
                Value<int?> costPricePaise = const Value.absent(),
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
                trackStock: trackStock,
                stockMilli: stockMilli,
                lowStockMilli: lowStockMilli,
                categoryId: categoryId,
                imagePath: imagePath,
                tracksBatches: tracksBatches,
                altUnit: altUnit,
                altUnitFactorMilli: altUnitFactorMilli,
                altUnitPricePaise: altUnitPricePaise,
                costPricePaise: costPricePaise,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ItemsTable, ItemRow>(table),
                  $$ItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                categoryId = false,
                billLinesRefs = false,
                itemBatchesRefs = false,
                stockMovementsRefs = false,
                purchaseLinesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (billLinesRefs) db.billLines,
                    if (itemBatchesRefs) db.itemBatches,
                    if (stockMovementsRefs) db.stockMovements,
                    if (purchaseLinesRefs) db.purchaseLines,
                  ],
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
                        if (categoryId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.categoryId,
                            referencedTable: $$ItemsTableReferences
                                ._categoryIdTable(db),
                            referencedColumn: $$ItemsTableReferences
                                ._categoryIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
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
                              $$ItemsTableReferences(
                                db,
                                table,
                                p0,
                              ).billLinesRefs,
                          currentColumn: 'id',
                          referencedColumn: 'item_id',
                          typedResults: items,
                        ),
                      if (itemBatchesRefs)
                        await $_getPrefetchedDataByColumns<
                          ItemRow,
                          $ItemsTable,
                          BatchRow,
                          $ItemBatchesTable
                        >(
                          currentTable: table,
                          referencedTable: $$ItemsTableReferences
                              ._itemBatchesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ItemsTableReferences(
                                db,
                                table,
                                p0,
                              ).itemBatchesRefs,
                          currentColumn: 'id',
                          referencedColumn: 'item_id',
                          typedResults: items,
                        ),
                      if (stockMovementsRefs)
                        await $_getPrefetchedDataByColumns<
                          ItemRow,
                          $ItemsTable,
                          MovementRow,
                          $StockMovementsTable
                        >(
                          currentTable: table,
                          referencedTable: $$ItemsTableReferences
                              ._stockMovementsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ItemsTableReferences(
                                db,
                                table,
                                p0,
                              ).stockMovementsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'item_id',
                          typedResults: items,
                        ),
                      if (purchaseLinesRefs)
                        await $_getPrefetchedDataByColumns<
                          ItemRow,
                          $ItemsTable,
                          PurchaseLineRow,
                          $PurchaseLinesTable
                        >(
                          currentTable: table,
                          referencedTable: $$ItemsTableReferences
                              ._purchaseLinesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ItemsTableReferences(
                                db,
                                table,
                                p0,
                              ).purchaseLinesRefs,
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
      PrefetchHooks Function({
        bool categoryId,
        bool billLinesRefs,
        bool itemBatchesRefs,
        bool stockMovementsRefs,
        bool purchaseLinesRefs,
      })
    >;
typedef $$PartiesTableCreateCompanionBuilder = PartiesCompanion Function({
  Value<int> id,
  Value<String> type,
  required String name,
  Value<String?> phone,
  Value<String?> addressLine,
  Value<String?> gstin,
  Value<String?> notes,
  Value<String?> stateCode,
  Value<int> balancePaise,
  Value<bool> isActive,
  required DateTime createdAt,
  required DateTime updatedAt,
});
typedef $$PartiesTableUpdateCompanionBuilder = PartiesCompanion Function({
  Value<int> id,
  Value<String> type,
  Value<String> name,
  Value<String?> phone,
  Value<String?> addressLine,
  Value<String?> gstin,
  Value<String?> notes,
  Value<String?> stateCode,
  Value<int> balancePaise,
  Value<bool> isActive,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

final class $$PartiesTableReferences
    extends BaseReferences<_$AppDatabase, $PartiesTable, PartyRow> {
  $$PartiesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$BillsTable, List<BillRow>> _billsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.bills,
    aliasName: 'parties__id__bills__party_id',
  );

  $$BillsTableProcessedTableManager get billsRefs {
    final manager = $$BillsTableTableManager(
      $_db,
      $_db.bills,
    ).filter((f) => f.partyId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_billsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$PartyEntriesTable, List<PartyEntryRow>>
  _partyEntriesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.partyEntries,
    aliasName: 'parties__id__party_entries__party_id',
  );

  $$PartyEntriesTableProcessedTableManager get partyEntriesRefs {
    final manager = $$PartyEntriesTableTableManager(
      $_db,
      $_db.partyEntries,
    ).filter((f) => f.partyId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_partyEntriesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$PurchasesTable, List<PurchaseRow>>
  _purchasesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.purchases,
    aliasName: 'parties__id__purchases__party_id',
  );

  $$PurchasesTableProcessedTableManager get purchasesRefs {
    final manager = $$PurchasesTableTableManager(
      $_db,
      $_db.purchases,
    ).filter((f) => f.partyId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_purchasesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PartiesTableFilterComposer
    extends Composer<_$AppDatabase, $PartiesTable> {
  $$PartiesTableFilterComposer({
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

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
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

  ColumnFilters<String> get gstin => $composableBuilder(
    column: $table.gstin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get stateCode => $composableBuilder(
    column: $table.stateCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get balancePaise => $composableBuilder(
    column: $table.balancePaise,
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

  Expression<bool> billsRefs(
    Expression<bool> Function($$BillsTableFilterComposer f) f,
  ) {
    final $$BillsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.bills,
      getReferencedColumn: (t) => t.partyId,
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
    return f(composer);
  }

  Expression<bool> partyEntriesRefs(
    Expression<bool> Function($$PartyEntriesTableFilterComposer f) f,
  ) {
    final $$PartyEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.partyEntries,
      getReferencedColumn: (t) => t.partyId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PartyEntriesTableFilterComposer(
            $db: $db,
            $table: $db.partyEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> purchasesRefs(
    Expression<bool> Function($$PurchasesTableFilterComposer f) f,
  ) {
    final $$PurchasesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.purchases,
      getReferencedColumn: (t) => t.partyId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PurchasesTableFilterComposer(
            $db: $db,
            $table: $db.purchases,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PartiesTableOrderingComposer
    extends Composer<_$AppDatabase, $PartiesTable> {
  $$PartiesTableOrderingComposer({
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

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
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

  ColumnOrderings<String> get gstin => $composableBuilder(
    column: $table.gstin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get stateCode => $composableBuilder(
    column: $table.stateCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get balancePaise => $composableBuilder(
    column: $table.balancePaise,
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

class $$PartiesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PartiesTable> {
  $$PartiesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get addressLine => $composableBuilder(
    column: $table.addressLine,
    builder: (column) => column,
  );

  GeneratedColumn<String> get gstin =>
      $composableBuilder(column: $table.gstin, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get stateCode =>
      $composableBuilder(column: $table.stateCode, builder: (column) => column);

  GeneratedColumn<int> get balancePaise => $composableBuilder(
    column: $table.balancePaise,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> billsRefs<T extends Object>(
    Expression<T> Function($$BillsTableAnnotationComposer a) f,
  ) {
    final $$BillsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.bills,
      getReferencedColumn: (t) => t.partyId,
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
    return f(composer);
  }

  Expression<T> partyEntriesRefs<T extends Object>(
    Expression<T> Function($$PartyEntriesTableAnnotationComposer a) f,
  ) {
    final $$PartyEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.partyEntries,
      getReferencedColumn: (t) => t.partyId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PartyEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.partyEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> purchasesRefs<T extends Object>(
    Expression<T> Function($$PurchasesTableAnnotationComposer a) f,
  ) {
    final $$PurchasesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.purchases,
      getReferencedColumn: (t) => t.partyId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PurchasesTableAnnotationComposer(
            $db: $db,
            $table: $db.purchases,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PartiesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PartiesTable,
          PartyRow,
          $$PartiesTableFilterComposer,
          $$PartiesTableOrderingComposer,
          $$PartiesTableAnnotationComposer,
          $$PartiesTableCreateCompanionBuilder,
          $$PartiesTableUpdateCompanionBuilder,
          (PartyRow, $$PartiesTableReferences),
          PartyRow,
          PrefetchHooks Function({
            bool billsRefs,
            bool partyEntriesRefs,
            bool purchasesRefs,
          })
        > {
  $$PartiesTableTableManager(_$AppDatabase db, $PartiesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PartiesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PartiesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PartiesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> addressLine = const Value.absent(),
                Value<String?> gstin = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> stateCode = const Value.absent(),
                Value<int> balancePaise = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => PartiesCompanion(
                id: id,
                type: type,
                name: name,
                phone: phone,
                addressLine: addressLine,
                gstin: gstin,
                notes: notes,
                stateCode: stateCode,
                balancePaise: balancePaise,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> type = const Value.absent(),
                required String name,
                Value<String?> phone = const Value.absent(),
                Value<String?> addressLine = const Value.absent(),
                Value<String?> gstin = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> stateCode = const Value.absent(),
                Value<int> balancePaise = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
              }) => PartiesCompanion.insert(
                id: id,
                type: type,
                name: name,
                phone: phone,
                addressLine: addressLine,
                gstin: gstin,
                notes: notes,
                stateCode: stateCode,
                balancePaise: balancePaise,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PartiesTable, PartyRow>(table),
                  $$PartiesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                billsRefs = false,
                partyEntriesRefs = false,
                purchasesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (billsRefs) db.bills,
                    if (partyEntriesRefs) db.partyEntries,
                    if (purchasesRefs) db.purchases,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (billsRefs)
                        await $_getPrefetchedDataByColumns<
                          PartyRow,
                          $PartiesTable,
                          BillRow,
                          $BillsTable
                        >(
                          currentTable: table,
                          referencedTable: $$PartiesTableReferences
                              ._billsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PartiesTableReferences(db, table, p0).billsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'party_id',
                          typedResults: items,
                        ),
                      if (partyEntriesRefs)
                        await $_getPrefetchedDataByColumns<
                          PartyRow,
                          $PartiesTable,
                          PartyEntryRow,
                          $PartyEntriesTable
                        >(
                          currentTable: table,
                          referencedTable: $$PartiesTableReferences
                              ._partyEntriesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PartiesTableReferences(
                                db,
                                table,
                                p0,
                              ).partyEntriesRefs,
                          currentColumn: 'id',
                          referencedColumn: 'party_id',
                          typedResults: items,
                        ),
                      if (purchasesRefs)
                        await $_getPrefetchedDataByColumns<
                          PartyRow,
                          $PartiesTable,
                          PurchaseRow,
                          $PurchasesTable
                        >(
                          currentTable: table,
                          referencedTable: $$PartiesTableReferences
                              ._purchasesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PartiesTableReferences(
                                db,
                                table,
                                p0,
                              ).purchasesRefs,
                          currentColumn: 'id',
                          referencedColumn: 'party_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$PartiesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PartiesTable,
      PartyRow,
      $$PartiesTableFilterComposer,
      $$PartiesTableOrderingComposer,
      $$PartiesTableAnnotationComposer,
      $$PartiesTableCreateCompanionBuilder,
      $$PartiesTableUpdateCompanionBuilder,
      (PartyRow, $$PartiesTableReferences),
      PartyRow,
      PrefetchHooks Function({
        bool billsRefs,
        bool partyEntriesRefs,
        bool purchasesRefs,
      })
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
  Value<int?> partyId,
  Value<int> duePaise,
  Value<bool> interState,
  Value<String?> placeOfSupply,
  Value<String?> buyerGstin,
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
  Value<int?> partyId,
  Value<int> duePaise,
  Value<bool> interState,
  Value<String?> placeOfSupply,
  Value<String?> buyerGstin,
});

final class $$BillsTableReferences
    extends BaseReferences<_$AppDatabase, $BillsTable, BillRow> {
  $$BillsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $PartiesTable _partyIdTable(_$AppDatabase db) =>
      db.parties.createAlias('bills__party_id__parties__id');

  $$PartiesTableProcessedTableManager? get partyId {
    final $_column = $_itemColumn<int>('party_id');
    if ($_column == null) return null;
    final manager = $$PartiesTableTableManager(
      $_db,
      $_db.parties,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_partyIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

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

  static MultiTypedResultKey<$StockMovementsTable, List<MovementRow>>
  _stockMovementsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.stockMovements,
    aliasName: 'bills__id__stock_movements__bill_id',
  );

  $$StockMovementsTableProcessedTableManager get stockMovementsRefs {
    final manager = $$StockMovementsTableTableManager(
      $_db,
      $_db.stockMovements,
    ).filter((f) => f.billId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_stockMovementsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$PartyEntriesTable, List<PartyEntryRow>>
  _partyEntriesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.partyEntries,
    aliasName: 'bills__id__party_entries__bill_id',
  );

  $$PartyEntriesTableProcessedTableManager get partyEntriesRefs {
    final manager = $$PartyEntriesTableTableManager(
      $_db,
      $_db.partyEntries,
    ).filter((f) => f.billId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_partyEntriesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$CreditNotesTable, List<CreditNoteRow>>
  _creditNotesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.creditNotes,
    aliasName: 'bills__id__credit_notes__bill_id',
  );

  $$CreditNotesTableProcessedTableManager get creditNotesRefs {
    final manager = $$CreditNotesTableTableManager(
      $_db,
      $_db.creditNotes,
    ).filter((f) => f.billId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_creditNotesRefsTable($_db));
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

  ColumnFilters<int> get duePaise => $composableBuilder(
    column: $table.duePaise,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get interState => $composableBuilder(
    column: $table.interState,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get placeOfSupply => $composableBuilder(
    column: $table.placeOfSupply,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get buyerGstin => $composableBuilder(
    column: $table.buyerGstin,
    builder: (column) => ColumnFilters(column),
  );

  $$PartiesTableFilterComposer get partyId {
    final $$PartiesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.partyId,
      referencedTable: $db.parties,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PartiesTableFilterComposer(
            $db: $db,
            $table: $db.parties,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

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

  Expression<bool> stockMovementsRefs(
    Expression<bool> Function($$StockMovementsTableFilterComposer f) f,
  ) {
    final $$StockMovementsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.stockMovements,
      getReferencedColumn: (t) => t.billId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StockMovementsTableFilterComposer(
            $db: $db,
            $table: $db.stockMovements,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> partyEntriesRefs(
    Expression<bool> Function($$PartyEntriesTableFilterComposer f) f,
  ) {
    final $$PartyEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.partyEntries,
      getReferencedColumn: (t) => t.billId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PartyEntriesTableFilterComposer(
            $db: $db,
            $table: $db.partyEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> creditNotesRefs(
    Expression<bool> Function($$CreditNotesTableFilterComposer f) f,
  ) {
    final $$CreditNotesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.creditNotes,
      getReferencedColumn: (t) => t.billId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CreditNotesTableFilterComposer(
            $db: $db,
            $table: $db.creditNotes,
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

  ColumnOrderings<int> get duePaise => $composableBuilder(
    column: $table.duePaise,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get interState => $composableBuilder(
    column: $table.interState,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get placeOfSupply => $composableBuilder(
    column: $table.placeOfSupply,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get buyerGstin => $composableBuilder(
    column: $table.buyerGstin,
    builder: (column) => ColumnOrderings(column),
  );

  $$PartiesTableOrderingComposer get partyId {
    final $$PartiesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.partyId,
      referencedTable: $db.parties,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PartiesTableOrderingComposer(
            $db: $db,
            $table: $db.parties,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
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

  GeneratedColumn<int> get duePaise =>
      $composableBuilder(column: $table.duePaise, builder: (column) => column);

  GeneratedColumn<bool> get interState => $composableBuilder(
    column: $table.interState,
    builder: (column) => column,
  );

  GeneratedColumn<String> get placeOfSupply => $composableBuilder(
    column: $table.placeOfSupply,
    builder: (column) => column,
  );

  GeneratedColumn<String> get buyerGstin => $composableBuilder(
    column: $table.buyerGstin,
    builder: (column) => column,
  );

  $$PartiesTableAnnotationComposer get partyId {
    final $$PartiesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.partyId,
      referencedTable: $db.parties,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PartiesTableAnnotationComposer(
            $db: $db,
            $table: $db.parties,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

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

  Expression<T> stockMovementsRefs<T extends Object>(
    Expression<T> Function($$StockMovementsTableAnnotationComposer a) f,
  ) {
    final $$StockMovementsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.stockMovements,
      getReferencedColumn: (t) => t.billId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StockMovementsTableAnnotationComposer(
            $db: $db,
            $table: $db.stockMovements,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> partyEntriesRefs<T extends Object>(
    Expression<T> Function($$PartyEntriesTableAnnotationComposer a) f,
  ) {
    final $$PartyEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.partyEntries,
      getReferencedColumn: (t) => t.billId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PartyEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.partyEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> creditNotesRefs<T extends Object>(
    Expression<T> Function($$CreditNotesTableAnnotationComposer a) f,
  ) {
    final $$CreditNotesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.creditNotes,
      getReferencedColumn: (t) => t.billId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CreditNotesTableAnnotationComposer(
            $db: $db,
            $table: $db.creditNotes,
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
          PrefetchHooks Function({
            bool partyId,
            bool billLinesRefs,
            bool stockMovementsRefs,
            bool partyEntriesRefs,
            bool creditNotesRefs,
          })
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
                Value<int?> partyId = const Value.absent(),
                Value<int> duePaise = const Value.absent(),
                Value<bool> interState = const Value.absent(),
                Value<String?> placeOfSupply = const Value.absent(),
                Value<String?> buyerGstin = const Value.absent(),
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
                partyId: partyId,
                duePaise: duePaise,
                interState: interState,
                placeOfSupply: placeOfSupply,
                buyerGstin: buyerGstin,
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
                Value<int?> partyId = const Value.absent(),
                Value<int> duePaise = const Value.absent(),
                Value<bool> interState = const Value.absent(),
                Value<String?> placeOfSupply = const Value.absent(),
                Value<String?> buyerGstin = const Value.absent(),
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
                partyId: partyId,
                duePaise: duePaise,
                interState: interState,
                placeOfSupply: placeOfSupply,
                buyerGstin: buyerGstin,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$BillsTable, BillRow>(table),
                  $$BillsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                partyId = false,
                billLinesRefs = false,
                stockMovementsRefs = false,
                partyEntriesRefs = false,
                creditNotesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (billLinesRefs) db.billLines,
                    if (stockMovementsRefs) db.stockMovements,
                    if (partyEntriesRefs) db.partyEntries,
                    if (creditNotesRefs) db.creditNotes,
                  ],
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
                        if (partyId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.partyId,
                            referencedTable: $$BillsTableReferences
                                ._partyIdTable(db),
                            referencedColumn: $$BillsTableReferences
                                ._partyIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
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
                              $$BillsTableReferences(
                                db,
                                table,
                                p0,
                              ).billLinesRefs,
                          currentColumn: 'id',
                          referencedColumn: 'bill_id',
                          typedResults: items,
                        ),
                      if (stockMovementsRefs)
                        await $_getPrefetchedDataByColumns<
                          BillRow,
                          $BillsTable,
                          MovementRow,
                          $StockMovementsTable
                        >(
                          currentTable: table,
                          referencedTable: $$BillsTableReferences
                              ._stockMovementsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$BillsTableReferences(
                                db,
                                table,
                                p0,
                              ).stockMovementsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'bill_id',
                          typedResults: items,
                        ),
                      if (partyEntriesRefs)
                        await $_getPrefetchedDataByColumns<
                          BillRow,
                          $BillsTable,
                          PartyEntryRow,
                          $PartyEntriesTable
                        >(
                          currentTable: table,
                          referencedTable: $$BillsTableReferences
                              ._partyEntriesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$BillsTableReferences(
                                db,
                                table,
                                p0,
                              ).partyEntriesRefs,
                          currentColumn: 'id',
                          referencedColumn: 'bill_id',
                          typedResults: items,
                        ),
                      if (creditNotesRefs)
                        await $_getPrefetchedDataByColumns<
                          BillRow,
                          $BillsTable,
                          CreditNoteRow,
                          $CreditNotesTable
                        >(
                          currentTable: table,
                          referencedTable: $$BillsTableReferences
                              ._creditNotesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$BillsTableReferences(
                                db,
                                table,
                                p0,
                              ).creditNotesRefs,
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
      PrefetchHooks Function({
        bool partyId,
        bool billLinesRefs,
        bool stockMovementsRefs,
        bool partyEntriesRefs,
        bool creditNotesRefs,
      })
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
  Value<int> unitFactorMilli,
  Value<int?> costPaise,
  Value<int> returnedMilli,
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
  Value<int> unitFactorMilli,
  Value<int?> costPaise,
  Value<int> returnedMilli,
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

  static MultiTypedResultKey<$CreditNoteLinesTable, List<CreditNoteLineRow>>
  _creditNoteLinesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.creditNoteLines,
    aliasName: 'bill_lines__id__credit_note_lines__bill_line_id',
  );

  $$CreditNoteLinesTableProcessedTableManager get creditNoteLinesRefs {
    final manager = $$CreditNoteLinesTableTableManager(
      $_db,
      $_db.creditNoteLines,
    ).filter((f) => f.billLineId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _creditNoteLinesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
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

  ColumnFilters<int> get unitFactorMilli => $composableBuilder(
    column: $table.unitFactorMilli,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get costPaise => $composableBuilder(
    column: $table.costPaise,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get returnedMilli => $composableBuilder(
    column: $table.returnedMilli,
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

  Expression<bool> creditNoteLinesRefs(
    Expression<bool> Function($$CreditNoteLinesTableFilterComposer f) f,
  ) {
    final $$CreditNoteLinesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.creditNoteLines,
      getReferencedColumn: (t) => t.billLineId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CreditNoteLinesTableFilterComposer(
            $db: $db,
            $table: $db.creditNoteLines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
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

  ColumnOrderings<int> get unitFactorMilli => $composableBuilder(
    column: $table.unitFactorMilli,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get costPaise => $composableBuilder(
    column: $table.costPaise,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get returnedMilli => $composableBuilder(
    column: $table.returnedMilli,
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

  GeneratedColumn<int> get unitFactorMilli => $composableBuilder(
    column: $table.unitFactorMilli,
    builder: (column) => column,
  );

  GeneratedColumn<int> get costPaise =>
      $composableBuilder(column: $table.costPaise, builder: (column) => column);

  GeneratedColumn<int> get returnedMilli => $composableBuilder(
    column: $table.returnedMilli,
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

  Expression<T> creditNoteLinesRefs<T extends Object>(
    Expression<T> Function($$CreditNoteLinesTableAnnotationComposer a) f,
  ) {
    final $$CreditNoteLinesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.creditNoteLines,
      getReferencedColumn: (t) => t.billLineId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CreditNoteLinesTableAnnotationComposer(
            $db: $db,
            $table: $db.creditNoteLines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
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
          PrefetchHooks Function({
            bool billId,
            bool itemId,
            bool creditNoteLinesRefs,
          })
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
                Value<int> unitFactorMilli = const Value.absent(),
                Value<int?> costPaise = const Value.absent(),
                Value<int> returnedMilli = const Value.absent(),
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
                unitFactorMilli: unitFactorMilli,
                costPaise: costPaise,
                returnedMilli: returnedMilli,
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
                Value<int> unitFactorMilli = const Value.absent(),
                Value<int?> costPaise = const Value.absent(),
                Value<int> returnedMilli = const Value.absent(),
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
                unitFactorMilli: unitFactorMilli,
                costPaise: costPaise,
                returnedMilli: returnedMilli,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$BillLinesTable, BillLineRow>(table),
                  $$BillLinesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({billId = false, itemId = false, creditNoteLinesRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (creditNoteLinesRefs) db.creditNoteLines,
                  ],
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
                    return [
                      if (creditNoteLinesRefs)
                        await $_getPrefetchedDataByColumns<
                          BillLineRow,
                          $BillLinesTable,
                          CreditNoteLineRow,
                          $CreditNoteLinesTable
                        >(
                          currentTable: table,
                          referencedTable: $$BillLinesTableReferences
                              ._creditNoteLinesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$BillLinesTableReferences(
                                db,
                                table,
                                p0,
                              ).creditNoteLinesRefs,
                          currentColumn: 'id',
                          referencedColumn: 'bill_line_id',
                          typedResults: items,
                        ),
                    ];
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
      PrefetchHooks Function({
        bool billId,
        bool itemId,
        bool creditNoteLinesRefs,
      })
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
typedef $$ItemBatchesTableCreateCompanionBuilder =
    ItemBatchesCompanion Function({
      Value<int> id,
      required int itemId,
      required String batchNo,
      Value<DateTime?> expiry,
      Value<int> quantityMilli,
      required DateTime createdAt,
    });
typedef $$ItemBatchesTableUpdateCompanionBuilder =
    ItemBatchesCompanion Function({
      Value<int> id,
      Value<int> itemId,
      Value<String> batchNo,
      Value<DateTime?> expiry,
      Value<int> quantityMilli,
      Value<DateTime> createdAt,
    });

final class $$ItemBatchesTableReferences
    extends BaseReferences<_$AppDatabase, $ItemBatchesTable, BatchRow> {
  $$ItemBatchesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ItemsTable _itemIdTable(_$AppDatabase db) =>
      db.items.createAlias('item_batches__item_id__items__id');

  $$ItemsTableProcessedTableManager get itemId {
    final $_column = $_itemColumn<int>('item_id')!;

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

  static MultiTypedResultKey<$StockMovementsTable, List<MovementRow>>
  _stockMovementsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.stockMovements,
    aliasName: 'item_batches__id__stock_movements__batch_id',
  );

  $$StockMovementsTableProcessedTableManager get stockMovementsRefs {
    final manager = $$StockMovementsTableTableManager(
      $_db,
      $_db.stockMovements,
    ).filter((f) => f.batchId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_stockMovementsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ItemBatchesTableFilterComposer
    extends Composer<_$AppDatabase, $ItemBatchesTable> {
  $$ItemBatchesTableFilterComposer({
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

  ColumnFilters<String> get batchNo => $composableBuilder(
    column: $table.batchNo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get expiry => $composableBuilder(
    column: $table.expiry,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quantityMilli => $composableBuilder(
    column: $table.quantityMilli,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

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

  Expression<bool> stockMovementsRefs(
    Expression<bool> Function($$StockMovementsTableFilterComposer f) f,
  ) {
    final $$StockMovementsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.stockMovements,
      getReferencedColumn: (t) => t.batchId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StockMovementsTableFilterComposer(
            $db: $db,
            $table: $db.stockMovements,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ItemBatchesTableOrderingComposer
    extends Composer<_$AppDatabase, $ItemBatchesTable> {
  $$ItemBatchesTableOrderingComposer({
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

  ColumnOrderings<String> get batchNo => $composableBuilder(
    column: $table.batchNo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get expiry => $composableBuilder(
    column: $table.expiry,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quantityMilli => $composableBuilder(
    column: $table.quantityMilli,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

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

class $$ItemBatchesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ItemBatchesTable> {
  $$ItemBatchesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get batchNo =>
      $composableBuilder(column: $table.batchNo, builder: (column) => column);

  GeneratedColumn<DateTime> get expiry =>
      $composableBuilder(column: $table.expiry, builder: (column) => column);

  GeneratedColumn<int> get quantityMilli => $composableBuilder(
    column: $table.quantityMilli,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

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

  Expression<T> stockMovementsRefs<T extends Object>(
    Expression<T> Function($$StockMovementsTableAnnotationComposer a) f,
  ) {
    final $$StockMovementsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.stockMovements,
      getReferencedColumn: (t) => t.batchId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StockMovementsTableAnnotationComposer(
            $db: $db,
            $table: $db.stockMovements,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ItemBatchesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ItemBatchesTable,
          BatchRow,
          $$ItemBatchesTableFilterComposer,
          $$ItemBatchesTableOrderingComposer,
          $$ItemBatchesTableAnnotationComposer,
          $$ItemBatchesTableCreateCompanionBuilder,
          $$ItemBatchesTableUpdateCompanionBuilder,
          (BatchRow, $$ItemBatchesTableReferences),
          BatchRow,
          PrefetchHooks Function({bool itemId, bool stockMovementsRefs})
        > {
  $$ItemBatchesTableTableManager(_$AppDatabase db, $ItemBatchesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ItemBatchesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ItemBatchesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ItemBatchesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> itemId = const Value.absent(),
                Value<String> batchNo = const Value.absent(),
                Value<DateTime?> expiry = const Value.absent(),
                Value<int> quantityMilli = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => ItemBatchesCompanion(
                id: id,
                itemId: itemId,
                batchNo: batchNo,
                expiry: expiry,
                quantityMilli: quantityMilli,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int itemId,
                required String batchNo,
                Value<DateTime?> expiry = const Value.absent(),
                Value<int> quantityMilli = const Value.absent(),
                required DateTime createdAt,
              }) => ItemBatchesCompanion.insert(
                id: id,
                itemId: itemId,
                batchNo: batchNo,
                expiry: expiry,
                quantityMilli: quantityMilli,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ItemBatchesTable, BatchRow>(table),
                  $$ItemBatchesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({itemId = false, stockMovementsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (stockMovementsRefs) db.stockMovements,
                  ],
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
                        if (itemId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.itemId,
                            referencedTable: $$ItemBatchesTableReferences
                                ._itemIdTable(db),
                            referencedColumn: $$ItemBatchesTableReferences
                                ._itemIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (stockMovementsRefs)
                        await $_getPrefetchedDataByColumns<
                          BatchRow,
                          $ItemBatchesTable,
                          MovementRow,
                          $StockMovementsTable
                        >(
                          currentTable: table,
                          referencedTable: $$ItemBatchesTableReferences
                              ._stockMovementsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ItemBatchesTableReferences(
                                db,
                                table,
                                p0,
                              ).stockMovementsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'batch_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ItemBatchesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ItemBatchesTable,
      BatchRow,
      $$ItemBatchesTableFilterComposer,
      $$ItemBatchesTableOrderingComposer,
      $$ItemBatchesTableAnnotationComposer,
      $$ItemBatchesTableCreateCompanionBuilder,
      $$ItemBatchesTableUpdateCompanionBuilder,
      (BatchRow, $$ItemBatchesTableReferences),
      BatchRow,
      PrefetchHooks Function({bool itemId, bool stockMovementsRefs})
    >;
typedef $$StockMovementsTableCreateCompanionBuilder =
    StockMovementsCompanion Function({
      Value<int> id,
      required int itemId,
      Value<int?> batchId,
      required int quantityMilli,
      required String type,
      Value<String?> note,
      Value<int?> billId,
      required int balanceAfterMilli,
      required DateTime at,
    });
typedef $$StockMovementsTableUpdateCompanionBuilder =
    StockMovementsCompanion Function({
      Value<int> id,
      Value<int> itemId,
      Value<int?> batchId,
      Value<int> quantityMilli,
      Value<String> type,
      Value<String?> note,
      Value<int?> billId,
      Value<int> balanceAfterMilli,
      Value<DateTime> at,
    });

final class $$StockMovementsTableReferences
    extends BaseReferences<_$AppDatabase, $StockMovementsTable, MovementRow> {
  $$StockMovementsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ItemsTable _itemIdTable(_$AppDatabase db) =>
      db.items.createAlias('stock_movements__item_id__items__id');

  $$ItemsTableProcessedTableManager get itemId {
    final $_column = $_itemColumn<int>('item_id')!;

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

  static $ItemBatchesTable _batchIdTable(_$AppDatabase db) =>
      db.itemBatches.createAlias('stock_movements__batch_id__item_batches__id');

  $$ItemBatchesTableProcessedTableManager? get batchId {
    final $_column = $_itemColumn<int>('batch_id');
    if ($_column == null) return null;
    final manager = $$ItemBatchesTableTableManager(
      $_db,
      $_db.itemBatches,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_batchIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $BillsTable _billIdTable(_$AppDatabase db) =>
      db.bills.createAlias('stock_movements__bill_id__bills__id');

  $$BillsTableProcessedTableManager? get billId {
    final $_column = $_itemColumn<int>('bill_id');
    if ($_column == null) return null;
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
}

class $$StockMovementsTableFilterComposer
    extends Composer<_$AppDatabase, $StockMovementsTable> {
  $$StockMovementsTableFilterComposer({
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

  ColumnFilters<int> get quantityMilli => $composableBuilder(
    column: $table.quantityMilli,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get balanceAfterMilli => $composableBuilder(
    column: $table.balanceAfterMilli,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get at => $composableBuilder(
    column: $table.at,
    builder: (column) => ColumnFilters(column),
  );

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

  $$ItemBatchesTableFilterComposer get batchId {
    final $$ItemBatchesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.batchId,
      referencedTable: $db.itemBatches,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemBatchesTableFilterComposer(
            $db: $db,
            $table: $db.itemBatches,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

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
}

class $$StockMovementsTableOrderingComposer
    extends Composer<_$AppDatabase, $StockMovementsTable> {
  $$StockMovementsTableOrderingComposer({
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

  ColumnOrderings<int> get quantityMilli => $composableBuilder(
    column: $table.quantityMilli,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get balanceAfterMilli => $composableBuilder(
    column: $table.balanceAfterMilli,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get at => $composableBuilder(
    column: $table.at,
    builder: (column) => ColumnOrderings(column),
  );

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

  $$ItemBatchesTableOrderingComposer get batchId {
    final $$ItemBatchesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.batchId,
      referencedTable: $db.itemBatches,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemBatchesTableOrderingComposer(
            $db: $db,
            $table: $db.itemBatches,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

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
}

class $$StockMovementsTableAnnotationComposer
    extends Composer<_$AppDatabase, $StockMovementsTable> {
  $$StockMovementsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get quantityMilli => $composableBuilder(
    column: $table.quantityMilli,
    builder: (column) => column,
  );

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<int> get balanceAfterMilli => $composableBuilder(
    column: $table.balanceAfterMilli,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get at =>
      $composableBuilder(column: $table.at, builder: (column) => column);

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

  $$ItemBatchesTableAnnotationComposer get batchId {
    final $$ItemBatchesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.batchId,
      referencedTable: $db.itemBatches,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemBatchesTableAnnotationComposer(
            $db: $db,
            $table: $db.itemBatches,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

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
}

class $$StockMovementsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StockMovementsTable,
          MovementRow,
          $$StockMovementsTableFilterComposer,
          $$StockMovementsTableOrderingComposer,
          $$StockMovementsTableAnnotationComposer,
          $$StockMovementsTableCreateCompanionBuilder,
          $$StockMovementsTableUpdateCompanionBuilder,
          (MovementRow, $$StockMovementsTableReferences),
          MovementRow,
          PrefetchHooks Function({bool itemId, bool batchId, bool billId})
        > {
  $$StockMovementsTableTableManager(
    _$AppDatabase db,
    $StockMovementsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StockMovementsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StockMovementsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StockMovementsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> itemId = const Value.absent(),
                Value<int?> batchId = const Value.absent(),
                Value<int> quantityMilli = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<int?> billId = const Value.absent(),
                Value<int> balanceAfterMilli = const Value.absent(),
                Value<DateTime> at = const Value.absent(),
              }) => StockMovementsCompanion(
                id: id,
                itemId: itemId,
                batchId: batchId,
                quantityMilli: quantityMilli,
                type: type,
                note: note,
                billId: billId,
                balanceAfterMilli: balanceAfterMilli,
                at: at,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int itemId,
                Value<int?> batchId = const Value.absent(),
                required int quantityMilli,
                required String type,
                Value<String?> note = const Value.absent(),
                Value<int?> billId = const Value.absent(),
                required int balanceAfterMilli,
                required DateTime at,
              }) => StockMovementsCompanion.insert(
                id: id,
                itemId: itemId,
                batchId: batchId,
                quantityMilli: quantityMilli,
                type: type,
                note: note,
                billId: billId,
                balanceAfterMilli: balanceAfterMilli,
                at: at,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$StockMovementsTable, MovementRow>(table),
                  $$StockMovementsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({itemId = false, batchId = false, billId = false}) {
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
                        if (itemId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.itemId,
                            referencedTable: $$StockMovementsTableReferences
                                ._itemIdTable(db),
                            referencedColumn: $$StockMovementsTableReferences
                                ._itemIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (batchId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.batchId,
                            referencedTable: $$StockMovementsTableReferences
                                ._batchIdTable(db),
                            referencedColumn: $$StockMovementsTableReferences
                                ._batchIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (billId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.billId,
                            referencedTable: $$StockMovementsTableReferences
                                ._billIdTable(db),
                            referencedColumn: $$StockMovementsTableReferences
                                ._billIdTable(db)
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

typedef $$StockMovementsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StockMovementsTable,
      MovementRow,
      $$StockMovementsTableFilterComposer,
      $$StockMovementsTableOrderingComposer,
      $$StockMovementsTableAnnotationComposer,
      $$StockMovementsTableCreateCompanionBuilder,
      $$StockMovementsTableUpdateCompanionBuilder,
      (MovementRow, $$StockMovementsTableReferences),
      MovementRow,
      PrefetchHooks Function({bool itemId, bool batchId, bool billId})
    >;
typedef $$PartyEntriesTableCreateCompanionBuilder =
    PartyEntriesCompanion Function({
      Value<int> id,
      required int partyId,
      required String type,
      required int amountPaise,
      Value<int?> billId,
      Value<String?> paymentMode,
      Value<String?> note,
      required int balanceAfterPaise,
      required DateTime at,
    });
typedef $$PartyEntriesTableUpdateCompanionBuilder =
    PartyEntriesCompanion Function({
      Value<int> id,
      Value<int> partyId,
      Value<String> type,
      Value<int> amountPaise,
      Value<int?> billId,
      Value<String?> paymentMode,
      Value<String?> note,
      Value<int> balanceAfterPaise,
      Value<DateTime> at,
    });

final class $$PartyEntriesTableReferences
    extends BaseReferences<_$AppDatabase, $PartyEntriesTable, PartyEntryRow> {
  $$PartyEntriesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $PartiesTable _partyIdTable(_$AppDatabase db) =>
      db.parties.createAlias('party_entries__party_id__parties__id');

  $$PartiesTableProcessedTableManager get partyId {
    final $_column = $_itemColumn<int>('party_id')!;

    final manager = $$PartiesTableTableManager(
      $_db,
      $_db.parties,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_partyIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $BillsTable _billIdTable(_$AppDatabase db) =>
      db.bills.createAlias('party_entries__bill_id__bills__id');

  $$BillsTableProcessedTableManager? get billId {
    final $_column = $_itemColumn<int>('bill_id');
    if ($_column == null) return null;
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
}

class $$PartyEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $PartyEntriesTable> {
  $$PartyEntriesTableFilterComposer({
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

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amountPaise => $composableBuilder(
    column: $table.amountPaise,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get paymentMode => $composableBuilder(
    column: $table.paymentMode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get balanceAfterPaise => $composableBuilder(
    column: $table.balanceAfterPaise,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get at => $composableBuilder(
    column: $table.at,
    builder: (column) => ColumnFilters(column),
  );

  $$PartiesTableFilterComposer get partyId {
    final $$PartiesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.partyId,
      referencedTable: $db.parties,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PartiesTableFilterComposer(
            $db: $db,
            $table: $db.parties,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

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
}

class $$PartyEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $PartyEntriesTable> {
  $$PartyEntriesTableOrderingComposer({
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

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountPaise => $composableBuilder(
    column: $table.amountPaise,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get paymentMode => $composableBuilder(
    column: $table.paymentMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get balanceAfterPaise => $composableBuilder(
    column: $table.balanceAfterPaise,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get at => $composableBuilder(
    column: $table.at,
    builder: (column) => ColumnOrderings(column),
  );

  $$PartiesTableOrderingComposer get partyId {
    final $$PartiesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.partyId,
      referencedTable: $db.parties,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PartiesTableOrderingComposer(
            $db: $db,
            $table: $db.parties,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

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
}

class $$PartyEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PartyEntriesTable> {
  $$PartyEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<int> get amountPaise => $composableBuilder(
    column: $table.amountPaise,
    builder: (column) => column,
  );

  GeneratedColumn<String> get paymentMode => $composableBuilder(
    column: $table.paymentMode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<int> get balanceAfterPaise => $composableBuilder(
    column: $table.balanceAfterPaise,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get at =>
      $composableBuilder(column: $table.at, builder: (column) => column);

  $$PartiesTableAnnotationComposer get partyId {
    final $$PartiesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.partyId,
      referencedTable: $db.parties,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PartiesTableAnnotationComposer(
            $db: $db,
            $table: $db.parties,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

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
}

class $$PartyEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PartyEntriesTable,
          PartyEntryRow,
          $$PartyEntriesTableFilterComposer,
          $$PartyEntriesTableOrderingComposer,
          $$PartyEntriesTableAnnotationComposer,
          $$PartyEntriesTableCreateCompanionBuilder,
          $$PartyEntriesTableUpdateCompanionBuilder,
          (PartyEntryRow, $$PartyEntriesTableReferences),
          PartyEntryRow,
          PrefetchHooks Function({bool partyId, bool billId})
        > {
  $$PartyEntriesTableTableManager(_$AppDatabase db, $PartyEntriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PartyEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PartyEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PartyEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> partyId = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<int> amountPaise = const Value.absent(),
                Value<int?> billId = const Value.absent(),
                Value<String?> paymentMode = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<int> balanceAfterPaise = const Value.absent(),
                Value<DateTime> at = const Value.absent(),
              }) => PartyEntriesCompanion(
                id: id,
                partyId: partyId,
                type: type,
                amountPaise: amountPaise,
                billId: billId,
                paymentMode: paymentMode,
                note: note,
                balanceAfterPaise: balanceAfterPaise,
                at: at,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int partyId,
                required String type,
                required int amountPaise,
                Value<int?> billId = const Value.absent(),
                Value<String?> paymentMode = const Value.absent(),
                Value<String?> note = const Value.absent(),
                required int balanceAfterPaise,
                required DateTime at,
              }) => PartyEntriesCompanion.insert(
                id: id,
                partyId: partyId,
                type: type,
                amountPaise: amountPaise,
                billId: billId,
                paymentMode: paymentMode,
                note: note,
                balanceAfterPaise: balanceAfterPaise,
                at: at,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PartyEntriesTable, PartyEntryRow>(table),
                  $$PartyEntriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({partyId = false, billId = false}) {
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
                    if (partyId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.partyId,
                        referencedTable: $$PartyEntriesTableReferences
                            ._partyIdTable(db),
                        referencedColumn: $$PartyEntriesTableReferences
                            ._partyIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (billId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.billId,
                        referencedTable: $$PartyEntriesTableReferences
                            ._billIdTable(db),
                        referencedColumn: $$PartyEntriesTableReferences
                            ._billIdTable(db)
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

typedef $$PartyEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PartyEntriesTable,
      PartyEntryRow,
      $$PartyEntriesTableFilterComposer,
      $$PartyEntriesTableOrderingComposer,
      $$PartyEntriesTableAnnotationComposer,
      $$PartyEntriesTableCreateCompanionBuilder,
      $$PartyEntriesTableUpdateCompanionBuilder,
      (PartyEntryRow, $$PartyEntriesTableReferences),
      PartyEntryRow,
      PrefetchHooks Function({bool partyId, bool billId})
    >;
typedef $$PurchasesTableCreateCompanionBuilder = PurchasesCompanion Function({
  Value<int> id,
  Value<int?> partyId,
  Value<String?> supplierName,
  Value<String?> supplierGstin,
  Value<String?> supplierInvoiceNo,
  required DateTime purchasedAt,
  Value<bool> interState,
  required int taxablePaise,
  required int taxPaise,
  Value<int> roundOffPaise,
  required int totalPaise,
  Value<int> duePaise,
  required String paymentMode,
  Value<String?> note,
  Value<String> status,
  Value<DateTime?> cancelledAt,
});
typedef $$PurchasesTableUpdateCompanionBuilder = PurchasesCompanion Function({
  Value<int> id,
  Value<int?> partyId,
  Value<String?> supplierName,
  Value<String?> supplierGstin,
  Value<String?> supplierInvoiceNo,
  Value<DateTime> purchasedAt,
  Value<bool> interState,
  Value<int> taxablePaise,
  Value<int> taxPaise,
  Value<int> roundOffPaise,
  Value<int> totalPaise,
  Value<int> duePaise,
  Value<String> paymentMode,
  Value<String?> note,
  Value<String> status,
  Value<DateTime?> cancelledAt,
});

final class $$PurchasesTableReferences
    extends BaseReferences<_$AppDatabase, $PurchasesTable, PurchaseRow> {
  $$PurchasesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $PartiesTable _partyIdTable(_$AppDatabase db) =>
      db.parties.createAlias('purchases__party_id__parties__id');

  $$PartiesTableProcessedTableManager? get partyId {
    final $_column = $_itemColumn<int>('party_id');
    if ($_column == null) return null;
    final manager = $$PartiesTableTableManager(
      $_db,
      $_db.parties,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_partyIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$PurchaseLinesTable, List<PurchaseLineRow>>
  _purchaseLinesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.purchaseLines,
    aliasName: 'purchases__id__purchase_lines__purchase_id',
  );

  $$PurchaseLinesTableProcessedTableManager get purchaseLinesRefs {
    final manager = $$PurchaseLinesTableTableManager(
      $_db,
      $_db.purchaseLines,
    ).filter((f) => f.purchaseId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_purchaseLinesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PurchasesTableFilterComposer
    extends Composer<_$AppDatabase, $PurchasesTable> {
  $$PurchasesTableFilterComposer({
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

  ColumnFilters<String> get supplierName => $composableBuilder(
    column: $table.supplierName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get supplierGstin => $composableBuilder(
    column: $table.supplierGstin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get supplierInvoiceNo => $composableBuilder(
    column: $table.supplierInvoiceNo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get purchasedAt => $composableBuilder(
    column: $table.purchasedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get interState => $composableBuilder(
    column: $table.interState,
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

  ColumnFilters<int> get totalPaise => $composableBuilder(
    column: $table.totalPaise,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get duePaise => $composableBuilder(
    column: $table.duePaise,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get paymentMode => $composableBuilder(
    column: $table.paymentMode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
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

  $$PartiesTableFilterComposer get partyId {
    final $$PartiesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.partyId,
      referencedTable: $db.parties,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PartiesTableFilterComposer(
            $db: $db,
            $table: $db.parties,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> purchaseLinesRefs(
    Expression<bool> Function($$PurchaseLinesTableFilterComposer f) f,
  ) {
    final $$PurchaseLinesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.purchaseLines,
      getReferencedColumn: (t) => t.purchaseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PurchaseLinesTableFilterComposer(
            $db: $db,
            $table: $db.purchaseLines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PurchasesTableOrderingComposer
    extends Composer<_$AppDatabase, $PurchasesTable> {
  $$PurchasesTableOrderingComposer({
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

  ColumnOrderings<String> get supplierName => $composableBuilder(
    column: $table.supplierName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get supplierGstin => $composableBuilder(
    column: $table.supplierGstin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get supplierInvoiceNo => $composableBuilder(
    column: $table.supplierInvoiceNo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get purchasedAt => $composableBuilder(
    column: $table.purchasedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get interState => $composableBuilder(
    column: $table.interState,
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

  ColumnOrderings<int> get totalPaise => $composableBuilder(
    column: $table.totalPaise,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get duePaise => $composableBuilder(
    column: $table.duePaise,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get paymentMode => $composableBuilder(
    column: $table.paymentMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
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

  $$PartiesTableOrderingComposer get partyId {
    final $$PartiesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.partyId,
      referencedTable: $db.parties,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PartiesTableOrderingComposer(
            $db: $db,
            $table: $db.parties,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PurchasesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PurchasesTable> {
  $$PurchasesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get supplierName => $composableBuilder(
    column: $table.supplierName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get supplierGstin => $composableBuilder(
    column: $table.supplierGstin,
    builder: (column) => column,
  );

  GeneratedColumn<String> get supplierInvoiceNo => $composableBuilder(
    column: $table.supplierInvoiceNo,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get purchasedAt => $composableBuilder(
    column: $table.purchasedAt,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get interState => $composableBuilder(
    column: $table.interState,
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

  GeneratedColumn<int> get totalPaise => $composableBuilder(
    column: $table.totalPaise,
    builder: (column) => column,
  );

  GeneratedColumn<int> get duePaise =>
      $composableBuilder(column: $table.duePaise, builder: (column) => column);

  GeneratedColumn<String> get paymentMode => $composableBuilder(
    column: $table.paymentMode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get cancelledAt => $composableBuilder(
    column: $table.cancelledAt,
    builder: (column) => column,
  );

  $$PartiesTableAnnotationComposer get partyId {
    final $$PartiesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.partyId,
      referencedTable: $db.parties,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PartiesTableAnnotationComposer(
            $db: $db,
            $table: $db.parties,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> purchaseLinesRefs<T extends Object>(
    Expression<T> Function($$PurchaseLinesTableAnnotationComposer a) f,
  ) {
    final $$PurchaseLinesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.purchaseLines,
      getReferencedColumn: (t) => t.purchaseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PurchaseLinesTableAnnotationComposer(
            $db: $db,
            $table: $db.purchaseLines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PurchasesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PurchasesTable,
          PurchaseRow,
          $$PurchasesTableFilterComposer,
          $$PurchasesTableOrderingComposer,
          $$PurchasesTableAnnotationComposer,
          $$PurchasesTableCreateCompanionBuilder,
          $$PurchasesTableUpdateCompanionBuilder,
          (PurchaseRow, $$PurchasesTableReferences),
          PurchaseRow,
          PrefetchHooks Function({bool partyId, bool purchaseLinesRefs})
        > {
  $$PurchasesTableTableManager(_$AppDatabase db, $PurchasesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PurchasesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PurchasesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PurchasesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> partyId = const Value.absent(),
                Value<String?> supplierName = const Value.absent(),
                Value<String?> supplierGstin = const Value.absent(),
                Value<String?> supplierInvoiceNo = const Value.absent(),
                Value<DateTime> purchasedAt = const Value.absent(),
                Value<bool> interState = const Value.absent(),
                Value<int> taxablePaise = const Value.absent(),
                Value<int> taxPaise = const Value.absent(),
                Value<int> roundOffPaise = const Value.absent(),
                Value<int> totalPaise = const Value.absent(),
                Value<int> duePaise = const Value.absent(),
                Value<String> paymentMode = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime?> cancelledAt = const Value.absent(),
              }) => PurchasesCompanion(
                id: id,
                partyId: partyId,
                supplierName: supplierName,
                supplierGstin: supplierGstin,
                supplierInvoiceNo: supplierInvoiceNo,
                purchasedAt: purchasedAt,
                interState: interState,
                taxablePaise: taxablePaise,
                taxPaise: taxPaise,
                roundOffPaise: roundOffPaise,
                totalPaise: totalPaise,
                duePaise: duePaise,
                paymentMode: paymentMode,
                note: note,
                status: status,
                cancelledAt: cancelledAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> partyId = const Value.absent(),
                Value<String?> supplierName = const Value.absent(),
                Value<String?> supplierGstin = const Value.absent(),
                Value<String?> supplierInvoiceNo = const Value.absent(),
                required DateTime purchasedAt,
                Value<bool> interState = const Value.absent(),
                required int taxablePaise,
                required int taxPaise,
                Value<int> roundOffPaise = const Value.absent(),
                required int totalPaise,
                Value<int> duePaise = const Value.absent(),
                required String paymentMode,
                Value<String?> note = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime?> cancelledAt = const Value.absent(),
              }) => PurchasesCompanion.insert(
                id: id,
                partyId: partyId,
                supplierName: supplierName,
                supplierGstin: supplierGstin,
                supplierInvoiceNo: supplierInvoiceNo,
                purchasedAt: purchasedAt,
                interState: interState,
                taxablePaise: taxablePaise,
                taxPaise: taxPaise,
                roundOffPaise: roundOffPaise,
                totalPaise: totalPaise,
                duePaise: duePaise,
                paymentMode: paymentMode,
                note: note,
                status: status,
                cancelledAt: cancelledAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PurchasesTable, PurchaseRow>(table),
                  $$PurchasesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({partyId = false, purchaseLinesRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (purchaseLinesRefs) db.purchaseLines,
                  ],
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
                        if (partyId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.partyId,
                            referencedTable: $$PurchasesTableReferences
                                ._partyIdTable(db),
                            referencedColumn: $$PurchasesTableReferences
                                ._partyIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (purchaseLinesRefs)
                        await $_getPrefetchedDataByColumns<
                          PurchaseRow,
                          $PurchasesTable,
                          PurchaseLineRow,
                          $PurchaseLinesTable
                        >(
                          currentTable: table,
                          referencedTable: $$PurchasesTableReferences
                              ._purchaseLinesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PurchasesTableReferences(
                                db,
                                table,
                                p0,
                              ).purchaseLinesRefs,
                          currentColumn: 'id',
                          referencedColumn: 'purchase_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$PurchasesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PurchasesTable,
      PurchaseRow,
      $$PurchasesTableFilterComposer,
      $$PurchasesTableOrderingComposer,
      $$PurchasesTableAnnotationComposer,
      $$PurchasesTableCreateCompanionBuilder,
      $$PurchasesTableUpdateCompanionBuilder,
      (PurchaseRow, $$PurchasesTableReferences),
      PurchaseRow,
      PrefetchHooks Function({bool partyId, bool purchaseLinesRefs})
    >;
typedef $$PurchaseLinesTableCreateCompanionBuilder =
    PurchaseLinesCompanion Function({
      Value<int> id,
      required int purchaseId,
      required int position,
      Value<int?> itemId,
      required String name,
      required String unit,
      Value<String?> hsn,
      required int quantityMilli,
      required int unitCostPaise,
      required bool costIncludesTax,
      required int taxRateBp,
      required int taxablePaise,
      required int taxPaise,
      required int totalPaise,
      Value<String?> batchNo,
      Value<DateTime?> expiry,
    });
typedef $$PurchaseLinesTableUpdateCompanionBuilder =
    PurchaseLinesCompanion Function({
      Value<int> id,
      Value<int> purchaseId,
      Value<int> position,
      Value<int?> itemId,
      Value<String> name,
      Value<String> unit,
      Value<String?> hsn,
      Value<int> quantityMilli,
      Value<int> unitCostPaise,
      Value<bool> costIncludesTax,
      Value<int> taxRateBp,
      Value<int> taxablePaise,
      Value<int> taxPaise,
      Value<int> totalPaise,
      Value<String?> batchNo,
      Value<DateTime?> expiry,
    });

final class $$PurchaseLinesTableReferences
    extends
        BaseReferences<_$AppDatabase, $PurchaseLinesTable, PurchaseLineRow> {
  $$PurchaseLinesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $PurchasesTable _purchaseIdTable(_$AppDatabase db) =>
      db.purchases.createAlias('purchase_lines__purchase_id__purchases__id');

  $$PurchasesTableProcessedTableManager get purchaseId {
    final $_column = $_itemColumn<int>('purchase_id')!;

    final manager = $$PurchasesTableTableManager(
      $_db,
      $_db.purchases,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_purchaseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ItemsTable _itemIdTable(_$AppDatabase db) =>
      db.items.createAlias('purchase_lines__item_id__items__id');

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

class $$PurchaseLinesTableFilterComposer
    extends Composer<_$AppDatabase, $PurchaseLinesTable> {
  $$PurchaseLinesTableFilterComposer({
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

  ColumnFilters<int> get unitCostPaise => $composableBuilder(
    column: $table.unitCostPaise,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get costIncludesTax => $composableBuilder(
    column: $table.costIncludesTax,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get taxRateBp => $composableBuilder(
    column: $table.taxRateBp,
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

  ColumnFilters<String> get batchNo => $composableBuilder(
    column: $table.batchNo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get expiry => $composableBuilder(
    column: $table.expiry,
    builder: (column) => ColumnFilters(column),
  );

  $$PurchasesTableFilterComposer get purchaseId {
    final $$PurchasesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.purchaseId,
      referencedTable: $db.purchases,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PurchasesTableFilterComposer(
            $db: $db,
            $table: $db.purchases,
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

class $$PurchaseLinesTableOrderingComposer
    extends Composer<_$AppDatabase, $PurchaseLinesTable> {
  $$PurchaseLinesTableOrderingComposer({
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

  ColumnOrderings<int> get unitCostPaise => $composableBuilder(
    column: $table.unitCostPaise,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get costIncludesTax => $composableBuilder(
    column: $table.costIncludesTax,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get taxRateBp => $composableBuilder(
    column: $table.taxRateBp,
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

  ColumnOrderings<String> get batchNo => $composableBuilder(
    column: $table.batchNo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get expiry => $composableBuilder(
    column: $table.expiry,
    builder: (column) => ColumnOrderings(column),
  );

  $$PurchasesTableOrderingComposer get purchaseId {
    final $$PurchasesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.purchaseId,
      referencedTable: $db.purchases,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PurchasesTableOrderingComposer(
            $db: $db,
            $table: $db.purchases,
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

class $$PurchaseLinesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PurchaseLinesTable> {
  $$PurchaseLinesTableAnnotationComposer({
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

  GeneratedColumn<int> get unitCostPaise => $composableBuilder(
    column: $table.unitCostPaise,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get costIncludesTax => $composableBuilder(
    column: $table.costIncludesTax,
    builder: (column) => column,
  );

  GeneratedColumn<int> get taxRateBp =>
      $composableBuilder(column: $table.taxRateBp, builder: (column) => column);

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

  GeneratedColumn<String> get batchNo =>
      $composableBuilder(column: $table.batchNo, builder: (column) => column);

  GeneratedColumn<DateTime> get expiry =>
      $composableBuilder(column: $table.expiry, builder: (column) => column);

  $$PurchasesTableAnnotationComposer get purchaseId {
    final $$PurchasesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.purchaseId,
      referencedTable: $db.purchases,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PurchasesTableAnnotationComposer(
            $db: $db,
            $table: $db.purchases,
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

class $$PurchaseLinesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PurchaseLinesTable,
          PurchaseLineRow,
          $$PurchaseLinesTableFilterComposer,
          $$PurchaseLinesTableOrderingComposer,
          $$PurchaseLinesTableAnnotationComposer,
          $$PurchaseLinesTableCreateCompanionBuilder,
          $$PurchaseLinesTableUpdateCompanionBuilder,
          (PurchaseLineRow, $$PurchaseLinesTableReferences),
          PurchaseLineRow,
          PrefetchHooks Function({bool purchaseId, bool itemId})
        > {
  $$PurchaseLinesTableTableManager(_$AppDatabase db, $PurchaseLinesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PurchaseLinesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PurchaseLinesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PurchaseLinesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> purchaseId = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<int?> itemId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> unit = const Value.absent(),
                Value<String?> hsn = const Value.absent(),
                Value<int> quantityMilli = const Value.absent(),
                Value<int> unitCostPaise = const Value.absent(),
                Value<bool> costIncludesTax = const Value.absent(),
                Value<int> taxRateBp = const Value.absent(),
                Value<int> taxablePaise = const Value.absent(),
                Value<int> taxPaise = const Value.absent(),
                Value<int> totalPaise = const Value.absent(),
                Value<String?> batchNo = const Value.absent(),
                Value<DateTime?> expiry = const Value.absent(),
              }) => PurchaseLinesCompanion(
                id: id,
                purchaseId: purchaseId,
                position: position,
                itemId: itemId,
                name: name,
                unit: unit,
                hsn: hsn,
                quantityMilli: quantityMilli,
                unitCostPaise: unitCostPaise,
                costIncludesTax: costIncludesTax,
                taxRateBp: taxRateBp,
                taxablePaise: taxablePaise,
                taxPaise: taxPaise,
                totalPaise: totalPaise,
                batchNo: batchNo,
                expiry: expiry,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int purchaseId,
                required int position,
                Value<int?> itemId = const Value.absent(),
                required String name,
                required String unit,
                Value<String?> hsn = const Value.absent(),
                required int quantityMilli,
                required int unitCostPaise,
                required bool costIncludesTax,
                required int taxRateBp,
                required int taxablePaise,
                required int taxPaise,
                required int totalPaise,
                Value<String?> batchNo = const Value.absent(),
                Value<DateTime?> expiry = const Value.absent(),
              }) => PurchaseLinesCompanion.insert(
                id: id,
                purchaseId: purchaseId,
                position: position,
                itemId: itemId,
                name: name,
                unit: unit,
                hsn: hsn,
                quantityMilli: quantityMilli,
                unitCostPaise: unitCostPaise,
                costIncludesTax: costIncludesTax,
                taxRateBp: taxRateBp,
                taxablePaise: taxablePaise,
                taxPaise: taxPaise,
                totalPaise: totalPaise,
                batchNo: batchNo,
                expiry: expiry,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PurchaseLinesTable, PurchaseLineRow>(table),
                  $$PurchaseLinesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({purchaseId = false, itemId = false}) {
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
                    if (purchaseId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.purchaseId,
                        referencedTable: $$PurchaseLinesTableReferences
                            ._purchaseIdTable(db),
                        referencedColumn: $$PurchaseLinesTableReferences
                            ._purchaseIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (itemId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.itemId,
                        referencedTable: $$PurchaseLinesTableReferences
                            ._itemIdTable(db),
                        referencedColumn: $$PurchaseLinesTableReferences
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

typedef $$PurchaseLinesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PurchaseLinesTable,
      PurchaseLineRow,
      $$PurchaseLinesTableFilterComposer,
      $$PurchaseLinesTableOrderingComposer,
      $$PurchaseLinesTableAnnotationComposer,
      $$PurchaseLinesTableCreateCompanionBuilder,
      $$PurchaseLinesTableUpdateCompanionBuilder,
      (PurchaseLineRow, $$PurchaseLinesTableReferences),
      PurchaseLineRow,
      PrefetchHooks Function({bool purchaseId, bool itemId})
    >;
typedef $$ExpensesTableCreateCompanionBuilder = ExpensesCompanion Function({
  Value<int> id,
  required DateTime spentAt,
  required String category,
  required int amountPaise,
  required String paymentMode,
  Value<String?> note,
  Value<bool> isDeleted,
});
typedef $$ExpensesTableUpdateCompanionBuilder = ExpensesCompanion Function({
  Value<int> id,
  Value<DateTime> spentAt,
  Value<String> category,
  Value<int> amountPaise,
  Value<String> paymentMode,
  Value<String?> note,
  Value<bool> isDeleted,
});

class $$ExpensesTableFilterComposer
    extends Composer<_$AppDatabase, $ExpensesTable> {
  $$ExpensesTableFilterComposer({
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

  ColumnFilters<DateTime> get spentAt => $composableBuilder(
    column: $table.spentAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amountPaise => $composableBuilder(
    column: $table.amountPaise,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get paymentMode => $composableBuilder(
    column: $table.paymentMode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ExpensesTableOrderingComposer
    extends Composer<_$AppDatabase, $ExpensesTable> {
  $$ExpensesTableOrderingComposer({
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

  ColumnOrderings<DateTime> get spentAt => $composableBuilder(
    column: $table.spentAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountPaise => $composableBuilder(
    column: $table.amountPaise,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get paymentMode => $composableBuilder(
    column: $table.paymentMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ExpensesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExpensesTable> {
  $$ExpensesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get spentAt =>
      $composableBuilder(column: $table.spentAt, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<int> get amountPaise => $composableBuilder(
    column: $table.amountPaise,
    builder: (column) => column,
  );

  GeneratedColumn<String> get paymentMode => $composableBuilder(
    column: $table.paymentMode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);
}

class $$ExpensesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExpensesTable,
          ExpenseRow,
          $$ExpensesTableFilterComposer,
          $$ExpensesTableOrderingComposer,
          $$ExpensesTableAnnotationComposer,
          $$ExpensesTableCreateCompanionBuilder,
          $$ExpensesTableUpdateCompanionBuilder,
          (
            ExpenseRow,
            BaseReferences<_$AppDatabase, $ExpensesTable, ExpenseRow>,
          ),
          ExpenseRow,
          PrefetchHooks Function()
        > {
  $$ExpensesTableTableManager(_$AppDatabase db, $ExpensesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExpensesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExpensesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExpensesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> spentAt = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<int> amountPaise = const Value.absent(),
                Value<String> paymentMode = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
              }) => ExpensesCompanion(
                id: id,
                spentAt: spentAt,
                category: category,
                amountPaise: amountPaise,
                paymentMode: paymentMode,
                note: note,
                isDeleted: isDeleted,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime spentAt,
                required String category,
                required int amountPaise,
                required String paymentMode,
                Value<String?> note = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
              }) => ExpensesCompanion.insert(
                id: id,
                spentAt: spentAt,
                category: category,
                amountPaise: amountPaise,
                paymentMode: paymentMode,
                note: note,
                isDeleted: isDeleted,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ExpensesTable, ExpenseRow>(table),
                  BaseReferences<_$AppDatabase, $ExpensesTable, ExpenseRow>(
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

typedef $$ExpensesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExpensesTable,
      ExpenseRow,
      $$ExpensesTableFilterComposer,
      $$ExpensesTableOrderingComposer,
      $$ExpensesTableAnnotationComposer,
      $$ExpensesTableCreateCompanionBuilder,
      $$ExpensesTableUpdateCompanionBuilder,
      (ExpenseRow, BaseReferences<_$AppDatabase, $ExpensesTable, ExpenseRow>),
      ExpenseRow,
      PrefetchHooks Function()
    >;
typedef $$CreditNotesTableCreateCompanionBuilder =
    CreditNotesCompanion Function({
      Value<int> id,
      required String noteNo,
      required int fyStart,
      required int sequence,
      required int billId,
      required DateTime issuedAt,
      Value<String?> reason,
      required int taxablePaise,
      required int taxPaise,
      required int totalPaise,
      required String refundMode,
    });
typedef $$CreditNotesTableUpdateCompanionBuilder =
    CreditNotesCompanion Function({
      Value<int> id,
      Value<String> noteNo,
      Value<int> fyStart,
      Value<int> sequence,
      Value<int> billId,
      Value<DateTime> issuedAt,
      Value<String?> reason,
      Value<int> taxablePaise,
      Value<int> taxPaise,
      Value<int> totalPaise,
      Value<String> refundMode,
    });

final class $$CreditNotesTableReferences
    extends BaseReferences<_$AppDatabase, $CreditNotesTable, CreditNoteRow> {
  $$CreditNotesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $BillsTable _billIdTable(_$AppDatabase db) =>
      db.bills.createAlias('credit_notes__bill_id__bills__id');

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

  static MultiTypedResultKey<$CreditNoteLinesTable, List<CreditNoteLineRow>>
  _creditNoteLinesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.creditNoteLines,
    aliasName: 'credit_notes__id__credit_note_lines__credit_note_id',
  );

  $$CreditNoteLinesTableProcessedTableManager get creditNoteLinesRefs {
    final manager = $$CreditNoteLinesTableTableManager(
      $_db,
      $_db.creditNoteLines,
    ).filter((f) => f.creditNoteId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _creditNoteLinesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CreditNotesTableFilterComposer
    extends Composer<_$AppDatabase, $CreditNotesTable> {
  $$CreditNotesTableFilterComposer({
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

  ColumnFilters<String> get noteNo => $composableBuilder(
    column: $table.noteNo,
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

  ColumnFilters<DateTime> get issuedAt => $composableBuilder(
    column: $table.issuedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reason => $composableBuilder(
    column: $table.reason,
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

  ColumnFilters<String> get refundMode => $composableBuilder(
    column: $table.refundMode,
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

  Expression<bool> creditNoteLinesRefs(
    Expression<bool> Function($$CreditNoteLinesTableFilterComposer f) f,
  ) {
    final $$CreditNoteLinesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.creditNoteLines,
      getReferencedColumn: (t) => t.creditNoteId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CreditNoteLinesTableFilterComposer(
            $db: $db,
            $table: $db.creditNoteLines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CreditNotesTableOrderingComposer
    extends Composer<_$AppDatabase, $CreditNotesTable> {
  $$CreditNotesTableOrderingComposer({
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

  ColumnOrderings<String> get noteNo => $composableBuilder(
    column: $table.noteNo,
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

  ColumnOrderings<DateTime> get issuedAt => $composableBuilder(
    column: $table.issuedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reason => $composableBuilder(
    column: $table.reason,
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

  ColumnOrderings<String> get refundMode => $composableBuilder(
    column: $table.refundMode,
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
}

class $$CreditNotesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CreditNotesTable> {
  $$CreditNotesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get noteNo =>
      $composableBuilder(column: $table.noteNo, builder: (column) => column);

  GeneratedColumn<int> get fyStart =>
      $composableBuilder(column: $table.fyStart, builder: (column) => column);

  GeneratedColumn<int> get sequence =>
      $composableBuilder(column: $table.sequence, builder: (column) => column);

  GeneratedColumn<DateTime> get issuedAt =>
      $composableBuilder(column: $table.issuedAt, builder: (column) => column);

  GeneratedColumn<String> get reason =>
      $composableBuilder(column: $table.reason, builder: (column) => column);

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

  GeneratedColumn<String> get refundMode => $composableBuilder(
    column: $table.refundMode,
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

  Expression<T> creditNoteLinesRefs<T extends Object>(
    Expression<T> Function($$CreditNoteLinesTableAnnotationComposer a) f,
  ) {
    final $$CreditNoteLinesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.creditNoteLines,
      getReferencedColumn: (t) => t.creditNoteId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CreditNoteLinesTableAnnotationComposer(
            $db: $db,
            $table: $db.creditNoteLines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CreditNotesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CreditNotesTable,
          CreditNoteRow,
          $$CreditNotesTableFilterComposer,
          $$CreditNotesTableOrderingComposer,
          $$CreditNotesTableAnnotationComposer,
          $$CreditNotesTableCreateCompanionBuilder,
          $$CreditNotesTableUpdateCompanionBuilder,
          (CreditNoteRow, $$CreditNotesTableReferences),
          CreditNoteRow,
          PrefetchHooks Function({bool billId, bool creditNoteLinesRefs})
        > {
  $$CreditNotesTableTableManager(_$AppDatabase db, $CreditNotesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CreditNotesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CreditNotesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CreditNotesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> noteNo = const Value.absent(),
                Value<int> fyStart = const Value.absent(),
                Value<int> sequence = const Value.absent(),
                Value<int> billId = const Value.absent(),
                Value<DateTime> issuedAt = const Value.absent(),
                Value<String?> reason = const Value.absent(),
                Value<int> taxablePaise = const Value.absent(),
                Value<int> taxPaise = const Value.absent(),
                Value<int> totalPaise = const Value.absent(),
                Value<String> refundMode = const Value.absent(),
              }) => CreditNotesCompanion(
                id: id,
                noteNo: noteNo,
                fyStart: fyStart,
                sequence: sequence,
                billId: billId,
                issuedAt: issuedAt,
                reason: reason,
                taxablePaise: taxablePaise,
                taxPaise: taxPaise,
                totalPaise: totalPaise,
                refundMode: refundMode,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String noteNo,
                required int fyStart,
                required int sequence,
                required int billId,
                required DateTime issuedAt,
                Value<String?> reason = const Value.absent(),
                required int taxablePaise,
                required int taxPaise,
                required int totalPaise,
                required String refundMode,
              }) => CreditNotesCompanion.insert(
                id: id,
                noteNo: noteNo,
                fyStart: fyStart,
                sequence: sequence,
                billId: billId,
                issuedAt: issuedAt,
                reason: reason,
                taxablePaise: taxablePaise,
                taxPaise: taxPaise,
                totalPaise: totalPaise,
                refundMode: refundMode,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CreditNotesTable, CreditNoteRow>(table),
                  $$CreditNotesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({billId = false, creditNoteLinesRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (creditNoteLinesRefs) db.creditNoteLines,
                  ],
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
                            referencedTable: $$CreditNotesTableReferences
                                ._billIdTable(db),
                            referencedColumn: $$CreditNotesTableReferences
                                ._billIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (creditNoteLinesRefs)
                        await $_getPrefetchedDataByColumns<
                          CreditNoteRow,
                          $CreditNotesTable,
                          CreditNoteLineRow,
                          $CreditNoteLinesTable
                        >(
                          currentTable: table,
                          referencedTable: $$CreditNotesTableReferences
                              ._creditNoteLinesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CreditNotesTableReferences(
                                db,
                                table,
                                p0,
                              ).creditNoteLinesRefs,
                          currentColumn: 'id',
                          referencedColumn: 'credit_note_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$CreditNotesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CreditNotesTable,
      CreditNoteRow,
      $$CreditNotesTableFilterComposer,
      $$CreditNotesTableOrderingComposer,
      $$CreditNotesTableAnnotationComposer,
      $$CreditNotesTableCreateCompanionBuilder,
      $$CreditNotesTableUpdateCompanionBuilder,
      (CreditNoteRow, $$CreditNotesTableReferences),
      CreditNoteRow,
      PrefetchHooks Function({bool billId, bool creditNoteLinesRefs})
    >;
typedef $$CreditNoteLinesTableCreateCompanionBuilder =
    CreditNoteLinesCompanion Function({
      Value<int> id,
      required int creditNoteId,
      required int billLineId,
      required int quantityMilli,
      required int taxablePaise,
      required int taxPaise,
      required int totalPaise,
    });
typedef $$CreditNoteLinesTableUpdateCompanionBuilder =
    CreditNoteLinesCompanion Function({
      Value<int> id,
      Value<int> creditNoteId,
      Value<int> billLineId,
      Value<int> quantityMilli,
      Value<int> taxablePaise,
      Value<int> taxPaise,
      Value<int> totalPaise,
    });

final class $$CreditNoteLinesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $CreditNoteLinesTable,
          CreditNoteLineRow
        > {
  $$CreditNoteLinesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $CreditNotesTable _creditNoteIdTable(_$AppDatabase db) => db
      .creditNotes
      .createAlias('credit_note_lines__credit_note_id__credit_notes__id');

  $$CreditNotesTableProcessedTableManager get creditNoteId {
    final $_column = $_itemColumn<int>('credit_note_id')!;

    final manager = $$CreditNotesTableTableManager(
      $_db,
      $_db.creditNotes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_creditNoteIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $BillLinesTable _billLineIdTable(_$AppDatabase db) => db.billLines
      .createAlias('credit_note_lines__bill_line_id__bill_lines__id');

  $$BillLinesTableProcessedTableManager get billLineId {
    final $_column = $_itemColumn<int>('bill_line_id')!;

    final manager = $$BillLinesTableTableManager(
      $_db,
      $_db.billLines,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_billLineIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$CreditNoteLinesTableFilterComposer
    extends Composer<_$AppDatabase, $CreditNoteLinesTable> {
  $$CreditNoteLinesTableFilterComposer({
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

  ColumnFilters<int> get quantityMilli => $composableBuilder(
    column: $table.quantityMilli,
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

  $$CreditNotesTableFilterComposer get creditNoteId {
    final $$CreditNotesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.creditNoteId,
      referencedTable: $db.creditNotes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CreditNotesTableFilterComposer(
            $db: $db,
            $table: $db.creditNotes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$BillLinesTableFilterComposer get billLineId {
    final $$BillLinesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.billLineId,
      referencedTable: $db.billLines,
      getReferencedColumn: (t) => t.id,
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
    return composer;
  }
}

class $$CreditNoteLinesTableOrderingComposer
    extends Composer<_$AppDatabase, $CreditNoteLinesTable> {
  $$CreditNoteLinesTableOrderingComposer({
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

  ColumnOrderings<int> get quantityMilli => $composableBuilder(
    column: $table.quantityMilli,
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

  $$CreditNotesTableOrderingComposer get creditNoteId {
    final $$CreditNotesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.creditNoteId,
      referencedTable: $db.creditNotes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CreditNotesTableOrderingComposer(
            $db: $db,
            $table: $db.creditNotes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$BillLinesTableOrderingComposer get billLineId {
    final $$BillLinesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.billLineId,
      referencedTable: $db.billLines,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BillLinesTableOrderingComposer(
            $db: $db,
            $table: $db.billLines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CreditNoteLinesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CreditNoteLinesTable> {
  $$CreditNoteLinesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get quantityMilli => $composableBuilder(
    column: $table.quantityMilli,
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

  $$CreditNotesTableAnnotationComposer get creditNoteId {
    final $$CreditNotesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.creditNoteId,
      referencedTable: $db.creditNotes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CreditNotesTableAnnotationComposer(
            $db: $db,
            $table: $db.creditNotes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$BillLinesTableAnnotationComposer get billLineId {
    final $$BillLinesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.billLineId,
      referencedTable: $db.billLines,
      getReferencedColumn: (t) => t.id,
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
    return composer;
  }
}

class $$CreditNoteLinesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CreditNoteLinesTable,
          CreditNoteLineRow,
          $$CreditNoteLinesTableFilterComposer,
          $$CreditNoteLinesTableOrderingComposer,
          $$CreditNoteLinesTableAnnotationComposer,
          $$CreditNoteLinesTableCreateCompanionBuilder,
          $$CreditNoteLinesTableUpdateCompanionBuilder,
          (CreditNoteLineRow, $$CreditNoteLinesTableReferences),
          CreditNoteLineRow,
          PrefetchHooks Function({bool creditNoteId, bool billLineId})
        > {
  $$CreditNoteLinesTableTableManager(
    _$AppDatabase db,
    $CreditNoteLinesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CreditNoteLinesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CreditNoteLinesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CreditNoteLinesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> creditNoteId = const Value.absent(),
                Value<int> billLineId = const Value.absent(),
                Value<int> quantityMilli = const Value.absent(),
                Value<int> taxablePaise = const Value.absent(),
                Value<int> taxPaise = const Value.absent(),
                Value<int> totalPaise = const Value.absent(),
              }) => CreditNoteLinesCompanion(
                id: id,
                creditNoteId: creditNoteId,
                billLineId: billLineId,
                quantityMilli: quantityMilli,
                taxablePaise: taxablePaise,
                taxPaise: taxPaise,
                totalPaise: totalPaise,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int creditNoteId,
                required int billLineId,
                required int quantityMilli,
                required int taxablePaise,
                required int taxPaise,
                required int totalPaise,
              }) => CreditNoteLinesCompanion.insert(
                id: id,
                creditNoteId: creditNoteId,
                billLineId: billLineId,
                quantityMilli: quantityMilli,
                taxablePaise: taxablePaise,
                taxPaise: taxPaise,
                totalPaise: totalPaise,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CreditNoteLinesTable, CreditNoteLineRow>(table),
                  $$CreditNoteLinesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({creditNoteId = false, billLineId = false}) {
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
                    if (creditNoteId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.creditNoteId,
                        referencedTable: $$CreditNoteLinesTableReferences
                            ._creditNoteIdTable(db),
                        referencedColumn: $$CreditNoteLinesTableReferences
                            ._creditNoteIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (billLineId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.billLineId,
                        referencedTable: $$CreditNoteLinesTableReferences
                            ._billLineIdTable(db),
                        referencedColumn: $$CreditNoteLinesTableReferences
                            ._billLineIdTable(db)
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

typedef $$CreditNoteLinesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CreditNoteLinesTable,
      CreditNoteLineRow,
      $$CreditNoteLinesTableFilterComposer,
      $$CreditNoteLinesTableOrderingComposer,
      $$CreditNoteLinesTableAnnotationComposer,
      $$CreditNoteLinesTableCreateCompanionBuilder,
      $$CreditNoteLinesTableUpdateCompanionBuilder,
      (CreditNoteLineRow, $$CreditNoteLinesTableReferences),
      CreditNoteLineRow,
      PrefetchHooks Function({bool creditNoteId, bool billLineId})
    >;
typedef $$CreditNoteCountersTableCreateCompanionBuilder =
    CreditNoteCountersCompanion Function({
      Value<int> fyStart,
      required int lastSequence,
    });
typedef $$CreditNoteCountersTableUpdateCompanionBuilder =
    CreditNoteCountersCompanion Function({
      Value<int> fyStart,
      Value<int> lastSequence,
    });

class $$CreditNoteCountersTableFilterComposer
    extends Composer<_$AppDatabase, $CreditNoteCountersTable> {
  $$CreditNoteCountersTableFilterComposer({
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

class $$CreditNoteCountersTableOrderingComposer
    extends Composer<_$AppDatabase, $CreditNoteCountersTable> {
  $$CreditNoteCountersTableOrderingComposer({
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

class $$CreditNoteCountersTableAnnotationComposer
    extends Composer<_$AppDatabase, $CreditNoteCountersTable> {
  $$CreditNoteCountersTableAnnotationComposer({
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

class $$CreditNoteCountersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CreditNoteCountersTable,
          CreditNoteCounter,
          $$CreditNoteCountersTableFilterComposer,
          $$CreditNoteCountersTableOrderingComposer,
          $$CreditNoteCountersTableAnnotationComposer,
          $$CreditNoteCountersTableCreateCompanionBuilder,
          $$CreditNoteCountersTableUpdateCompanionBuilder,
          (
            CreditNoteCounter,
            BaseReferences<
              _$AppDatabase,
              $CreditNoteCountersTable,
              CreditNoteCounter
            >,
          ),
          CreditNoteCounter,
          PrefetchHooks Function()
        > {
  $$CreditNoteCountersTableTableManager(
    _$AppDatabase db,
    $CreditNoteCountersTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CreditNoteCountersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CreditNoteCountersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CreditNoteCountersTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> fyStart = const Value.absent(),
                Value<int> lastSequence = const Value.absent(),
              }) => CreditNoteCountersCompanion(
                fyStart: fyStart,
                lastSequence: lastSequence,
              ),
          createCompanionCallback:
              ({
                Value<int> fyStart = const Value.absent(),
                required int lastSequence,
              }) => CreditNoteCountersCompanion.insert(
                fyStart: fyStart,
                lastSequence: lastSequence,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CreditNoteCountersTable, CreditNoteCounter>(
                    table,
                  ),
                  BaseReferences<
                    _$AppDatabase,
                    $CreditNoteCountersTable,
                    CreditNoteCounter
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CreditNoteCountersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CreditNoteCountersTable,
      CreditNoteCounter,
      $$CreditNoteCountersTableFilterComposer,
      $$CreditNoteCountersTableOrderingComposer,
      $$CreditNoteCountersTableAnnotationComposer,
      $$CreditNoteCountersTableCreateCompanionBuilder,
      $$CreditNoteCountersTableUpdateCompanionBuilder,
      (
        CreditNoteCounter,
        BaseReferences<
          _$AppDatabase,
          $CreditNoteCountersTable,
          CreditNoteCounter
        >,
      ),
      CreditNoteCounter,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ShopProfilesTableTableManager get shopProfiles =>
      $$ShopProfilesTableTableManager(_db, _db.shopProfiles);
  $$CategoriesTableTableManager get categories =>
      $$CategoriesTableTableManager(_db, _db.categories);
  $$ItemsTableTableManager get items =>
      $$ItemsTableTableManager(_db, _db.items);
  $$PartiesTableTableManager get parties =>
      $$PartiesTableTableManager(_db, _db.parties);
  $$BillsTableTableManager get bills =>
      $$BillsTableTableManager(_db, _db.bills);
  $$BillLinesTableTableManager get billLines =>
      $$BillLinesTableTableManager(_db, _db.billLines);
  $$InvoiceCountersTableTableManager get invoiceCounters =>
      $$InvoiceCountersTableTableManager(_db, _db.invoiceCounters);
  $$AppSettingsTableTableManager get appSettings =>
      $$AppSettingsTableTableManager(_db, _db.appSettings);
  $$ItemBatchesTableTableManager get itemBatches =>
      $$ItemBatchesTableTableManager(_db, _db.itemBatches);
  $$StockMovementsTableTableManager get stockMovements =>
      $$StockMovementsTableTableManager(_db, _db.stockMovements);
  $$PartyEntriesTableTableManager get partyEntries =>
      $$PartyEntriesTableTableManager(_db, _db.partyEntries);
  $$PurchasesTableTableManager get purchases =>
      $$PurchasesTableTableManager(_db, _db.purchases);
  $$PurchaseLinesTableTableManager get purchaseLines =>
      $$PurchaseLinesTableTableManager(_db, _db.purchaseLines);
  $$ExpensesTableTableManager get expenses =>
      $$ExpensesTableTableManager(_db, _db.expenses);
  $$CreditNotesTableTableManager get creditNotes =>
      $$CreditNotesTableTableManager(_db, _db.creditNotes);
  $$CreditNoteLinesTableTableManager get creditNoteLines =>
      $$CreditNoteLinesTableTableManager(_db, _db.creditNoteLines);
  $$CreditNoteCountersTableTableManager get creditNoteCounters =>
      $$CreditNoteCountersTableTableManager(_db, _db.creditNoteCounters);
}
