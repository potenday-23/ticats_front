import 'dart:io' as io;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/file.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:ticats/app/config/app_color.dart';
import 'package:ticats/app/config/app_typeface.dart';
import 'package:ticats/app/extension/datetime_to_ordinal.dart';
import 'package:ticats/domain/entities/ticket.dart';

import '../enum/ticket_enum.dart';
import 'ticats_chip.dart';

class TicketFront extends StatelessWidget {
  const TicketFront(this.ticket, {super.key, this.imagePath});

  final Ticket ticket;

  final String? imagePath;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return FutureBuilder<ImageShader>(
        future: _createShaderAndImage(constraints.maxWidth, constraints.maxHeight),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const SizedBox.shrink();
          return Stack(
            children: [
              ShaderMask(
                blendMode: BlendMode.srcATop,
                shaderCallback: (rect) => snapshot.data!,
                child: Image.asset('assets/tickets/ticket_${ticket.ticketType.index}.png'),
              ),
              Positioned.fill(
                bottom: 24.w,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: SvgPicture.asset('assets/tickets/ticats_logo.svg'),
                ),
              ),
            ],
          );
        },
      );
    });
  }

  Future<ImageShader> _createShaderAndImage(double w, double h) async {
    late Uint8List data;

    if (ticket.imageUrl != null) {
      File file = await DefaultCacheManager().getSingleFile(ticket.imageUrl!);

      data = file.readAsBytesSync().buffer.asUint8List();
    } else {
      data = io.File(imagePath!).readAsBytesSync().buffer.asUint8List();
    }

    Codec codec = await instantiateImageCodec(data, targetWidth: w.toInt(), targetHeight: h.toInt());

    FrameInfo fi = await codec.getNextFrame();
    ImageShader shader = ImageShader(fi.image, TileMode.clamp, TileMode.clamp, Matrix4.identity().storage);

    return shader;
  }
}

class TicketBack extends StatelessWidget {
  const TicketBack(this.ticket, {super.key});

  final Ticket ticket;

  @override
  Widget build(BuildContext context) {
    if (ticket.layoutType == TicketLayoutType.layout0) {
      return Stack(
        children: [
          Image.asset('assets/tickets/ticket_${ticket.ticketType.index}.png'),
          Positioned.fill(
            child: Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 50.w),
                child: Column(children: [
                  Text(ticket.title, style: AppTypeFace.small18SemiBold),
                  SizedBox(height: 10.w),
                  _RatingStarWidget(ticket.rating),
                  SizedBox(height: ticket.ticketType == TicketType.type1 ? 195.w : 244.w),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TicatsChip(ticket.category!.name, color: AppColor.grayF2),
                      Text(DateFormat('yyyy년 MM월 dd일 (E)').format(ticket.ticketDate), style: AppTypeFace.xSmall14Medium),
                    ],
                  ),
                  SizedBox(height: ticket.ticketType == TicketType.type1 ? 89.w : 45.w),
                  Text(
                    ticket.memo ?? "",
                    style: AppTypeFace.xSmall14Medium,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 5,
                  ),
                ]),
              ),
            ),
          ),
        ],
      );
    } else if (ticket.layoutType == TicketLayoutType.layout1) {
      return Stack(
        children: [
          Image.asset('assets/tickets/ticket_${ticket.ticketType.index}.png'),
          Positioned.fill(
            child: Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                    24.w,
                    50.w,
                    24.w,
                    ticket.ticketType == TicketType.type0
                        ? 24.w
                        : ticket.ticketType == TicketType.type1
                            ? 44.w
                            : 48.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(ticket.title, style: AppTypeFace.medium24Bold),
                    SizedBox(height: 10.w),
                    Text("/ ${ticket.category!.name}", style: AppTypeFace.xSmall12Bold),
                    SizedBox(height: 10.w),
                    Text(
                      ticket.memo ?? "",
                      style: AppTypeFace.xSmall14Medium,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 5,
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(DateFormat('yyyy', 'en_US').format(ticket.ticketDate),
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w900,
                              color: AppColor.primaryNormal,
                            )),
                        Text(DateFormat('MMM', 'en_US').format(ticket.ticketDate).toUpperCase(),
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w900,
                              color: AppColor.primaryNormal,
                            )),
                        Text(ticket.ticketDate.toOrdinalDate(),
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w900,
                              color: AppColor.primaryNormal,
                            )),
                        Text(DateFormat('E', 'en_US').format(ticket.ticketDate).toUpperCase(),
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w900,
                              color: AppColor.primaryNormal,
                            )),
                      ],
                    ),
                    SizedBox(
                        height: ticket.ticketType == TicketType.type0
                            ? 132.w
                            : ticket.ticketType == TicketType.type1
                                ? 50.w
                                : 108.w),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: ticket.ticketType == TicketType.type2 ? 10.w : 0.w),
                          child: _RatingStarWidget(ticket.rating),
                        ),
                        const Spacer(),
                        SvgPicture.asset('assets/tickets/ticats_icon.svg', width: 20.w, height: 32.w),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    } else {
      return Stack(
        children: [
          Image.asset('assets/tickets/ticket_${ticket.ticketType.index}_back.png'),
          Positioned.fill(
            top: ticket.ticketType == TicketType.type2 ? 60.w : 40.w,
            left: 24.w,
            child: Align(
              alignment: Alignment.topLeft,
              child: RotatedBox(
                quarterTurns: 1,
                child: Row(
                  children: [
                    Text(DateFormat("yyyy. MM. dd").format(ticket.ticketDate), style: AppTypeFace.medium24Medium),
                    SizedBox(width: 10.w),
                    SizedBox(
                      width: 76.w,
                      child: const Divider(height: 1, thickness: 1, color: Colors.black),
                    ),
                    SizedBox(width: 10.w),
                    Text(DateFormat("E", "en_US").format(ticket.ticketDate).toUpperCase(), style: AppTypeFace.medium24Medium),
                  ],
                ),
              ),
            ),
          ),
          Positioned.fill(
            top: ticket.ticketType == TicketType.type2 ? 60.w : 40.w,
            right: 24.w,
            child: Align(
              alignment: Alignment.topRight,
              child: RotatedBox(
                quarterTurns: 1,
                child: Text("/ ${ticket.category!.name}", style: AppTypeFace.xSmall12Bold),
              ),
            ),
          ),
          Positioned.fill(
            top: ticket.ticketType == TicketType.type1 ? 288.w : 345.w,
            child: Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: ticket.ticketType == TicketType.type1 ? 35.w : 0.w),
                      child: Text(ticket.title, style: AppTypeFace.large26SemiBold),
                    ),
                    SizedBox(
                        height: ticket.ticketType == TicketType.type0
                            ? 49.w
                            : ticket.ticketType == TicketType.type1
                                ? 90.w
                                : 25.w),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            ticket.memo ?? "",
                            style: AppTypeFace.xSmall14Medium,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 5,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        _RatingStarWidget(ticket.rating, isVertical: true),
                      ],
                    ),
                    SizedBox(height: 10.w),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    }
  }
}

class _RatingStarWidget extends StatelessWidget {
  const _RatingStarWidget(this.rating, {this.isVertical = false});

  final double rating;
  final bool isVertical;

  @override
  Widget build(BuildContext context) {
    if (isVertical) {
      return Column(
        children: [
          for (int i = 0; i < 5; i++) ...[
            if (i < rating.floor()) ...[
              SvgPicture.asset('assets/tickets/star_full.svg', width: 18.w, height: 18.w),
            ] else if (i == rating.floor() && rating % 1 != 0) ...[
              SvgPicture.asset('assets/tickets/star_half.svg', width: 18.w, height: 18.w),
            ] else ...[
              SvgPicture.asset('assets/tickets/star_empty.svg', width: 18.w, height: 18.w),
            ]
          ]
        ],
      );
    } else {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (int i = 0; i < 5; i++) ...[
            if (i < rating.floor()) ...[
              SvgPicture.asset('assets/tickets/star_full.svg', width: 18.w, height: 18.w),
            ] else if (i == rating.floor() && rating % 1 != 0) ...[
              SvgPicture.asset('assets/tickets/star_half.svg', width: 18.w, height: 18.w),
            ] else ...[
              SvgPicture.asset('assets/tickets/star_empty.svg', width: 18.w, height: 18.w),
            ]
          ]
        ],
      );
    }
  }
}
