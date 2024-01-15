import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stacked_card_carousel/stacked_card_carousel.dart';

import 'package:ticats/domain/entities/ticket.dart';
import 'package:ticats/presentation/common/widgets/ticats_ticket.dart';

class TicatsCardView extends StatefulWidget {
  const TicatsCardView({Key? key, required this.controller, required this.ticketList, this.isMain = false}) : super(key: key);

  final PageController controller;
  final List<Ticket> ticketList;
  final bool isMain;

  @override
  State<TicatsCardView> createState() => _TicatsCardViewState();
}

class _TicatsCardViewState extends State<TicatsCardView> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return StackedCardCarousel(
      type: StackedCardCarouselType.fadeOutStack,
      pageController: widget.controller,
      initialOffset: 24.h,
      spaceBetweenItems: 588.h,
      items: [
        for (final ticket in widget.ticketList)
          SizedBox(
            height: 564.h,
            child: RepaintBoundary(
              child: FlipCard(
                front: TicketCardFront(ticket, isMain: widget.isMain),
                back: TicketBack(ticket),
              ),
            ),
          ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
