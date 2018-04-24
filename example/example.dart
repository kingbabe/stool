import 'dart:mirrors';

class Demo {
  void hello() {
    print('hello');
  }
}

void main() {
  var demo = reflectClass(Demo);
  var b = demo.newInstance(new Symbol(''), []).reflectee;
  (b as Demo).hello();
}