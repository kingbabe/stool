import 'dart:mirrors';
import 'package:path/path.dart' as Path;

import 'tools/path_to_regex.dart';
import 'tools/annotations.dart';
import 'controller.dart';

/// route annotation
class Route {
  final String path;
  final String method;
  /// define a route
  const Route(this.path, [this.method]);
  const Route.GET(String path) : this(path, 'GET');
  const Route.POST(String path) : this(path, 'POST');
  const Route.DELETE(String path) : this(path, 'DELETE');
  const Route.OPTION(String path) : this(path, 'OPTION');
  const Route.PUT(String path) : this(path, 'PUT');
  const Route.REDIRECT(String path) : this(path, 'REDIRECT');
  const Route.HEAD(String path) : this(path, 'HEAD');
  const Route.ALL(String path) : this(path, 'ALL');

  String toString() => '$method:$path';
}


class StoolRouter {
  static final StoolRouter _instance = new StoolRouter._internal();

  factory StoolRouter() {
    return _instance;
  }

  /// private constructor
  StoolRouter._internal();

  Map<String, Map<PathToRegex, Symbol>> router = {};
  Map<String, StoolController> _controllers = {};

  Map<String, StoolController> get controllers => _controllers;
  Map<PathToRegex, Symbol> getControllerMap(String path) => router[path];

  /// use this regex to judge if a function is async function
  RegExp _asyncFuncRegex = new RegExp('async\ *\n*{');

  /// register a controller into router map
  void registerController(Object controllerIns, String path) {
    // push a controller into memory
    _controllers[path] = controllerIns;

    var klass = reflectClass(controllerIns.runtimeType);
    Map<PathToRegex, Symbol> controllerMethodMap = {};
    klass.declarations.forEach((Symbol symbol, DeclarationMirror declare) {
      if (declare is MethodMirror) {
        MethodMirror method = declare;
        if (method.isRegularMethod &&
            !method.isAbstract &&
            !method.isOperator &&
            method.source.contains(_asyncFuncRegex)) {
          Route routeAnnotation = GetAnnotation(method, Route);
          if (routeAnnotation != null) {
            controllerMethodMap[new PathToRegex(Path.join(path, routeAnnotation.path), routeAnnotation.method)] = method.simpleName;
          }
        }
      }
    });
    router[path] = controllerMethodMap;
    print('[Stool Router] controller ${controllerIns.runtimeType} for route \'$path\' loaded');
  }


  Symbol handlerForRequest(Uri uri) {

  }
}