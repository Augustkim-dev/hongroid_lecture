import 'package:flutter/material.dart';
import 'package:flutter_store_pick_app/widget/appbars.dart';
import 'package:flutter_store_pick_app/widget/texts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../model/user.dart';

/// 내 정보 화면
class MyInfoScreen extends StatefulWidget {
  const MyInfoScreen({super.key});

  @override
  State<MyInfoScreen> createState() => _MyInfoScreenState();
}

class _MyInfoScreenState extends State<MyInfoScreen> {
  final supabase = Supabase.instance.client;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: '내 정보',
        isLeading: false,
        actions: [
          GestureDetector(
            child: SectionText(
              text: '로그아웃',
              textColor: const Color(0xff858585),
            ),
            onTap: () async {
              /// 로그아웃 기능 수행
              await supabase.auth.signOut();
              if (!mounted) return;
              // 로그인 화면으로 복귀
              Navigator.popAndPushNamed(context, '/login');
            },
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: FutureBuilder(
        future: _getMyProfile(),
        builder: (BuildContext context, AsyncSnapshot<UserModel> snapshot) {
          // 데이터가 없을 경우
          if (!snapshot.hasData) {
            // 원형 프로그레스 바 (로딩 역할)
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          // 데이터 통신 중 에러가 났을 경우
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          UserModel userModel = snapshot.data!;
          return _buildMyProfile(userModel);
        },
      ),
    );
  }

  Future<UserModel> _getMyProfile() async {
    // 내 정보 가져오기
    final userMap = await supabase
        .from('user')
        .select()
        .eq('uid', supabase.auth.currentUser!.id);
    print('UserMap : $userMap');
    return userMap.map((e) => UserModel.fromJson(e)).single;
  }

  Widget _buildMyProfile(UserModel userModel) {
    return Container(
      margin: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 프로필 카드 영역
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                side: BorderSide(width: 2),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            child: Row(
              children: [
                /// 프로필 사진
                ClipRRect(
                  borderRadius: BorderRadius.circular(360),
                  child: userModel.profileUrl != null
                      ? Image.network(
                          userModel.profileUrl.toString(),
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        )
                      : const Icon(
                          Icons.person,
                          size: 50,
                        ),
                ),
                const SizedBox(width: 20),

                /// 닉네임 + 이메일
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 닉네임
                    SectionText(
                      text: userModel.name,
                      textColor: Colors.black,
                    ),
                    // 이메일
                    Text(
                      userModel.email,
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xff858585),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          const SizedBox(height: 30),

          /// 자기 소개
          SectionText(text: '자기 소개', textColor: Colors.black),
          const SizedBox(height: 20),
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 2),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              child: Text(
                userModel.introduce,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}


// https://gocpskrrkaptukxazafb.supabase.co/storage/v1/object/public/store_pick/profiles/748362e2-4b54-48a5-8ce4-70051d48483f_2024-03-30%2021:11:43.586625.jpg