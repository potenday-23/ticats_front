import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stacked_card_carousel/stacked_card_carousel.dart';

import 'package:ticats/domain/entities/ticket.dart';
import 'package:ticats/presentation/common/widgets/ticats_ticket.dart';

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
      initialOffset: 24.w,
      spaceBetweenItems: 588.w,
      items: [
        for (final ticket in widget.ticketList)
          SizedBox(
            width: 342.w,
            height: 564.w,
            child: FlipCard(
              front: TicketFront(ticket),
              back: TicketBack(ticket),
            ),
          ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
