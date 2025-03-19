import 'package:googleapis_auth/auth_io.dart';

class GoogleSecret {

  static Future<String> getServerKey()async{

    final scopes = [
      "https://www.googleapis.com/auth/userinfo.email",
      "https://www.googleapis.com/auth/firebase.database",
      "https://www.googleapis.com/auth/firebase.messaging"
    ];

    final client = await clientViaServiceAccount(
        ServiceAccountCredentials.fromJson(
            {
              "type": "service_account",
              "project_id": "fir-apptest-c3e4e",
              "private_key_id": "bfb3362c07f474d1fffd75ef0bb7d680ca77c580",
              "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQCZeqJTk6fV5AAF\nNabY8lPX92NnIPsy6ES2vl1grHDxyj0CIwDVkqYmeuc0l8PKGYEweZgifTGW5j5b\ndxUwMTIM4nM9XkLtY4cpHmEe7x3taKb4mMy4nkXqp5GhbLCw8MZkIIBuCmrPBzMI\nuR/lyBgLbS3ObpA9ft6obn9gmMT9p8XTymVtMyXBUWTekRKKdwPuKb4GXpopQXGL\nuzOpN2D2EwA8oF26xKDOthpPVZTOFcg/YHaZvwikLm8lNZAskoZwzZVDZCX8kFO1\nskAtkFXWHujxNMcal40uRyUr1iN0qwa8+YcHXEHme/PFcvQDdn5rTcFRc1YwgslK\nTXzZXnxXAgMBAAECggEAAYOWr1lhCfieUW7WjwRQ9Gvx1JYcNEPbTawyEp6Q3KnA\nkVFUFEdGkVGcD0ZB/a/juN0yNYDjqNfrnI5frKKHml3vghb4dQwKzMqKbboxIuLp\n5sDnIBkbmnV9t8hxM8WkR1+UtMEwjYtGIxtkZ6liJ1az4XnwvVKPkrzIT+Uh6Fin\n7nq0OsVEzA8r+dZmLEVPO3xncncw8+TKyofIPPj57T4+eLPaVLxQ1fC+XIFr3EiY\nBagQMCObsNGVSAYmGVEnzlvzvNU8ZSJfxZI89Q9B35Vq8Uvws0DaDp2cjAMeDMZA\nQIc6li/aZQB5sk8f08IyMZHnC2u/TowS7yHjfHYP1QKBgQC+d1a81VlK8zP18KBG\nRZcPTgBVRkRMjI8NJAABSnsUVuAKYLRHSjg1HjDnz0YHLtzemuLnlXtVRdgFI8qK\nVc/LZ3KzLoSnSl2WKN9+xBc/nI4Fx3twiTOhmoYVAXwMn/27FJ+aV8QujRliww99\nbFvSh1Mlb6qywdPNJ/HNExPSNQKBgQDOSWQh+Hhqz7YRrEH4J8cB+M6PA4/w62ZK\nifRPLPSRb2qCpojhvU9paQPKdQ811OU9faaani7H/QQ1fviJUTcZeLh+YU6srlRv\nkGIWoKCDYT8bgUgW78+A37cZbATt482Oqla2EwIqX5L+x9rL+E7C8y+f6WPFkWD8\nDXEFwugl2wKBgC/tQaM0oEpu1jVdvkbQfgl43DaY/tiwSdLJq0Kn5j6g+bFC0jpa\nH7imBzJdgsaN8UAGg3A4uhckAw6QCggzPZ12Q3N5EiIyYUhGsq5oU11LXKVxo8sW\niypwAqtIe1mF7MflkZ+51ADOuoOSh9RMrvJT4QU7ix1+DnjCQ2MSGNu9AoGAejT+\nTiWt6NEesn+TIVknS2LDs/PPTVGXaucpRdKDHLmdpsLT6q/FINRmu4T3utNh7zjF\n/2lgm3eoC60pvefQNZXP7oblHeW0/dbSVUdZcBunUDsZowT0sAtYpIXasbe36iG9\nduXx7XprUebCFv4GYvXArAKO6ddDVm78GwapkusCgYB/7jaiU4LtOIlSeWnrDgNN\nRWOUZMAfGlFjptcSOrelEtBt+qWWub1T5tGzA6r+Al8P2jDlblEw3EV1mW1LhhWL\nlgYJGq9RSRD+KAflLvd4SqhEiTdf5+hiB6zEmW8kyu7+qOxgoAtrBIAVNO1YIzTW\nXOiDCoJyvxKE2b07hh/+PQ==\n-----END PRIVATE KEY-----\n",
              "client_email": "firebase-adminsdk-w2exz@fir-apptest-c3e4e.iam.gserviceaccount.com",
              "client_id": "102593739613645437720",
              "auth_uri": "https://accounts.google.com/o/oauth2/auth",
              "token_uri": "https://oauth2.googleapis.com/token",
              "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
              "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-w2exz%40fir-apptest-c3e4e.iam.gserviceaccount.com",
              "universe_domain": "googleapis.com"
            }
        ),
        scopes);
    final serverKey = client.credentials.accessToken.data;
    return serverKey;
  }
}