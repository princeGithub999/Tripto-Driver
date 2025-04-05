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
              "private_key_id": "00cd581ba6298b0473420e109e30180a11b4a87c",
              "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQC2zwV83r7xSy0p\nVGRuPN1s3E+MFq+kdsSjOv4O/TmdsyCu7nGdeL8kz7ncFB3nqo4737RKxWmRHMUl\n++WzyBSqG/j/JC6bEj8zC/faDZHiy4ZIi4OGGmf/oAHdK14LOcsAhBC/QHkARItg\nukPQalaesw5rnjn68SfiXfXy6BEKZlQ5mzAgkPYKMKaxw0r1ss7F0ez85eYaUAQ6\n2TehIueYBzhK3vBMIzVrcxA0afpojZiGTOYrNCnqKfBHnia9PnMB//PCKqEUO/j7\naLPttU+3xpU8LtfkWDPbPyMm9JTsRQDXbtnaV1oKLWbL/qiJ+/UHAJq4RdRmgtIl\novSzxpOrAgMBAAECggEAM2phiD/b42C5+HxYbNroiiQiqWt+Bhszbhd6+jtFd7G4\nWQsOYHRkClX0V84+pPhG3dcqzbbdXKeDWY4SCnEVQszwSM5j31CP/ur4UFdttyR4\nBbJbkR2fL3nQ3GREpJKiImiCj0/yWF1u+AsbZKRr7WG+Bg2wEADAr32u3Z1goZQw\nx9tKlTMgQzl5iyP2iHYUXmW9+KsCeglgVH8tty7jSHoAaAHnpH0OHkJRr9/ka9Wb\nHOh3rQgUyQgATp174hpH3ZGSUW7DCz1l5EUB+2vZWWSX5PhcmvyuOo80xJKnKTEZ\nkhuWJ6DXWoFZKraZdwr+JtJU1khfOayqjDaO0pIL3QKBgQDzRdMx/ztYS2JjgxXH\n/ocY7+KXRpY/r5cBYHxl+1n2TOEksuhUxSsl+bX8vNQU8p8JOlw6pPX9qk9RdXpt\ntNxeCTDXgR/zBh1yUhuZbxQrJ6x8df0Gn4JuaXSu4tE83hOmkzRcltmJV+lDkiJH\ncpt48xaeSCfjHiau/RhLEFWEBQKBgQDAX2U2JIhoMXyfPaDwqHS+0mYTk4jZD4oq\nw2zyju/YQSNbI+D5Xc7BISpNkSj+DdgTMhXlokmCJ78aQN5dE2FsM2fQ7f6HHJsT\njQ9vXIPCBwl5pUvNQ59t8YuTigpASZORijeqkmm5yhUIRkYDR4WiPTKmCTM/VBji\n1dyjm+p37wKBgQCHasnqXdoqBySIolKAlnWbcwUeEkPWxaZ4NL5qgmUMjrURGans\nbijbpcohGvevhXLzzxHB70ujXadzf8KbyP6WNeWDQLSJMlE37u7AFS4T66y/R2qG\nwkn3riouo8G3cSNdKToPhEUph88oNvNv9CMJS7++cgoKCiGcbPSV7Ey+BQKBgG1S\nCNdC3Y2wiayIvjvkzytdr4pybfNEJHV2xyP0XJJdOfViJ0guqf8QlNStqEjvnxoR\nfWYY2oMviScnM/ZavCNb9yRBC0LG2825fMsBHRMXIqhRaglE44X8HSCD8p1j8otj\nq4ywVYqyL0+bd9AHRgbTlkPKuKfFZ7sIY7FKOm1bAoGBAONFhp1CVz4OzB++Y8dZ\nernDmdkYajwSw+0XHhLl9whBp9/eMHBNa3dSHA1tqwPUEv87lY90POwMLWTGivPo\nshGHV3BeScXCQUsx2Tj9lXViWibYaFBHCdsRYaeTuRc8XdLjVqS0y+dqbv742uw5\nhzd52ImMjgVyTXO0k7ERIF8o\n-----END PRIVATE KEY-----\n",
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