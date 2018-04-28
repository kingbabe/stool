// helper methods for annotations used in Stool
import 'dart:mirrors';

dynamic GetAnnotation(DeclarationMirror typeMirror, Type annotationType) {
  for (var ins in typeMirror.metadata) {
    if (ins.hasReflectee) {
      if (ins.reflectee.runtimeType == annotationType) {
        return ins.reflectee;
      }
    }
  }
  return null;
}