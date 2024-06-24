import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String baseUrl = 'http://10.0.2.2:8000';
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';

  Future<void> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/customers/token/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final String accessToken = data['access'];
      final String refreshToken = data['refresh'];

      await saveToken(accessToken, refreshToken);
    } else {
      throw Exception('Failed to login');
    }
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(accessTokenKey);
    await prefs.remove(refreshTokenKey);
  }

  Future<void> refreshToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? refreshToken = prefs.getString(refreshTokenKey);

    if (refreshToken != null) {
      final response = await http.post(
        Uri.parse('$baseUrl/api/customers/token/refresh/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refresh': refreshToken}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final String newAccessToken = data['access'];
        final String newRefreshToken = data['refresh'];
        await saveToken(newAccessToken, newRefreshToken);
      } else {
        logout();
      }
    }
  }

  Future<void> saveToken(String accessToken, String refreshToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(accessTokenKey, accessToken);
    await prefs.setString(refreshTokenKey, refreshToken);
  }

  Future<String?> getAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(accessTokenKey);
  }

  Future<Map<String, dynamic>> getLoyaltyProgram() async {
    try {
      final String? accessToken = await getAccessToken();

      if (accessToken != null) {
        final response = await http.get(
          Uri.parse('$baseUrl/api/customers/loyalty-program/'),
          headers: {'Authorization': 'Bearer $accessToken'},
        );

        if (response.statusCode == 200) {
          return jsonDecode(response.body);
        } else if (response.statusCode == 401) {
          // Token expired, try refreshing it
          await refreshToken();
          final String? accessToken2 = await getAccessToken();
          // Retry the request with the new token
          final refreshedResponse = await http.get(
            Uri.parse('$baseUrl/api/customers/loyalty-program/'),
            headers: {'Authorization': 'Bearer $accessToken2'},
          );

          if (refreshedResponse.statusCode == 200) {
            return jsonDecode(refreshedResponse.body);
          } else {
            throw Exception(
                'Failed to fetch loyalty program data after token refresh');
          }
        } else {
          // Handle other HTTP error codes
          throw Exception(
              'Failed to fetch loyalty program data: ${response.statusCode}');
        }
      } else {
        throw Exception('Failed to fetch loyalty program data');
      }
    } catch (e) {
      // Handle other exceptions, log the error, etc.
      print('Error in getLoyaltyProgram: $e');
      rethrow; // Rethrow the caught exception
    }
  }

  Future<List<Map<String, dynamic>>> getCouponsProgram() async {
    try {
      final String? accessToken = await getAccessToken();

      if (accessToken != null) {
        final response = await http.get(
          Uri.parse('$baseUrl/api/customers/coupons/'), // Update the endpoint
          headers: {'Authorization': 'Bearer $accessToken'},
        );

        if (response.statusCode == 200) {
          final List<Map<String, dynamic>> userCoupons =
              List<Map<String, dynamic>>.from(jsonDecode(response.body));
          return userCoupons;
        } else if (response.statusCode == 401) {
          await refreshToken();
          final String? accessToken2 = await getAccessToken();
          final refreshedResponse = await http.get(
            Uri.parse('$baseUrl/api/customers/coupons/'), // Update the endpoint
            headers: {'Authorization': 'Bearer $accessToken2'},
          );

          if (refreshedResponse.statusCode == 200) {
            final List<Map<String, dynamic>> userCoupons =
                List<Map<String, dynamic>>.from(
                    jsonDecode(refreshedResponse.body));
            return userCoupons;
          } else {
            throw Exception(
                'Failed to fetch user coupons data after token refresh');
          }
        } else {
          throw Exception(
              'Failed to fetch user coupons data: ${response.statusCode}');
        }
      } else {
        throw Exception('Failed to fetch user coupons data');
      }
    } catch (e) {
      print('Error in getCouponsProgram: $e');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getPaymentsProgram() async {
    try {
      final String? accessToken = await getAccessToken();

      if (accessToken != null) {
        final response = await http.get(
          Uri.parse('$baseUrl/api/customers/transactions/'),
          headers: {'Authorization': 'Bearer $accessToken'},
        );

        if (response.statusCode == 200) {
          final List<Map<String, dynamic>> userTransaction =
              List<Map<String, dynamic>>.from(jsonDecode(response.body));
          return userTransaction;
        } else if (response.statusCode == 401) {
          await refreshToken();
          final String? accessToken2 = await getAccessToken();
          final refreshedResponse = await http.get(
            Uri.parse('$baseUrl/api/customers/transactions/'),
            headers: {'Authorization': 'Bearer $accessToken2'},
          );

          if (refreshedResponse.statusCode == 200) {
            final List<Map<String, dynamic>> userTransaction =
                List<Map<String, dynamic>>.from(
                    jsonDecode(refreshedResponse.body));
            return userTransaction;
          } else {
            throw Exception(
                'Failed to fetch user payments data after token refresh');
          }
        } else {
          throw Exception(
              'Failed to fetch user payments data: ${response.statusCode}');
        }
      } else {
        throw Exception('Failed to fetch user payments data');
      }
    } catch (e) {
      print('Error in getPaymentsProgram: $e');
      rethrow;
    }
  }

  Future<void> buyProduct(int productId) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('access');

      final response = await http.post(
        Uri.parse('http://10.0.2.2:8000/api/products/buy-product/$productId/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        print('Product bought successfully');
      } else if (response.statusCode == 401) {
        await refreshToken();

        final String? accessToken = await getAccessToken();

        if (accessToken != null) {
          final refreshedResponse = await http.post(
            Uri.parse(
                'http://10.0.2.2:8000/api/products/buy-product/$productId/'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $accessToken',
            },
          );

          if (refreshedResponse.statusCode == 200) {
            print('Product bought successfully after token refresh');
          } else {
            throw Exception(
                'Failed to buy product after token refresh: ${refreshedResponse.statusCode}');
          }
        } else {
          throw Exception('Failed to get access token after refresh');
        }
      } else {
        throw Exception('Error buying product: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in buyProduct: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getTransaction() async {
    try {
      final String? accessToken = await getAccessToken();

      if (accessToken != null) {
        final response = await http.get(
          Uri.parse('$baseUrl/api/gas_station/get-transaction/'),
          headers: {'Authorization': 'Bearer $accessToken'},
        );

        if (response.statusCode == 200) {
          var responseData = jsonDecode(response.body);
          if (responseData["pump"] == null) {
            return {'shouldStopTimer': false, 'data': {}};
          } else {
            return {'shouldStopTimer': true, 'data': responseData};
          }
        } else if (response.statusCode == 401) {
          await refreshToken();
          final String? accessToken2 = await getAccessToken();
          final refreshedResponse = await http.get(
            Uri.parse('$baseUrl/api/gas_station/get-transaction/'),
            headers: {'Authorization': 'Bearer $accessToken2'},
          );

          if (refreshedResponse.statusCode == 200) {
            var responseData = jsonDecode(response.body);
            if (responseData["gas_station"] == null) {
              return {'shouldStopTimer': false, 'data': {}};
            } else {
              return {'shouldStopTimer': true, 'data': responseData};
            }
          } else {
            throw Exception(
                'Failed to fetch transaction data after token refresh');
          }
        } else {
          throw Exception(
              'Failed to fetch transaction data: ${response.statusCode}');
        }
      } else {
        throw Exception('Failed to transaction data');
      }
    } catch (e) {
      print('Error in getTransaction: $e');
      rethrow; // Rethrow the caught exception
    }
  }

  Future<Map<String, dynamic>> processTransaction() async {
    try {
      final String? accessToken = await getAccessToken();

      if (accessToken != null) {
        final response = await http.post(
          Uri.parse('$baseUrl/api/gas_station/get-transaction/'),
          headers: {'Authorization': 'Bearer $accessToken'},
        );

        if (response.statusCode == 200) {
          return {'message': 'Transaction proccessed successfully'};
        } else if (response.statusCode == 401) {
          await refreshToken();
          final String? accessToken2 = await getAccessToken();
          final refreshedResponse = await http.post(
            Uri.parse('$baseUrl/api/gas_station/get-transaction/'),
            headers: {'Authorization': 'Bearer $accessToken2'},
          );

          if (refreshedResponse.statusCode == 200) {
            return {'message': 'Transaction proccessed successfully'};
          } else {
            throw Exception(
                'Failed to proccess transaction after token refresh');
          }
        } else {
          throw Exception(
              'Failed to proccess transaction: ${response.statusCode}');
        }
      } else {
        throw Exception('Failed to proccess transaction');
      }
    } catch (e) {
      print('Error in proccessTransaction: $e');
      rethrow;
    }
  }
}
