// Stool request
import 'dart:io';

class Request {

  HttpRequest _raw;
  Map<String, String> params = {};

  Uri get uri => _raw?.uri;
  String get path => this.uri?.path;
  Map<String, String> get query => this.uri?.queryParameters;
  String get method => _raw?.method;

  Request(HttpRequest rawRequest): _raw = rawRequest {}

}