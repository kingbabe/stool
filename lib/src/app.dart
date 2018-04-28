// standard
import 'dart:mirrors';
import 'dart:async';
import 'dart:isolate';
import 'dart:io';
// custom
import 'router.dart';
import 'controller.dart';
import 'request.dart';
import 'tools/tools.dart';

class Stool {
  static final StoolRouter router = new StoolRouter();
  static final _app = new Stool._internal();

  HttpServer _server;

  factory Stool() {
    return _app;
  }

  Stool._internal() {
    _findAppLibraries();
  }

  _findAppLibraries() {
    currentMirrorSystem().libraries.forEach((uri, lib) {
      if (uri.scheme == 'file') {
        _findControllers(lib);
      }
    });
  }

  _findControllers(LibraryMirror lib) {
    var controllerClassMirror = reflectClass(StoolController);
    lib.declarations.forEach((symbol, declare) {
      if (declare is ClassMirror) {
        ClassMirror klass = declare as ClassMirror;
        if (klass.isSubclassOf(controllerClassMirror) && !klass.isAbstract) {
          Route route = GetAnnotation(klass, Route);
          if (route != null) {
            _route(klass.reflectedType, route.path);
          }
        }
      }
    });
  }

  /// bind port
  listen(InternetAddress host, int port) async  {
    if (this._server != null) {
      return;
    }
    this._server = await HttpServer.bind(host, port);
    await for (HttpRequest request in _server) {
      // handle requests
      dispatchRequest(request);
    }
  }

  _route(Type controllerClass, [String path]) {
    var klass = reflectClass(controllerClass);
    var controller = klass.newInstance(new Symbol(''), []).reflectee;
    router.registerController(controller, path);
    print('[Stool Controller Loader]: load $controllerClass success');
  }

  dispatchRequest(HttpRequest req) async {
    var path = controllerPath(req.uri);
    StoolContext context = new StoolContext();
    if (path == null) {
      // TODO: jump to 404
    }
    var controller = router.controllers[path];
    Map<PathToRegex, Symbol> map = router.getControllerMap(path);
    var params = null;
    Symbol handler = null;
    map.forEach((PathToRegex pathToRegex, Symbol symbo) {
      if (pathToRegex.match(req.uri, req.method.toUpperCase())) {
        params = pathToRegex.getPathParams(req.uri);
        handler = symbo;
      }
    });
    if (handler == null) {
      // TODO: jump to 404
    }
    context.request = new Request(req);
    context.request.params = params;
    controller.ctx = context;
    var reflectedInstance = reflect(controller);
    await reflectedInstance.invoke(handler, []);
    // TODO: get ctx and pass to next

  }

  String controllerPath(Uri uri) {
    router.controllers.forEach((path, controller) {
      if (uri.path.startsWith(path)) {
        return path;
      }
    });
    return null;
  }
}