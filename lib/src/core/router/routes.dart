enum Routes(final String path) {
  splash('/splash'),
  onboarding('/onboarding'),

  /// Authentication
  signIn('/input-phone'),
  otpCode('otp-code'),
  biometrics('/biometrics'),

  /// PIN
  enterPin('/enter-pin'),
  createPin('/create-pin'),

  /// Profile
  profile('/profile'),
  editProfile('/edit-profile'),
  notifications('notifications'),
  userBindingCards('user-binding-cards'),
  settings('settings'),
  selectLanguage('select-language'),
  editPin('edit-pin'),
  aboutApp('about-app'),

  /// Home
  home('/home'),

  /// Luggage storage
  checkInLuggageOrder('add-luggage/:storageId'),
  selectAirport('/select-airport'),
  selectStorage('/select-storage'),
  orderCreated('order-created/:orderId'),
  takePhoto('/take-photo'),
  chooseWhereToPay('choose-where-to-pay'),
  paymentWebView('/payment-web-view/:url'),
  paymentResult('/payment-result'),
  paymentInProgress('/payment-in-progress'),

  /// Orders
  orders('/orders'),
  order('/order/:orderId'),
  cancelOrder('cancel-order'),

  /// Support
  howWorksScreen('/how-works-screen'),
  faq('/faq'),
  support('support'),
  instruction('/instruction'),

  /// Fly post
  selectSendService('/select-send-service'),

  /// System screen
  connectionError('/connection-error'),
  technicalError('/technical-error'),
  updateApp('/update-app'),
}
