import 'package:flutter/material.dart';

class onBoardingScreen extends StatefulWidget {
  const onBoardingScreen({super.key});

  @override
  State<onBoardingScreen> createState() => _onBoardingScreenState();
}

class _onBoardingScreenState extends State<onBoardingScreen> {
  late PageController _pageController;

  int _pageIndex = 0;

  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  itemCount: data.length,
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _pageIndex = index;
                    });
                  },
                  itemBuilder: (context, index) => OnBoardingContent(
                    image: data[index].image,
                    title: data[index].title,
                    description: data[index].description,
                  ),
                ),
              ),
              _pageIndex == data.length - 1
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        children: [
                          MaterialButton(
                            onPressed: () =>
                                Navigator.pushNamed(context, '/login'),
                            elevation: 0,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(15),
                              ),
                            ),
                            height: 50,
                            color: const Color.fromARGB(255, 59, 160, 255),
                            textColor: Colors.black,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Comienza',
                                  style: TextStyle(
                                    letterSpacing: 0.8,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Ya tienes una cuenta?',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                              ),
                              TextButton(
                                onPressed: () =>
                                    Navigator.pushNamed(context, '/register'),
                                child: const Text(
                                  'Iniciar sesion',
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 16,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(
                          height: 60,
                          width: 60,
                        ),
                        ...List.generate(
                          data.length,
                          (index) => Padding(
                            padding: const EdgeInsets.only(right: 4),
                            child: DoItIndicator(
                              isActive: index == _pageIndex,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 60,
                          width: 60,
                          child: IconButton(
                            iconSize: 40,
                            color: Color.fromARGB(255, 0, 168, 22),
                            onPressed: () {
                              _pageController.nextPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.ease);
                            },
                            icon: const Icon(Icons.arrow_circle_right),
                            style: IconButton.styleFrom(
                              shape: const CircleBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

class DoItIndicator extends StatelessWidget {
  const DoItIndicator({
    this.isActive = false,
    super.key,
  });

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: isActive ? 15 : 8,
      width: 15,
      decoration: BoxDecoration(
          color: isActive
              ? Color.fromARGB(255, 0, 168, 22)
              : const Color.fromARGB(255, 150, 150, 150),
          borderRadius: const BorderRadius.all(Radius.circular(12))),
    );
  }
}

class OnBoard {
  final String image, title, description;

  OnBoard({
    required this.image,
    required this.title,
    required this.description,
  });
}

final List<OnBoard> data = [
  OnBoard(
      image: 'assets/boarding1.png',
      title: 'Come sano',
      description: 'Mantener una buena alimentacion es muy importante.'),
  OnBoard(
      image: 'assets/boarding3.png',
      title: 'Recetas saludables',
      description: 'Busca en nuestro repertorio de recetas lo que te interece.'),
  OnBoard(
      image: 'assets/boarding2.png',
      title: 'Comparte!',
      description: 'Comparte con mas personas tus recetas.'),
];

class OnBoardingContent extends StatelessWidget {
  const OnBoardingContent({
    super.key,
    required this.image,
    required this.title,
    required this.description,
  });

  final String image, title, description;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Spacer(),
        Image.asset(
          image,
          height: 300,
        ),
        const SizedBox(
          height: 20,
        ),
        Text(
          title,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
        const SizedBox(
          height: 20,
        ),
        Text(
          description,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                fontWeight: FontWeight.w200,
              ),
        ),
        const Spacer(),
      ],
    );
  }
}
