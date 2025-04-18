import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'loginScreen/login_screen.dart';
import 'boardScreen/notice_board.dart';
import 'mainScreen/simple_notice_board.dart';
import 'mainScreen/categoryItem.dart';
import 'secure_storage/secure_storage_notifier.dart';
import 'mainScreen/user_summary_board.dart';
import 'drawerScreen/account_drawer.dart';

// 전역 네비게이션 키 정의
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final Color primaryGray = Colors.grey[700]!;
  final Color backgroundGray = Colors.grey[200]!;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: primaryGray,
        scaffoldBackgroundColor: backgroundGray,
        appBarTheme: AppBarTheme(
          color: Colors.white,
          foregroundColor: Colors.grey[700],
        ),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: primaryGray,
          secondary: Colors.grey[600],
          surface: backgroundGray,
        ),
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.grey[900]),
          bodyMedium: TextStyle(color: Colors.grey[800]),
        ),
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.grey[700],
          textTheme: ButtonTextTheme.primary,
        ),
      ),
      navigatorKey: navigatorKey,
      initialRoute: '/main',
      routes: {'/main': (context) => HomePage()},
      home: const HomePage(),
    );
  }
}

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  void initState() {
    super.initState();
    _checkToken();
  }

  // 토큰 상태 확인 및 로드
  Future<void> _checkToken() async {
    await ref.read(secureStorageProvider.notifier).load('ACCESS_TOKEN');
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    // secureStorageProvider 상태 감시
    final tokenState = ref.watch(secureStorageProvider);
    final hasToken =
        tokenState != null && tokenState.containsKey('ACCESS_TOKEN');
    final TextEditingController _searchController = TextEditingController();

    // debugPrint('main.dart 현재 토큰 상태: $tokenState');
    // debugPrint('main.dart 토큰 존재 여부: $hasToken');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[600],
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            //Icon(Icons.ac_unit_rounded, size: 40),
            SizedBox(width: 5),
            Text(
              "데일리국회",
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ],
        ),
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.notifications),
              onPressed: () {
                debugPrint('refresh');
                Scaffold.of(context).openEndDrawer();
              },
            ),
          ),
          hasToken ? _buildDrawerButton() : _buildLoginButton(),
          SizedBox(width: 5,)
        ],
      ),
      endDrawer: AccountDrawer(),
      body: FutureBuilder(
          future: ref.read(secureStorageProvider.notifier).load('ACCESS_TOKEN'),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            // 토큰이 로드된 후
            final tokenState = ref.watch(secureStorageProvider);
            final hasToken =
                tokenState != null && tokenState.containsKey('ACCESS_TOKEN');

            // debugPrint('현재 토큰 상태: $tokenState');
            // debugPrint('토큰 존재 여부: $hasToken');

            return RefreshIndicator(
              color: Colors.grey[700],
              onRefresh: () async {
                setState(() {});
              },
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 20),
                children: [
                  const Text(
                    "성공적인 연금 개혁을 위한\n 뜨거운 논쟁이 벌어지고 있어요",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  _buildSearchBar(_searchController),
                  const SizedBox(height: 20),

                  // 로그인 상태에 따라 다른 환영 메시지 표시
                  _buildSectionTitle(
                      hasToken ? "환영합니다! 맞춤 요약을 확인하세요" : "로그인하고 맞춤 정보를 확인하세요"),

                  _buildSummarySection(),
                  // SummaryBoard(),
                  SizedBox(
                    height: 20,
                  ),
                  _buildSectionTitle("최근 국회 회의록, 쉽게 읽어보세요", showMore: true),
                  _buildRecentMeetings(),
                  SizedBox(
                    height: 20,
                  ),
                  _buildSectionTitle("요즘 국회", showMore: true, onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => NoticeBoard()));
                  }),
                  _buildNoticeBoard(),
                  SizedBox(
                    height: 20,
                  ),
                  _buildSectionTitle("카테고리 별로 모아봤어요"),
                  Categoryitem(),
                ],
              ),
            );
          }),
    );
  }

  Widget _buildSearchBar(TextEditingController controller) {
    TextEditingController _searchController = controller;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: TextField(
        cursorColor: Colors.black,
        controller: _searchController,
        decoration: InputDecoration(
          hintText: "검색어를 입력하세요",
          hintStyle: TextStyle(color: Colors.grey[800]),
          contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide(color: Colors.grey[900]!, width: 2)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide(color: Colors.grey[700]!)),
          suffixIcon: IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              debugPrint(_searchController.text);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title,
      {bool showMore = false, VoidCallback? onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(title,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          if (showMore)
            GestureDetector(
              onTap: onTap ?? () => debugPrint("자세히 보기 클릭"),
              child: const Text("자세히 보기 ",
                  style: TextStyle(
                      color: Colors.grey, fontWeight: FontWeight.bold), ),
            ),
        ],
      ),
    );
  }

  Widget _buildSummarySection() {
    return SummaryBoard();
  }

  Widget _buildRecentMeetings() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: Colors.black12, borderRadius: BorderRadius.circular(5)),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("[2207596] 제421회국회(임시회) 회기결정의 건(의장)",
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Text(
              "1. 서울서부지방법원 불법적 폭동사태 관련 긴급현안질문 실시의 건(의장 제의)(의안번호 2207752)\n\n2. 서울서부지방법원 불법적 폭동사태 관련 긴급현안질문",
              style: TextStyle(fontSize: 11)),
        ],
      ),
    );
  }

  Widget _buildNoticeBoard() {
    return Container(
      width: double.infinity,
      height: 245,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: Colors.black12, borderRadius: BorderRadius.circular(5)),
      child: SimpleNoticeBoardItem(),
    );
  }

  Widget _buildLoginButton() {
    return ElevatedButton(
      onPressed: () async {
        final result = await Navigator.push(context,
            MaterialPageRoute(builder: (context) => const LoginPage()));

        if (result == true) {
          // 로그인 성공 후 토큰 상태 다시 확인
          setState(() {});
        }
      },
      style: ElevatedButton.styleFrom(
        fixedSize: const Size(85, 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      // child: hasToken ? IconButton(onPressed: () {}, icon: Icon(Icons.account_circle)),
      child: Text("로그인",
          style: const TextStyle(fontSize: 13, color: Colors.black)),
    );
  }

  Widget _buildDrawerButton() {
    return Builder(
        builder: ((context) => IconButton(
            onPressed: () {
              Scaffold.of(context).openEndDrawer();
            },
            icon: Icon(Icons.person))));
  }
}
