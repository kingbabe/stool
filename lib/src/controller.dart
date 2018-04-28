// controller.dart
import 'dart:io';
import 'request.dart';

class StoolContext {
  Map<String, Object> services = null;
  int statusCode = HttpStatus.OK;
  Request request = null;
  /// body can be string, also can be Map
  Object body = null;
}

abstract class StoolController {
  /// ctx is application context
  StoolContext ctx = null;
}

abstract class StoolService {
  /// ctx is application context
  StoolContext ctx = null;
}

abstract class StoolMiddleWare {
  /// ctx is application context
  StoolContext ctx = null;
}