/// One synced record as the cloud keeps it: which table, its uid, and its
/// shared columns as JSON. [seq] orders all rows of a shop (set by the
/// server on every insert or update).
class CloudRow {
  const CloudRow({
    required this.tbl,
    required this.rowId,
    required this.data,
    this.seq = 0,
  });

  final String tbl;
  final String rowId;
  final Map<String, Object?> data;
  final int seq;
}

/// The cloud end of syncing: the shop's shared rows.
abstract interface class SyncRemote {
  /// Adds or replaces [rows] (by table and row id) for [shopId].
  Future<void> push(String shopId, String deviceId, List<CloudRow> rows);

  /// The shop's rows numbered above [after], oldest first, at most [limit].
  Future<List<CloudRow>> pull(String shopId, {required int after, int limit});
}

/// How syncing stands, for the account screen.
class SyncStatus {
  const SyncStatus({
    this.running = false,
    this.lastSyncedAt,
    this.pending = 0,
    this.error,
  });

  final bool running;
  final DateTime? lastSyncedAt;

  /// Changes on this phone not yet in the cloud.
  final int pending;

  /// Why the last attempt failed (no internet…), if it did.
  final String? error;

  SyncStatus copyWith({
    bool? running,
    DateTime? lastSyncedAt,
    int? pending,
    String? error,
    bool clearError = false,
  }) => SyncStatus(
    running: running ?? this.running,
    lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
    pending: pending ?? this.pending,
    error: clearError ? null : (error ?? this.error),
  );
}
