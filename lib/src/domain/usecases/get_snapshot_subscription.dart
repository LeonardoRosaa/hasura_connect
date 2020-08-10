import 'package:dartz/dartz.dart';
import 'package:hasura_connect/src/domain/models/request.dart';
import 'package:string_validator/string_validator.dart';
import '../entities/snapshot.dart';
import '../errors/errors.dart';

abstract class GetSnapshotSubscription {
  Future<Either<HasuraError, Snapshot>> call(
      {Request request, void Function(Snapshot) closeConnection});
}

class GetSnapshotSubscriptionImpl implements GetSnapshotSubscription {
  @override
  Future<Either<HasuraError, Snapshot>> call(
      {Request request, void Function(Snapshot) closeConnection}) async {
    if (!request.query.isValid) {
      return Left(const InvalidRequestError('Invalid Query document'));
    } else if (!request.query.document.startsWith('subscription')) {
      return Left(const InvalidRequestError('Document is not a subscription'));
    } else if (request.query.key == null || request.query.key.isEmpty) {
      return Left(const InvalidRequestError('Invalid key'));
    } else if (request.type != RequestType.subscription) {
      return Left(const InvalidRequestError(
          'Request type is not RequestType.subscription'));
    } else if (!isURL(request.url)) {
      return Left(const InvalidRequestError('Invalid url'));
    }
    return Right(
        Snapshot(query: request.query, closeConnection: closeConnection));
  }
}
