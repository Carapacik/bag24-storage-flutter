/// The progress of luggage storage booking completion
enum LuggageStorageBookingProgress() {
  /// The user has not yet started the booking process.
  notStarted,

  /// The user started but did not complete the booking process.
  inProgress,

  /// The user completed the booking process.
  completed,

  /// There was an error during the booking process.
  error,

  /// The user canceled the booking process.
  canceled,
}
