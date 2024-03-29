import 'dart:io';
import 'package:flutter_store_pick_app/common/snackbar_utils.dart';
import 'package:flutter_store_pick_app/model/user.dart';
import 'package:flutter_store_pick_app/widget/appbars.dart';
import 'package:flutter_store_pick_app/widget/buttons.dart';
import 'package:flutter_store_pick_app/widget/text_fields.dart';
import 'package:flutter_store_pick_app/widget/texts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// 회원가입 화면
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final formKey = GlobalKey<FormState>();
  final supabase = Supabase.instance.client;
  File? profileImg;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordReController = TextEditingController();
  final TextEditingController _introduceController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _passwordReController.dispose();
    _introduceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: 'Food PICK 가입하기',
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
                /// 프로필 사진
                GestureDetector(
                  child: _buildProfile(),
                  onTap: () {
                    // 프로필 이미지 변경 및 삭제 팝업 띄우기
                    showBottomSheetAboutProfile();
                  },
                ),

                /// 섹션 및 입력필드들
                SectionText(text: '닉네임', textColor: Color(0xff979797)),
                const SizedBox(height: 8),
                TextFormFieldCustom(
                  hintText: '닉네임을 입력해주세요',
                  isPasswordField: false,
                  isReadOnly: false,
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  validator: (value) => inputNameValidator(value),
                  controller: _nameController,
                ),

                const SizedBox(height: 16),

                SectionText(text: '이메일', textColor: Color(0xff979797)),
                const SizedBox(height: 8),
                TextFormFieldCustom(
                  hintText: '이메일을 입력해주세요',
                  isPasswordField: false,
                  isReadOnly: false,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  validator: (value) => inputEmailValidator(value),
                  controller: _emailController,
                ),

                const SizedBox(height: 16),

                SectionText(text: '비밀번호', textColor: Color(0xff979797)),
                const SizedBox(height: 8),
                TextFormFieldCustom(
                  hintText: '비밀번호를 입력해주세요',
                  isPasswordField: true,
                  maxLines: 1,
                  isReadOnly: false,
                  keyboardType: TextInputType.visiblePassword,
                  textInputAction: TextInputAction.next,
                  validator: (value) => inputPasswordValidator(value),
                  controller: _passwordController,
                ),

                const SizedBox(height: 16),

                SectionText(text: '비밀번호 확인', textColor: Color(0xff979797)),
                const SizedBox(height: 8),
                TextFormFieldCustom(
                  hintText: '비밀번호 확인을 입력해주세요',
                  isPasswordField: true,
                  maxLines: 1,
                  isReadOnly: false,
                  keyboardType: TextInputType.visiblePassword,
                  textInputAction: TextInputAction.next,
                  validator: (value) => inputPasswordReValidator(value),
                  controller: _passwordReController,
                ),

                const SizedBox(height: 16),

                SectionText(text: '자기소개', textColor: Color(0xff979797)),
                const SizedBox(height: 8),
                TextFormFieldCustom(
                  hintText: '자기소개를 입력해주세요',
                  isPasswordField: false,
                  maxLines: 10,
                  isReadOnly: false,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  validator: (value) => inputIntroduceValidator(value),
                  controller: _introduceController,
                ),

                const SizedBox(height: 16),

                /// 가입 완료 버튼
                Container(
                  margin: EdgeInsets.symmetric(vertical: 16),
                  width: double.infinity,
                  height: 64,
                  child: ElevatedButtonCustom(
                    text: '가입 완료',
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
                    onPressed: () async {
                      // 가입 완료 시 호출
                      String emailValue = _emailController.text;
                      String passwordValue = _passwordController.text;

                      // 유효성 검사 체크
                      if (!formKey.currentState!.validate()) {
                        return;
                      }

                      // supabase 에 계정 등록
                      bool isRegisterSuccess =
                          await registerAccount(emailValue, passwordValue);
                      if (!context.mounted) return;
                      if (!isRegisterSuccess) {
                        showSnackBar(context, '회원가입을 실패하였습니다');
                        return;
                      }

                      showSnackBar(context, '회원가입을 성공하였습니다');
                      Navigator.pop(context);
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

  Widget _buildProfile() {
    if (profileImg == null) {
      // 이미지가 없을 경우
      return Center(
        child: CircleAvatar(
          backgroundColor: Colors.grey,
          radius: 48,
          child: Icon(
            Icons.add_a_photo,
            color: Colors.white,
            size: 48,
          ),
        ),
      );
    } else {
      // 이미지가 존재할 경우
      return Center(
        child: CircleAvatar(
          backgroundColor: Colors.grey,
          radius: 48,
          backgroundImage: FileImage(profileImg!),
        ),
      );
    }
  }

  void showBottomSheetAboutProfile() {
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

              /// 프로필 사진 삭제
              TextButton(
                onPressed: () {
                  // 프로필 삭제
                  Navigator.pop(context);
                  deleteProfileImg();
                },
                child: Text(
                  '프로필 사진 삭제',
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
        profileImg = File(image.path);
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
        profileImg = File(image.path);
      });
    }
  }

  void deleteProfileImg() {
    // 프로필 사진 삭제
    setState(() {
      profileImg = null;
    });
  }

  inputNameValidator(value) {
    // 닉네임 필드 검증 함수
    if (value.isEmpty) {
      return '닉네임을 입력해주세요';
    }
    return null;
  }

  inputEmailValidator(value) {
    // 이메일 필드 검증 함수
    if (value.isEmpty) {
      return '이메일을 입력해주세요';
    }
    return null;
  }

  inputPasswordValidator(value) {
    // 비밀번호 필드 검증 함수
    if (value.isEmpty) {
      return '비밀번호를 입력해주세요';
    }
    return null;
  }

  inputPasswordReValidator(value) {
    // 비밀번호 확인 필드 검증 함수
    if (value.isEmpty) {
      return '비밀번호를 입력해주세요';
    }
    return null;
  }

  inputIntroduceValidator(value) {
    // 자기소개 필드 검증 함수
    if (value.isEmpty) {
      return '자기소개를 입력해주세요';
    }
    return null;
  }

  Future<bool> registerAccount(String emailValue, String passwordValue) async {
    // 이메일 회원가입 시도

    bool isRegisterSuccess = false;
    final AuthResponse response =
        await supabase.auth.signUp(email: emailValue, password: passwordValue);
    if (response.user != null) {
      // 회원가입이 정상적으로 처리되었을 경우 !
      isRegisterSuccess = true;

      // 1. 프로필 사진을 등록했다면 업로드 처리

      DateTime nowTime = DateTime.now();

      String? imageUrl;
      if (profileImg != null) {
        final imgFile = profileImg;
        // 이미지 파일 업로드
        await supabase.storage.from('store_pick').upload(
              'profiles/${response.user!.id}_$nowTime.jpg',
              imgFile!,
              fileOptions: const FileOptions(
                cacheControl: '3600',
                upsert: true,
              ),
            );

        // 업로드 된 파일의 이미지 url주소를 취득
        imageUrl = supabase.storage
            .from('food_pick')
            .getPublicUrl('profiles/${response.user!.id}_$nowTime.jpg');
      }

      // 2. 수파베이스 db에 insert
      await supabase.from('user').insert(
            UserModel(
                    profileUrl: imageUrl,
                    name: _nameController.text,
                    email: emailValue,
                    introduce: _introduceController.text,
                    uid: response.user!.id)
                .toMap(),
          );
    } else {
      isRegisterSuccess = false;
    }

    return isRegisterSuccess;
  }
}
