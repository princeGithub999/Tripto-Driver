import 'package:googleapis_auth/auth_io.dart';

class GoogleSecret {

  static Future<String> getServerKey()async{

    final scopes = [
      "https://www.googleapis.com/auth/firebase.messaging"
    ];

    final client = await clientViaServiceAccount(
        ServiceAccountCredentials.fromJson(
            {
              "type": "service_account",
              "project_id": "fir-apptest-c3e4e",
              "private_key_id": "64b8d6b58bbc91b8677fbb3bf1b6a6feda29411d",
              "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDECiWZFHd7ELRk\nN7OgoGGrUqa+K3zJ1IckHyL+oE2deodHzYEAUfFHrrN+SlGtGE13576kDFAHAt0f\n5WaYRugYUfIIuUf5zUl8KeDhyHg5PEzsKnhImnXIEufoqGElpTTCKkl0grEEjbKj\nwvjxIgwRfiSc7MG7WDAtQue5J65rK0lAACHk3zwdakmvbni82dIzRjMRvx9eNTy2\nAB+Z1jL0f+U620w2wHKbAer0BHbWhcDjjhcXUEr+symaDJKkE/bgRO8F+ArB1nWy\nSGIKgj/v6heqzfnPeCRnauz0UwjhCYnb3l+xmI+DQZW8w5ygPW3cIG8pLQgE+LtY\nCfTmmldRAgMBAAECggEAAWl+0PCALk6MA52d256vb+bC7E1FaDhtRXczH5tgr1UW\niyFhIhZsMDn+0oLRbmo96q4oCmxl77nAPrJdfsCvljLG+seXBTQrw2fi7BxSl/4f\nRYR/sbhlCcMkr8+3yX35+o1x6H2PZ1jJQc0i529EYijWy6Q7bOAKpGIzMp6TlpJv\nVM7IJHMQpnawJA7WJgXAhlNqv1f8h/0ZlkLGXMD4OWZRk/NiJM4YfOW59Ntc6z0b\nZ+5MUnE3q6myKxkQplgwg8ssOmRr/7o7WrDoUf8FOnywulpGGI/5SrzIWrqSwoAs\no8hpRv5mUmczkITXYhqeeOV6Ha0gMkM5zuDhxt1Q4QKBgQDiRpnTYX5tmC0xwa5T\n+ySwyi8QZsGC1aOBPss30E0HdHfBovFz5f90XumYGchlcoUYDzBnYTgQiUFBFd4N\nIIpzUFPJcW6sx7eweiHbwVJhVE2+siRTGhmodXFcdrni8k9U5cD/G26Md845QuoX\noEA25WhYzp8z5EIurdOOGMHoJQKBgQDdyr0LbIIOlGhfoWlgd3xl2MwNr4eIuaaI\nPQD0wjsvYFvx5JW4MwDrG9CwckvcJNuoh0vb9wIZ96PHUuS4LICFVEWoc+iGGb9N\nE+FsNutmaTPnpWRBk0wzMP110+/bHKvJuP6yGov1XrLiG07R+q1adPhaDquOORyc\npxut9p3kvQKBgDIgHbd743v3uBtLooisG+amA2MIwFlxZjUdaftFQ6shG95jcEWS\nb9Khq/Gr1H7UrbM0ui5MlRTksvXuGDCkQsdkxgrb+/5+h6yqgZGi89Ln0AksgWt/\nXqu4yJIJIwipUPWnp+dbdlPbvm1k62Ksd00x6LmznATszdR1YWYbCemZAoGBAL2j\nb+ioqruUoXnDJbrZ73+V00OQZi69rmqm3n5o5PopRfSaInoRAiQE8HcuAzcEPNzo\ncjBuD1nsqBjyA6aGRo259KWIFbUzpqJc8U3512UFZuAWRpbbPzg2F0H8KQYMicY9\na2kV0b3HbuRtvQNFd5v0j7VQ/dbpdlFrgPtJ9s9xAoGBAOFEgzMZj+lem5WhzhWT\nQ1M0IRtCqNxG2v6PfudeS/BGhLxiojLWm7zGetxRffmNAgxcBIN2UwPJCPHpT4UT\nNdnWtnFnqATMR7hbiEds3+/TjmQQQbp/csktl/sd+y5627ZDuo8ARa7k1VO5HI3b\nLoUktI8w6Lc7Ub11RU78X1Jz\n-----END PRIVATE KEY-----\n",
              "client_email": "firebase-adminsdk-fbsvc@fir-apptest-c3e4e.iam.gserviceaccount.com",
              "client_id": "117271971666771266746",
              "auth_uri": "https://accounts.google.com/o/oauth2/auth",
              "token_uri": "https://oauth2.googleapis.com/token",
              "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
              "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-fbsvc%40fir-apptest-c3e4e.iam.gserviceaccount.com",
              "universe_domain": "googleapis.com"
            }
        ),
        scopes);
    final serverKey = client.credentials.accessToken.data;
    return serverKey;
  }
}