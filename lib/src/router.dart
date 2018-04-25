import 'dart:mirrors';
import 'dart:async';
/// route annotation
class Route {
  final String path;
  final String method;
  /// define a route
  const Route(this.path, this.method);
  const Route.GET(String path) : this(path, 'GET');
  const Route.POST(String path) : this(path, 'POST');
  const Route.DELETE(String path) : this(path, 'DELETE');
  const Route.OPTION(String path) : this(path, 'OPTION');
  const Route.PUT(String path) : this(path, 'PUT');

  String toString() => '$method:$path';
}


class Router {
  static final Router _instance = new Router._internal();

  factory Router() {
    return _instance;
  }

  /// private constructor
  Router._internal();

  Map<String, Map<String, Symbol>> router = {};
  Map<String, Object> _controllers = {};

  /// use this regex to judge if a function is async function
  RegExp _asyncFuncRegex = new RegExp('async\ *\n*{');

  /// register a controller into router map
  void registerController(Object controllerIns, String path) {
    // push a controller into memory
    _controllers[path] = controllerIns;

    var klass = reflectClass(controllerIns.runtimeType);
    Map<String, Symbol> controllerMethodMap = {};
    klass.declarations.forEach((Symbol symbol, DeclarationMirror declare) {
      if (declare is MethodMirror) {
        MethodMirror method = declare;
        if (method.isRegularMethod &&
            !method.isAbstract &&
            !method.isOperator &&
            method.source.contains(_asyncFuncRegex)) {
          Route routeAnnotation = _getAnnotation(method, Route);
          if (routeAnnotation != null) {
            controllerMethodMap[routeAnnotation.toString()] = method.simpleName;
          }
        }
      }
    });
    router[path] = controllerMethodMap;
  }

  /// get annotation for controller route method
  dynamic _getAnnotation(MethodMirror method, Type annotationType) {
    for (var ins in method.metadata) {
      if (ins.hasReflectee) {
        if (ins.reflectee.runtimeType == annotationType) {
          return ins.reflectee;
        }
      }
    }
    return null;
  }
}