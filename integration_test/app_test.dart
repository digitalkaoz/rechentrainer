import 'package:integration_test/integration_test.dart';

import '../test/widgets/app_test.dart' as flow;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  flow.main(onDevice: true);
}
