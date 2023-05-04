import 'dart:io';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:truvender/theme.dart';
import 'package:truvender/utils/utils.dart';

class FileUploader extends StatefulWidget {
  final String label;
  final bool isMultiple;
  final Function? onSelected;
  final Widget trigger;

  const FileUploader(
      {Key? key,
      required this.label,
      this.isMultiple = false,
      this.onSelected,
      required this.trigger})
      : super(key: key);

  @override
  _FileUploaderState createState() => _FileUploaderState();
}

class _FileUploaderState extends State<FileUploader> {
  List? files;

  selectFiles() async {
    FilePickerResult? pickerResult = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['png', 'jpg', 'jpeg'],
        dialogTitle: widget.label,
        allowMultiple: widget.isMultiple);
    if (pickerResult != null) {
      if (widget.isMultiple) {
        List selectedFiles = pickerResult.files.map((path) => path).toList();
        setState(() {
          files = selectedFiles;
        });
        widget.onSelected!(files);
      } else if (!widget.isMultiple) {
        setState(() {
          files = [File(pickerResult.files.single.path!)];
        });
      }

      widget.onSelected!(files);
    }
  }

  unSelectFile(toRemove) async {
    setState(() {
      files!.remove(toRemove);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: selectFiles,
          child: widget.trigger,
        ),
        files != null && files!.isNotEmpty
            ? Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Selected Images',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontSize: 15,
                            color: AppColors.textFaded,
                          ),
                    ),
                    verticalSpacing(10),
                    ConstrainedBox(
                      constraints: const BoxConstraints(minHeight: 20, maxHeight: 280),
                      child: IntrinsicHeight(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: files!
                                .map((file) => GestureDetector(
                                      onLongPress: () {
                                        unSelectFile(file);
                                      },
                                      child: FilePreviewer(
                                        file: File(file.path),
                                        platformFile: file,
                                      ),
                                    ))
                                .toList()
                                .animate(interval: 2300.ms)
                                .fade(duration: 300.ms),
                          ),
                        ),
                      ),
                    ),
                    verticalSpacing(20),
                  ],
                ),
              )
            : const SizedBox(),
      ],
    );
  }
}

class FilePreviewer extends StatefulWidget {
  final File file;
  final PlatformFile? platformFile;
  const FilePreviewer({Key? key, required this.file, this.platformFile})
      : super(key: key);

  @override
  _FilePreviewerState createState() => _FilePreviewerState();
}

class _FilePreviewerState extends State<FilePreviewer>
    with SingleTickerProviderStateMixin {
  PlatformFile? _platformFile;
  late AnimationController loadingController;

  @override
  void initState() {
    loadingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..addListener(() {
        setState(() {});
      });
    super.initState();
    _platformFile = widget.platformFile;
    Future.delayed(const Duration(seconds: 1), () {
      loadingController.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.only(bottom: 12),
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
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.file(
              widget.file,
              width: 84,
            ),
          ),
          horizontalSpacing(10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _platformFile!.name,
                  style: const TextStyle(fontSize: 13, color: Colors.black),
                ),
                verticalSpacing(5),
                Text(
                  '${(_platformFile!.size / 1024).ceil()} KB',
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
                ),
                verticalSpacing(5),
                Container(
                    height: 5,
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.blue.shade50,
                    ),
                    child: LinearProgressIndicator(
                      value: loadingController.value,
                    )),
                verticalSpacing(6),
                Text(
                  "Hold to remove image",
                  style: TextStyle(fontSize: 12, color: Colors.red.shade400),
                ),
              ],
            ),
          ),
          horizontalSpacing(10),
        ],
      ),
    );
  }
}
