import 'dart:typed_data';
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:gcloud/storage.dart';
import 'package:mime/mime.dart';

class CloudApi {
  final auth.ServiceAccountCredentials _credentials;
  late auth.AutoRefreshingAuthClient _client;
  bool _clientInitialized = false;


  CloudApi(String json)
      : _credentials = auth.ServiceAccountCredentials.fromJson(json);

  Future<void> _initializeClient() async {
    if (!_clientInitialized) {
      _client = await auth.clientViaServiceAccount(_credentials, Storage.SCOPES);
      _clientInitialized = true;
    }
  }

  Future<ObjectInfo> save(String name, Uint8List imgBytes) async {
    // Create a client
    await _initializeClient();
    // Instantiate objects to cloud storage
    var storage = Storage(_client, 'Image Upload Google Storage');
    var bucket = storage.bucket('imatges-sistemes-multimedia');

    // Save to bucket
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final type = lookupMimeType(name);
    return await bucket.writeBytes(name, imgBytes,
        metadata: ObjectMetadata(
          contentType: type,
          custom: {
            'timestamp': '$timestamp',
          },
        ));
  }

}