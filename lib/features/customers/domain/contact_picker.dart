/// A name and number chosen from the phone's contacts.
typedef PickedContact = ({String name, String phone});

/// Opens the phone's own contact picker. Only the chosen contact is shared
/// with the app, so no "read all contacts" permission is needed.
abstract interface class ContactPicker {
  /// `null` if cancelled.
  Future<PickedContact?> pick();
}
