import '4_4_sealed.dart';

// 인스턴스화 불가능
Parent parent = Parent();

// sealed class는 상속 불가능
class Child1 extends Parent {}

// implement 불가능
class Child2 implements Parent {}
