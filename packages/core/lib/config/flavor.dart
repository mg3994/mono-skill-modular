import '../flavor/flavor_interface.dart';

enum Flavor implements FlavorInterface {
  development(
    baseUrl: String.fromEnvironment(
      'DEV_BLOGGER_URL',
      defaultValue: 'https://api.dev.yourdomain.com',
    ),
  ),

  staging(
    baseUrl: String.fromEnvironment(
      'STG_BLOGGER_URL',
      defaultValue: 'https://api.stg.yourdomain.com',
    ),
  ),

  production(
    baseUrl: String.fromEnvironment(
      'PROD_BLOGGER_URL',
      defaultValue: 'https://api.prod.yourdomain.com',
    ),
  );

  const Flavor({required this.baseUrl});

  @override
  final String baseUrl;

  static Flavor fromString(String? value) {
    return switch (value?.toLowerCase()) {
      'dev' || 'development' => Flavor.development,
      'stg' || 'staging' => Flavor.staging,
      'prod' || 'production' => Flavor.production,
      _ =>
        Flavor
            .production, //by default , please chage it whenever you are in dev
    };
  }
}
