import 'dart:async';
import 'dart:convert';
import 'dart:io';

class CustomHttpClient with HttpClient {
  CustomHttpClient() {

  }

  bool autoUncompress;
  Duration connectionTimeout;
  Duration idleTimeout;
  int maxConnectionsPerHost;
  String userAgent;
  void addCredentials(
      Uri url, String realm, HttpClientCredentials credentials) {}
  void addProxyCredentials(
      String host, int port, String realm, HttpClientCredentials credentials) {}
  set authenticate(
      Future<bool> Function(Uri url, String scheme, String realm) f) {}
  set authenticateProxy(
      Future<bool> Function(String host, int port, String scheme, String realm)
          f) {}
  set badCertificateCallback(
      bool Function(X509Certificate cert, String host, int port) callback) {}
  void close({bool force = false}) {}
  Future<HttpClientRequest> delete(String host, int port, String path) {
    return null;
  }

  Future<HttpClientRequest> deleteUrl(Uri url) {
    return null;
  }

  set findProxy(String Function(Uri url) f) {}

  @override
  Future<HttpClientRequest> get(String host, int port, String path) {
        print('get');
    return null;
  }

  @override
  Future<HttpClientRequest> getUrl(Uri url) {
        print('getUrl');
    return null;
  }

  Future<HttpClientRequest> head(String host, int port, String path) {
    return null;
  }

  Future<HttpClientRequest> headUrl(Uri url) {
    return null;
  }

  @override
  Future<HttpClientRequest> open(
      String method, String host, int port, String path) {
        print('open');

    return null;
  }

  @override
  Future<HttpClientRequest> openUrl(String method, Uri url) {
        print('openUrl');
    return null;
  }

  Future<HttpClientRequest> patch(String host, int port, String path) {
    return null;
  }

  Future<HttpClientRequest> patchUrl(Uri url) {
    return null;
  }

  Future<HttpClientRequest> post(String host, int port, String path) {
    return null;
  }

  Future<HttpClientRequest> postUrl(Uri url) {
    return null;
  }

  Future<HttpClientRequest> put(String host, int port, String path) {
    return null;
  }

  Future<HttpClientRequest> putUrl(Uri url) {
    return null;
  }
}

/// This class overrides the global proxy settings.
class DeviceProxyHttpOverride extends HttpOverrides {
  DeviceProxyHttpOverride() {
    print('DeviceProxyHttpOverride()');
  }

  @override
  HttpClient createHttpClient(SecurityContext context) {
    print('createHttpClient');
    return CustomHttpClient();
  }
}

class FakeHttpClientRequest implements HttpClientRequest {
  FakeHttpClientRequest();

  @override
  bool bufferOutput;

  @override
  int contentLength;

  @override
  Encoding encoding;

  @override
  bool followRedirects;

  @override
  int maxRedirects;

  @override
  bool persistentConnection;

  @override
  void add(List<int> data) {}

  @override
  void addError(Object error, [StackTrace stackTrace]) {}

  @override
  Future<void> addStream(Stream<List<int>> stream) async {}

  @override
  Future<HttpClientResponse> close() async {
    return FakeHttpClientResponse();
  }

  @override
  HttpConnectionInfo get connectionInfo => null;

  @override
  List<Cookie> get cookies => <Cookie>[];

  @override
  Future<HttpClientResponse> get done => null;

  @override
  Future<void> flush() {
    return Future<void>.value();
  }

  @override
  HttpHeaders get headers => FakeHttpHeaders();

  @override
  String get method => null;

  @override
  Uri get uri => null;

  @override
  void write(Object obj) {}

  @override
  void writeAll(Iterable<Object> objects, [String separator = '']) {}

  @override
  void writeCharCode(int charCode) {}

  @override
  void writeln([Object obj = '']) {}

  @override
  void abort([Object exception, StackTrace stackTrace]) {}
}

class FakeHttpClientResponse implements HttpClientResponse {
  final Stream<List<int>> _delegate = Stream<List<int>>.fromIterable(const Iterable<List<int>>.empty());

  @override
  final HttpHeaders headers = FakeHttpHeaders();

  @override
  X509Certificate get certificate => null;

  @override
  HttpConnectionInfo get connectionInfo => null;

  @override
  int get contentLength => 0;

  @override
  HttpClientResponseCompressionState get compressionState {
    return HttpClientResponseCompressionState.decompressed;
  }

  @override
  List<Cookie> get cookies => null;

  @override
  Future<Socket> detachSocket() {
    return Future<Socket>.error(UnsupportedError('Mocked response'));
  }

  @override
  bool get isRedirect => false;

  @override
  StreamSubscription<List<int>> listen(void Function(List<int> event) onData, { Function onError, void Function() onDone, bool cancelOnError }) {
    return const Stream<List<int>>.empty().listen(onData, onError: onError, onDone: onDone, cancelOnError: cancelOnError);
  }

  @override
  bool get persistentConnection => null;

  @override
  String get reasonPhrase => null;

  @override
  Future<HttpClientResponse> redirect([ String method, Uri url, bool followLoops ]) {
    return Future<HttpClientResponse>.error(UnsupportedError('Mocked response'));
  }

  @override
  List<RedirectInfo> get redirects => <RedirectInfo>[];

  @override
  int get statusCode => 400;

  @override
  Future<bool> any(bool Function(List<int> element) test) {
    return _delegate.any(test);
  }

  @override
  Stream<List<int>> asBroadcastStream({
    void Function(StreamSubscription<List<int>> subscription) onListen,
    void Function(StreamSubscription<List<int>> subscription) onCancel,
  }) {
    return _delegate.asBroadcastStream(onListen: onListen, onCancel: onCancel);
  }

  @override
  Stream<E> asyncExpand<E>(Stream<E> Function(List<int> event) convert) {
    return _delegate.asyncExpand<E>(convert);
  }

  @override
  Stream<E> asyncMap<E>(FutureOr<E> Function(List<int> event) convert) {
    return _delegate.asyncMap<E>(convert);
  }

  @override
  Stream<R> cast<R>() {
    return _delegate.cast<R>();
  }

  @override
  Future<bool> contains(Object needle) {
    return _delegate.contains(needle);
  }

  @override
  Stream<List<int>> distinct([bool Function(List<int> previous, List<int> next) equals]) {
    return _delegate.distinct(equals);
  }

  @override
  Future<E> drain<E>([E futureValue]) {
    return _delegate.drain<E>(futureValue);
  }

  @override
  Future<List<int>> elementAt(int index) {
    return _delegate.elementAt(index);
  }

  @override
  Future<bool> every(bool Function(List<int> element) test) {
    return _delegate.every(test);
  }

  @override
  Stream<S> expand<S>(Iterable<S> Function(List<int> element) convert) {
    return _delegate.expand(convert);
  }

  @override
  Future<List<int>> get first => _delegate.first;

  @override
  Future<List<int>> firstWhere(
    bool Function(List<int> element) test, {
    List<int> Function() orElse,
  }) {
    return _delegate.firstWhere(test, orElse: orElse);
  }

  @override
  Future<S> fold<S>(S initialValue, S Function(S previous, List<int> element) combine) {
    return _delegate.fold<S>(initialValue, combine);
  }

  @override
  Future<dynamic> forEach(void Function(List<int> element) action) {
    return _delegate.forEach(action);
  }

  @override
  Stream<List<int>> handleError(
    Function onError, {
    bool Function(dynamic error) test,
  }) {
    return _delegate.handleError(onError, test: test);
  }

  @override
  bool get isBroadcast => _delegate.isBroadcast;

  @override
  Future<bool> get isEmpty => _delegate.isEmpty;

  @override
  Future<String> join([String separator = '']) {
    return _delegate.join(separator);
  }

  @override
  Future<List<int>> get last => _delegate.last;

  @override
  Future<List<int>> lastWhere(
    bool Function(List<int> element) test, {
    List<int> Function() orElse,
  }) {
    return _delegate.lastWhere(test, orElse: orElse);
  }

  @override
  Future<int> get length => _delegate.length;

  @override
  Stream<S> map<S>(S Function(List<int> event) convert) {
    return _delegate.map<S>(convert);
  }

  @override
  Future<dynamic> pipe(StreamConsumer<List<int>> streamConsumer) {
    return _delegate.pipe(streamConsumer);
  }

  @override
  Future<List<int>> reduce(List<int> Function(List<int> previous, List<int> element) combine) {
    return _delegate.reduce(combine);
  }

  @override
  Future<List<int>> get single => _delegate.single;

  @override
  Future<List<int>> singleWhere(bool Function(List<int> element) test, {List<int> Function() orElse}) {
    return _delegate.singleWhere(test, orElse: orElse);
  }

  @override
  Stream<List<int>> skip(int count) {
    return _delegate.skip(count);
  }

  @override
  Stream<List<int>> skipWhile(bool Function(List<int> element) test) {
    return _delegate.skipWhile(test);
  }

  @override
  Stream<List<int>> take(int count) {
    return _delegate.take(count);
  }

  @override
  Stream<List<int>> takeWhile(bool Function(List<int> element) test) {
    return _delegate.takeWhile(test);
  }

  @override
  Stream<List<int>> timeout(
    Duration timeLimit, {
    void Function(EventSink<List<int>> sink) onTimeout,
  }) {
    return _delegate.timeout(timeLimit, onTimeout: onTimeout);
  }

  @override
  Future<List<List<int>>> toList() {
    return _delegate.toList();
  }

  @override
  Future<Set<List<int>>> toSet() {
    return _delegate.toSet();
  }

  @override
  Stream<S> transform<S>(StreamTransformer<List<int>, S> streamTransformer) {
    return _delegate.transform<S>(streamTransformer);
  }

  @override
  Stream<List<int>> where(bool Function(List<int> event) test) {
    return _delegate.where(test);
  }
}

/// A fake [HttpHeaders] that ignores all writes.
class FakeHttpHeaders extends HttpHeaders {
  @override
  List<String> operator [](String name) => <String>[];

  @override
  void add(String name, Object value, {bool preserveHeaderCase = false}) { }

  @override
  void clear() { }

  @override
  void forEach(void Function(String name, List<String> values) f) { }

  @override
  void noFolding(String name) { }

  @override
  void remove(String name, Object value) { }

  @override
  void removeAll(String name) { }

  @override
  void set(String name, Object value, {bool preserveHeaderCase = false}) { }

  @override
  String value(String name) => null;
}