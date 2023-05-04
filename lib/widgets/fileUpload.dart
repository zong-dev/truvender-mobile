import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:truvender/utils/spacing.dart';

import '../theme.dart';

class FileUpload extends StatefulWidget {
  final String label;
  final bool isMultiple;
  final Function? onSelected;

  const FileUpload({Key? key, this.label = 'Select File', required this.isMultiple, this.onSelected}) : super(key: key);

  @override
  _FileUploadState createState() => _FileUploadState();
}

class _FileUploadState extends State<FileUpload>
    with SingleTickerProviderStateMixin {
  late AnimationController loadingController;
  File? _file;
  PlatformFile? _platformFile;

  selectFile() async {
    final uploader = await FilePicker.platform.pickFiles(
        type: FileType.custom, allowedExtensions: ['png', 'jpg', 'jpeg']);

    if (uploader != null) {
      
      // widget.onSelected!(uploader.files.first);

      setState(() {
        _file = File(uploader.files.single.path!);
        _platformFile = uploader.files.first;
      });
      
    }
    loadingController.forward();
  }

  @override
  void initState() {
    loadingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..addListener(() {
        setState(() {});
      });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          GestureDetector(
            onTap: selectFile,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 5, vertical: 10.0),
              child: DottedBorder(
                borderType: BorderType.RRect,
                radius: const Radius.circular(10),
                dashPattern: const [10, 4],
                strokeCap: StrokeCap.round,
                color: Theme.of(context).colorScheme.primary,
                child: Container(
                  width: double.infinity,
                  height: 150,
                  decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(14)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.file_open_rounded,
                        color: Theme.of(context).colorScheme.primary,
                        size: 40,
                      ),
                      verticalSpacing(15),
                      Text(
                        widget.label,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              fontSize: 15,
                              color: AppColors.textFaded,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          _platformFile != null
              ? Container(
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal:  10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Selected File',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              fontSize: 15,
                              color: AppColors.textFaded,
                          
                        ),
                      ),
                      verticalSpacing(10),
                      Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: AppColors.secoundaryLight,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.shade200,
                                  offset: const Offset(0, 1),
                                  blurRadius: 3,
                                  spreadRadius: 2,
                                )
                              ]),
                          child: Row(
                            children: [
                              ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.file(
                                    _file!,
                                    width: 70,
                                  )),
                              horizontalSpacing(10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _platformFile!.name,
                                      style: const TextStyle(
                                          fontSize: 13, color: Colors.black),
                                    ),
                                    verticalSpacing(5),
                                    Text(
                                      '${(_platformFile!.size / 1024).ceil()} KB',
                                      style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.grey.shade500),
                                    ),
                                    verticalSpacing(5),
                                    Container(
                                        height: 5,
                                        clipBehavior: Clip.hardEdge,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: Colors.blue.shade50,
                                        ),
                                        child: LinearProgressIndicator(
                                          value: loadingController.value,
                                        )),
                                  ],
                                ),
                              ),
                              horizontalSpacing(10),
                            ],
                          )),
                      verticalSpacing(20),
                    ],
                  ))
              : Container(),
        ],
      ),
    );
  }
}
