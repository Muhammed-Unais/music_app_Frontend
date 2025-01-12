import 'dart:io';
import 'package:client/core/theme/app_pallete.dart';
import 'package:client/core/utils/utils.dart';
import 'package:client/core/widgets/custom_field.dart';
import 'package:client/featues/auth/view/widgets/loader.dart';
import 'package:client/featues/home/view/widgets/audio_wave.dart';
import 'package:client/featues/home/view_model/home_viewmodel.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UploadSongsPage extends ConsumerStatefulWidget {
  const UploadSongsPage({super.key});

  @override
  ConsumerState<UploadSongsPage> createState() => _UploadSongsPageState();
}

class _UploadSongsPageState extends ConsumerState<UploadSongsPage> {
  final _artistController = TextEditingController();
  final _songNameController = TextEditingController();
  Color _selectedColor = Pallete.cardColor;
  File? _selectedImage;
  File? _selectedAudio;
  final _formKey = GlobalKey<FormState>();

  void selectImage() async {
    final pickedImage = await pickImage();

    if (pickedImage != null) {
      setState(() {
        _selectedImage = pickedImage;
      });
    }
  }

  void selectAudio() async {
    final pickedAudio = await pickAudio();

    if (pickedAudio != null) {
      setState(() {
        _selectedAudio = pickedAudio;
      });
    }
  }

  @override
  void dispose() {
    _artistController.dispose();
    _songNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(
      homeViewmodelProvider.select(
        (value) => value?.isLoading == true,
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Song'),
        actions: [
          IconButton(
            onPressed: () async {
              if (_formKey.currentState!.validate() &&
                  _selectedImage != null &&
                  _selectedAudio != null) {
                ref.read(homeViewmodelProvider.notifier).uploadSongs(
                      selctedSongFile: _selectedAudio!,
                      selectedThumbnailFile: _selectedImage!,
                      artist: _artistController.text,
                      songName: _songNameController.text,
                      color: _selectedColor,
                    );
              }
            },
            icon: const Icon(Icons.check),
          ),
        ],
      ),
      body: isLoading
          ? const Loader()
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: selectImage,
                        child: _selectedImage != null
                            ? SizedBox(
                                height: 150,
                                width: double.infinity,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.file(
                                    _selectedImage!,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              )
                            : _thumbnailSelectionField(),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      _selectedAudio != null
                          ? AudioWave(path: _selectedAudio!.path)
                          : CustomField(
                              hintText: "Pick Song",
                              readOnly: true,
                              onTap: selectAudio,
                            ),
                      const SizedBox(
                        height: 20,
                      ),
                      CustomField(
                        hintText: "Artist",
                        onTap: () {},
                        controller: _artistController,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      CustomField(
                        hintText: "Song Name",
                        onTap: () {},
                        controller: _songNameController,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ColorPicker(
                        color: _selectedColor,
                        pickersEnabled: const {ColorPickerType.wheel: true},
                        onColorChanged: (value) {
                          setState(() {
                            _selectedColor = value;
                          });
                        },
                        heading: const Text(
                          "Select Color",
                          style: TextStyle(fontSize: 16),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  DottedBorder _thumbnailSelectionField() {
    return DottedBorder(
      color: Pallete.borderColor,
      radius: const Radius.circular(10),
      borderType: BorderType.RRect,
      dashPattern: const [10, 4],
      strokeCap: StrokeCap.round,
      child: const SizedBox(
        height: 150,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.folder_open,
              size: 40,
            ),
            SizedBox(height: 15),
            Text(
              'Select the thumbnail for your song',
              style: TextStyle(
                fontSize: 15,
              ),
            )
          ],
        ),
      ),
    );
  }
}
