import 'package:get/get.dart';

import '../entities/ticket.dart';
import '../repositories/like_repository.dart';

class LikeUseCases {
  final LikeRepository _repository = Get.find<LikeRepository>();

  GetLikesUseCase get getLikesUseCase => Get.put(GetLikesUseCase(_repository));
  PostLikeUseCase get postLikeUseCase => Get.put(PostLikeUseCase(_repository));
}

class GetLikesUseCase {
  final LikeRepository _repository;
  GetLikesUseCase(this._repository);

  Future<List<Ticket>> execute() async {
    List<Ticket> member = await _repository.getLikes();

    return member;
  }
}

class PostLikeUseCase {
  final LikeRepository _repository;
  PostLikeUseCase(this._repository);

  Future<void> execute(int ticketId) async {
    await _repository.postLike(ticketId);
  }
}
