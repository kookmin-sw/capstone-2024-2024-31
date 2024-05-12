abstract class Env {
  Env._();

  static String serverUrl = 'http://${serverIpByEnv()}:8080';
  static String serverUrlNip = 'http://${serverIpByEnv()}.nip.io:8080';

  static String serverIpByEnv() {
    const env = String.fromEnvironment("env", defaultValue: 'production');
    switch (env) {
      case 'development':
        return '3.34.14.45';
      case 'local':
        return '10.0.2.2';
      default:
        return '10.0.2.2';
    }
  }
}
