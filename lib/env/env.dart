
import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env.dev')
abstract class Env {
  @EnviedField(varName: 'API_KEY', obfuscate: true)
  static final String api_key = _Env.api_key;
  @EnviedField(varName: 'APP_ID', obfuscate: true)
  static final String app_id = _Env.app_id;
  @EnviedField(varName: 'MESSAGING_SENDER_ID', obfuscate: true)
  static final String messaging_sender_id = _Env.messaging_sender_id;
  @EnviedField(varName: 'PROJECT_ID', obfuscate: true)
  static final String project_id = _Env.project_id;
}