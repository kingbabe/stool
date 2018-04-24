import 'dart:mirrors';

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
}
// abstract router

class Router {
  Map<String, Map> _router = {};

  void registerController(Object controllerIns, String path) {
    var klass = reflectClass(controllerIns.runtimeType);
    klass.declarations.forEach((Symbol symbol, DeclarationMirror declare) {
      if (declare is MethodMirror) {
        MethodMirror method = declare;
        if (method.isRegularMethod &&
            !method.isAbstract &&
            !method.isOperator) {
          var routeAnnotation = _getAnnotation(method, Route);
          if (routeAnnotation != null) {
          }
        }
      }
    });
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