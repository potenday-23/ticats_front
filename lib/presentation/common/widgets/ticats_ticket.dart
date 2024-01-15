import 'dart:io' as io;
import 'dart:ui';

import 'package:flip_card/flip_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/file.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ticats/app/config/app_color.dart';
import 'package:ticats/app/config/app_typeface.dart';
import 'package:ticats/app/extension/datetime_to_ordinal.dart';
import 'package:ticats/app/service/auth_service.dart';
import 'package:ticats/domain/entities/ticket.dart';
import 'package:ticats/presentation/common/enum/color_type.dart';
import 'package:ticats/presentation/common/widgets/ticats_dialog.dart';
import 'package:ticats/presentation/main/controller/ticket_controller.dart';

import '../enum/ticket_enum.dart';
import 'ticats_chip.dart';

class TicketCardFront extends StatelessWidget {
  const TicketCardFront(this.ticket, {super.key, this.hasHeart = true, this.hasReport = true});

  final Ticket ticket;
  final bool hasHeart;
  final bool hasReport;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: SizedBox(
        width: 513,
        height: 846,
        child: FutureBuilder<ImageShader>(
          future: _createShaderAndImage(513, 846),
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
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Image.asset('assets/tickets/ticket_${ticket.ticketType.index}_gradient.png'),
                  ),
                ),
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: RotatedBox(quarterTurns: 2, child: Image.asset('assets/tickets/ticket_${ticket.ticketType.index}_gradient.png')),
                  ),
                ),
                if (hasHeart && AuthService.to.isLogin) ...[
                  Positioned.fill(
                    top: 40,
                    right: 40,
                    child: Align(
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                        onTap: () async {
                          await Get.find<TicketController>().likeTicket(ticket);
                        },
                        child: GetX<TicketController>(
                          builder: (controller) {
                            return SvgPicture.asset(
                              controller.likeTicketList.contains(ticket) ? 'assets/icons/like.svg' : 'assets/icons/unlike.svg',
                              width: 48,
                              height: 48,
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  if (hasReport)
                    Positioned.fill(
                      left: 40,
                      bottom: 40,
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: GestureDetector(
                          onTap: () async {
                            await showReportDialog(context, ticket);
                          },
                          child: SvgPicture.asset('assets/icons/report.svg', width: 36, height: 36),
                        ),
                      ),
                    ),
                ],
                Positioned.fill(
                  bottom: 36,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: SvgPicture.asset('assets/tickets/ticats_logo.svg', width: 69, height: 21),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<ImageShader> _createShaderAndImage(double w, double h) async {
    late Uint8List data;

    if (ticket.imageUrl != null) {
      File file = await DefaultCacheManager().getSingleFile(ticket.imageUrl!);

      data = file.readAsBytesSync().buffer.asUint8List();
    } else {
      data = io.File(ticket.imagePath!).readAsBytesSync().buffer.asUint8List();
    }

    Codec codec = await instantiateImageCodec(data, targetWidth: w.toInt(), targetHeight: h.toInt());

    FrameInfo fi = await codec.getNextFrame();
    ImageShader shader = ImageShader(fi.image, TileMode.clamp, TileMode.clamp, Matrix4.identity().storage);

    return shader;
  }
}

class TicketGridFront extends StatelessWidget {
  const TicketGridFront(this.ticket, {super.key, this.isMyTicket = false, this.hasReport = true});

  final Ticket ticket;
  final bool isMyTicket;
  final bool hasReport;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async => _showTicketDialog(context, ticket, isMyTicket, hasReport),
      child: SizedBox(
        width: 163.w,
        child: FittedBox(
          child: SizedBox(
            width: 163,
            height: 270,
            child: FutureBuilder<ImageShader>(
              future: _createShaderAndImage(513, 846),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const SizedBox.shrink();
                return Stack(
                  children: [
                    FittedBox(
                      child: SizedBox(
                        width: 513,
                        height: 846,
                        child: ShaderMask(
                          blendMode: BlendMode.srcATop,
                          shaderCallback: (rect) => snapshot.data!,
                          child: Image.asset('assets/tickets/ticket_${ticket.ticketType.index}.png'),
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Image.asset('assets/tickets/ticket_${ticket.ticketType.index}_grid_gradient.png', fit: BoxFit.fitWidth),
                      ),
                    ),
                    Positioned.fill(
                      top: 16,
                      left: 16,
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: TicatsChip(
                          ticket.category!.name,
                          color: AppColor.primaryDark,
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          textStyle: AppTypeFace.xSmall12Regular,
                          textColor: Colors.white,
                        ),
                      ),
                    ),
                    Positioned.fill(
                      top: ticket.ticketType == TicketType.type0
                          ? 206
                          : ticket.ticketType == TicketType.type1
                              ? 203
                              : 210,
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(ticket.title, style: AppTypeFace.xSmall12Bold.copyWith(color: Colors.white)),
                        ),
                      ),
                    ),
                    if (AuthService.to.isLogin) ...[
                      Positioned.fill(
                        top: 16,
                        right: 16,
                        child: Align(
                          alignment: Alignment.topRight,
                          child: GestureDetector(
                            onTap: () async {
                              await Get.find<TicketController>().likeTicket(ticket);
                            },
                            child: GetX<TicketController>(
                              builder: (controller) {
                                return SvgPicture.asset(
                                  controller.likeTicketList.contains(ticket) ? 'assets/icons/like.svg' : 'assets/icons/unlike.svg',
                                  width: 24,
                                  height: 24,
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      if (hasReport)
                        Positioned.fill(
                          right: 14,
                          bottom: 14,
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: GestureDetector(
                              onTap: () async {
                                await showReportDialog(context, ticket);
                              },
                              child: SvgPicture.asset('assets/icons/report.svg', width: 20, height: 20),
                            ),
                          ),
                        ),
                    ],
                    Positioned.fill(
                      bottom: 12,
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: SvgPicture.asset('assets/tickets/ticats_logo.svg', width: 23, height: 7),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<ImageShader> _createShaderAndImage(double w, double h) async {
    late Uint8List data;

    if (ticket.imageUrl != null) {
      File file = await DefaultCacheManager().getSingleFile(ticket.imageUrl!);

      data = file.readAsBytesSync().buffer.asUint8List();
    } else {
      data = io.File(ticket.imagePath!).readAsBytesSync().buffer.asUint8List();
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
      return FittedBox(
        child: SizedBox(
          width: 342,
          height: 564,
          child: Stack(
            children: [
              Image.asset('assets/tickets/ticket_${ticket.ticketType.index}_${ticket.layoutType.index}_back.png'),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 50),
                    child: Column(children: [
                      Text(ticket.title, style: AppTypeFace.small18SemiBold),
                      const SizedBox(height: 10),
                      _RatingStarWidget(ticket.rating),
                      SizedBox(height: ticket.ticketType == TicketType.type1 ? 195 : 234),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TicatsChip(ticket.category!.engName, color: AppColor.grayF2),
                          Text(DateFormat('yyyy년 MM월 dd일 (E)').format(ticket.ticketDate), style: AppTypeFace.xSmall14Medium),
                        ],
                      ),
                      SizedBox(height: ticket.ticketType == TicketType.type1 ? 77 : 50),
                      Text(
                        ticket.memo ?? "",
                        style: AppTypeFace.xSmall14Medium.copyWith(color: ColorType.values[int.parse(ticket.color!)].color),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 5,
                      ),
                    ]),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } else if (ticket.layoutType == TicketLayoutType.layout1) {
      return FittedBox(
        child: SizedBox(
          width: 342,
          height: 564,
          child: Stack(
            children: [
              Image.asset('assets/tickets/ticket_${ticket.ticketType.index}_${ticket.layoutType.index}_back.png'),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                        24,
                        50,
                        24,
                        ticket.ticketType == TicketType.type0
                            ? 24
                            : ticket.ticketType == TicketType.type1
                                ? 44
                                : 48),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(ticket.title, style: AppTypeFace.medium24Bold),
                        const SizedBox(height: 10),
                        Text("/ ${ticket.category!.engName}", style: AppTypeFace.xSmall12Bold),
                        const SizedBox(height: 10),
                        Text(
                          ticket.memo ?? "",
                          style: AppTypeFace.xSmall14Medium.copyWith(color: ColorType.values[int.parse(ticket.color!)].color),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 5,
                        ),
                        const Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(DateFormat('yyyy', 'en_US').format(ticket.ticketDate),
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                  color: AppColor.primaryNormal,
                                )),
                            Text(DateFormat('MMM', 'en_US').format(ticket.ticketDate).toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                  color: AppColor.primaryNormal,
                                )),
                            Text(ticket.ticketDate.toOrdinalDate(),
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                  color: AppColor.primaryNormal,
                                )),
                            Text(DateFormat('E', 'en_US').format(ticket.ticketDate).toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                  color: AppColor.primaryNormal,
                                )),
                          ],
                        ),
                        SizedBox(
                            height: ticket.ticketType == TicketType.type0
                                ? 146
                                : ticket.ticketType == TicketType.type1
                                    ? 64
                                    : 122),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: ticket.ticketType == TicketType.type2 ? 10 : 0),
                              child: _RatingStarWidget(ticket.rating),
                            ),
                            const Spacer(),
                            SvgPicture.asset('assets/tickets/ticats_icon.svg', width: 20, height: 32),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return FittedBox(
        child: SizedBox(
          width: 342,
          height: 564,
          child: Stack(
            children: [
              Image.asset('assets/tickets/ticket_${ticket.ticketType.index}_${ticket.layoutType.index}_back.png'),
              Positioned.fill(
                top: ticket.ticketType == TicketType.type2 ? 60 : 40,
                left: 24,
                child: Align(
                  alignment: Alignment.topLeft,
                  child: RotatedBox(
                    quarterTurns: 1,
                    child: Row(
                      children: [
                        Text(DateFormat("yyyy. MM. dd").format(ticket.ticketDate), style: AppTypeFace.medium24Medium),
                        const SizedBox(width: 10),
                        const SizedBox(
                          width: 76,
                          child: Divider(height: 1, thickness: 1, color: Colors.black),
                        ),
                        const SizedBox(width: 10),
                        Text(DateFormat("E", "en_US").format(ticket.ticketDate).toUpperCase(), style: AppTypeFace.medium24Medium),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                top: ticket.ticketType == TicketType.type2 ? 60 : 40,
                right: 24,
                child: Align(
                  alignment: Alignment.topRight,
                  child: RotatedBox(
                    quarterTurns: 1,
                    child: Text("/ ${ticket.category!.engName}", style: AppTypeFace.xSmall12Bold),
                  ),
                ),
              ),
              Positioned.fill(
                top: ticket.ticketType == TicketType.type1 ? 308 : 355,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: ticket.ticketType == TicketType.type1 ? 35 : 0),
                          child: Text(ticket.title, style: AppTypeFace.large26SemiBold),
                        ),
                        SizedBox(
                            height: ticket.ticketType == TicketType.type0
                                ? 49
                                : ticket.ticketType == TicketType.type1
                                    ? 80
                                    : 25),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                ticket.memo ?? "",
                                style: AppTypeFace.xSmall14Medium.copyWith(color: ColorType.values[int.parse(ticket.color!)].color),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 5,
                              ),
                            ),
                            const SizedBox(width: 8),
                            _RatingStarWidget(ticket.rating, isVertical: true),
                          ],
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
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
              SvgPicture.asset('assets/tickets/star_full.svg', width: 18, height: 18),
            ] else if (i == rating.floor() && rating % 1 != 0) ...[
              SvgPicture.asset('assets/tickets/star_half.svg', width: 18, height: 18),
            ] else ...[
              SvgPicture.asset('assets/tickets/star_empty.svg', width: 18, height: 18),
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
              SvgPicture.asset('assets/tickets/star_full.svg', width: 18, height: 18),
            ] else if (i == rating.floor() && rating % 1 != 0) ...[
              SvgPicture.asset('assets/tickets/star_half.svg', width: 18, height: 18),
            ] else ...[
              SvgPicture.asset('assets/tickets/star_empty.svg', width: 18, height: 18),
            ]
          ]
        ],
      );
    }
  }
}

Future<void> _showTicketDialog(BuildContext context, Ticket ticket, bool isMyTicket, bool hasLike) async {
  await showDialog(
    context: context,
    barrierColor: Colors.black.withOpacity(0.40),
    builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        insetPadding: EdgeInsets.zero,
        content: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => Navigator.pop(context),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isMyTicket) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TicatsChip(
                      '삭제',
                      color: AppColor.grayE5,
                      radius: 16.r,
                      onTap: () async {
                        bool result = await showDeleteDialog(context, ticket.id!);

                        if (result) Get.back();
                      },
                    ),
                    TicatsChip(
                      '완료',
                      color: const Color(0xFFFFE34F),
                      radius: 16.r,
                      onTap: () => Get.back(),
                    ),
                  ],
                ),
                SizedBox(height: 35.w),
              ],
              SizedBox(width: 342.w, child: FlipCard(front: TicketCardFront(ticket, hasReport: hasLike), back: TicketBack(ticket))),
              if (isMyTicket) ...[
                SizedBox(height: 10.w),
                Align(
                  alignment: Alignment.centerRight,
                  child: TicatsChip(
                    '',
                    padding: EdgeInsets.fromLTRB(12.w, 4.5.w, 6.w, 4.5.w),
                    radius: 16.r,
                    color: AppColor.grayF2,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('나만 보기', style: AppTypeFace.xSmall14Medium),
                        SizedBox(width: 6.w),
                        SizedBox(
                          width: 51.w,
                          height: 31.w,
                          child: CupertinoSwitch(
                            activeColor: AppColor.primaryDark,
                            value: true,
                            onChanged: (value) {},
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
              ],
            ],
          ),
        ),
      );
    },
  );
}
