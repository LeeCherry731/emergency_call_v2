import 'package:get/get.dart';
import 'package:logger/logger.dart';

enum LoadStatus {
  loading,
  success,
  error,
}

final log = Logger(printer: PrettyPrinter());

class HomeController extends GetxService {}
