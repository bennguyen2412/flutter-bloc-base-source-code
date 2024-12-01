enum FlavorConfigurations {
  dev(
    baseUrl: 'https://631eb73e58a1c0fe9f562cec.mockapi.io/',
    name: 'dev',
  ),
  staging(
    baseUrl: 'https://631eb73e58a1c0fe9f562cec.mockapi.io/',
    name: 'staging',
  ),
  production(
    baseUrl: 'https://631eb73e58a1c0fe9f562cec.mockapi.io/',
    name: 'production',
  );

  final String baseUrl;
  final int connectTimeout;
  final int receiveTimeout;
  final int sendTimeout;
  final String name;

  // Flavor things...

  const FlavorConfigurations({
    required this.baseUrl,
    required this.name,
    this.connectTimeout = _defaultConnectTimeout,
    this.receiveTimeout = _defaultReceiveTimeout,
    this.sendTimeout = _defaultSendTimeout,
  });

  static const _defaultConnectTimeout = 30000;
  static const _defaultReceiveTimeout = 30000;
  static const _defaultSendTimeout = 30000;

  static FlavorConfigurations _current = FlavorConfigurations.dev;

  static FlavorConfigurations get current {
    return _current;
  }

  static set current(FlavorConfigurations flavor) {
    _current = flavor;
  }
}
