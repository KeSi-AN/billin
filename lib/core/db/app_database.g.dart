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

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ShopProfilesTable shopProfiles = $ShopProfilesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [shopProfiles];
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

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ShopProfilesTableTableManager get shopProfiles =>
      $$ShopProfilesTableTableManager(_db, _db.shopProfiles);
}
