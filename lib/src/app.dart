// standard
import 'dart:mirrors';
// custom
import 'router.dart';

class Stool {
  final Router router = new Router();

  Stool() {

  }

  bool route(Type controllerClass, [String path]) {
    var klass = reflectClass(controllerClass);
    var controller = klass.newInstance(new Symbol(''), []).reflectee;
    
  }
}