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
              "private_key_id": "aed32385cfdae2caa9674513b2c448fb97990d43",
              "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvwIBADANBgkqhkiG9w0BAQEFAASCBKkwggSlAgEAAoIBAQDR4KH7QeY9t3YH\nJwheA/mW6VtLti+t+h99FO5xPuveBI6QeE4d83gFhWRm8Sltkerrbv1r6XVnraDE\nhv3+KmmREcKe4RpWfczjeeW94TJhj3ZYFeAUKVcNCUoGkc74IRvKCks5tJop9Rgl\nACE1YKadvaliyDJBKAQ+n+TM6TDdfFdHahi3n8aIEt/wUJ+/3Xk4J2aRdLnr6Zwc\nTp/xzdppe0qGEAFQlSdsA7+Rypp7gzh0prdfz6x2SzUG97QjR0TTheYHePUdgbq2\nnacEJNxUa4ZM5QHYQQpmgEYyPV8ufKN+eJhG1pMSnWULK9FUVdUpEZvA/go/3fTO\nUFd/NQ75AgMBAAECggEAAf/xvIJHR84Dqxkx/RcCWy/iyZpFLXNpS/tbCMZJ1Xob\nY3tupMjVEKS8XSHojEWESfqVzKq4g8oC8sXFrd+Yqn6onoku+NqWwnxJkOk7CMnc\nSFtVVjfXyfU3/iSdnAi7ui17g+5JZu4xt6je8s0L6rZGjYfdDmN2WTmT4r3I6YlW\nn3JdgctljOib1glNtQSLcUat7m9iivbUvW7j3J6dDDtQJl9WFP3g7UFI+RDN4Dq7\nWp/buaeaAsnslr0uqkmr2iPbqr6b2bkPQeei5+bWCDCXV62QbM33e5X2es2b6tqy\n2iyNG6qybSP3qbPvyhYDVuA0/6q7Gna4CF1vCJ2pcQKBgQD+H7f8fxVqJcMw2VJz\n0tLhAwjRZQxKMB7b3fA55L/szWqjnHn8gF38Wkvdx9seNduoMtonWkWkbcHcl3bt\na1GmRi42ans4cCdwt4b/PreqKqWTWk2P6jdz+erOKmNb3Zqz25g0kUELF2RBto2q\nyIo633826ifqdi2XV+ZT4JhJ8QKBgQDTbUpgWDb/oETSgjCvJpaPMZFafF+QKjCk\nxVPOiM1/HzAug7fBnfX8DrXkewZqaH2g4o0ZJXeVdizHp4nnImjuJMk8v+DHdMxz\n3FHrlgu9Otr/SifCIUIGzHem5Usn1YYbWULD/lzeMJhYZrNM8/iF/SocmiMi3j4T\nDjJevvhNiQKBgQCDo7CuVrKkKu2i92DT6OkecHD3741fPPAvWxefFdUp+Pr9yAgU\n+fY1zByyxV3Hl4Sy66zAZ+3dkJG1EK0lrcs9A+vaemxcPxTfOeLvg/CmcLMW0teM\n7npNVLACnkicBP6nnuCIkpoMAdEIjWVzi7C3cKE4tDF7Lj7NwFXrK1QYMQKBgQDB\nNZTMapEIFXwPK242AXuBK/j6ycHCyutdB/7INPgl/WhYeYJJa4LJbuAGBe8c+pQj\nnCT5H+YiLbZKVe6NzEI7rl5AJ9DQNQpJrsMmGR5tNQXAWhHvM9lUwTFu0QdXRaei\nAnYjCaXwXlQ6JNAhuKoaN/pt3OXTDWmInGancrkSkQKBgQCJEzZ31ou7O766VN0k\nLcF9DJrdWCFHooq4bwu9P8Ij6QYOx760s7HoHmXGdBuDuhCB31StAgBtlBYxyfHD\n2VBxRSAckkdQWRx0QH9R4XdMCZd9a22Un/y9aXchzzm1VAxbN1C01nNYZ/k+jGWT\nsbvUGnAEOmIQwdHNx9D2Ttf9VA==\n-----END PRIVATE KEY-----\n",
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