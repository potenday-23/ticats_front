import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stacked_card_carousel/stacked_card_carousel.dart';

import 'package:ticats/domain/entities/ticket.dart';
import 'package:ticats/presentation/common/widgets/masked_image.dart';

class TicatsCardView extends StatefulWidget {
  const TicatsCardView({Key? key, required this.ticketList}) : super(key: key);

  final List<Ticket> ticketList;

  @override
  State<TicatsCardView> createState() => _TicatsCardViewState();
}

class _TicatsCardViewState extends State<TicatsCardView> with AutomaticKeepAliveClientMixin {
  final PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return StackedCardCarousel(
      type: StackedCardCarouselType.fadeOutStack,
      pageController: pageController,
      initialOffset: 36.h,
      spaceBetweenItems: 580.h,
      items: [
        for (final ticket in widget.ticketList)
          SizedBox(
            width: 342.w,
            height: 564.h,
            child: FlipCard(
              front: MaskedImage(
                mask: 'assets/tickets/ticket_1.png',
                imageUrl: ticket.imageUrl,
              ),
              back: Image.asset('assets/tickets/ticket_back.png'),
            ),
          )
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
