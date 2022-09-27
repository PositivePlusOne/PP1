import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

import '../models/zephyr_paginated_results.dart';
import '../models/zephyr_test_execution.dart';

part 'zephyr_rest_client.g.dart';

@RestApi(baseUrl: "https://api.zephyrscale.smartbear.com/v2")
abstract class ZephyrRestClient {
  factory ZephyrRestClient(Dio dio, {String baseUrl}) = _ZephyrRestClient;

  @GET("/testcycles")
  Future<ZephyrPaginatedResults> getTestCycles(@Query("projectKey") String projectKey, @Header('Authorization') token);

  @GET("/testcases")
  Future<ZephyrPaginatedResults> getTestCases(@Query("projectKey") String projectKey, @Header('Authorization') token);

  @POST("/testexecutions")
  Future<HttpResponse> publishTestExecution(@Body() ZephyrTestExecution execution, @Header('Authorization') token);
}
