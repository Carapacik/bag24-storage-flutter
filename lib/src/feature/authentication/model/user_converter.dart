import 'dart:convert';

import 'package:bag24/src/feature/authentication/model/user.dart';
import 'package:rest_client/account/dto/token_dto.dart';

final class const UserConverter() extends Converter<TokenDto, AuthenticatedUser> {
  @override
  AuthenticatedUser convert(TokenDto input) =>
      AuthenticatedUser(accessToken: input.access, refreshToken: input.refresh);
}
