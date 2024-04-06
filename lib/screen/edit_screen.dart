import 'dart:convert';
import 'dart:io';

import 'package:daum_postcode_search/data_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_store_pick_app/common/snackbar_utils.dart';
import 'package:flutter_store_pick_app/model/food_store.dart';
import 'package:flutter_store_pick_app/widget/appbars.dart';
import 'package:flutter_store_pick_app/widget/buttons.dart';
import 'package:flutter_store_pick_app/widget/text_fields.dart';
import 'package:flutter_store_pick_app/widget/texts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/http.dart' as http;

/// 작성 화면
class EditScreen extends StatefulWidget {
  const EditScreen({super.key});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  File? storeImg; // 갤러리에서 새로 선택한 맛집정보 이미지

  final formKey = GlobalKey<FormState>();
  final TextEditingController _storeAddressController =
      TextEditingController(); // 주소 컨트롤러
  final TextEditingController _storeNameController =
      TextEditingController(); // 별명 컨트롤러
  final TextEditingController _storeCommentController =
      TextEditingController(); // 내용 컨트롤러
  DataModel? dataModel; // 주소 검색 결과값을 담는 변수
  final supabase = Supabase.instance.client;

  @override
  void dispose() {
    _storeAddressController.dispose();
    _storeCommentController.dispose();
    _storeNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: '맛집 등록하기',
        isLeading: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(16),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// 맛집 사진
                GestureDetector(
                  child: _buildStoreImg(),
                  onTap: () {
                    // 바텀 다이얼로그 표시
                    showBottomSheetAboutStoreImg();
                  },
                ),
                const SizedBox(height: 24),

                /// 맛집 위치 (도로명 주소)
                SectionText(text: '맛집 위치 (도로명 주소)', textColor: Colors.black),
                const SizedBox(height: 8),
                TextFormFieldCustom(
                  isPasswordField: false,
                  isReadOnly: true,
                  hintText: '클릭하여 주소 입력',
                  keyboardType: TextInputType.streetAddress,
                  textInputAction: TextInputAction.next,
                  validator: (value) => inputAddressValidator(value),
                  controller: _storeAddressController,
                  onTap: () async {
                    // 주소 검색 웹뷰화면으로 이동
                    var result =
                        await Navigator.pushNamed(context, '/search_address');
                    if (result != null) {
                      print('다음주소 : $result');
                      setState(() {
                        dataModel = result as DataModel?;
                        _storeAddressController.text =
                            dataModel?.roadAddress ?? '맛집 주소를 선택 해주세요';
                      });
                    }
                  },
                ),

                const SizedBox(height: 24),

                /// 맛집 별명
                SectionText(text: '맛집 별명', textColor: Colors.black),
                const SizedBox(height: 8),
                TextFormFieldCustom(
                  isPasswordField: false,
                  isReadOnly: false,
                  hintText: '별명을 입력해주세요',
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  validator: (value) => inputNameValidator(value),
                  controller: _storeNameController,
                ),

                const SizedBox(height: 24),

                /// 메모
                SectionText(text: '메모', textColor: Colors.black),
                const SizedBox(height: 8),
                TextFormFieldCustom(
                  isPasswordField: false,
                  isReadOnly: false,
                  maxLines: 5,
                  hintText: '메모를 입력해주세요',
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  validator: (value) => inputMemoValidator(value),
                  controller: _storeCommentController,
                ),

                const SizedBox(height: 24),

                /// 맛집 등록 완료 버튼
                Container(
                  width: double.infinity,
                  height: 69,
                  child: ElevatedButtonCustom(
                    text: '맛집 등록 완료',
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
                    onPressed: () async {
                      // 맛집 등록

                      // 1. 유효성 검사
                      if (!formKey.currentState!.validate()) {
                        return;
                      }

                      // 2. 수파베이스 디비에 insert
                      bool isEditSuccess = await editFoodStore();

                      if (!mounted) return;
                      if (!isEditSuccess) {
                        showSnackBar(context, '맛집 등록 중 문제가 발생했습니다');
                        Navigator.pop(context);
                        return;
                      }

                      showSnackBar(context, '맛집 등록을 성공 하였습니다');
                      Navigator.pop(context, 'completed_edit');
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  inputAddressValidator(value) {
    // 닉네임 필드 검증 함수
    if (value.isEmpty) {
      return '맛집 위치를  입력해주세요';
    }
    return null;
  }

  inputNameValidator(value) {
    // 별명 필드 검증 함수
    if (value.isEmpty) {
      return '별명을 입력해주세요';
    }
    return null;
  }

  inputMemoValidator(value) {
    // 메모 필드 검증 함수
    if (value.isEmpty) {
      return '메모를 입력해주세요';
    }
    return null;
  }

  Widget _buildStoreImg() {
    // 맛집 정보 사진

    if (storeImg == null) {
      // default image
      return Container(
        width: double.infinity,
        height: 140,
        decoration: ShapeDecoration(
          color: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        child: const Icon(
          Icons.image_search,
          size: 96,
          color: Colors.white,
        ),
      );
    } else {
      // food store image
      return Container(
        width: double.infinity,
        height: 140,
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: BorderSide(width: 2),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        child: Image.file(
          storeImg!,
          fit: BoxFit.cover,
        ),
      );
    }
  }

  void showBottomSheetAboutStoreImg() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// 사진 촬영 버튼
              TextButton(
                onPressed: () {
                  // 사진 촬영
                  Navigator.pop(context);
                  getCameraImage();
                },
                child: Text(
                  '사진 촬영',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                ),
              ),

              /// 앨범에서 사진 선택
              TextButton(
                onPressed: () {
                  // 앨범 사진 선택
                  Navigator.pop(context);
                  getGalleryImage();
                },
                child: Text(
                  '앨범에서 사진 선택',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                ),
              ),

              /// 사진 삭제
              TextButton(
                onPressed: () {
                  // 등록된 삭제
                  Navigator.pop(context);
                  deleteProfileImg();
                },
                child: Text(
                  '등록된 사진 삭제',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> getCameraImage() async {
    // 카메라로 사진 촬영하여 이미지 파일을 가져오는 함수
    var image = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 10,
    );
    if (image != null) {
      setState(() {
        storeImg = File(image.path);
      });
    }
  }

  Future<void> getGalleryImage() async {
    // 갤러리에서 사진 선택하는 함수
    var image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 10,
    );
    if (image != null) {
      setState(() {
        storeImg = File(image.path);
      });
    }
  }

  void deleteProfileImg() {
    // 맛집 정보 사진 삭제
    setState(() {
      storeImg = null;
    });
  }

  Future<bool> editFoodStore() async {
    DateTime nowTime = DateTime.now(); // 현재 시간 값 가져오기
    // 1. 이미지 업로드
    String? imageUrl;
    if (storeImg != null) {
      final imgFile = storeImg;
      // 이미지 파일 업로드
      await supabase.storage.from('store_pick').upload(
            'stores/$nowTime.jpg',
            imgFile!,
            fileOptions: const FileOptions(
              cacheControl: '3600',
              upsert: true,
            ),
          );

      // 업로드 된 파일의 이미지 url주소를 취득
      imageUrl = supabase.storage
          .from('store_pick')
          .getPublicUrl('stores/$nowTime.jpg');
    }

    // 2. 네이버 클라우드 플랫폼에서 지원하는 geocoding api 를 활용하여 주소 -> 위경도 값으로 변환 !
    final String apiUrl =
        'https://naveropenapi.apigw.ntruss.com/map-geocode/v2/geocode?query=${_storeAddressController.text}';
    final apiResponse = await http.get(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'X-NCP-APIGW-API-KEY-ID': 'ttl8us9u92',
        'X-NCP-APIGW-API-KEY': '1wRpeO65tlJlbmMAqR8EW2nJke9TM5kxvUilhIu4',
        'Accept': 'application/json',
      },
    );

    if (apiResponse.statusCode == 200) {
      // api 호출에 성공 !
      Map<String, dynamic> parsedJson = jsonDecode(apiResponse.body);

      if (parsedJson["meta"]['totalCount'] == 0) {
        if (!mounted) return false;
        showSnackBar(context, '위치 계산에 오류가 있어서 다른 주소 값으로 검색 바랍니다');
        return false;
      }

      double latitude =
          double.parse(parsedJson['addresses'][0]['y']); // 위도 값 추출
      double longitude =
          double.parse(parsedJson['addresses'][0]['x']); // 경도 값 추출

      // 수파베이스에 db set
      await supabase.from('food_store').insert(
            FoodStoreModel(
              storeName: _storeNameController.text,
              storeAddress: _storeAddressController.text,
              storeComment: _storeCommentController.text,
              storeImgUrl: imageUrl,
              uid: supabase.auth.currentUser!.id,
              latitude: latitude,
              longitude: longitude,
            ).toMap(),
          );

      return true;
    } else {
      // 만약에 서버 응답이 성공하지 않으면 에러를 던진다.
      return false;
    }
  }
}
