import 'package:desgram_ui/domain/models/personal_information_model.dart';
import 'package:desgram_ui/domain/models/post_model.dart';
import 'package:desgram_ui/domain/models/profile_model.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../domain/models/user_model.dart';

part 'api_client.g.dart';

@RestApi()
abstract class ApiClient {
  factory ApiClient(Dio dio, {String? baseUrl}) = _ApiClient;

  @GET("/api/User/GetCurrentUser")
  Future<UserModel?> getCurrentUser();

  @GET("/api/User/GetPersonalInformation")
  Future<PersonalInformationModel?> getPersonalInformation();

  @POST("/api/User/UpdateProfile")
  Future updateProfile(@Body() ProfileModel body);

  @GET("/api/Post/GetPostsByUserId")
  Future<List<PostModel>?> getPostsByUserId(@Query("UserId") String userId,
      @Query("Skip") int skip, @Query("Take") int take);
}
