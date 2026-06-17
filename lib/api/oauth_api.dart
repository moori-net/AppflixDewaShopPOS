import 'package:oauth2/oauth2.dart' as oauth2;
import 'package:dewa_app/api/logging_http_client.dart';

const String authEndpoint = 'api/oauth/token';
const String clientIdentifier = 'administration';
const String clientSecret = '';

Future<oauth2.Client> createClientCredentials(
    String appUrl,
    String accessKey,
    String secretAccessKey
    ) async {
  var client = await oauth2.clientCredentialsGrant(
      Uri.parse('$appUrl/$authEndpoint'),
      accessKey,
      secretAccessKey,
      scopes: ['write'],
      httpClient: LoggingHttpClient(),
      basicAuth: false
  );

  return client;
}

Future<oauth2.Client> createResourceOwnerPassword(
    String appUrl,
    String username,
    String password
    ) async {
  var client = await oauth2.resourceOwnerPasswordGrant(
    Uri.parse('$appUrl/$authEndpoint'),
    username,
    password,
    identifier: clientIdentifier,
    scopes: ['write'],
      httpClient: LoggingHttpClient(),
    basicAuth: false
  );

  return client;
}

Future<oauth2.Client> getClientFromCredentials(
    oauth2.Credentials credentials
    ) async {
  final client = oauth2.Client(
    credentials,
    identifier: clientIdentifier,
    secret: clientSecret,
      httpClient: LoggingHttpClient(),
    basicAuth: false
  );

  return await client;
}
