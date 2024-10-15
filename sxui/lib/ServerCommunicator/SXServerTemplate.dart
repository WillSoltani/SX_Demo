/// Author: Kia Kalani
/// Last Revision: 10/9/24
/// This module contains the definition
/// for a template client communicator.
library;

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// <summary>
/// An abstract class intended for
/// server communications.
/// </summary>
class SXServerTemplate {
  /// <summary>
  /// The storage instance that is used for
  /// storing components securly. Components
  /// such as the token, local configurations etc.
  /// </summary>
  FlutterSecureStorage? storage;

  /// <summary>
  /// The dio instance for server communications
  /// </summary>
  Dio? dioInst;

  /// <summary>
  /// Constructor for setting the instances
  /// of storage and dio.
  /// </summary>
  SXServerTemplate() {
    storage = const FlutterSecureStorage();
    dioInst = Dio(BaseOptions(
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));
  }

  /// <summary>
  /// A setter method for the IP address.
  /// </summary>
  /// <param name="ip">
  /// The new value for ip address.
  /// </param>
  /// <param name="port">
  /// The new value for port of the server
  /// </param>
  /// <return>A boolean indicating whether a valid ip address
  /// has been set </return>
  Future<bool> setIPAddressAndPort(String ip, int port) async {
    var ipPattern = RegExp(
      r"^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$"
    );
    if (!ipPattern.hasMatch(ip)) return false;

    // trying to open a connection to server's port to validate the ip and port
    try {
      final socket = await Socket.connect(ip, port, timeout: const Duration(seconds: 2));
      await socket.close();
    } catch (e) {
      return false;
    }
    await storage!.write(key: "ip", value: ip);
    await storage!.write(key: "port", value: port.toString());
    return true;
  }

  /// <summary>
  /// Getter for current ip address. If no ip
  /// is set, this method would return null.
  /// </summary>
  /// <return>the ip as a string or null</return>
  Future<String?> getIPAddress() async {
    return await storage!.read(key: "ip");
  }

  /// <summary>
  /// Getter for the port value.
  /// If no value is set for port, this method
  /// would return null.
  /// </summary>
  /// <return>the port as a string or null</return>
  Future<String?> getPort() async {
    return await storage!.read(key: "port");
  }

  /// <summary>
  /// A wrapper method for running a get
  /// request against the server.
  /// </summary>
  /// <param name="path"> The specific path
  /// we are making a request for.
  /// </param>
  /// <return> a response object.</return>
  Future<Response?> getRequest(String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    void Function(int, int)? onReceiveProgress,
  }) async {
    // Getting the ip
    String? ip = await storage!.read(key: "ip");
    if (null == ip) return null;

    // Getting the port
    String? port = await storage!.read(key: "port");
    if (null == port) return null;

    // Getting the token
    String? token = await storage!.read(key: "token");
    if (null == token) {
      // making the request without token
      return await dioInst!.get(
        "http://$ip:$port/$path",
        data: data, queryParameters: queryParameters, options: Options(headers: {
          'Content-Type': 'application/json',
        }, validateStatus: (status) => status! > 500), // allowing 400 response
        cancelToken: cancelToken, onReceiveProgress: onReceiveProgress
      );
    }

    // Making the request with the credentials
    return await dioInst!.get(
      "http://$ip:$port/$path",
      data: data, queryParameters: queryParameters, options: Options(headers: {
        'Content-Type': 'application/json',
        'Auth-Token': token
      }, validateStatus: (status) => status! > 500), // allowing 400 response
      cancelToken: cancelToken, onReceiveProgress: onReceiveProgress
    );
  }

  /// <summary>
  /// A wrapper method for running a post
  /// request against the server.
  /// </summary>
  /// <param name="path"> The specific path
  /// we are making a request for.
  /// </param>
  /// <return> a response object.</return>
  Future<Response?> postRequest(String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    void Function(int, int)? onReceiveProgress,
  }) async {
    // Getting the ip
    String? ip = await storage!.read(key: "ip");
    if (null == ip) return null;

    // Getting the port
    String? port = await storage!.read(key: "port");
    if (null == port) return null;

    // Getting the token
    String? token = await storage!.read(key: "token");

    // making the request without token
    if (null == token) {
      return await dioInst!.post(
        "http://$ip:$port/$path",
        data: data, queryParameters: queryParameters, options: Options(headers: {
          'Content-Type': 'application/json',
        }, validateStatus: (status) => status! > 500), // allowing 400 response
        cancelToken: cancelToken, onReceiveProgress: onReceiveProgress
      );
    }

    // Making the request with the credentials
    return await dioInst!.post(
      "http://$ip:$port/$path",
      data: data, queryParameters: queryParameters, options: Options(headers: {
        'Content-Type': 'application/json',
        'Auth-Token': token
      }, validateStatus: (status) => status! > 500), // allowing 400 response
      cancelToken: cancelToken, onReceiveProgress: onReceiveProgress
    );
  }

  /// <summary>
  /// A method that would indicate if the user
  /// is currently logged in.
  /// </summary>
  Future<bool> isLoggedIn() async {
    var resp = await getRequest("auth/checktoken");
    if (null == resp) return false;
    return resp.statusCode == 200;
  }

  /// <summary>
  /// A method that would indicate whether the
  /// client is connected to the server or not.
  /// </summary>
  /// <return> true if connected else false</return>
  Future<bool> isConnectedToServer() async {
    String? ip = await storage!.read(key: "ip");
    if (null == ip) return false;

    String? port = await storage!.read(key: "port");
    if (null == port) return false;
    int? iPort = int.tryParse(port);
    if (null == iPort) return false;

    try {
      final socket = await Socket.connect(ip, iPort, timeout: const Duration(seconds: 2));
      await socket.close();
    } catch (e) {
      return false;
    }
    return true;
  }
}